class ImportDeclarationsController < ApplicationController
  def index
    @import_declarations = ImportDeclaration.search(params)
  end

  def import
    @import_declaration = ImportDeclaration.find(params[:id])
    @import_declaration.import!
    redirect_to :action => :index
  end

  def import_all
    ImportDeclaration.import_all!
    redirect_to :action => :index
  end

  def delete_imported
    ImportDeclaration.delete_imported!
    redirect_to :action => :index
  end

  def show
    @import_declaration = ImportDeclaration.find(params[:id])
    respond_to do |format|
      format.json do
        render :json => @import_declaration
      end
    end
  end

end
