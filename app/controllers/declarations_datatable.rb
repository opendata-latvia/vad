class DeclarationsDatatable
  delegate :params, :h, :link_to, :to => :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    @query_params = {}
    {
      :sEcho => params[:sEcho].to_i,
      :iTotalRecords => Declaration.data_rows_count,
      :iTotalDisplayRecords => results[:total_results],
      :aaData => data,
      :queryParams => @query_params
    }
  end

  private

  def data
    results[:rows].map do |row|
      row.map do |value|
        h value
      end
    end
  end

  def results
    @results ||= fetch_results
  end

  def fetch_results
    @query_params = {
      :q => query,
      :sort => sort_column,
      :sort_direction => sort_direction,
      :page => page,
      :per_page => per_page
    }
    Declaration.data_search @query_params[:q], @query_params.except(:q)
  end

  def query
    query_string = Declaration.datatable_column_names.map.with_index do |name, i|
      if (value = params["sSearch_#{i}"]).present?
        if value =~ /^(!?=|[><]=?)(.*)$/
          operator = $1
          value = $2
        else
          operator = ':'
        end
        "#{quote_term(name)}#{operator}#{quote_term(value)}"
      end
    end.compact.join(' ')
    query_string << " " if query_string.present? and params[:sSearch].present?
    query_string << params[:sSearch] if params[:sSearch].present?
    query_string
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    Declaration.datatable_column_names[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def quote_term(value)
    if value =~ /["'\s]/
      "\"#{value.gsub('"', '""')}\""
    else
      value
    end
  end
end
