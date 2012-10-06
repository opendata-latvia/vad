class AddImportDeclarationError < ActiveRecord::Migration
  def change
    add_column :import_declarations, :error, :text
    add_column :declarations, :import_declaration_id, :integer
  end

end
