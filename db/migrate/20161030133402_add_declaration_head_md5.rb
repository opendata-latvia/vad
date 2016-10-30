class AddDeclarationHeadMd5 < ActiveRecord::Migration
  def change
    add_column :declarations, :head_md5, :string
    add_index :declarations, [:head_md5, :project]
  end
end
