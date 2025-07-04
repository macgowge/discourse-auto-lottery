class CreateEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :lottery_entries do |t|
      t.integer :lottery_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end

    add_index :lottery_entries, [:lottery_id, :user_id], unique: true
  end
end
