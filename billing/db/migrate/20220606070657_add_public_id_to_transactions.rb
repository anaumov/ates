class AddPublicIdToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :public_id, :string
    Transaction.all.each { |t| t.update_column(:public_id, SecureRandom.uuid) }
  end
end
