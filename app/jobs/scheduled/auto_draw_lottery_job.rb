# app/jobs/scheduled/auto_draw_lottery_job.rb
module Jobs
  class AutoDrawLotteryJob < ::Jobs::Scheduled
    every 1.minute

    def execute(args)
      AutoLottery::Lottery.where(drawn: false).each do |lottery|
        if lottery.should_draw?
          topic = Topic.find_by(id: lottery.topic_id)
          next unless topic

          post_ids = Post.where(topic_id: topic.id)
                         .where.not(user_id: topic.user_id)
                         .pluck(:user_id)
                         .uniq

          next if post_ids.empty?

          winner_id = post_ids.sample
          winner = User.find_by(id: winner_id)

          if winner
            PostCreator.create!(
              Discourse.system_user,
              topic_id: topic.id,
              raw: "🎉 恭喜 [@#{winner.username}](/u/#{winner.username}) 抽中本次奖品！"
            )

            lottery.update!(drawn: true)
          end
        end
      end
    end
  end
end
