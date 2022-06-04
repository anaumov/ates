class AddBalanceToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :balance_cents, :integer, null: false, default: 0
  end
end
