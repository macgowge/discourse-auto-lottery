# frozen_string_literal: true

module Jobs
  class AutoDrawLotteryJob < ::Jobs::Scheduled
    every 1.minute

    def execute(args)
      now = Time.zone.now

      Lottery.where(status: "active")
             .where("auto_draw_at <= ?", now)
             .find_each do |lottery|
        Rails.logger.info("[AutoLottery] 自动开奖抽奖 ID: #{lottery.id}")

        # 剔除创建者、重复用户
        entries = Entry.where(lottery_id: lottery.id).where.not(user_id: lottery.creator_id)
        unique_user_ids = entries.distinct.pluck(:user_id)
        users = User.where(id: unique_user_ids)

        winners = users.sample(lottery.prize_count).map(&:username)
        lottery.complete_draw(winners)

        # 系统回帖发布结果
        topic = lottery.topic
        if topic
          raw = "🎉 本次抽奖已结束！中奖用户为：#{winners.join("、")}，恭喜！"
          PostCreator.create!(Discourse.system_user, topic_id: topic.id, raw: raw)
        end
      end
    end
  end
end
