class InitialSchema < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :full_name
      t.string :first_name
      t.string :last_name
      t.string :person_code
    end

    create_table :declarations do |t|
      t.string :kind
      t.integer :period_year
      t.date :status_on
      t.string :full_name
      t.string :workplace
      t.string :position
      t.date :submitted_on
      t.date :published_on
      t.integer :person_id
    end

    create_table :declaration_other_workplaces do |t|
      t.integer :declaration_id
      t.string :position
      t.string :workplace
      t.string :registration_number
      t.string :legal_address
    end

    create_table :declaration_real_estates do |t|
      t.integer :declaration_id
      t.string :kind
      t.string :location
      t.string :ownership_type
      t.string :other_owners
    end

    create_table :declaration_companies do |t|
      t.integer :declaration_id
      t.string :name
      t.string :registration_number
      t.string :legal_address
      t.integer :shares
      t.decimal :amount, :precision => 15, :scale => 2
      t.string :currency
      t.decimal :amount_lvl, :precision => 15, :scale => 2
    end

    create_table :declaration_securities do |t|
      t.integer :declaration_id
      t.string :issuer
      t.string :registration_number
      t.string :kind
      t.integer :units
      t.decimal :amount, :precision => 15, :scale => 2
      t.string :currency
      t.decimal :amount_lvl, :precision => 15, :scale => 2
    end

    create_table :declaration_vehicles do |t|
      t.integer :declaration_id
      t.string :kind
      t.string :model
      t.integer :release_year
      t.integer :registration_year
      t.string :ownership_type
    end

    create_table :declaration_cash do |t|
      t.integer :declaration_id
      t.string :kind
      t.decimal :amount, :precision => 15, :scale => 2
      t.string :currency
      t.decimal :amount_lvl, :precision => 15, :scale => 2
      t.string :amount_in_words
      t.string :bank
      t.string :registration_number
      t.string :legal_address
    end

    create_table :declaration_income do |t|
      t.integer :declaration_id
      t.string :source
      t.string :registration_number
      t.string :legal_address
      t.string :kind
      t.decimal :amount, :precision => 15, :scale => 2
      t.string :currency
      t.decimal :amount_lvl, :precision => 15, :scale => 2
    end

    create_table :declaration_deals do |t|
      t.integer :declaration_id
      t.string :description
      t.decimal :amount, :precision => 15, :scale => 2
      t.string :currency
      t.decimal :amount_lvl, :precision => 15, :scale => 2
    end

    create_table :declaration_debts do |t|
      t.integer :declaration_id
      t.decimal :amount, :precision => 15, :scale => 2
      t.string :currency
      t.decimal :amount_lvl, :precision => 15, :scale => 2
      t.string :amount_in_words
    end

    create_table :declaration_loans do |t|
      t.integer :declaration_id
      t.decimal :amount, :precision => 15, :scale => 2
      t.string :currency
      t.decimal :amount_lvl, :precision => 15, :scale => 2
      t.string :amount_in_words
    end

    create_table :declaration_other_facts do |t|
      t.integer :declaration_id
      t.text :description
    end

    create_table :declaration_relatives do |t|
      t.integer :declaration_id
      t.string :full_name
      t.string :kind
    end

    create_table :import_declarations do |t|
      t.string :status, :default => 'new'
      t.text :data
    end
  end

end
