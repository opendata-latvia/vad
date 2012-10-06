class AddDescriptionToDebtsAndLoans < ActiveRecord::Migration
  def change
    add_column :declaration_debts, :description, :text
    add_column :declaration_loans, :description, :text
  end
end
