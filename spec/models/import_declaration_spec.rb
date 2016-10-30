# encoding: utf-8

require "spec_helper"

describe "import declaration" do
  before(:all) do
    @data = File.read(File.expand_path("data.json", "#{Rails.root}/spec/fixtures"))
    @project = 'test'
  end

  before(:each) do
    @import_declaration = ImportDeclaration.create(
      status: 'new',
      data: @data,
      md5: Digest::MD5.hexdigest(@data),
      project: @project
    )
    @import_declaration.import!
    @declaration = Declaration.find_by_import_declaration_id(@import_declaration.id)
  end

  it "should have data as array" do
    @import_declaration.data.should be_kind_of(Hash)
  end

  it "should create declaration header" do
    @declaration.should_not be_nil
    @declaration.kind.should == "Kārtējā gada deklarācija"
    @declaration.period_year.should == 2011
    @declaration.workplace.should == "'LATVIJAS VALSTS PREZIDENTA KANCELEJA'"
    @declaration.position.should == "Valsts prezidents"
    @declaration.submitted_on.should == Date.new(2012,03,29)
    @declaration.published_on.should == Date.new(2012,04,13)
    @declaration.import_declaration_id.should == @import_declaration.id
  end

  it "should create other workplaces" do
    @declaration.other_workplaces.map{|r| [r.position, r.workplace, r.registration_number, r.legal_address]}.should == [
      [ "KĀJIŅAS ZEMNIEKU SAIMNIECĪBA", "Cēsu rajona Drabešu pagasta zemnieku saimniecība \"KĀJIŅAS\"",
        "44101029858", "Latvija, Drabešu pag., \"KĀJIŅAS\""
      ],
      [ "Valsts prezidents", "'LATVIJAS VALSTS PREZIDENTA KANCELEJA'",
        "90000038578", "Latvija, Rīga, Rātslaukums 7"
      ]
    ]
    @declaration.declaration_other_workplaces_count.should == @declaration.other_workplaces.size
  end

  it "should create real estates" do
    @declaration.real_estates.map{|r| [r.kind, r.location, r.ownership_type, r.other_owners]}.first.should ==
      [
        "Zeme",
        "Latvija, Drabešu pag.",
        "īpašumā",
        "-"
      ]
    @declaration.declaration_real_estates_count.should == @declaration.real_estates.size
  end

  it "should create companies" do
    @declaration.companies.map{|r| [r.name, r.registration_number, r.legal_address, r.shares,
          r.amount, r.currency, r.amount_lvl, r.amount_eur]}.first.should ==
      [
        "Cēsu rajona Drabešu pagasta zemnieku saimniecība \"KĀJIŅAS\"",
        "44101029858",
        "Latvija, Drabešu pag., \"KĀJIŅAS\"",
        1,
        1.0,
        "LVL",
        1.0,
        (1.0 / 0.702804).round(2)
      ]
    @declaration.declaration_companies_count.should == @declaration.companies.size
  end

  it "should create securities" do
    @declaration.securities.map{|r| [r.issuer, r.registration_number, r.legal_address, r.kind, r.units,
          r.amount, r.currency, r.amount_lvl, r.amount_eur]}.first.should ==
      [
        "AS \"SEB banka\"",
        "40003151743",
        "Latvija, Ķekavas pag., Valdlauči, Meistaru 1",
        "Obligācijas",
        200,
        20000.00,
        "EUR",
        20000.00 * 0.702804,
        20000.00
      ]
    @declaration.declaration_securities_count.should == @declaration.securities.size
  end

  it "should create vehicles" do
    @declaration.vehicles.map{|r| [r.kind, r.model, r.release_year, r.registration_year, r.ownership_type]}.first.should ==
      [
        "Vieglais pasažieru",
        "MERCEDES BENZ ML320",
        2007,
        2008,
        "īpašumā"
      ]
    @declaration.declaration_vehicles_count.should == @declaration.vehicles.size
  end

  it "creates cash on hand" do
    @declaration.cash.map { |r|
      [r.kind, r.amount, r.currency, r.amount_lvl, r.amount_eur, r.amount_in_words]
    }.first.should ==
      [
        "Skaidrās naudas uzkrājuma summa ar cipariem",
        500.00,
        "LVL",
        500.00,
        BigDecimal((500.00 / 0.702804).round(2).to_s),
        "pieci simti latu"
      ]
    @declaration.declaration_cash_count.should == @declaration.cash.size
  end

  it "creates cash in bank" do
    @declaration.cash.map { |r|
      if r.bank
        [r.kind, r.amount, r.currency, r.amount_lvl, r.amount_eur, r.bank, r.registration_number, r.legal_address]
      end
    }.compact.first.should ==
      [
        "Bezkaidrās naudas uzkrājuma summa",
        25289.31,
        "LVL",
        25289.31,
        BigDecimal((25289.31 / 0.702804).round(2).to_s),
        "AS \"SEB banka\"",
        "40003151743",
        "Latvija, Ķekavas pag., Valdlauči, Meistaru 1"
      ]
  end

  it "creates income" do
    @declaration.income.map { |r|
      if r.registration_number
        [r.source, r.registration_number, r.legal_address, r.kind, r.amount.to_s, r.currency, r.amount_lvl.to_s, r.amount_eur.to_s]
      end
    }.compact.first.should ==
      [
        "'LATVIJAS REPUBLIKAS SAEIMA'",
        "90000028300",
        "Latvija, Rīga, Jēkaba 11",
        "Alga",
        "9572.13",
        "LVL",
        '9572.13',
        (9572.13 / 0.702804).round(2).to_s
      ]
    @declaration.declaration_income_count.should == @declaration.income.size
  end

  it "creates deals"do
    @declaration.deals.map { |r|
      [r.description, r.amount, r.currency, r.amount_lvl, r.amount_eur.to_s]
    }.first.should ==
      [
        "ZEME GARK.KLĀVKALTIŅI-12",
        44000.00,
        "LVL",
        44000.00,
        (44000 / 0.702804).round(2).to_s
      ]
    @declaration.declaration_deals_count.should == @declaration.deals.size
  end

  it "creates debts" do
    @declaration.debts.map { |r|
      [r.amount, r.currency, r.amount_lvl, r.amount_eur.to_s, r.amount_in_words]
    }.first.should ==
      [
        5000.00,
        "LVL",
        5000.00,
        (5000 / 0.702804).round(2).to_s,
        "pieci tūkstoši latu"
      ]
    @declaration.declaration_debts_count.should == @declaration.debts.size
  end

  it "creates loans" do
    @declaration.loans.map { |r|
      [r.amount, r.currency, r.amount_lvl, r.amount_eur.to_s, r.amount_in_words]
    }.first.should ==
      [
        190548.41,
        "LVL",
        190548.41,
        (190548.41 / 0.702804).round(2).to_s,
        "viens simts deviņdesmit tūkstoši pieci simti četrdesmit astoņi lati 41 santīms"
      ]
    @declaration.declaration_loans_count.should == @declaration.loans.size
  end

  it "creats other facts" do
    @declaration.other_facts.map { |r| [r.description] }.first.should ==
      [
        "2011 GADA ZIEDOJUMI-NĪTAURES VIDUSSK., SIGULDAS VALSTS ĢIMNĀZIJA,MEDUMU VIDUSSKOLA, CĒSU VALSTS ĢIMNĀZIJA, VIĻĀNU VIDUSSK."
      ]
  end

  it "creates relatives" do
    @declaration.relatives.map { |r|
      [r.full_name, r.kind]
    }.first.should ==
      [
        "AIGARS BĒRZIŅŠ",
        "Dēls"
      ]
    @declaration.declaration_relatives_count.should == @declaration.relatives.size
    @declaration.declaration_children_count.should == @declaration.relatives.select{|r| r.kind =~ /dēls|meita/i}.size
  end

  it "creates person" do
    person = Person.find(@declaration.person_id)
    person.full_name.should == "ANDRIS BĒRZIŅŠ"
    person.first_name.should == "ANDRIS"
    person.last_name.should == "BĒRZIŅŠ"
  end

  it "should delete imported declarations in a project" do
    ImportDeclaration.delete_imported!(project: @project)
    Declaration.where(project: @project).should be_empty
    [
      DeclarationOtherWorkplace,
      DeclarationRealEstate,
      DeclarationCompany,
      DeclarationSecurity,
      DeclarationVehicle,
      DeclarationCash,
      DeclarationIncome,
      DeclarationDeal,
      DeclarationDebt,
      DeclarationLoan,
      DeclarationOtherFact,
      DeclarationRelative
    ].each do |klass|
      klass.where(declaration_id: @declaration.id).should be_empty
    end
    Person.where(id: @declaration.person_id).should be_empty
    ImportDeclaration.find(@import_declaration.id).status.should == 'new'
  end
end
