class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.integer :product_id, null: false, index: true
      t.integer :account_id, null: false, index: true
      t.string :transaction_type, null: false
      t.string :amount_cents, null: false
      t.timestamps
    end
  end
end
