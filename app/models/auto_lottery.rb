# frozen_string_literal: true

class AutoLottery < ActiveRecord::Base
  self.table_name = "auto_lotteries"

  belongs_to :post
  belongs_to :creator, class_name: "User", foreign_key: "user_id"

  has_many :entries, class_name: "AutoLotteryEntry", foreign_key: :auto_lottery_id

  validates :post_id, presence: true, uniqueness: true
  validates :prize_name, presence: true
  validates :auto_draw_at, presence: true
  validates :prize_count, numericality: { greater_than: 0 }

  enum status: { active: 0, drawn: 1 }

  scope :active, -> { where("auto_draw_at > ?", Time.current) }

  def draw!
    return if drawn?

    # 剔除发起人，去重
    user_ids = entries.where.not(user_id: creator.id).pluck(:user_id).uniq
    winner_ids = user_ids.sample(prize_count)

    update!(
      winner_ids: winner_ids,
      drawn_at: Time.current,
      status: :drawn
    )
  end

  def drawn?
    status == "drawn"
  end
end
