# frozen_string_literal: true

module AutoLottery
  class EntriesController < ::ApplicationController
    requires_plugin "discourse-auto-lottery"

    before_action :ensure_logged_in

    def create
      lottery_id = params.require(:auto_lottery_id)
      lottery = AutoLottery.find_by(id: lottery_id)

      if lottery.nil? || lottery.drawn?
        render json: { error: "抽奖不存在或已结束" }, status: 422
        return
      end

      entry = AutoLotteryEntry.find_or_initialize_by(auto_lottery_id: lottery_id, user_id: current_user.id)
      if entry.new_record?
        entry.save
        lottery.increment!(:total_entries)
        render json: { success: true, message: "参与成功", total_entries: lottery.total_entries }
      else
        render json: { error: "您已参与过此抽奖" }, status: 422
      end
    end
  end
end
