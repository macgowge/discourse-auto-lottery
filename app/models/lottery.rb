module AutoLottery
  class Lottery < ActiveRecord::Base
    self.table_name = "lotteries"

    belongs_to :creator, class_name: "User", foreign_key: :creator_id

    validates :title, presence: true
    validates :prize_name, presence: true
    validates :prize_count, numericality: { greater_than: 0 }
    validates :auto_draw_at, presence: true
    validates :status, inclusion: { in: %w[active completed cancelled] }

    # 解析中奖用户名为数组
    def winner_usernames_array
      winner_usernames.to_s.split(",").map(&:strip)
    end

    # 判断开奖时间是否到
    def due_for_draw?
      status == "active" && auto_draw_at <= Time.current
    end

    # 标记开奖完成，设置中奖用户名
    def complete_draw(winners)
      self.status = "completed"
      self.winner_usernames = winners.join(",")
      save!
    end

    # 增加参与数
    def increment_entries!
      self.total_entries += 1
      save!
    end
  end
end
