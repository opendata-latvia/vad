# encoding: utf-8
require 'digest/md5'

class ImportDeclaration < ActiveRecord::Base
  def new?
    status == 'new'
  end

  def error?
    status == 'error'
  end

  def data
    @data ||= JSON.parse read_attribute('data')
  end

  def pretty_data
    JSON.pretty_generate data
  end

  def summary
    data.values_at("type", "name", "workplace", "workplace_role").join(', ')
  rescue
    "Sorry - kļūda kopsavlikumā"
  end

  def as_json(options = {})
    super.merge(
      :pretty_data => pretty_data
    )
  end

  def self.search(params)
    relation = order('created_at desc')
    [:status, :project].each do |attr|
      relation = relation.where(attr.to_sym => params[attr]) if params[attr]
    end
    params[:page] ||= 1
    params[:per_page] ||= 50
    relation.paginate(params.slice(:page, :per_page))
  end

  def self.import_all!(params = {})
    relation = where("status in (?)", %w(new error))
    relation = relation.where("project = ?", params[:project]) if params[:project]
    relation.each do |id|
      id.import!
    end
  end

  def self.delete_imported!
    Person.delete_all
    Declaration.delete_all
    DeclarationOtherWorkplace.delete_all
    DeclarationRealEstate.delete_all
    DeclarationCompany.delete_all
    DeclarationSecurity.delete_all
    DeclarationVehicle.delete_all
    DeclarationCash.delete_all
    DeclarationIncome.delete_all
    DeclarationDeal.delete_all
    DeclarationDebt.delete_all
    DeclarationLoan.delete_all
    DeclarationOtherFact.delete_all
    DeclarationRelative.delete_all

    update_all("status = 'new'")
  end

  def import!
    unless data['sections'].present?
      self.error = "Trūkst sections!"
      self.status = 'skip'
      save!
      return
    end

    import_head
    import_other_workplaces
    import_real_estates
    import_companies_and_securities
    import_vehicles
    import_cash
    import_income
    import_deals
    import_debts
    import_loans
    import_other_facts
    import_relatives

    assign_person_to_declaration

    self.error = nil
    self.status = 'imported'
    save!
  rescue => e
    raise if Rails.env.test?
    self.error = "#{e.message}\n#{e.backtrace[0..2].join("\n")}"
    self.status = 'error'
    save!
  end

  def import_head
    kind, period_year = data["type"].split('-')
    kind = kind.strip
    if period_year =~ /(\d+)/
      period_year = $1
    end
    @declaration = Declaration.new(
      project: project,
      kind: kind,
      period_year: period_year,
      full_name: data["name"],
      workplace: data["workplace"],
      position: data["workplace_role"],
      submitted_on: parse_date(data["date_added"]),
      published_on: parse_date(data["date_published"])
    )
    @declaration.save!
  end

  private

  def assign_person_to_declaration
    first_name, last_name = data["name"].split(/^\s*(\w+)\s*(.+)/).reject(&:blank?)
    hash_data = {name: data["name"], project: project}
    declaration_hash = Digest::MD5.hexdigest(JSON.dump hash_data)
    person = Person.find_or_create_by_declaration_hash(
      :full_name => data["name"],
      :first_name => first_name,
      :last_name => last_name,
      :declaration_hash => declaration_hash
    )
    @declaration.update_attributes(:person_id => person.id)
  end

  def parse_date(string)
    if string =~ /^(\d\d)\.(\d\d)\.(\d\d\d\d)$/
      Date.new($3.to_i, $2.to_i, $1.to_i)
    end
  end

  # returns [registration_number, legal_address]
  def parse_legal_address(string)
    if string =~ /^\s*(\d+)\s*(.*)$/
      [$1, $2]
    else
      [nil, string]
    end
  end

  # returns [source, registration_number, legal_address]
  def parse_source(string)
    if string =~ /^\s*(.*),\s*(\d+),\s*(.*)$/
      [$1, $2, $3]
    else
      [nil, nil, string]
    end
  end

  def convert_amount_lvl(amount, currency)
    CurrencyRates.to_lvl(amount, currency)
  end

  def convert_amount_eur(amount, currency)
    CurrencyRates.to_eur(amount, currency)
  end

  # return [amount, currency, amount_lvl, amount_eur]
  def parse_amount(amount, currency)
    return [nil, nil, nil] unless amount.to_s =~ /\d/

    if currency.blank?
      amount, currency = amount.split(' ')
    end
    [amount, currency, convert_amount_lvl(amount, currency), convert_amount_eur(amount, currency)]
  end

  def section_data(title)
    section_title = data['sections'].detect do |s|
      case title
      when String then s.include?(title)
      when Regexp then s =~ title
      end
    end
    if section_title
      data['sectionData'][section_title]
    end
  end

  def get(section, title)
    section.each do |key, value|
      case title
      when String
        if key.include?(title)
          return value
        end
      when Regexp
        if key =~ title
          return value
        end
      end
    end
    nil
  end

  def import_other_workplaces
    return unless other_workplaces = section_data('Citi amati')
    other_workplaces.each do |ow|
      registration_number, legal_address = parse_legal_address get(ow, /Juridisk.* numurs/)
      @declaration.other_workplaces.create!(
        :position => get(ow, "Amata nosaukums"),
        :workplace => get(ow, /Juridisk.* nosaukums/),
        :registration_number => registration_number,
        :legal_address => legal_address
      )
    end
  end

  def import_real_estates
    return unless real_estates = section_data('nekustamie īpašumi')
    real_estates.each do |re|
      @declaration.real_estates.create!(
        :kind => get(re, "Nekustamā īpašuma veids"),
        :location => get(re, "Nekustamā īpašuma atrašanās vieta"),
        :ownership_type => get(re, "Atzīme par to, vai ir īpašumā"),
        :other_owners => get(re, "īpašnieka vai līdzīpašnieka vārdu un uzvārdu")
      )
    end
  end

  def import_companies_and_securities
    return unless companies = section_data('Komercsabiedrības')
    total_companies_amount_eur = 0
    total_securities_amount_eur = 0
    companies.each do |c|
      if shares = get(c, "Kapitāla daļu skaits")
        registration_number, legal_address = parse_legal_address get(c, "Reģistrācijas numurs")
        amount, currency, amount_lvl, amount_eur = parse_amount(c["Summa"], c["Valūta"])
        @declaration.companies.create!(
          :name => get(c, "Juridiskās personas nosaukums"),
          :registration_number => registration_number,
          :legal_address => legal_address,
          :shares => shares,
          :amount => amount,
          :currency => currency,
          :amount_lvl => amount_lvl,
          :amount_eur => amount_eur
        )
        total_companies_amount_eur += amount_eur||0
      else
        registration_number, legal_address = parse_legal_address get(c, "Reģistrācijas numurs")
        amount, currency, amount_lvl, amount_eur = parse_amount(c["Summa (nominālvērtībā)"], c["Valūta"])
        @declaration.securities.create!(
          :issuer => c["Vērtspapīru emitenta nosaukums"],
          :registration_number => registration_number,
          :legal_address => legal_address,
          :kind => c["Vērtspapīru veids"],
          :units => c["Skaits"],
          :amount => amount,
          :currency => currency,
          :amount_lvl => amount_lvl,
          :amount_eur => amount_eur,
        )
        total_securities_amount_eur += amount_eur||0
      end
    end
    @declaration.update_attribute :companies_amount_eur, total_companies_amount_eur
    @declaration.update_attribute :securities_amount_eur, total_securities_amount_eur
  end

  def import_vehicles
    return unless vehicles = section_data('transportlīdzekļi')
    vehicles.each do |v|
      @declaration.vehicles.create!(
        :kind => get(v, "Transportlīdzekļa veids"),
        :model => v["Marka"],
        :release_year => v["Izlaides gads"],
        :registration_year => v["Reģistrācijas gads"],
        :ownership_type => get(v, "Atzīme par to, vai ir īpašumā")
      )
    end
  end

  def import_cash
    return unless cash = section_data('naudas uzkrājumi')
    total_cash_amount_eur = 0
    total_bank_amount_eur = 0
    cash.each do |c|
      if c["Skaidrās naudas uzkrājuma summa ar cipariem"]
        amount, currency, amount_lvl, amount_eur = parse_amount(c["Skaidrās naudas uzkrājuma summa ar cipariem"], c["Valūta"])
        @declaration.cash.create!(
          :kind => "Skaidrās naudas uzkrājuma summa ar cipariem",
          :amount => amount,
          :currency => currency,
          :amount_lvl => amount_lvl,
          :amount_eur => amount_eur,
          :amount_in_words => c["Skaidrās naudas uzkrājuma summa ar vārdiem"]
        )
        total_cash_amount_eur += amount_eur||0
      elsif c["Bezkaidrās naudas uzkrājuma summa"]
        registration_number, legal_address = parse_legal_address(get(c, /Juridisk.* reģistrācijas numurs/))
        amount, currency, amount_lvl, amount_eur = parse_amount(c["Bezkaidrās naudas uzkrājuma summa"], c["Valūta"])
        @declaration.cash.create!(
          :kind => "Bezkaidrās naudas uzkrājuma summa",
          :amount => amount,
          :currency => currency,
          :amount_lvl => amount_lvl,
          :amount_eur => amount_eur,
          :bank => get(c, "Bezskaidrās naudas uzkrājumu turētāja"),
          :registration_number => registration_number,
          :legal_address => legal_address
        )
        total_bank_amount_eur += amount_eur||0
      end
    end
    @declaration.update_attribute :cash_amount_eur, total_cash_amount_eur
    @declaration.update_attribute :bank_amount_eur, total_bank_amount_eur
  end

  def import_income
    return unless income = section_data('gūtie ienākumi')
    total_amount_eur = 0
    income.each do |i|
      source, registration_number, legal_address = parse_source(get(i, "Ienākumu gūšanas vieta"))
      amount, currency, amount_lvl, amount_eur = parse_amount(i["Summa"], i["Valūta"])
      @declaration.income.create!(
        :source => source,
        :registration_number => registration_number,
        :legal_address => legal_address,
        :kind => i["Ienākumu veids"],
        :amount => amount,
        :currency => currency,
        :amount_lvl => amount_lvl,
        :amount_eur => amount_eur
      )
      total_amount_eur += amount_eur||0
    end
    @declaration.update_attribute :income_amount_eur, total_amount_eur
  end

  def import_deals
    return unless deals = section_data('veiktie darījumi')
    total_amount_eur = 0
    deals.each do |d|
      amount, currency, amount_lvl, amount_eur = parse_amount(d["Summa"], d["Valūta"])
      @declaration.deals.create!(
        :description => d["Darījuma veids"],
        :amount => amount,
        :currency => currency,
        :amount_lvl => amount_lvl,
        :amount_eur => amount_eur
      )
      total_amount_eur += amount_eur||0
    end
    @declaration.update_attribute :deals_amount_eur, total_amount_eur
  end

  def import_debts
    return unless debts = section_data('parādsaistības')
    total_amount_eur = 0
    debts.each do |d|
      @declaration.debts.create!(
        if d["Publicējamā daļa"]
          { :description => d["Publicējamā daļa"] }
        else
          amount, currency, amount_lvl, amount_eur = parse_amount(d["Summa ar cipariem"], d["Valūta"])
          total_amount_eur += amount_eur||0
          {
            :amount => amount,
            :currency => currency,
            :amount_lvl => amount_lvl,
            :amount_eur => amount_eur,
            :amount_in_words => d["Summa ar vārdiem"]
          }
        end
      )
    end
    @declaration.update_attribute :debts_amount_eur, total_amount_eur
  end

  def import_loans
    return unless loans = section_data('izsniegtie aizdevumi')
    total_amount_eur = 0
    loans.each do |l|
      @declaration.loans.create!(
        if l["Publicējamā daļa"]
          { :description => l["Publicējamā daļa"] }
        else
          amount, currency, amount_lvl, amount_eur = parse_amount(l["Summa ar cipariem"], l["Valūta"])
          total_amount_eur += amount_eur||0
          {
            :amount => amount,
            :currency => currency,
            :amount_lvl => amount_lvl,
            :amount_eur => amount_eur,
            :amount_in_words => l["Summa ar vārdiem"]
          }
        end
      )
    end
    @declaration.update_attribute :loans_amount_eur, total_amount_eur
  end

  def import_other_facts
    return unless other_facts = section_data('citiem faktiem')
    other_facts.each do |of|
      @declaration.other_facts.create!(
        :description => of["Publicējamā daļa"]
      )
    end
  end

  def import_relatives
    return unless relatives = section_data('laulātais')
    children_count = 0
    relatives.each do |r|
      @declaration.relatives.create!(
        :full_name => r["Vārds, uzvārds"],
        :kind => (kind = r["Radniecība"])
      )
      children_count += 1 if kind =~ /dēls|meita/i
    end
    @declaration.update_attribute :declaration_children_count, children_count
  end

end
