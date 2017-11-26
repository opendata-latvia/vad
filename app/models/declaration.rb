# encoding: utf-8
require "csv"

class Declaration < ActiveRecord::Base
  has_many :other_workplaces, dependent: :destroy, class_name: "DeclarationOtherWorkplace"
  has_many :real_estates, dependent: :destroy, class_name: "DeclarationRealEstate"
  has_many :companies, dependent: :destroy, class_name: "DeclarationCompany"
  has_many :securities, dependent: :destroy, class_name: "DeclarationSecurity"
  has_many :vehicles, dependent: :destroy, class_name: "DeclarationVehicle"
  has_many :cash, dependent: :destroy, class_name: "DeclarationCash"
  has_many :income, dependent: :destroy, class_name: "DeclarationIncome"
  has_many :deals, dependent: :destroy, class_name: "DeclarationDeal"
  has_many :debts, dependent: :destroy, class_name: "DeclarationDebt"
  has_many :loans, dependent: :destroy, class_name: "DeclarationLoan"
  has_many :other_facts, dependent: :destroy, class_name: "DeclarationOtherFact"
  has_many :relatives, dependent: :destroy, class_name: "DeclarationRelative"

  DATATABLE_COLUMNS = [
    {:name => 'full_name_with_id', :label => 'Vārds, Uzvārds (ID)', :data_type => :string},
    {:name => 'project', :label => 'Projekts', :data_type => :string},
    {:name => 'person_id', :label => 'Personas ID', :data_type => :integer},
    {:name => 'full_name', :label => 'Vārds, Uzvārds', :data_type => :string},
    {:name => 'id', :label => 'Deklarācijas ID', :data_type => :integer},
    {:name => 'kind', :label => 'Veids', :data_type => :string},
    {:name => 'period_year', :label => 'Gads', :data_type => :string},
    {:name => 'workplace', :label => 'Darba vieta', :data_type => :string},
    {:name => 'position', :label => 'Amats', :data_type => :string},
    {:name => 'declaration_real_estates_count', :label => 'Nekust. īp. skaits', :data_type => :integer},
    {:name => 'declaration_companies_count', :label => 'Uzņēmumu skaits', :data_type => :integer},
    {:name => 'companies_amount_eur', :label => 'Uzņēmumu vērt. EUR', :data_type => :integer},
    {:name => 'declaration_securities_count', :label => 'Vērtspapīru skaits', :data_type => :integer},
    {:name => 'securities_amount_eur', :label => 'Vērtspapīru vērt. EUR', :data_type => :integer},
    {:name => 'declaration_vehicles_count', :label => 'Transportlīdz. skaits', :data_type => :integer},
    {:name => 'cash_amount_eur', :label => 'Skaidr. naudas uzkr. EUR', :data_type => :decimal},
    {:name => 'bank_amount_eur', :label => 'Bezsk. naudas uzkr. EUR', :data_type => :decimal},
    {:name => 'income_amount_eur', :label => 'Ieņēmumi EUR', :data_type => :decimal},
    {:name => 'deals_amount_eur', :label => 'Darījumi EUR', :data_type => :decimal},
    {:name => 'debts_amount_eur', :label => 'Parādi EUR', :data_type => :decimal},
    {:name => 'loans_amount_eur', :label => 'Aizdevumi EUR', :data_type => :decimal},
    {:name => 'declaration_relatives_count', :label => 'Radinieku skaits', :data_type => :integer},
    {:name => 'declaration_children_count', :label => 'Bērnu skaits', :data_type => :integer}
  ]

  DATATABLE_COLUMN_NAMES = DATATABLE_COLUMNS.map{|c| c[:name]}

  DATATABLE_DECLARATION_ID_INDEX = DATATABLE_COLUMNS.map.with_index{|column, i| column[:name] == 'id' ? i : nil}.compact.first

  def self.datatable_columns
    DATATABLE_COLUMNS
  end

  def self.datatable_column_names
    DATATABLE_COLUMN_NAMES
  end

  def self.data_rows_count
    count.to_i
  end

  class Query
    attr_reader :query, :parts

    def initialize(query)
      @query = query
      @parts = []
      parse_query
    end

    private

    PART_REGEXP = %r{
      (                 # attribute or value if no attribute is present
        [^\s"':=><!]+   # attribute without spaces or quotes
      |
        "(?:[^"]|"")+"  # attribute in double quotes, inside it all quotes should be doubled
      |
        '[^']+'         # attribute in single quotes
      )
      (?:
        (:|!?=|[><]=?)  # allowed operators between attribute and quote
      (
        [^\s"']+        # value without spaces or quotes
      |
        "(?:[^"]|"")+"  # value in double quotes, inside it all quotes should be doubled
      |
        '[^']+'         # value in single quotes
      )
      )?
    }x
    QUOTED_VALUE_REGEXP = /\A(["'])(.*)\1\Z/

    def parse_query
      @query.scan(PART_REGEXP).map do |attribute, operator, value|
        attribute = $2.gsub($1+$1, $1) if attribute =~ QUOTED_VALUE_REGEXP
        value = $2.gsub($1+$1, $1) if value =~ QUOTED_VALUE_REGEXP
        @parts << case operator
        when ':'
          [:contains, attribute, value]
        when nil
          [:contains, :any, attribute]
        else
          [operator.to_sym, attribute, value]
        end
      end
    end
  end

  def self.data_search(query_string, params = {})
    results_relation = Declaration.arel_table.from(table_name)

    if query_string.present?
      query = Query.new query_string
      query.parts.each do |operator, attribute, value|
        add_relation_condition(results_relation, operator, attribute, value)
      end
    end

    count_relation = results_relation.clone.project('COUNT(*)')
    results_relation.project(*datatable_column_names.map{|c|
      if c == 'full_name_with_id'
        "CONCAT(full_name, ' (', COALESCE(person_id, ''), ')') AS full_name_with_id"
      else
        c
      end
    })

    if column = datatable_column_names.detect{|name| name == params[:sort]}
      if column == 'full_name_with_id'
        results_relation.order "full_name #{params[:sort_direction] || 'asc'}, person_id #{params[:sort_direction] || 'asc'}"
      else
        results_relation.order "#{column} #{params[:sort_direction] || 'asc'}"
      end
    end

    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 10).to_i
    offset = per_page * (page - 1)
    results_relation.skip(offset).take(per_page)

    results_sql = results_relation.to_sql
    logger.debug "[data_search] SQL: #{results_sql}"
    {
      :rows => Declaration.connection.select_rows(results_sql),
      :total_results => params[:total_results] == false ? nil : Declaration.connection.select_value(count_relation.to_sql)
    }
  end

  def self.data_download(params)
    all_pages = true
    page = 1
    params[:per_page] = 5000

    while true
      search_results = data_search(
        params[:q],
        params.slice(
          :sort, :sort_direction, :per_page
        ).merge(:page => page, :total_results => false)
      )
      result_rows = search_results[:rows]
      data = case params[:format]
      when 'csv'
        csv_data = CSV.generate do |csv|
          csv << datatable_column_names if !all_pages || page == 1
          result_rows.each do |row|
            csv << row
          end
        end
        csv_data
      else
        result_rows
      end
      yield data
      break if !all_pages || result_rows.length == 0
      page += 1
    end
  end

  def self.download_klasses
    [
      Declaration,
      DeclarationCash,
      DeclarationCompany,
      DeclarationDeal,
      DeclarationDebt,
      DeclarationIncome,
      DeclarationLoan,
      DeclarationOtherFact,
      DeclarationOtherWorkplace,
      DeclarationRealEstate,
      DeclarationRelative,
      DeclarationSecurity,
      DeclarationVehicle
    ]
  end

  def self.download_all_files(params)
    FileUtils.mkdir_p download_files_path

    (klasses = download_klasses).each do |klass|
      create_table_csv_file(klass)
    end

    data_download(params) do |data|
      declaration_ids = data.map{|r| r[DATATABLE_DECLARATION_ID_INDEX]}.compact
      next unless declaration_ids.present?
      klasses.each do |klass|
        append_rows_to_table_csv_file(klass, klass_table_rows(klass, declaration_ids))
      end
    end
    zipped_log_files(klasses)
  end

  def self.klass_table_rows(klass, declaration_ids)
    sql = "SELECT * FROM #{klass.table_name} WHERE "
    id_name = klass == Declaration ? 'id' : 'declaration_id'
    sql << "#{id_name} IN (#{declaration_ids.map(&:to_s).join(',')}) ORDER BY #{id_name}"
    sql << ", id" unless klass == Declaration
     klass.connection.select_rows(sql)
  end

  def self.zipped_log_files(klasses)
    zip_file_path = download_files_path.join("declarations.zip")
    File.delete zip_file_path if File.file?(zip_file_path)

    Zip::File.open(zip_file_path, Zip::File::CREATE) do |zip_file|
      klasses.each do |klass|
        file_path = table_csv_file_name(klass)
        file_name = File.basename(file_path)
        zip_file.add file_name, file_path
      end
    end
    zip_file_path
  end


  def self.create_table_csv_file(klass)
    File.open(table_csv_file_name(klass), 'w') do |f|
      f.puts klass.connection.columns(klass.table_name).map(&:name).to_csv
    end
  end

  def self.append_rows_to_table_csv_file(klass, rows)
    File.open(table_csv_file_name(klass), 'a') do |f|
      f.puts rows.map(&:to_csv).join
    end
  end

  def self.download_files_path
    Rails.root.join("tmp/download")
  end

  def self.table_csv_file_name(klass)
    download_files_path.join("#{klass.table_name}.csv")
  end

  private

  def self.add_relation_condition(results_relation, operator, attribute, value)
    condition_string = if attribute == :any
      # conditions = columns.map do |column|
      #   if column[:data_type] == :string
      #     column_condition(operator, column, value)
      #   end
      # end.compact
      # "(#{conditions.join(' OR ')})" if conditions.present?
    elsif column = datatable_columns.detect{|c| c[:name] == attribute}
      column_condition(operator, column, value)
    end
    results_relation.where(Arel::Nodes::SqlLiteral.new condition_string) if condition_string.present?
  end

  def self.column_condition(operator, column, value)
    return nil if value.blank?
    case operator
    when :contains
      "#{column[:name]} LIKE #{Declaration.connection.quote "%#{value}%"}"
    when :"=", :"!=", :<, :<=, :>, :>=
      "#{column[:name]} #{operator} #{Declaration.connection.quote bind_value(column, value)}"
    end
  end

  def self.bind_value(column, raw_value)
    return nil if raw_value.nil?
    case column[:data_type]
    when :string
      raw_value
    when :integer
      raw_value.to_i
    when :decimal
      BigDecimal(raw_value)
    when :date
      Date.parse raw_value
    when :datetime
      Time.parse raw_value
    end
  rescue ArgumentError
    nil
  end

end
