# frozen_string_literal: true

module AutoLottery
  class PostHandler
    BB_TAG = /\[lottery([^\]]*)\](.*?)\[\/lottery\]/im

    def self.handle_post(post)
      return unless SiteSetting.auto_lottery_enabled
      return unless post.is_first_post?
      return unless post.raw =~ BB_TAG

      match = post.raw.match(BB_TAG)
      return unless match

      params_str = match[1]
      content = match[2]

      attrs = parse_attributes(params_str)
      return unless attrs["draw_at"] # draw_at 是必须参数

      begin
        draw_time = Time.zone.parse(attrs["draw_at"])
      rescue StandardError
        return
      end

      AutoLottery.create!(
        post_id: post.id,
        topic_id: post.topic_id,
        user_id: post.user_id,
        prize_name: attrs["prize"] || content.strip,
        prize_count: attrs["count"]&.to_i || 1,
        draw_at: draw_time
      )
    end

    def self.parse_attributes(str)
      attributes = {}
      str.to_s.scan(/(\w+)="([^"]*)"/) do |key, val|
        attributes[key.downcase] = val
      end
      attributes
    end
  end
end
