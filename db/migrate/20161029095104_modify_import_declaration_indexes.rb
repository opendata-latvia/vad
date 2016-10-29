class ModifyImportDeclarationIndexes < ActiveRecord::Migration
  def up
    remove_index :import_declarations, :source_id
    remove_column :import_declarations, :source_id
    add_index :import_declarations, [:md5, :project], unique: true
  end

  def down
    remove_index :import_declarations, [:md5, :project]
    add_column :import_declarations, :source_id, :string
    add_index :import_declarations, :source_id
  end
end
