# frozen_string_literal: true

# 插件元信息
# name: discourse-auto-lottery
# about: Discourse 自动抽奖插件，基于回复自动参与，支持定时自动开奖
# version: 0.1
# authors: YourName
# url: https://github.com/yourname/discourse-auto-lottery

enabled_site_setting :auto_lottery_enabled

after_initialize do
  # 添加一个后台插件页面条目，不需要页面内容
  add_admin_route 'auto_lottery.title', 'auto-lottery'
  
  # 加载模型
  # require_relative "app/models/auto_lottery"
  require_relative "app/models/auto_lottery/lottery"
  require_relative "app/models/auto_lottery_entry"

  # 加载控制器
  require_relative "app/controllers/discourse_auto_lottery/admin_controller"
  require_relative "app/controllers/auto_lottery/entries_controller"

  # 加载 BBCode 抽奖解析器
  require_relative "lib/auto_lottery/post_handler"

  # 注册后台管理页面视图路径
  if defined?(Admin::AdminController)
    Admin::AdminController.prepend_view_path(File.expand_path("../app/views", __FILE__))
    add_admin_route "auto_lottery.title", "auto_lottery"
  end

  # 定时任务：自动开奖
  # require_relative "app/jobs/auto_draw_lottery_job"
  require_relative "app/jobs/scheduled/auto_draw_lottery_job"

  # 注册路由
  Discourse::Application.routes.append do
    namespace :auto_lottery, constraints: StaffConstraint.new do
      get "/" => "admin#index"
      post "/admin/draw/:id" => "admin#draw"
    end

    post "/auto_lottery/entries" => "entries#create"
  end

  # 帖子创建时解析抽奖标签
  on(:post_created) do |post|
    ::AutoLottery::PostHandler.handle_post(post)
  end
end

# 注册前端资源
# register_asset "javascripts/discourse/initializers/auto-lottery.js", :client
register_asset "stylesheets/admin/auto-lottery.scss"

