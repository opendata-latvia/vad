class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string   :email, :null => false
      t.boolean  :super_admin
      t.boolean  :user_admin
      t.boolean  :data_admin
      t.string   :encrypted_password, :limit => 128, :default => "", :null => false
      t.string   :reset_password_token
      t.datetime :remember_created_at
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.integer  :failed_attempts, :default => 0
      t.string   :unlock_token
      t.datetime :locked_at
      t.string   :authentication_token
      t.string   :invitation_token, :limit => 60
      t.datetime :invitation_sent_at
      t.datetime :invitation_accepted_at
      t.integer  :invitation_limit
      t.integer  :invited_by_id
      t.string   :invited_by_type
      t.datetime :created_at
      t.datetime :updated_at
      t.datetime :reset_password_sent_at
    end

    add_index :users, :email, :unique => true
    add_index :users, :confirmation_token, :unique => true
    add_index :users, :invitation_token, :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :unlock_token, :unique => true

  end

  def down
    drop_table :users
  end
end
