class AddCounterCacheToDeclarationHasManyAssociations < ActiveRecord::Migration
  def change
    add_column :declarations, :declaration_other_workplaces_count, :integer, :default => 0
    add_column :declarations, :declaration_real_estates_count, :integer, :default => 0
    add_column :declarations, :declaration_companies_count, :integer, :default => 0
    add_column :declarations, :declaration_securities_count, :integer, :default => 0
    add_column :declarations, :declaration_vehicles_count, :integer, :default => 0
    add_column :declarations, :declaration_cash_count, :integer, :default => 0
    add_column :declarations, :declaration_income_count, :integer, :default => 0
    add_column :declarations, :declaration_deals_count, :integer, :default => 0
    add_column :declarations, :declaration_debts_count, :integer, :default => 0
    add_column :declarations, :declaration_loans_count, :integer, :default => 0
    add_column :declarations, :declaration_relatives_count, :integer, :default => 0
    add_column :declarations, :declaration_childrens_count, :integer, :default => 0
  end
end
