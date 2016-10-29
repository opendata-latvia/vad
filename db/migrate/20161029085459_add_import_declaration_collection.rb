class AddImportDeclarationCollection < ActiveRecord::Migration
  def change
    add_column :import_declarations, :project, :string
    add_column :import_declarations, :source_id, :string

    add_index :import_declarations, :source_id
  end
end
