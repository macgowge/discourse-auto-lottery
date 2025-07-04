class CreateLotteries < ActiveRecord::Migration[6.1]
  def change
    create_table :lotteries do |t|
      t.string :title, null: false
      t.text :prize_name, null: false
      t.integer :prize_count, default: 1, null: false
      t.datetime :auto_draw_at, null: false
      t.integer :creator_id, null: false
      t.string :status, default: "active", null: false

      t.text :winner_usernames, default: "" # 中奖用户名列表，逗号分隔
      t.integer :total_entries, default: 0, null: false

      t.timestamps
    end

    add_index :lotteries, :creator_id
    add_index :lotteries, :auto_draw_at
    add_index :lotteries, :status
  end
end
