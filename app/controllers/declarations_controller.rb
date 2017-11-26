class DeclarationsController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :read, Declaration
  end

  def datatable
    authorize! :read, Declaration
    respond_to do |format|
      format.json do
        render :json => DeclarationsDatatable.new(view_context)
      end
    end
  end

  def download
    authorize! :read, Declaration
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

  def download_all
    authorize! :read, Declaration

    send_file Declaration.download_all_files(params)
  end

end
