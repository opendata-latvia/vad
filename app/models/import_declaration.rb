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
    JSON.parse read_attribute('data')
  end

  def pretty_data
    JSON.pretty_generate data
  end

  def as_json(options = {})
    super.merge(
      :pretty_data => pretty_data
    )
  end

  def self.search(params)
    relation = order('created_at desc')
    relation = relation.where(:status => params[:status]) if params[:status]
    relation
  end

  def self.import_all!
    where("status in (?)", %w(new error)).each do |id|
      id.import!
    end
  end

  def self.delete_imported!
    Declaration.delete_all
    DeclarationOtherWorkplace.delete_all
    DeclarationRealEstate.delete_all
    DeclarationCompany.delete_all
    DeclarationSecurity.delete_all
    DeclarationVehicle.delete_all
    DeclarationCash.delete_all
    DeclarationIncome.delete_all
    DeclarationDeal.delete_all
    update_all("status = 'new'")
  end

  def import!
    unless "f80ce7b04d33af0cd25def7819a45f06" == Digest::MD5.hexdigest(data[1]["Sadaļas"].to_s)
      raise "Sorry, bet šādu deklarācijas veidu mēs nevaram apstrādāt"
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

    create_person

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
    head = data[1]
    kind, period_year = head["Deklarācijas veids"].split('-')
    kind = kind.strip
    if period_year =~ /(\d+)/
      period_year = $1
    end
    @declaration = Declaration.new(
      :kind => kind,
      :period_year => period_year,
      :full_name => head["Vārds uzvārds"],
      :workplace => head["Darbavieta"],
      :position => head["Amats"],
      :submitted_on => parse_date(head["Iesniegta VID"]),
      :published_on => parse_date(head["Publicēta"])
    )
    @declaration.save!
  end

  private
  
  def create_person
    declaration_hash = Digest::MD5.hexdigest(data[0].to_s)

    if (person = Person.where(:declaration_hash => declaration_hash).any?)
      Declaration.last.update_attributes(:person_id => person.id)
    else
      first_name, last_name = data[0]["Vārds, uzvārds"].split(/^\s*(\w+)\s*(.+)/).reject(&:blank?)
      person = Person.create!(
        :full_name => data[0]["Vārds, uzvārds"],
        :first_name => first_name,
        :last_name => last_name,
        :declaration_hash => declaration_hash
      )
      Declaration.last.update_attributes(:person_id => person.id)
    end
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

  RATES = {
    'LVL' => 1,
    'EUR' => 0.702804,
    'USD' => 0.544000,
    'GBP' => 0.875000,
    'RUB' => 0.017500,
    'CHF' => 0.580000,
    'BYR' => 0.063400
  }

  def convert_amount_lvl(amount, currency)
    raise ArgumentError, "trūkst #{currency} valūtas kurss" unless rate = RATES[currency]
    amount.to_f * rate
  end

  # return [amount, currency, amount_lvl]
  def parse_amount(amount, currency)
    return [nil, nil, nil] unless amount.to_s =~ /\d/

    if currency.blank?
      amount, currency = amount.split(' ')
    end
    [amount, currency, convert_amount_lvl(amount, currency)]
  end

  def import_other_workplaces
    return unless other_workplaces = data[2]
    other_workplaces.each do |ow|
      registration_number, legal_address = parse_legal_address ow["Juridiskai personai - reģistrācijas numurs Komercreģistrā un juridiskā adrese"]
      @declaration.other_workplaces.create!(
        :position => ow["Amata nosaukums, darbi, informācija par uzņēmuma līgumiem un pilnvarojumiem"],
        :workplace => ow["Juridiskās personas nosaukums; fiziskās personas vārds un uzvārds"],
        :registration_number => registration_number,
        :legal_address => legal_address
      )
    end
  end

  def import_real_estates
    return unless real_estates = data[3]
    real_estates.each do |re|
      @declaration.real_estates.create!(
        :kind => re["Nekustamā īpašuma veids"],
        :location => re["Nekustamā īpašuma atrašanās vieta (valsts, pilsēta/apdzīvota vieta)"],
        :ownership_type => re["Atzīme par to, vai ir īpašumā (kopīpašumā), valdījumā vai lietošanā"],
        :other_owners => re["Ja ir valdījumā, lietošanā vai kopīpašumā, norādīt īpašnieka vai līdzīpašnieka vārdu un uzvārdu"]
      )
    end
  end

  def import_companies_and_securities
    return unless companies = data[4]
    companies.each do |c|
      if c["Kapitāla daļu skaits"]
        registration_number, legal_address = parse_legal_address c["Reģistrācijas numurs Komercreģistrā un juridiskā adrese"]
        amount, currency, amount_lvl = parse_amount(c["Summa"], c["Valūta"])
        @declaration.companies.create!(
          :name => c["Juridiskās personas nosaukums"],
          :registration_number => registration_number,
          :legal_address => legal_address,
          :shares => c["Kapitāla daļu skaits"],
          :amount => amount,
          :currency => currency,
          :amount_lvl => amount_lvl
        )
      else
        registration_number, legal_address = parse_legal_address c["Reģistrācijas numurs Komercreģistrā un juridiskā adrese"]
        amount, currency, amount_lvl = parse_amount(c["Summa (nominālvērtībā)"], c["Valūta"])
        @declaration.securities.create!(
          :issuer => c["Vērtspapīru emitenta nosaukums"],
          :registration_number => registration_number,
          :legal_address => legal_address,
          :kind => c["Vērtspapīru veids"],
          :units => c["Skaits"],
          :amount => amount,
          :currency => currency,
          :amount_lvl => amount_lvl
        )
      end
    end
  end

  def import_vehicles
    return unless vehicles = data[5]
    vehicles.each do |v|
      @declaration.vehicles.create!(
        :kind => v["Transportlīdzekļa veids"],
        :model => v["Marka"],
        :release_year => v["Izlaides gads"],
        :registration_year => v["Reģistrācijas gads"],
        :ownership_type => v["Atzīme par to, vai ir īpašumā, valdījumā vai lietošanā"]
      )
    end
  end

  def import_cash
    return unless cash = data[6]
    cash.each do |c|
      if c["Skaidrās naudas uzkrājuma summa ar cipariem"]
        amount, currency, amount_lvl = parse_amount(c["Skaidrās naudas uzkrājuma summa ar cipariem"], c["Valūta"])
        @declaration.cash.create!(
          :kind => "Skaidrās naudas uzkrājuma summa ar cipariem",
          :amount => amount,
          :currency => currency,
          :amount_lvl => amount_lvl,
          :amount_in_words => c["Skaidrās naudas uzkrājuma summa ar vārdiem"]
        )
      elsif c["Bezkaidrās naudas uzkrājuma summa"]
        registration_number, legal_address = parse_legal_address(c["Juridiskai personai - reģistrācijas numurs Komercreģistrā un juridiskā adrese; fiziskās personas vārds un uzvārds"])
        amount, currency, amount_lvl = parse_amount(c["Bezkaidrās naudas uzkrājuma summa"], c["Valūta"])
        @declaration.cash.create!(
          :kind => "Bezkaidrās naudas uzkrājuma summa",
          :amount => amount,
          :currency => currency,
          :amount_lvl => amount_lvl,
          :bank => c["Bezskaidrās naudas uzkrājumu turētāja vai norēķinu kartes izdevēja nosaukums"],
          :registration_number => registration_number,
          :legal_address => legal_address
        )
      end
    end
  end

  def import_income
    return unless income = data[7]
    income.each do |i|

      source, registration_number, legal_address = parse_source(i["Ienākumu gūšanas vieta (avots) – juridiskās personas nosaukums, reģistrācijas numurs komercreģistrā un juridiskā adrese; fiziskās personas vārds un uzvārds"])
      amount, currency, amount_lvl = parse_amount(i["Summa"], i["Valūta"])
      @declaration.income.create!(
        :source => source,
        :registration_number => registration_number,
        :legal_address => legal_address,
        :kind => i["Ienākumu veids"],
        :amount => amount,
        :currency => currency,
        :amount_lvl => amount_lvl
      )
    end
  end

  def import_deals
    return unless deals = data[8]
    deals.each do |d|
      amount, currency, amount_lvl = parse_amount(d["Summa"], d["Valūta"])
      @declaration.deals.create!(
        :description => d["Darījuma veids"],
        :amount => amount,
        :currency => currency,
        :amount_lvl => amount_lvl
      )
    end
  end

  def import_debts
    return unless debts = data[9]
    debts.each do |d|
      @declaration.debts.create!(
        if d["Publicējamā daļa"]
          { :description => d["Publicējamā daļa"] }
        else
          amount, currency, amount_lvl = parse_amount(d["Summa ar cipariem"], d["Valūta"])
          {
            :amount => amount,
            :currency => currency,
            :amount_lvl => amount_lvl,
            :amount_in_words => d["Summa ar vārdiem"]
          }
        end
      )
    end
  end

  def import_loans
    return unless loans = data[10]
    loans.each do |l|
      @declaration.loans.create!(
        if l["Publicējamā daļa"]
          { :description => l["Publicējamā daļa"] }
        else
          amount, currency, amount_lvl = parse_amount(l["Summa ar cipariem"], l["Valūta"])
          {
            :amount => amount,
            :currency => currency,
            :amount_lvl => amount_lvl,
            :amount_in_words => l["Summa ar vārdiem"]
          }
        end
      )
    end
  end

  def import_other_facts
    return unless other_facts = data[11]
    other_facts.each do |of|
      @declaration.other_facts.create!(
        :description => of["Publicējamā daļa"]
      )
    end
  end

  def import_relatives
    return unless relatives = data[12]
    relatives.each do |r|
      @declaration.relatives.create!(
        :full_name => r["Vārds, uzvārds"],
        :kind => r["Radniecība"]
      )
    end
  end

end
