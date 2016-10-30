class AddImportDeclarationIdIndex < ActiveRecord::Migration
  def change
    add_index :declarations, [:import_declaration_id]
  end
end
