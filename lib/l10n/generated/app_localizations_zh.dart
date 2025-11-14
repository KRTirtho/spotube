// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get guest => '访客';

  @override
  String get browse => '浏览';

  @override
  String get search => '搜索';

  @override
  String get library => '音乐库';

  @override
  String get lyrics => '歌词';

  @override
  String get settings => '设置';

  @override
  String get genre_categories_filter => '筛选类别...';

  @override
  String get genre => '探索歌单';

  @override
  String get personalized => '为你打造';

  @override
  String get featured => '推荐';

  @override
  String get new_releases => '新歌热播';

  @override
  String get songs => '歌曲';

  @override
  String playing_track(Object track) {
    return '播放 $track';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return '这将清空当前的播放队列。$track_length 首歌曲将被移除\n你确定要继续吗?';
  }

  @override
  String get load_more => '加载更多';

  @override
  String get playlists => '歌单';

  @override
  String get artists => '艺人';

  @override
  String get albums => '专辑';

  @override
  String get tracks => '歌曲';

  @override
  String get downloads => '下载';

  @override
  String get filter_playlists => '筛选歌单...';

  @override
  String get liked_tracks => '已点赞的歌曲';

  @override
  String get liked_tracks_description => '你点赞过的所有歌曲';

  @override
  String get playlist => '播放列表';

  @override
  String get create_a_playlist => '创建一个歌单';

  @override
  String get update_playlist => '更新播放列表';

  @override
  String get create => '创建';

  @override
  String get cancel => '取消';

  @override
  String get update => '更新';

  @override
  String get playlist_name => '歌单名称';

  @override
  String get name_of_playlist => '歌单的名称';

  @override
  String get description => '描述';

  @override
  String get public => '公开';

  @override
  String get collaborative => '共享协作';

  @override
  String get search_local_tracks => '搜索本地歌曲...';

  @override
  String get play => '播放';

  @override
  String get delete => '删除';

  @override
  String get none => '无';

  @override
  String get sort_a_z => '按字母正序';

  @override
  String get sort_z_a => '按字母倒序';

  @override
  String get sort_artist => '按艺人';

  @override
  String get sort_album => '按专辑';

  @override
  String get sort_duration => '按时长排序';

  @override
  String get sort_tracks => '排序方式';

  @override
  String currently_downloading(Object tracks_length) {
    return '正在下载 ($tracks_length)';
  }

  @override
  String get cancel_all => '取消全部';

  @override
  String get filter_artist => '筛选艺人...';

  @override
  String followers(Object followers) {
    return '$followers 名关注者';
  }

  @override
  String get add_artist_to_blacklist => '屏蔽该艺人';

  @override
  String get top_tracks => '热门歌曲';

  @override
  String get fans_also_like => '粉丝也喜欢';

  @override
  String get loading => '加载中...';

  @override
  String get artist => '艺人';

  @override
  String get blacklisted => '已屏蔽';

  @override
  String get following => '关注中';

  @override
  String get follow => '关注';

  @override
  String get artist_url_copied => '艺人的分享链接已复制至剪贴板';

  @override
  String added_to_queue(Object tracks) {
    return '已添加 $tracks 首歌曲到播放队列';
  }

  @override
  String get filter_albums => '筛选专辑...';

  @override
  String get synced => '同步';

  @override
  String get plain => '无同步';

  @override
  String get shuffle => '随机播放';

  @override
  String get search_tracks => '搜索歌曲...';

  @override
  String get released => '发行时间';

  @override
  String error(Object error) {
    return '错误 $error';
  }

  @override
  String get title => '标题';

  @override
  String get time => '时长';

  @override
  String get more_actions => '更多操作';

  @override
  String download_count(Object count) {
    return '下载 ($count) 首歌曲';
  }

  @override
  String add_count_to_playlist(Object count) {
    return '添加 ($count) 首歌曲到歌单中';
  }

  @override
  String add_count_to_queue(Object count) {
    return '添加 ($count) 首歌曲到播放队列中';
  }

  @override
  String play_count_next(Object count) {
    return '接下来播放 ($count) 首歌曲';
  }

  @override
  String get album => '专辑';

  @override
  String copied_to_clipboard(Object data) {
    return '已将 $data 复制至剪贴板';
  }

  @override
  String add_to_following_playlists(Object track) {
    return '添加 $track 到以下播放列表';
  }

  @override
  String get add => '添加';

  @override
  String added_track_to_queue(Object track) {
    return '添加 $track 到播放队列';
  }

  @override
  String get add_to_queue => '添加到播放队列';

  @override
  String track_will_play_next(Object track) {
    return '$track 将在下一首播放';
  }

  @override
  String get play_next => '下一首播放';

  @override
  String removed_track_from_queue(Object track) {
    return '将 $track 从播放队列中移除';
  }

  @override
  String get remove_from_queue => '从播放队列移除';

  @override
  String get remove_from_favorites => '取消点赞';

  @override
  String get save_as_favorite => '点赞';

  @override
  String get add_to_playlist => '添加到歌单';

  @override
  String get remove_from_playlist => '从歌单中移除';

  @override
  String get add_to_blacklist => '添加到屏蔽列表';

  @override
  String get remove_from_blacklist => '从屏蔽列表中移除';

  @override
  String get share => '分享';

  @override
  String get mini_player => '小窗模式';

  @override
  String get slide_to_seek => '滑动以前进或后退';

  @override
  String get shuffle_playlist => '随机播放歌单';

  @override
  String get unshuffle_playlist => '取消随机播放歌单';

  @override
  String get previous_track => '上一首歌曲';

  @override
  String get next_track => '下一首歌曲';

  @override
  String get pause_playback => '暂停播放';

  @override
  String get resume_playback => '恢复播放';

  @override
  String get loop_track => '单曲循环';

  @override
  String get no_loop => '无循环';

  @override
  String get repeat_playlist => '歌单循环';

  @override
  String get queue => '播放队列';

  @override
  String get alternative_track_sources => '其它音源';

  @override
  String get download_track => '下载歌曲';

  @override
  String tracks_in_queue(Object tracks) {
    return '$tracks 首歌曲在播放队列中';
  }

  @override
  String get clear_all => '清除全部';

  @override
  String get show_hide_ui_on_hover => '悬停时显示/隐藏控制栏';

  @override
  String get always_on_top => '置顶';

  @override
  String get exit_mini_player => '退出小窗模式';

  @override
  String get download_location => '下载路径';

  @override
  String get local_library => '本地图书馆';

  @override
  String get add_library_location => '添加到图书馆';

  @override
  String get remove_library_location => '从图书馆中删除';

  @override
  String get account => '账户';

  @override
  String get logout => '退出';

  @override
  String get logout_of_this_account => '退出该账户';

  @override
  String get language_region => '语言和地区';

  @override
  String get language => '语言';

  @override
  String get system_default => '系统默认';

  @override
  String get market_place_region => '市场地区';

  @override
  String get recommendation_country => '选择国家与地区以获取对应推荐';

  @override
  String get appearance => '外观';

  @override
  String get layout_mode => '布局类型';

  @override
  String get override_layout_settings => '将覆盖响应式布局设置';

  @override
  String get adaptive => '自适应';

  @override
  String get compact => '紧凑';

  @override
  String get extended => '宽广';

  @override
  String get theme => '主题';

  @override
  String get dark => '深色';

  @override
  String get light => '浅色';

  @override
  String get system => '系统';

  @override
  String get accent_color => '主色调';

  @override
  String get sync_album_color => '匹配封面颜色';

  @override
  String get sync_album_color_description => '选取专辑封面主题色作为主色调';

  @override
  String get playback => '播放';

  @override
  String get audio_quality => '音质';

  @override
  String get high => '高';

  @override
  String get low => '低';

  @override
  String get pre_download_play => '先下后播';

  @override
  String get pre_download_play_description => '先下载歌曲后再播放而非流式播放（推荐带宽较高用户使用）';

  @override
  String get skip_non_music => '跳过非音乐片段（屏蔽赞助商）';

  @override
  String get blacklist_description => '已屏蔽的歌曲与艺人';

  @override
  String get wait_for_download_to_finish => '请等待当前下载任务完成';

  @override
  String get desktop => '桌面端设置';

  @override
  String get close_behavior => '点击关闭按钮行为';

  @override
  String get close => '关闭';

  @override
  String get minimize_to_tray => '最小化到托盘';

  @override
  String get show_tray_icon => '显示托盘图标';

  @override
  String get about => '关于';

  @override
  String get u_love_spotube => '我们明白你喜欢 Spotube';

  @override
  String get check_for_updates => '检查更新';

  @override
  String get about_spotube => '关于 Spotube';

  @override
  String get blacklist => '屏蔽列表';

  @override
  String get please_sponsor => '请赞助/捐赠';

  @override
  String get spotube_description => 'Spotube，一个轻量、跨平台且完全免费的 Spotify 客户端。';

  @override
  String get version => '版本';

  @override
  String get build_number => '构建代码';

  @override
  String get founder => '发起人';

  @override
  String get repository => '源码';

  @override
  String get bug_issues => '缺陷和问题报告';

  @override
  String get made_with => '于孟加拉🇧🇩用 ❤️ 发电';

  @override
  String get kingkor_roy_tirtho => 'Kingkor Roy Tirtho';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year Kingkor Roy Tirtho';
  }

  @override
  String get license => '许可证';

  @override
  String get credentials_will_not_be_shared_disclaimer =>
      '不用担心，软件不会收集或分享任何个人数据给第三方';

  @override
  String get know_how_to_login => '不知道该怎么做？';

  @override
  String get follow_step_by_step_guide => '请按照以下指南进行';

  @override
  String cookie_name_cookie(Object name) {
    return '$name Cookie';
  }

  @override
  String get fill_in_all_fields => '请填写所有栏目';

  @override
  String get submit => '提交';

  @override
  String get exit => '退出';

  @override
  String get previous => '上一步';

  @override
  String get next => '下一步';

  @override
  String get done => '完成';

  @override
  String get step_1 => '步骤 1';

  @override
  String get first_go_to => '首先，前往';

  @override
  String get something_went_wrong => '某些地方出现了问题';

  @override
  String get piped_instance => 'Piped 服务器实例';

  @override
  String get piped_description => 'Piped 服务器实例用于匹配歌曲';

  @override
  String get piped_warning => '它们中的一部分可能并不能正常工作。使用时请自行承担风险';

  @override
  String get invidious_instance => 'Invidious服务器实例';

  @override
  String get invidious_description => '用于音轨匹配的Invidious服务器实例';

  @override
  String get invidious_warning => '有些可能无法正常工作。请自行承担风险';

  @override
  String get generate => '生成';

  @override
  String track_exists(Object track) {
    return '歌曲 $track 已存在';
  }

  @override
  String get replace_downloaded_tracks => '替换已下载的歌曲';

  @override
  String get skip_download_tracks => '下载时跳过已下载的歌曲';

  @override
  String get do_you_want_to_replace => '你确定要替换已下载的歌曲吗？？';

  @override
  String get replace => '替换';

  @override
  String get skip => '跳过';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return '选择多达 $count 种的类型 $type';
  }

  @override
  String get select_genres => '选择曲风';

  @override
  String get add_genres => '添加曲风';

  @override
  String get country => '国家和地区';

  @override
  String get number_of_tracks_generate => '生成歌曲的数目';

  @override
  String get acousticness => '原声程度';

  @override
  String get danceability => '律动感';

  @override
  String get energy => '冲击感';

  @override
  String get instrumentalness => '歌唱部分占比';

  @override
  String get liveness => '现场感';

  @override
  String get loudness => '响度';

  @override
  String get speechiness => '朗诵比例';

  @override
  String get valence => '心理感受';

  @override
  String get popularity => '流行度';

  @override
  String get key => '曲调';

  @override
  String get duration => '歌曲时长 (s)';

  @override
  String get tempo => '分钟节拍数 (BPM)';

  @override
  String get mode => '旋律重复度';

  @override
  String get time_signature => '音符时值';

  @override
  String get short => '短';

  @override
  String get medium => '中';

  @override
  String get long => '长';

  @override
  String get min => '最低';

  @override
  String get max => '最高';

  @override
  String get target => '目标';

  @override
  String get moderate => '中';

  @override
  String get deselect_all => '取消全选';

  @override
  String get select_all => '全选';

  @override
  String get are_you_sure => '你确定吗？';

  @override
  String get generating_playlist => '正在生成你的自定义歌单...';

  @override
  String selected_count_tracks(Object count) {
    return '已选择 $count 首歌曲';
  }

  @override
  String get download_warning =>
      '如果你大量下载这些歌曲，你显然在侵犯音乐的版权并对音乐创作社区造成了伤害。我希望你能意识到这一点。永远要尊重并支持艺术家们的辛勤工作';

  @override
  String get download_ip_ban_warning =>
      '小心，如果出现超出正常的下载请求那你的 IP 可能会被 YouTube 封禁，这意味着你的设备将在长达 2-3 个月的时间内无法使用该 IP 访问 YouTube（即使你没登录）。Spotube 对此不承担任何责任';

  @override
  String get by_clicking_accept_terms => '点击 \'同意\' 代表着你同意以下的条款';

  @override
  String get download_agreement_1 => '我明白侵犯音乐版权是一件不好的事情';

  @override
  String get download_agreement_2 => '我将尽可能支持艺术家的工作。我现在之所以做不到是因为缺乏资金来购买正版';

  @override
  String get download_agreement_3 =>
      '我完全了解我的 IP 存在被 YouTube的风险。我同意 Spotube 的所有者与贡献者们无须对我目前的行为所导致的任何后果负责';

  @override
  String get decline => '拒绝';

  @override
  String get accept => '同意';

  @override
  String get details => '详情';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => '频道';

  @override
  String get likes => '赞';

  @override
  String get dislikes => '踩';

  @override
  String get views => '浏览次数';

  @override
  String get streamUrl => '播放流 URL';

  @override
  String get stop => '停止';

  @override
  String get sort_newest => '按添加日期正序';

  @override
  String get sort_oldest => '按添加日期倒序';

  @override
  String get sleep_timer => '睡眠定时器';

  @override
  String mins(Object minutes) {
    return '$minutes 分';
  }

  @override
  String hours(Object hours) {
    return '$hours 时';
  }

  @override
  String hour(Object hours) {
    return '$hours 时';
  }

  @override
  String get custom_hours => '自定义时间';

  @override
  String get logs => '日志';

  @override
  String get developers => '开发者';

  @override
  String get not_logged_in => '你尚未登录';

  @override
  String get search_mode => '搜索模式';

  @override
  String get audio_source => '音频源';

  @override
  String get ok => '确定';

  @override
  String get failed_to_encrypt => '加密失败';

  @override
  String get encryption_failed_warning =>
      'Spotube使用加密来安全地存储您的数据。但是失败了。因此，它将回退到不安全的存储\n如果您使用Linux，请确保已安装gnome-keyring、kde-wallet和keepassxc等秘密服务';

  @override
  String get querying_info => '正在查询信息...';

  @override
  String get piped_api_down => 'Piped API不可用';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return '当前Piped实例$pipedInstance不可用\n\n请更改实例或将\'API类型\'更改为官方YouTube API\n\n更改后请确保重新启动应用程序';
  }

  @override
  String get you_are_offline => '您当前处于离线状态';

  @override
  String get connection_restored => '您的互联网连接已恢复';

  @override
  String get use_system_title_bar => '使用系统标题栏';

  @override
  String get crunching_results => '处理结果中...';

  @override
  String get search_to_get_results => '搜索以获取结果';

  @override
  String get use_amoled_mode => '使用 AMOLED 模式';

  @override
  String get pitch_dark_theme => '深色主题';

  @override
  String get normalize_audio => '标准化音频';

  @override
  String get change_cover => '更改封面';

  @override
  String get add_cover => '添加封面';

  @override
  String get restore_defaults => '恢复默认值';

  @override
  String get download_music_format => '下载音乐格式';

  @override
  String get streaming_music_format => '流媒体音乐格式';

  @override
  String get download_music_quality => '下载音乐质量';

  @override
  String get streaming_music_quality => '流媒体音乐质量';

  @override
  String get login_with_lastfm => '使用 Last.fm 登录';

  @override
  String get connect => '连接';

  @override
  String get disconnect_lastfm => '断开 Last.fm 连接';

  @override
  String get disconnect => '断开连接';

  @override
  String get username => '用户名';

  @override
  String get password => '密码';

  @override
  String get login => '登录';

  @override
  String get login_with_your_lastfm => '使用您的 Last.fm 帐户登录';

  @override
  String get scrobble_to_lastfm => '在 Last.fm 上记录播放';

  @override
  String get go_to_album => '前往专辑';

  @override
  String get discord_rich_presence => 'Discord 丰富展现';

  @override
  String get browse_all => '浏览全部';

  @override
  String get genres => '音乐类型';

  @override
  String get explore_genres => '探索音乐类型';

  @override
  String get friends => '朋友';

  @override
  String get no_lyrics_available => '抱歉，无法找到此曲的歌词';

  @override
  String get start_a_radio => '开始收听电台';

  @override
  String get how_to_start_radio => '您想如何开始收听电台？';

  @override
  String get replace_queue_question => '您想要替换当前队列还是追加到队列？';

  @override
  String get endless_playback => '无尽播放';

  @override
  String get delete_playlist => '删除播放列表';

  @override
  String get delete_playlist_confirmation => '您确定要删除此播放列表吗？';

  @override
  String get local_tracks => '本地音轨';

  @override
  String get local_tab => '本地';

  @override
  String get song_link => '歌曲链接';

  @override
  String get skip_this_nonsense => '跳过此无聊内容';

  @override
  String get freedom_of_music => '“音乐的自由”';

  @override
  String get freedom_of_music_palm => '“音乐的自由掌握在您手中”';

  @override
  String get get_started => '让我们开始吧';

  @override
  String get youtube_source_description => '推荐并且效果最佳。';

  @override
  String get piped_source_description => '感觉自由？与YouTube一样但更自由。';

  @override
  String get jiosaavn_source_description => '最适合南亚地区。';

  @override
  String get invidious_source_description => '类似于Piped，但可用性更高。';

  @override
  String highest_quality(Object quality) {
    return '最高音质：$quality';
  }

  @override
  String get select_audio_source => '选择音频源';

  @override
  String get endless_playback_description => '自动将新歌曲添加到队列的末尾';

  @override
  String get choose_your_region => '选择您的地区';

  @override
  String get choose_your_region_description => '这将帮助Spotube为您的位置显示正确的内容。';

  @override
  String get choose_your_language => '选择您的语言';

  @override
  String get help_project_grow => '帮助这个项目成长';

  @override
  String get help_project_grow_description =>
      'Spotube是一个开源项目。您可以通过为项目做出贡献、报告错误或建议新功能来帮助该项目成长。';

  @override
  String get contribute_on_github => '在GitHub上做出贡献';

  @override
  String get donate_on_open_collective => '在Open Collective上捐款';

  @override
  String get browse_anonymously => '匿名浏览';

  @override
  String get enable_connect => '启用连接';

  @override
  String get enable_connect_description => '从其他设备控制Spotube';

  @override
  String get devices => '设备';

  @override
  String get select => '选择';

  @override
  String connect_client_alert(Object client) {
    return '您正在被 $client 控制';
  }

  @override
  String get this_device => '此设备';

  @override
  String get remote => '远程';

  @override
  String get stats => '统计';

  @override
  String and_n_more(Object count) {
    return '和 $count 更多';
  }

  @override
  String get recently_played => '最近播放';

  @override
  String get browse_more => '浏览更多';

  @override
  String get no_title => '没有标题';

  @override
  String get not_playing => '未播放';

  @override
  String get epic_failure => '史诗级失败！';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return '已将 $tracks_length 首曲目添加到队列';
  }

  @override
  String get spotube_has_an_update => 'Spotube 有更新';

  @override
  String get download_now => '立即下载';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Spotube Nightly $nightlyBuildNum 已发布';
  }

  @override
  String release_version(Object version) {
    return 'Spotube v$version 已发布';
  }

  @override
  String get read_the_latest => '阅读最新';

  @override
  String get release_notes => '版本说明';

  @override
  String get pick_color_scheme => '选择配色方案';

  @override
  String get save => '保存';

  @override
  String get choose_the_device => '选择设备：';

  @override
  String get multiple_device_connected => '已连接多个设备。\n选择您希望执行此操作的设备';

  @override
  String get nothing_found => '未找到任何内容';

  @override
  String get the_box_is_empty => '箱子为空';

  @override
  String get top_artists => '热门艺术家';

  @override
  String get top_albums => '热门专辑';

  @override
  String get this_week => '本周';

  @override
  String get this_month => '本月';

  @override
  String get last_6_months => '过去6个月';

  @override
  String get this_year => '今年';

  @override
  String get last_2_years => '过去2年';

  @override
  String get all_time => '所有时间';

  @override
  String powered_by_provider(Object providerName) {
    return '由 $providerName 提供支持';
  }

  @override
  String get email => '电子邮件';

  @override
  String get profile_followers => '关注者';

  @override
  String get birthday => '生日';

  @override
  String get subscription => '订阅';

  @override
  String get not_born => '尚未出生';

  @override
  String get hacker => '黑客';

  @override
  String get profile => '个人资料';

  @override
  String get no_name => '无名';

  @override
  String get edit => '编辑';

  @override
  String get user_profile => '用户资料';

  @override
  String count_plays(Object count) {
    return '$count 次播放';
  }

  @override
  String get streaming_fees_hypothetical =>
      '*基于 Spotify 每次播放的支付金额\n从 \$0.003 到 \$0.005 计算。这是一个假设性的\n计算，旨在让用户了解如果他们在 Spotify 上收听\n这些歌曲，可能会付给艺术家的金额。';

  @override
  String get minutes_listened => '听的分钟数';

  @override
  String get streamed_songs => '已流媒体歌曲';

  @override
  String count_streams(Object count) {
    return '$count 次流媒体';
  }

  @override
  String get owned_by_you => '由您拥有';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return '$shareUrl 已复制到剪贴板';
  }

  @override
  String get hipotetical_calculation =>
      '*这是根据在线音乐流媒体平台每流平均支付0.003美元至0.005美元计算得出的。这是一个假设性的计算，旨在让用户了解如果他们在不同的音乐流媒体平台上收听歌曲，他们将需要向艺人支付多少费用。';

  @override
  String count_mins(Object minutes) {
    return '$minutes 分钟';
  }

  @override
  String get summary_minutes => '分钟';

  @override
  String get summary_listened_to_music => '听音乐';

  @override
  String get summary_songs => '歌曲';

  @override
  String get summary_streamed_overall => '总体流媒体';

  @override
  String get summary_owed_to_artists => '本月欠艺术家的';

  @override
  String get summary_artists => '艺术家的';

  @override
  String get summary_music_reached_you => '音乐触及了你';

  @override
  String get summary_full_albums => '完整专辑';

  @override
  String get summary_got_your_love => '获得了你的爱';

  @override
  String get summary_playlists => '播放列表';

  @override
  String get summary_were_on_repeat => '已重复播放';

  @override
  String total_money(Object money) {
    return '总计 $money';
  }

  @override
  String get webview_not_found => '未找到 Webview';

  @override
  String get webview_not_found_description =>
      '您的设备中未安装 Webview 运行时。\n如果已安装，请确保它在 environment PATH 中\n\n安装后，重新启动应用程序';

  @override
  String get unsupported_platform => '不支持的平台';

  @override
  String get cache_music => '缓存音乐';

  @override
  String get open => '打开';

  @override
  String get cache_folder => '缓存文件夹';

  @override
  String get export => '导出';

  @override
  String get clear_cache => '清除缓存';

  @override
  String get clear_cache_confirmation => '您要清除缓存吗？';

  @override
  String get export_cache_files => '导出缓存文件';

  @override
  String found_n_files(Object count) {
    return '找到 $count 个文件';
  }

  @override
  String get export_cache_confirmation => '您要导出这些文件到';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return '导出了 $filesExported / $files 个文件';
  }

  @override
  String get undo => '撤销';

  @override
  String get download_all => '下载全部';

  @override
  String get add_all_to_playlist => '将全部添加到播放列表';

  @override
  String get add_all_to_queue => '将全部添加到队列';

  @override
  String get play_all_next => '播放全部下一首';

  @override
  String get pause => '暂停';

  @override
  String get view_all => '查看所有';

  @override
  String get no_tracks_added_yet => '看起来你还没有添加任何曲目';

  @override
  String get no_tracks => '看起来这里没有任何曲目';

  @override
  String get no_tracks_listened_yet => '看起来你还没有听任何东西';

  @override
  String get not_following_artists => '你没有关注任何艺术家';

  @override
  String get no_favorite_albums_yet => '看起来你还没有将任何专辑添加到收藏夹';

  @override
  String get no_logs_found => '未找到日志';

  @override
  String get youtube_engine => 'YouTube 引擎';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engine 未安装';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engine 未在您的系统中安装。';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return '确保它可用在 PATH 变量中，或\n设置 $engine 可执行文件的绝对路径';
  }

  @override
  String get youtube_engine_unix_issue_message =>
      '在 macOS/Linux/Unix 类操作系统中，在 .zshrc/.bashrc/.bash_profile 等文件中设置路径无效。\n您需要在 shell 配置文件中设置路径';

  @override
  String get download => '下载';

  @override
  String get file_not_found => '文件未找到';

  @override
  String get custom => '自定义';

  @override
  String get add_custom_url => '添加自定义 URL';

  @override
  String get edit_port => '编辑端口';

  @override
  String get port_helper_msg => '默认值为-1，表示随机数。如果您已配置防火墙，建议设置此项。';

  @override
  String connect_request(Object client) {
    return '允许 $client 连接吗？';
  }

  @override
  String get connection_request_denied => '连接被拒绝。用户拒绝访问。';

  @override
  String get an_error_occurred => '发生错误';

  @override
  String get copy_to_clipboard => '复制到剪贴板';

  @override
  String get view_logs => '查看日志';

  @override
  String get retry => '重试';

  @override
  String get no_default_metadata_provider_selected => '您未设置默认元数据提供者';

  @override
  String get manage_metadata_providers => '管理元数据提供者';

  @override
  String get open_link_in_browser => '在浏览器中打开链接？';

  @override
  String get do_you_want_to_open_the_following_link => '您想打开以下链接吗';

  @override
  String get unsafe_url_warning => '从不受信任的来源打开链接可能不安全。请谨慎！\n您也可以将链接复制到剪贴板。';

  @override
  String get copy_link => '复制链接';

  @override
  String get building_your_timeline => '正在根据您的收听记录构建您的时间线...';

  @override
  String get official => '官方';

  @override
  String author_name(Object author) {
    return '作者：$author';
  }

  @override
  String get third_party => '第三方';

  @override
  String get plugin_requires_authentication => '插件需要身份验证';

  @override
  String get update_available => '有可用更新';

  @override
  String get supports_scrobbling => '支持 Scrobbling';

  @override
  String get plugin_scrobbling_info => '此插件会 scrobble 您的音乐以生成您的收听历史记录。';

  @override
  String get default_metadata_source => '默认元数据源';

  @override
  String get set_default_metadata_source => '设置默认元数据源';

  @override
  String get default_audio_source => '默认音频源';

  @override
  String get set_default_audio_source => '设置默认音频源';

  @override
  String get set_default => '设为默认';

  @override
  String get support => '支持';

  @override
  String get support_plugin_development => '支持插件开发';

  @override
  String can_access_name_api(Object name) {
    return '- 可以访问 **$name** API';
  }

  @override
  String get do_you_want_to_install_this_plugin => '您想安装此插件吗？';

  @override
  String get third_party_plugin_warning => '此插件来自第三方存储库。请在安装前确保您信任此来源。';

  @override
  String get author => '作者';

  @override
  String get this_plugin_can_do_following => '此插件可以执行以下操作';

  @override
  String get install => '安装';

  @override
  String get install_a_metadata_provider => '安装元数据提供者';

  @override
  String get no_tracks_playing => '当前没有播放任何曲目';

  @override
  String get synced_lyrics_not_available => '此歌曲的同步歌词不可用。请使用';

  @override
  String get plain_lyrics => '纯歌词';

  @override
  String get tab_instead => '选项卡。';

  @override
  String get disclaimer => '免责声明';

  @override
  String get third_party_plugin_dmca_notice =>
      'Spotube 团队对任何“第三方”插件不承担任何责任（包括法律责任）。\n请自行承担风险使用。对于任何错误/问题，请向插件存储库报告。\n\n如果任何“第三方”插件违反了任何服务/法律实体的服务条款/DMCA，请要求该“第三方”插件作者或托管平台（例如 GitHub/Codeberg）采取行动。上面列出的（标记为“第三方”）都是公共/社区维护的插件。我们不对此类插件进行管理，因此无法对其采取任何行动。\n\n';

  @override
  String get input_does_not_match_format => '输入与所需格式不匹配';

  @override
  String get plugins => '插件';

  @override
  String get paste_plugin_download_url =>
      '粘贴下载 URL、GitHub/Codeberg 存储库 URL 或 .smplug 文件的直接链接';

  @override
  String get download_and_install_plugin_from_url => '从 URL 下载并安装插件';

  @override
  String failed_to_add_plugin_error(Object error) {
    return '添加插件失败：$error';
  }

  @override
  String get upload_plugin_from_file => '从文件上传插件';

  @override
  String get installed => '已安装';

  @override
  String get available_plugins => '可用插件';

  @override
  String get configure_plugins => '配置您自己的元数据提供者和音频源插件';

  @override
  String get audio_scrobblers => '音频 Scrobblers';

  @override
  String get scrobbling => 'Scrobbling';

  @override
  String get source => '来源：';

  @override
  String get uncompressed => '无损';

  @override
  String get dab_music_source_description =>
      '适合发烧友。提供高质量/无损音频流。基于 ISRC 的精确曲目匹配。';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get guest => '訪客';

  @override
  String get browse => '瀏覽';

  @override
  String get search => '搜尋';

  @override
  String get library => '音樂庫';

  @override
  String get lyrics => '歌詞';

  @override
  String get settings => '設定';

  @override
  String get genre_categories_filter => '過濾分類...';

  @override
  String get genre => '探索歌單';

  @override
  String get personalized => '為你打造';

  @override
  String get featured => '推薦';

  @override
  String get new_releases => '新歌熱播';

  @override
  String get songs => '歌曲';

  @override
  String playing_track(Object track) {
    return '播放 $track';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return '這將清空目前的播放清單。$track_length 首歌曲將被移除\n你確定要繼續嗎?';
  }

  @override
  String get load_more => '載入更多';

  @override
  String get playlists => '歌單';

  @override
  String get artists => '藝人';

  @override
  String get albums => '專輯';

  @override
  String get tracks => '歌曲';

  @override
  String get downloads => '下載';

  @override
  String get filter_playlists => '過濾歌單...';

  @override
  String get liked_tracks => '已按讚的歌曲';

  @override
  String get liked_tracks_description => '你按過讚的所有歌曲';

  @override
  String get playlist => '播放清單';

  @override
  String get create_a_playlist => '建立一個歌單';

  @override
  String get update_playlist => '更新播放清單';

  @override
  String get create => '建立';

  @override
  String get cancel => '取消';

  @override
  String get update => '更新';

  @override
  String get playlist_name => '歌單名稱';

  @override
  String get name_of_playlist => '歌單的名稱';

  @override
  String get description => '說明';

  @override
  String get public => '公開';

  @override
  String get collaborative => '共享協作';

  @override
  String get search_local_tracks => '搜尋本地歌曲...';

  @override
  String get play => '播放';

  @override
  String get delete => '刪除';

  @override
  String get none => '無';

  @override
  String get sort_a_z => '依字母順序';

  @override
  String get sort_z_a => '依字母倒序';

  @override
  String get sort_artist => '按藝人';

  @override
  String get sort_album => '按專輯';

  @override
  String get sort_duration => '依長度排序';

  @override
  String get sort_tracks => '排序方式';

  @override
  String currently_downloading(Object tracks_length) {
    return '正在下載 ($tracks_length)';
  }

  @override
  String get cancel_all => '取消全部';

  @override
  String get filter_artist => '過濾藝人...';

  @override
  String followers(Object followers) {
    return '$followers 名追蹤者';
  }

  @override
  String get add_artist_to_blacklist => '封鎖該藝人';

  @override
  String get top_tracks => '熱門歌曲';

  @override
  String get fans_also_like => '粉絲也喜歡';

  @override
  String get loading => '載入中...';

  @override
  String get artist => '藝人';

  @override
  String get blacklisted => '已封鎖';

  @override
  String get following => '關注中';

  @override
  String get follow => '關注';

  @override
  String get artist_url_copied => '此名藝人的分享連結已複製至剪貼簿';

  @override
  String added_to_queue(Object tracks) {
    return '已新增 $tracks 首歌曲到播放清單';
  }

  @override
  String get filter_albums => '過濾專輯...';

  @override
  String get synced => '同步';

  @override
  String get plain => '未同步';

  @override
  String get shuffle => '隨機播放';

  @override
  String get search_tracks => '搜尋歌曲...';

  @override
  String get released => '發表時間';

  @override
  String error(Object error) {
    return '發生錯誤： $error';
  }

  @override
  String get title => '標題';

  @override
  String get time => '時長';

  @override
  String get more_actions => '更多動作';

  @override
  String download_count(Object count) {
    return '下載 ($count) 首歌曲';
  }

  @override
  String add_count_to_playlist(Object count) {
    return '將 ($count) 首歌曲新增到歌單中';
  }

  @override
  String add_count_to_queue(Object count) {
    return '新增 ($count) 首歌曲到播放清單';
  }

  @override
  String play_count_next(Object count) {
    return '接下來將播放 ($count) 首歌曲';
  }

  @override
  String get album => '專輯';

  @override
  String copied_to_clipboard(Object data) {
    return '已將 $data 複製至剪貼簿';
  }

  @override
  String add_to_following_playlists(Object track) {
    return '新增 $track 到以下播放清單';
  }

  @override
  String get add => '新增';

  @override
  String added_track_to_queue(Object track) {
    return '新增 $track 到播放清單';
  }

  @override
  String get add_to_queue => '新增至播放清單';

  @override
  String track_will_play_next(Object track) {
    return '$track 將在下一首播放';
  }

  @override
  String get play_next => '下一首播放';

  @override
  String removed_track_from_queue(Object track) {
    return '將 $track 從播放清單移除';
  }

  @override
  String get remove_from_queue => '從播放清單移除';

  @override
  String get remove_from_favorites => '取消按讚';

  @override
  String get save_as_favorite => '按讚';

  @override
  String get add_to_playlist => '新增到歌單';

  @override
  String get remove_from_playlist => '從歌單移除';

  @override
  String get add_to_blacklist => '新增到已封鎖清單';

  @override
  String get remove_from_blacklist => '從已封鎖清單移除';

  @override
  String get share => '分享';

  @override
  String get mini_player => '小窗模式';

  @override
  String get slide_to_seek => '滑動以前進或後退';

  @override
  String get shuffle_playlist => '隨機播放歌單';

  @override
  String get unshuffle_playlist => '取消隨機播放歌單';

  @override
  String get previous_track => '上一首歌曲';

  @override
  String get next_track => '下一首歌';

  @override
  String get pause_playback => '暫停播放';

  @override
  String get resume_playback => '恢復播放';

  @override
  String get loop_track => '單曲循環';

  @override
  String get no_loop => '無循環';

  @override
  String get repeat_playlist => '歌單循環';

  @override
  String get queue => '播放清單';

  @override
  String get alternative_track_sources => '其它音源';

  @override
  String get download_track => '下載歌曲';

  @override
  String tracks_in_queue(Object tracks) {
    return '$tracks 首歌曲在播放清單中';
  }

  @override
  String get clear_all => '清除全部';

  @override
  String get show_hide_ui_on_hover => '游標暫留時顯示 / 隱藏控制列';

  @override
  String get always_on_top => '置頂';

  @override
  String get exit_mini_player => '退出小窗模式';

  @override
  String get download_location => '下載路徑';

  @override
  String get local_library => '本地媒體庫';

  @override
  String get add_library_location => '新增至媒體庫';

  @override
  String get remove_library_location => '從媒體庫移除';

  @override
  String get account => '帳戶';

  @override
  String get logout => '退出';

  @override
  String get logout_of_this_account => '退出該帳戶';

  @override
  String get language_region => '語言與地區';

  @override
  String get language => '語言';

  @override
  String get system_default => '系統預設';

  @override
  String get market_place_region => '市集地區';

  @override
  String get recommendation_country => '請選擇國家與地區以取得對應的音樂推薦';

  @override
  String get appearance => '外觀';

  @override
  String get layout_mode => '佈局類型';

  @override
  String get override_layout_settings => '將覆寫響應式佈局設定';

  @override
  String get adaptive => '響應式';

  @override
  String get compact => '緊湊';

  @override
  String get extended => '寬闊';

  @override
  String get theme => '主題';

  @override
  String get dark => '深色';

  @override
  String get light => '淺色';

  @override
  String get system => '依循系統';

  @override
  String get accent_color => '主色調';

  @override
  String get sync_album_color => '符合封面顏色';

  @override
  String get sync_album_color_description => '選取專輯封面主題色為主色調';

  @override
  String get playback => '播放';

  @override
  String get audio_quality => '音質';

  @override
  String get high => '高';

  @override
  String get low => '低';

  @override
  String get pre_download_play => '下載後播放';

  @override
  String get pre_download_play_description => '先下載歌曲後再播放而非串流播放（建議頻寬較高使用者使用）';

  @override
  String get skip_non_music => '跳過非音樂片段（跳過贊助商廣告）';

  @override
  String get blacklist_description => '已封鎖的歌曲與藝人';

  @override
  String get wait_for_download_to_finish => '請等待目前下載工作完成';

  @override
  String get desktop => '桌面版設定';

  @override
  String get close_behavior => '點選關閉按鈕行為';

  @override
  String get close => '關閉';

  @override
  String get minimize_to_tray => '最小化到工作列';

  @override
  String get show_tray_icon => '顯示工作列圖示';

  @override
  String get about => '關於';

  @override
  String get u_love_spotube => '我們明白你喜歡 Spotube';

  @override
  String get check_for_updates => '檢查更新';

  @override
  String get about_spotube => '關於 Spotube';

  @override
  String get blacklist => '黑名單';

  @override
  String get please_sponsor => '請考慮贊助或捐款';

  @override
  String get spotube_description => 'Spotube，一款輕量、跨平台且完全免費的 Spotify 用戶端。';

  @override
  String get version => '版本';

  @override
  String get build_number => '建置編號';

  @override
  String get founder => '發起人';

  @override
  String get repository => '專案儲存庫';

  @override
  String get bug_issues => '缺陷與問題報告';

  @override
  String get made_with => '於孟加拉🇧🇩用 ❤️ 發電';

  @override
  String get kingkor_roy_tirtho => 'Kingkor Roy Tirtho';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year Kingkor Roy Tirtho';
  }

  @override
  String get license => '授權';

  @override
  String get credentials_will_not_be_shared_disclaimer =>
      '您大可放心，軟體不會收集或分享任何個人資料給第三方';

  @override
  String get know_how_to_login => '不知道該怎麼辦？';

  @override
  String get follow_step_by_step_guide => '請依照以下說明進行';

  @override
  String cookie_name_cookie(Object name) {
    return '$name Cookie';
  }

  @override
  String get fill_in_all_fields => '請填入所有欄位';

  @override
  String get submit => '提交';

  @override
  String get exit => '退出';

  @override
  String get previous => '上一步';

  @override
  String get next => '下一步';

  @override
  String get done => '完成';

  @override
  String get step_1 => '步驟 1';

  @override
  String get first_go_to => '首先，前往';

  @override
  String get something_went_wrong => '某些地方出現了問題';

  @override
  String get piped_instance => 'Piped 伺服器實例';

  @override
  String get piped_description => 'Piped 伺服器實例用於匹配歌曲';

  @override
  String get piped_warning => '它們之中的一部分可能無法正常運作。使用時請自行承擔風險';

  @override
  String get invidious_instance => 'Invidious 伺服器實例';

  @override
  String get invidious_description => '用於音軌匹配的 Invidious 伺服器實例';

  @override
  String get invidious_warning => '有些可能無法正常運作。請自行承擔風險';

  @override
  String get generate => '生成';

  @override
  String track_exists(Object track) {
    return '曲目 $track 已存在';
  }

  @override
  String get replace_downloaded_tracks => '替換已下載的歌曲';

  @override
  String get skip_download_tracks => '下載時跳過已下載的歌曲';

  @override
  String get do_you_want_to_replace => '你確定要取代已下載的歌曲嗎？？';

  @override
  String get replace => '取代';

  @override
  String get skip => '跳過';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return '選擇最多 $count 種的類型 $type';
  }

  @override
  String get select_genres => '選擇曲風';

  @override
  String get add_genres => '新增曲風';

  @override
  String get country => '國家和地區';

  @override
  String get number_of_tracks_generate => '產生歌曲的數目';

  @override
  String get acousticness => '原聲程度';

  @override
  String get danceability => '律動感';

  @override
  String get energy => '衝擊感';

  @override
  String get instrumentalness => '歌唱部分佔比';

  @override
  String get liveness => '現場感';

  @override
  String get loudness => '響度';

  @override
  String get speechiness => '朗誦比例';

  @override
  String get valence => '心理感受';

  @override
  String get popularity => '流行度';

  @override
  String get key => '曲調';

  @override
  String get duration => '歌曲長度 (s)';

  @override
  String get tempo => '每分鐘拍數 (BPM)';

  @override
  String get mode => '旋律重複度';

  @override
  String get time_signature => '音符時值';

  @override
  String get short => '短';

  @override
  String get medium => '中';

  @override
  String get long => '長';

  @override
  String get min => '最低';

  @override
  String get max => '最高';

  @override
  String get target => '目標';

  @override
  String get moderate => '中';

  @override
  String get deselect_all => '取消全選';

  @override
  String get select_all => '全選';

  @override
  String get are_you_sure => '你確定嗎？';

  @override
  String get generating_playlist => '正在產生你的自訂歌單...';

  @override
  String selected_count_tracks(Object count) {
    return '已選取 $count 首歌曲';
  }

  @override
  String get download_warning =>
      '如果你大量下載這些歌曲，你顯然在侵犯音樂的版權並對音樂創作社區造成了傷害。我希望你能意識到這一點。永遠要尊重並支持藝術家們的辛勤工作';

  @override
  String get download_ip_ban_warning =>
      '小心，如果出現超出正常的下載請求，那你的 IP 可能會被 YouTube 封鎖，這意味著你的裝置將在長達 2-3 個月的時間內無法使用該 IP 訪問 YouTube（即使你沒登入）。Spotube 不會因而承擔任何責任';

  @override
  String get by_clicking_accept_terms => '點擊 \'同意\' 代表你同意以下的條款';

  @override
  String get download_agreement_1 => '我明白侵害音樂版權是一件不好的事';

  @override
  String get download_agreement_2 => '我將盡可能支持藝術家的工作。我現在之所以做不到是因為缺乏資金來購買正版';

  @override
  String get download_agreement_3 =>
      '我完全了解我的 IP 存在被 YouTube 封鎖的風險。並且我明白 Spotube 的擁有者與貢獻者們無須對我目前的行為所導致的任何後果負責';

  @override
  String get decline => '拒絕';

  @override
  String get accept => '同意';

  @override
  String get details => '詳細資訊';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => '頻道';

  @override
  String get likes => '讚';

  @override
  String get dislikes => '倒讚';

  @override
  String get views => '瀏覽次數';

  @override
  String get streamUrl => '播放串流 URL';

  @override
  String get stop => '停止';

  @override
  String get sort_newest => '依新增日期順序';

  @override
  String get sort_oldest => '依新增日期倒序';

  @override
  String get sleep_timer => '睡眠計時器';

  @override
  String mins(Object minutes) {
    return '$minutes 分';
  }

  @override
  String hours(Object hours) {
    return '$hours 時';
  }

  @override
  String hour(Object hours) {
    return '$hours 時';
  }

  @override
  String get custom_hours => '自訂時長';

  @override
  String get logs => '記錄檔（Log）';

  @override
  String get developers => '開發者';

  @override
  String get not_logged_in => '你尚未登入';

  @override
  String get search_mode => '搜尋模式';

  @override
  String get audio_source => '音訊來源';

  @override
  String get ok => '確定';

  @override
  String get failed_to_encrypt => '加密失敗';

  @override
  String get encryption_failed_warning =>
      'Spotube使用加密來安全地儲存您的資料。但是失敗了。因此，它將回退到不安全的儲存空間\n如果您使用Linux，請確保已安裝gnome-keyring、kde-wallet和keepassxc等加密服務';

  @override
  String get querying_info => '正在查詢資訊...';

  @override
  String get piped_api_down => 'Piped API 無法使用';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return '當前Piped實例 $pipedInstance 不可用\n\n請更改實例或將\'API類型\'更改為官方YouTube API\n\n更改後請確保重新啟動應用程式';
  }

  @override
  String get you_are_offline => '您目前處於離線狀態';

  @override
  String get connection_restored => '您的網路連線已恢復';

  @override
  String get use_system_title_bar => '使用作業系統的預設視窗標題列';

  @override
  String get crunching_results => '處理結果中...';

  @override
  String get search_to_get_results => '搜尋以取得結果';

  @override
  String get use_amoled_mode => '使用 AMOLED 模式';

  @override
  String get pitch_dark_theme => '漆黑主題';

  @override
  String get normalize_audio => '標準化音訊';

  @override
  String get change_cover => '更改封面';

  @override
  String get add_cover => '新增封面';

  @override
  String get restore_defaults => '恢復預設值';

  @override
  String get download_music_format => '下載音樂格式';

  @override
  String get streaming_music_format => '串流音樂格式';

  @override
  String get download_music_quality => '下載音樂品質';

  @override
  String get streaming_music_quality => '串流音樂品質';

  @override
  String get login_with_lastfm => '使用 Last.fm 登入';

  @override
  String get connect => '連線';

  @override
  String get disconnect_lastfm => '切斷 Last.fm 連線';

  @override
  String get disconnect => '斷開連線';

  @override
  String get username => '帳號';

  @override
  String get password => '密碼';

  @override
  String get login => '登入';

  @override
  String get login_with_your_lastfm => '使用您的 Last.fm 帳號登入';

  @override
  String get scrobble_to_lastfm => '在 Last.fm 上記錄你的播放';

  @override
  String get go_to_album => '前往專輯';

  @override
  String get discord_rich_presence => 'Discord Rick Presence（Discord 狀態）';

  @override
  String get browse_all => '瀏覽全部';

  @override
  String get genres => '音樂類型';

  @override
  String get explore_genres => '探索音樂類型';

  @override
  String get friends => '好友';

  @override
  String get no_lyrics_available => '抱歉，無法找到這首歌的歌詞';

  @override
  String get start_a_radio => '開始收聽電台';

  @override
  String get how_to_start_radio => '您想如何開始收聽電台？';

  @override
  String get replace_queue_question => '您想要取代目前清單還是追加到清單？';

  @override
  String get endless_playback => '無限播放';

  @override
  String get delete_playlist => '刪除播放清單';

  @override
  String get delete_playlist_confirmation => '您確定要刪除此播放清單嗎？';

  @override
  String get local_tracks => '本地音訊';

  @override
  String get local_tab => '本地';

  @override
  String get song_link => '歌曲連結';

  @override
  String get skip_this_nonsense => '跳過這個無聊內容';

  @override
  String get freedom_of_music => '“音樂的自由”';

  @override
  String get freedom_of_music_palm => '「音樂的自由掌握在您手中」';

  @override
  String get get_started => '我們開始吧';

  @override
  String get youtube_source_description => '建議且效果最佳。';

  @override
  String get piped_source_description => '感覺自由？與 YouTube 一樣，但更自由。';

  @override
  String get jiosaavn_source_description => '最適合南亞地區。';

  @override
  String get invidious_source_description => '類似 Piped，但可用性更高。';

  @override
  String highest_quality(Object quality) {
    return '最高音質：$quality';
  }

  @override
  String get select_audio_source => '選擇音訊來源';

  @override
  String get endless_playback_description => '自動將新歌曲加入清單的結尾';

  @override
  String get choose_your_region => '選擇您的所在地區';

  @override
  String get choose_your_region_description => '這能幫助 Spotube 為您的所在位置顯示正確的內容。';

  @override
  String get choose_your_language => '選擇您的語言';

  @override
  String get help_project_grow => '幫助這個專案成長';

  @override
  String get help_project_grow_description =>
      'Spotube是一個開源專案。您可以透過為專案做出貢獻、回報錯誤或建議新功能來幫助專案成長。';

  @override
  String get contribute_on_github => '在GitHub上做出貢獻';

  @override
  String get donate_on_open_collective => '在Open Collective上捐款';

  @override
  String get browse_anonymously => '匿名瀏覽';

  @override
  String get enable_connect => '啟用連線';

  @override
  String get enable_connect_description => '從其他裝置控制Spotube';

  @override
  String get devices => '裝置';

  @override
  String get select => '選擇';

  @override
  String connect_client_alert(Object client) {
    return '您正在被 $client 控制';
  }

  @override
  String get this_device => '此裝置';

  @override
  String get remote => '遠端';

  @override
  String get stats => '統計';

  @override
  String and_n_more(Object count) {
    return '還有 $count 個';
  }

  @override
  String get recently_played => '最近播放';

  @override
  String get browse_more => '瀏覽更多';

  @override
  String get no_title => '無標題';

  @override
  String get not_playing => '未播放';

  @override
  String get epic_failure => '史詩級的失敗！';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return '已將 $tracks_length 首曲目新增至清單';
  }

  @override
  String get spotube_has_an_update => 'Spotube 有更新版本';

  @override
  String get download_now => '立即下載';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Spotube Nightly $nightlyBuildNum 已發佈';
  }

  @override
  String release_version(Object version) {
    return 'Spotube v$version 已發布';
  }

  @override
  String get read_the_latest => '閱讀最新';

  @override
  String get release_notes => '版本說明';

  @override
  String get pick_color_scheme => '選擇配色方案';

  @override
  String get save => '儲存';

  @override
  String get choose_the_device => '選擇裝置：';

  @override
  String get multiple_device_connected => '已連接多個裝置。\n選擇您希望執行此操作的裝置';

  @override
  String get nothing_found => '未找到任何內容';

  @override
  String get the_box_is_empty => '箱子為空';

  @override
  String get top_artists => '熱門藝人';

  @override
  String get top_albums => '熱門專輯';

  @override
  String get this_week => '本週';

  @override
  String get this_month => '本月';

  @override
  String get last_6_months => '過去6個月';

  @override
  String get this_year => '今年';

  @override
  String get last_2_years => '過去2年';

  @override
  String get all_time => '所有時間';

  @override
  String powered_by_provider(Object providerName) {
    return '由 $providerName 提供支援';
  }

  @override
  String get email => '電子郵件';

  @override
  String get profile_followers => '追蹤者';

  @override
  String get birthday => '生日';

  @override
  String get subscription => '訂閱';

  @override
  String get not_born => '尚未建立';

  @override
  String get hacker => '駭客';

  @override
  String get profile => '個人資訊';

  @override
  String get no_name => '沒有名字';

  @override
  String get edit => '編輯';

  @override
  String get user_profile => '使用者資料';

  @override
  String count_plays(Object count) {
    return '$count 次播放';
  }

  @override
  String get streaming_fees_hypothetical =>
      '*基於 Spotify 每次播放的支付金額\n從 \$0.003 到 \$0.005 計算。這是一個假設性的\n計算，旨在讓用戶了解如果他們在 Spotify 上收聽\n這些歌曲，可能會付給作者的金額。';

  @override
  String get minutes_listened => '聽的分鐘數';

  @override
  String get streamed_songs => '已串流歌曲';

  @override
  String count_streams(Object count) {
    return '$count 次串流';
  }

  @override
  String get owned_by_you => '由您所有';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return '$shareUrl 已複製到剪貼簿';
  }

  @override
  String get hipotetical_calculation =>
      '*此為根據線上音樂串流平台平均每次播放 \$0.003 至 \$0.005 的收益所計算的假設值。此為一個假設性計算，旨在讓使用者了解若他們在不同的音樂串流平台上收聽同一首歌曲，他們將會支付給藝人多少費用。';

  @override
  String count_mins(Object minutes) {
    return '$minutes 分鐘';
  }

  @override
  String get summary_minutes => '分鐘';

  @override
  String get summary_listened_to_music => '聽音樂';

  @override
  String get summary_songs => '歌曲';

  @override
  String get summary_streamed_overall => '整體串流媒體';

  @override
  String get summary_owed_to_artists => '本月欠藝術家的';

  @override
  String get summary_artists => '藝術家的';

  @override
  String get summary_music_reached_you => '音樂接觸到你';

  @override
  String get summary_full_albums => '完整專輯';

  @override
  String get summary_got_your_love => '獲得了你的愛心';

  @override
  String get summary_playlists => '播放清單';

  @override
  String get summary_were_on_repeat => '已經重複播放';

  @override
  String total_money(Object money) {
    return '總計 $money';
  }

  @override
  String get webview_not_found => '未找到 Webview 框架';

  @override
  String get webview_not_found_description =>
      '您的裝置中未安裝 Webview Runtime。\n如果已安裝，請確保它的位置在系統環境變數（PATH）中\n\n安裝後，重新啟動應用程式';

  @override
  String get unsupported_platform => '不支援的平台';

  @override
  String get cache_music => '快取音樂';

  @override
  String get open => '開啟';

  @override
  String get cache_folder => '快取資料夾';

  @override
  String get export => '導出';

  @override
  String get clear_cache => '清除快取';

  @override
  String get clear_cache_confirmation => '您要清除快取嗎？';

  @override
  String get export_cache_files => '匯出快取檔案';

  @override
  String found_n_files(Object count) {
    return '找到 $count 個檔案';
  }

  @override
  String get export_cache_confirmation => '您要匯出這些檔案到';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return '匯出了 $filesExported / $files 個檔案';
  }

  @override
  String get undo => '取消';

  @override
  String get download_all => '下載全部';

  @override
  String get add_all_to_playlist => '全部加入到播放清單';

  @override
  String get add_all_to_queue => '全部加入清單';

  @override
  String get play_all_next => '播放全部下一首';

  @override
  String get pause => '暫停';

  @override
  String get view_all => '檢視全部';

  @override
  String get no_tracks_added_yet => '看起來你還沒有加入任何歌曲';

  @override
  String get no_tracks => '看起來這裡沒有任何歌曲';

  @override
  String get no_tracks_listened_yet => '看起來你還沒聽任何歌曲';

  @override
  String get not_following_artists => '你沒有關注任何藝術家';

  @override
  String get no_favorite_albums_yet => '看起來你還沒有將任何專輯加入到收藏夾';

  @override
  String get no_logs_found => '未找到日誌';

  @override
  String get youtube_engine => 'YouTube 引擎';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engine 未安裝';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engine 未在您的系統中安裝。';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return '確保它可用在 PATH 變數中，或\n設定 $engine 執行檔的絕對路徑';
  }

  @override
  String get youtube_engine_unix_issue_message =>
      '在類 Unix 作業系統（如 macOS/Linux/Unix）中，請在 .zshrc/.bashrc/.bash_profile 等檔案中設定路徑無效。\n您需要在 shell 設定檔中設定路徑';

  @override
  String get download => '下載';

  @override
  String get file_not_found => '找不到檔案';

  @override
  String get custom => '自訂';

  @override
  String get add_custom_url => '新增自訂 URL';

  @override
  String get edit_port => '編輯端口';

  @override
  String get port_helper_msg => '預設值為 -1，表示隨機數。如果您已配置防火牆，建議設定此項目。';

  @override
  String connect_request(Object client) {
    return '允許 $client 連線嗎？';
  }

  @override
  String get connection_request_denied => '連線被拒絕。請求被使用者拒絕。';

  @override
  String get an_error_occurred => '發生錯誤';

  @override
  String get copy_to_clipboard => '複製到剪貼簿';

  @override
  String get view_logs => '檢視日誌';

  @override
  String get retry => '重試';

  @override
  String get no_default_metadata_provider_selected => '您沒有設定預設的中繼資料供應商';

  @override
  String get manage_metadata_providers => '管理中繼資料供應商';

  @override
  String get open_link_in_browser => '要在瀏覽器中開啟連結嗎？';

  @override
  String get do_you_want_to_open_the_following_link => '您想開啟以下連結嗎';

  @override
  String get unsafe_url_warning => '從不受信任的來源開啟連結可能不安全。請務必小心！\n您也可以將連結複製到剪貼簿。';

  @override
  String get copy_link => '複製連結';

  @override
  String get building_your_timeline => '正在根據您的收聽記錄建立您的時間軸...';

  @override
  String get official => '官方';

  @override
  String author_name(Object author) {
    return '作者：$author';
  }

  @override
  String get third_party => '第三方';

  @override
  String get plugin_requires_authentication => '此外掛程式需要驗證';

  @override
  String get update_available => '有可用的更新';

  @override
  String get supports_scrobbling => '支援 Scrobbling';

  @override
  String get plugin_scrobbling_info => '此外掛程式會 Scrobble 您的音樂以產生您的收聽記錄。';

  @override
  String get default_metadata_source => '預設中繼資料來源';

  @override
  String get set_default_metadata_source => '設定預設中繼資料來源';

  @override
  String get default_audio_source => '預設音訊來源';

  @override
  String get set_default_audio_source => '設定預設音訊來源';

  @override
  String get set_default => '設為預設';

  @override
  String get support => '支援';

  @override
  String get support_plugin_development => '支援外掛程式開發';

  @override
  String can_access_name_api(Object name) {
    return '- 可以存取 **$name** API';
  }

  @override
  String get do_you_want_to_install_this_plugin => '您想安裝此外掛程式嗎？';

  @override
  String get third_party_plugin_warning => '此外掛程式來自第三方儲存庫。請在安裝前確認您信任該來源。';

  @override
  String get author => '作者';

  @override
  String get this_plugin_can_do_following => '此外掛程式可以執行以下操作';

  @override
  String get install => '安裝';

  @override
  String get install_a_metadata_provider => '安裝中繼資料供應商';

  @override
  String get no_tracks_playing => '目前沒有正在播放的曲目';

  @override
  String get synced_lyrics_not_available => '此歌曲沒有同步歌詞。請改用';

  @override
  String get plain_lyrics => '純歌詞';

  @override
  String get tab_instead => '分頁。';

  @override
  String get disclaimer => '免責聲明';

  @override
  String get third_party_plugin_dmca_notice =>
      'Spotube 團隊對任何「第三方」外掛程式不負任何責任（包括法律責任）。\n請自行承擔使用風險。如有任何錯誤/問題，請向該外掛程式的儲存庫回報。\n\n若有任何「第三方」外掛程式違反任何服務/法律實體的服務條款/DMCA，請向「第三方」外掛程式作者或託管平台（如 GitHub/Codeberg）要求採取行動。以上列出的（標記為「第三方」）外掛程式均為公開/社群維護的外掛程式。我們沒有對其進行審核，因此無法對其採取任何行動。\n\n';

  @override
  String get input_does_not_match_format => '輸入不符合所需格式';

  @override
  String get plugins => '外掛程式';

  @override
  String get paste_plugin_download_url =>
      '貼上下載網址、GitHub/Codeberg 儲存庫網址或 .smplug 檔案的直接連結';

  @override
  String get download_and_install_plugin_from_url => '從網址下載並安裝外掛程式';

  @override
  String failed_to_add_plugin_error(Object error) {
    return '新增外掛程式失敗：$error';
  }

  @override
  String get upload_plugin_from_file => '從檔案上傳外掛程式';

  @override
  String get installed => '已安裝';

  @override
  String get available_plugins => '可用的外掛程式';

  @override
  String get configure_plugins => '配置您自己的中繼資料提供者和音訊來源外掛程式';

  @override
  String get audio_scrobblers => '音訊 Scrobblers';

  @override
  String get scrobbling => 'Scrobbling';

  @override
  String get source => '來源：';

  @override
  String get uncompressed => '未壓縮';

  @override
  String get dab_music_source_description =>
      '適合音響發燒友。提供高品質/無損音訊串流。精確的 ISRC 曲目比對。';
}
