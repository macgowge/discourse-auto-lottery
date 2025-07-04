# frozen_string_literal: true

module AutoLottery
  class AdminController < ::Admin::AdminController
    requires_plugin "discourse-auto-lottery"

    before_action :find_lottery, only: [:draw]

    def index
      lotteries = AutoLottery.order(created_at: :desc).limit(50)
      render json: lotteries.as_json(only: [:id, :post_id, :prize_name, :status, :auto_draw_at, :prize_count])
    end

    def draw
      raise Discourse::NotAuthorized unless current_user.admin?

      if @lottery.drawn?
        render json: { error: "该抽奖已开奖" }, status: 422
        return
      end

      @lottery.draw!
      render json: { success: true, message: "开奖成功", winners: @lottery.winners }
    end

    private

    def find_lottery
      @lottery = AutoLottery.find(params[:id])
    end
  end
end
