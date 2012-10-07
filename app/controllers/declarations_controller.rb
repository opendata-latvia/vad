class DeclarationsController < ApplicationController
  def index

  end

  def datatable
    respond_to do |format|
      format.json do
        render :json => DeclarationsDatatable.new(view_context)
      end
    end
  end

  def download
    case format = params[:format]
    when 'csv'
      response.sending_file = true
      headers.merge!(
        'Content-Type' => 'text/csv',
        'Content-Disposition'       => "attachment; filename=\"declarations.#{format}\"",
        'Content-Transfer-Encoding' => 'binary'
      )
      self.status = 200
      self.content_type = headers["Content-Type"]
      self.response_body = Enumerator.new do |y|
        Declaration.data_download(params) do |data|
          y << data
        end
      end

    end
  end

end
