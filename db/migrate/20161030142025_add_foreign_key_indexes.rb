class AddForeignKeyIndexes < ActiveRecord::Migration
  def change
    add_index :declaration_cash, :declaration_id
    add_index :declaration_companies, :declaration_id
    add_index :declaration_deals, :declaration_id
    add_index :declaration_debts, :declaration_id
    add_index :declaration_income, :declaration_id
    add_index :declaration_loans, :declaration_id
    add_index :declaration_other_facts, :declaration_id
    add_index :declaration_other_workplaces, :declaration_id
    add_index :declaration_real_estates, :declaration_id
    add_index :declaration_relatives, :declaration_id
    add_index :declaration_securities, :declaration_id
    add_index :declaration_vehicles, :declaration_id
    add_index :people, :declaration_hash
  end
end
