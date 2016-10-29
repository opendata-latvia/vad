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
    redirect_to import_declarations_path(params.slice(:project))
  end

  def import_all
    authorize! :import, ImportDeclaration
    ImportDeclaration.import_all!(params)
    redirect_to import_declarations_path(params.slice(:project))
  end

  def delete_imported
    authorize! :destroy, Declaration
    ImportDeclaration.delete_imported!
    redirect_to :action => :index
  end

  def create
    md5 = Digest::MD5.hexdigest(params[:data].to_s)
    project = (params[:project] || params[:collection]).presence
    result = if ImportDeclaration.find_by_md5_and_project(md5, project)
      'IN'
    else
      if (data_json = (JSON.parse(params[:data]) rescue nil)) && data_json['sections'].present?
        ImportDeclaration.create(
          data: params[:data],
          md5: md5,
          project: project
        )
        'OK'
      else
        'ERROR'
      end
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
