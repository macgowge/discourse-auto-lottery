module AutoLottery
  class EntriesController < ::ApplicationController
    requires_plugin "discourse-auto-lottery"

    before_action :ensure_logged_in

    def create
      lottery_id = params.require(:lottery_id)
      lottery = Lottery.find_by(id: lottery_id)

      unless lottery && lottery.status == "active"
        render_json_error("抽奖不存在或不在活动状态")
        return
      end

      user = current_user

      # 查找用户是否已参加该抽奖（通过帖子回复记录）
      if Entry.exists?(lottery_id: lottery.id, user_id: user.id)
        render json: { success: false, error: "您已参与该抽奖，无需重复参与" }
        return
      end

      # TODO: 判断用户积分是否足够扣除，扣除积分（如果设置了积分消耗）

      # 创建参与记录
      Entry.create!(lottery_id: lottery.id, user_id: user.id)

      lottery.increment_entries!

      render json: { success: true, message: "参与成功", total_entries: lottery.total_entries }
    end
  end
end
