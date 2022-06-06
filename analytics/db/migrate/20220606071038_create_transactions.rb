class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.integer :account_id, null: false, index: true

      t.string :product_type, null: false
      t.string :transaction_type, null: false
      t.string :amount_cents, null: false
      t.string :public_id, :string, null: false
      t.timestamps
    end
  end
end
