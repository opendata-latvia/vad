class AddEurAmounts < ActiveRecord::Migration
  def change
    add_column :declaration_cash, :amount_eur, :decimal, precision: 15, scale: 2
    add_column :declaration_companies, :amount_eur, :decimal, precision: 15, scale: 2
    add_column :declaration_deals, :amount_eur, :decimal, precision: 15, scale: 2
    add_column :declaration_debts, :amount_eur, :decimal, precision: 15, scale: 2
    add_column :declaration_income, :amount_eur, :decimal, precision: 15, scale: 2
    add_column :declaration_loans, :amount_eur, :decimal, precision: 15, scale: 2
    add_column :declaration_securities, :amount_eur, :decimal, precision: 15, scale: 2
    add_column :declarations, :cash_amount_eur, :decimal, precision: 15, scale: 2
    add_column :declarations, :bank_amount_eur, :decimal, precision: 15, scale: 2
    add_column :declarations, :companies_amount_eur, :decimal, precision: 15, scale: 2
    add_column :declarations, :deals_amount_eur, :decimal, precision: 15, scale: 2
    add_column :declarations, :debts_amount_eur, :decimal, precision: 15, scale: 2
    add_column :declarations, :income_amount_eur, :decimal, precision: 15, scale: 2
    add_column :declarations, :loans_amount_eur, :decimal, precision: 15, scale: 2
    add_column :declarations, :securities_amount_eur, :decimal, precision: 15, scale: 2
  end
end
