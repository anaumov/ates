# frozen_string_literal: true

class AddDeviseToAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :email, null: false, default: ""
      t.string :provider
      t.string :doorkeeper_access_token
      t.string :doorkeeper_refresh_token

      t.string :name,      null: false, default: ""
      t.string :public_id, null: false, default: ""
      t.string :role,      null: false, default: ""

      t.timestamps null: false
    end

    add_index :accounts, :email, unique: true
  end
end
