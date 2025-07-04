# frozen_string_literal: true

class AutoLotteryEntry < ActiveRecord::Base
  self.table_name = "auto_lottery_entries"

  belongs_to :auto_lottery
  belongs_to :user

  validates :auto_lottery_id, :user_id, presence: true
  validates :user_id, uniqueness: { scope: :auto_lottery_id }
end
