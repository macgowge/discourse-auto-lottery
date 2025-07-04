# frozen_string_literal: true

module AutoLottery
  class AdminController < ::ApplicationController
    requires_plugin "discourse-auto-lottery"

    before_action :ensure_admin

    # 获取抽奖列表
    def index
      lotteries = Lottery.order(auto_draw_at: :desc).limit(100).map do |lottery|
        {
          id: lottery.id,
          topic_id: lottery.topic_id,
          post_id: lottery.post_id,
          title: lottery.title,
          prize_name: lottery.prize_name,
          prize_count: lottery.prize_count,
          auto_draw_at: lottery.auto_draw_at,
          status: lottery.status,
          total_entries: lottery.total_entries,
          winner_usernames: lottery.winner_usernames
        }
      end

      render json: { lotteries: lotteries }
    end

    # 手动开奖
    def draw
      lottery = Lottery.find_by(id: params[:id])
      if lottery.nil? || lottery.status != "active"
        render json: { success: false, error: "抽奖不存在或状态错误" }
        return
      end

      # 剔除创建者和重复用户
      entries = Entry.where(lottery_id: lottery.id)
                     .includes(:user)
                     .where.not(user_id: lottery.creator_id)
                     .distinct(:user_id)
      users = entries.map(&:user).uniq

      winners = users.sample(lottery.prize_count).map(&:username)
      lottery.complete_draw(winners)

      render json: { success: true, message: "开奖完成，中奖用户: #{winners.join(', ')}" }
    end

    # 删除抽奖
    def destroy
      lottery = Lottery.find_by(id: params[:id])
      if lottery.nil?
        render json: { success: false, error: "找不到抽奖记录" }
        return
      end

      lottery.destroy
      render json: { success: true, message: "抽奖已删除" }
    end
  end
end
