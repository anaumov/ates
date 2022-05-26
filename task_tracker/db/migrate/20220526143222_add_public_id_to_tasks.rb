class AddPublicIdToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :public_id, :string
  end
end
