# frozen_string_literal: true

class AutoLottery < ActiveRecord::Base
  self.table_name = "auto_lotteries"

  belongs_to :post
  belongs_to :user # 创建者

  serialize :winners, Array

  validates :post_id, presence: true, uniqueness: true
  validates :prize_name, presence: true
  validates :auto_draw_at, presence: true

  scope :active, -> { where("auto_draw_at > ?", Time.current) }

  def draw!
    return if drawn?

    entries = AutoLotteryEntry.where(auto_lottery_id: id).where.not(user_id: user_id).distinct(:user_id)
    user_ids = entries.pluck(:user_id).uniq
    winners_ids = user_ids.sample(prize_count)

    update!(
      winners: winners_ids,
      drawn_at: Time.current,
      status: "drawn"
    )
  end

  def drawn?
    status == "drawn"
  end
end
