class ImportDeclarationsController < ApplicationController
  before_filter :authenticate_user!, except: :create

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

  def create
    source_id = params[:id].presence
    project = (params[:project] || params[:collection]).presence
    result = if source_id && ImportDeclaration.find_by_source_id_and_project(source_id, project)
      'IN'
    else
      ImportDeclaration.create(
        data: params[:data],
        project: project,
        source_id: source_id
      )
      'OK'
    end
    response.headers['Access-Control-Allow-Origin'] = '*'
    render text: result
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
