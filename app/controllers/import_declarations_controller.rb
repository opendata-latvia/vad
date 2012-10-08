class ImportDeclarationsController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :read, ImportDeclaration
    @import_declarations = ImportDeclaration.search(params)
  end

  def import
    @import_declaration = ImportDeclaration.find(params[:id])
    authorize! :import, @import_declaration
    @import_declaration.import!
    redirect_to :action => :index
  end

  def import_all
    authorize! :import, ImportDeclaration
    ImportDeclaration.import_all!
    redirect_to :action => :index
  end

  def delete_imported
    authorize! :destroy, Declaration
    ImportDeclaration.delete_imported!
    redirect_to :action => :index
  end

  def show
    @import_declaration = ImportDeclaration.find(params[:id])
    authorize! :read, @import_declaration
    respond_to do |format|
      format.json do
        render :json => @import_declaration
      end
    end
  end

  def destroy
    @import_declaration = ImportDeclaration.find(params[:id])
    authorize! :destroy, @import_declaration
    @import_declaration.destroy
    respond_to do |format|
      format.json do
        render :json => ""
      end
    end
  end

end
