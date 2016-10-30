# encoding: utf-8

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
    if params[:project].present?
      ImportDeclaration.import_all!(params)
    else
      flash[:alert] = 'Jāizvēlas projekts, kura deklarācijas ir jāimportē!'
    end
    redirect_to import_declarations_path(params.slice(:project))
  end

  def delete_imported
    authorize! :destroy, Declaration
    if params[:project].present?
      ImportDeclaration.delete_imported!(params)
      flash[:notice] = 'Importētās deklarācijas ir izdzēstas, var veikt atkārtotu importu.'
    else
      flash[:alert] = 'Jāizvēlas projekts, kura deklarācijas ir jādzēš!'
    end
    redirect_to import_declarations_path(params.slice(:project))
  end

  def create
    project = (params[:project] || params[:collection]).presence
    data_json = (JSON.parse(params[:data]) rescue nil)
    md5 = Digest::MD5.hexdigest(params[:data].to_s)

    result = if !project
      'ERROR - jānorāda projekts!'
    elsif !data_json || data_json['sections'].blank?
      'ERROR - trūkst sections dati, mēģiniet vēlreiz!'
    elsif ImportDeclaration.find_by_md5_and_project(md5, project)
      'IN'
    else
      ImportDeclaration.create(
        data: params[:data],
        md5: md5,
        project: project
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
