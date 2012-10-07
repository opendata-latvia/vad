class AddDeclarationTotalLvlColumns < ActiveRecord::Migration
  def change
    rename_column :declarations, :declaration_childrens_count, :declaration_children_count
    add_column :declarations, :cash_amount_lvl, :decimal, :precision => 15, :scale => 2
    add_column :declarations, :bank_amount_lvl, :decimal, :precision => 15, :scale => 2
    add_column :declarations, :companies_amount_lvl, :decimal, :precision => 15, :scale => 2
    add_column :declarations, :deals_amount_lvl, :decimal, :precision => 15, :scale => 2
    add_column :declarations, :debts_amount_lvl, :decimal, :precision => 15, :scale => 2
    add_column :declarations, :income_amount_lvl, :decimal, :precision => 15, :scale => 2
    add_column :declarations, :loans_amount_lvl, :decimal, :precision => 15, :scale => 2
    add_column :declarations, :securities_amount_lvl, :decimal, :precision => 15, :scale => 2
  end

end
