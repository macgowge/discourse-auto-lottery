module AutoLottery
  class Entry < ActiveRecord::Base
    self.table_name = "lottery_entries"

    belongs_to :lottery, class_name: "AutoLottery::Lottery"
    belongs_to :user

    validates :lottery_id, presence: true
    validates :user_id, presence: true
    validates_uniqueness_of :user_id, scope: :lottery_id
  end
end
