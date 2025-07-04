# discourse-auto-lottery

Discourse 自动抽奖插件，基于回复自动参与，支持定时自动开奖。  
用户通过回复帖子自动参与抽奖，创建者可设定开奖时间，系统定时自动开奖，自动剔除创建者及重复参与用户，支持多奖项开奖。

---

## 功能特点

- 通过帖子中的 BBCode 标签轻松创建抽奖  
- 用户回复帖子即自动参与，无需点击按钮  
- 自动过滤抽奖创建者和重复参与用户  
- 支持设置奖品名称和多个中奖名额  
- 支持设置定时自动开奖，无需管理员手动操作  
- 开奖结果自动公布在抽奖帖内，所有用户可见  
- 管理后台提供抽奖列表及手动开奖功能  
- 界面和提示为简体中文，易于使用  

---

## 安装步骤

1. 下载或克隆插件代码到 Discourse `plugins/` 目录：  
   ```bash
   cd /var/discourse/plugins
   git clone https://github.com/yourname/discourse-auto-lottery.git

2. 执行数据库迁移更新结构：
    cd /var/discourse
    ./launcher enter app
    rake db:migrate
    exit

3. 重启 Discourse 服务使插件生效：
    ./launcher restart app

4. 登录管理员后台，在「站点设置」中启用 auto_lottery_enabled 选项。

## 如何创建抽奖

1. 在帖子正文中使用 BBCode 标签创建抽奖，格式如下：

    [lottery prize="奖品名称" count=3 auto_draw_at="2025-12-31 23:59:59"]
    这里填写抽奖说明或规则
    [/lottery]

    参数说明：

    prize：奖品名称，必填

    count：中奖人数，默认1

    auto_draw_at：开奖时间，格式为 "YYYY-MM-DD HH:MM:SS"（24小时制），必填

    示例：
    [lottery prize="蓝牙耳机" count=2 auto_draw_at="2025-12-31 23:59:59"]
    回复本帖参与抽奖，中奖者将获得蓝牙耳机！
    [/lottery]

## 用户参与方式

    用户只需回复带有抽奖标签的帖子，即自动成为抽奖参与者。

    无需点击额外按钮，回复即视为参与。

    系统自动剔除重复用户及抽奖创建者

## 自动开奖机制

    插件会根据 auto_draw_at 设置的时间，自动定时开奖。

    开奖时随机选出指定数量的获奖者，剔除重复和创建者。

    开奖结果将自动发布在抽奖帖中，供所有用户查看。

    管理员也可通过后台手动触发开奖。

## 管理后台功能

    管理员可在后台管理页面查看和管理抽奖：

        访问路径：/admin/plugins/auto_lottery

        查看所有抽奖的基本信息（标题、奖品、参与人数、开奖时间等）

        手动触发抽奖开奖

        查看开奖结果

## 常见问题

    Q: 用户回复后为何没有参与？
    A: 请确认回复帖包含正确的抽奖帖子ID且插件已启用。

    Q: 开奖时间到了为何未开奖？
    A: 请确认定时任务 AutoDrawLotteryJob 正常运行，或者管理员手动开奖。

    Q: 可以自定义更多抽奖规则吗？
    A: 目前支持基本自动参与与定时开奖，后续可根据需求开发更多功能。

## 贡献与反馈

    欢迎提交 Issues 或 Pull Requests，感谢您的支持和贡献！

## 许可证

    MIT License

## 作者

    Chatgpt辅助生成
    GitHub: https://github.com/macgowge