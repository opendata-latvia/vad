class ImportDeclarationsController < ApplicationController
  def index
    @import_declarations = ImportDeclaration.order('created_at desc')
  end

  def import

  end
end
