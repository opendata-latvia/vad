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

end
