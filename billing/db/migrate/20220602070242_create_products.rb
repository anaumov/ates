class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :product_type, null: false
      t.string :product_public_id, null: false
      t.string :transaction_type, null: false
      t.integer :price_cents, null: false
      t.timestamps
    end
  end
end
