# app/controllers/auto_lottery/admin_controller.rb
module AutoLottery
  class AdminController < ::ApplicationController
    requires_plugin "discourse-auto-lottery"
    before_action :ensure_staff

    def index
      lotteries = AutoLottery.order(auto_draw_at: :desc).limit(50)
      render json: lotteries.as_json(only: [:id, :post_id, :prize_name, :prize_count, :auto_draw_at, :status, :winner_ids])
    end

    def draw
      lottery = AutoLottery.find_by(id: params[:id])
      if lottery.nil? || lottery.status != "active"
        render json: { success: false, error: "抽奖不存在或状态错误" }
        return
      end

      lottery.draw!
      winners = User.where(id: lottery.winner_ids).pluck(:username)

      render json: { success: true, message: "开奖完成，中奖用户: #{winners.join(', ')}" }
    end
  end
end
