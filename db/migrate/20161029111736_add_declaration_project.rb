class AddDeclarationProject < ActiveRecord::Migration
  def change
    add_column :declarations, :project, :string
  end
end
