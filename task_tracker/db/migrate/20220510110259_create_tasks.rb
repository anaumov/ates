class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :description, null: false
      t.references :account
      t.string :status, null: false, default: :in_progress
      t.timestamps
    end
  end
end
