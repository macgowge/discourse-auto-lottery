module AutoLottery
  class Lottery < ActiveRecord::Base
    self.table_name = "auto_lotteries"

    validates :topic_id, presence: true
    validates :draw_time, presence: true

    def should_draw?
      Time.zone.now >= draw_time && !drawn
    end
  end
end
