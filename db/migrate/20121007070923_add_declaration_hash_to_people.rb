class AddDeclarationHashToPeople < ActiveRecord::Migration
  def change
    add_column :people, :declaration_hash, :string
  end
end
