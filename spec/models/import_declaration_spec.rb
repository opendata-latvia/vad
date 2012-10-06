# encoding: utf-8

require "spec_helper"

describe "import declaration" do
  before(:all) do
    @data = File.read(File.expand_path("data.json", "#{Rails.root}/spec/fixtures"))
  end

  before(:each) do
    @import_declaration = ImportDeclaration.new(
      :status => 'new',
      :data => @data
    )
    @import_declaration.import!
    @declaration = Declaration.last
  end

  it "should have data as array" do
    @import_declaration.data.should be_kind_of(Array)
  end

  it "should create declaration header" do
    @declaration.should_not be_nil
    @declaration.kind.should == "Kārtējā gada deklarācija"
    @declaration.period_year.should == 2011
    @declaration.workplace.should == "'LATVIJAS VALSTS PREZIDENTA KANCELEJA'"
    @declaration.position.should == "Valsts prezidents"
    @declaration.submitted_on.should == Date.new(2012,03,29)
    @declaration.published_on.should == Date.new(2012,04,13)
  end

  it "should create other workplaces" do
    @declaration.other_workplaces.map{|r| [r.position, r.workplace, r.registration_number, r.legal_address]}.should == [
      [ "KĀJIŅAS ZEMNIEKU SAIMNIECĪBA", "Cēsu rajona Drabešu pagasta zemnieku saimniecība \"KĀJIŅAS\"",
        "44101029858", "Latvija, Drabešu pag., \"KĀJIŅAS\""
      ],
      [ "Valsts prezidents", "'LATVIJAS VALSTS PREZIDENTA KANCELEJA'",
        "90000038578", "Latvija, Rīga, Pils laukums 3"
      ]
    ]
  end

  it "should create real estates" do
    @declaration.real_estates.map{|r| [r.kind, r.location, r.ownership_type, r.other_owners]}.first.should ==
      [
        "Zeme,ēkas.",
        "Latvija, Līgatnes pag.",
        "īpašumā",
        "-"
      ]
  end

  it "should create companies" do
    @declaration.companies.map{|r| [r.name, r.registration_number, r.legal_address, r.shares,
          r.amount, r.currency, r.amount_lvl]}.first.should ==
      [
        "Cēsu rajona Drabešu pagasta zemnieku saimniecība \"KĀJIŅAS\"",
        "44101029858",
        "Latvija, Drabešu pag., \"KĀJIŅAS\"",
        1,
        1.0,
        "LVL",
        1.0
      ]
  end

  it "should create securities" do
    @declaration.securities.map{|r| [r.issuer, r.registration_number, r.legal_address, r.kind, r.units,
          r.amount, r.currency, r.amount_lvl]}.first.should ==
      [
        "AS \"SEB banka\"",
        "40003151743",
        "Latvija, Ķekavas pag., Valdlauči, Meistaru 1",
        "Obligācijas",
        200,
        20000.00,
        "EUR",
        20000.00 * 0.702804
      ]
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
  end



end
