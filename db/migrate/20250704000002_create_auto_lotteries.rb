class CreateAutoLotteries < ActiveRecord::Migration[7.0]
  def change
    create_table :auto_lotteries do |t|
      t.string :topic_id
      t.datetime :draw_at
      t.boolean :drawn, default: false
      t.text :winner_usernames
      t.timestamps
    end
  end
end
