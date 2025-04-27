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
  String get login_with_spotify => '使用 Spotify 登录';

  @override
  String get connect_with_spotify => '与 Spotify 账户连接';

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
  String get add_spotify_credentials => '添加你的 Spotify 登录信息以开始使用';

  @override
  String get credentials_will_not_be_shared_disclaimer => '不用担心，软件不会收集或分享任何个人数据给第三方';

  @override
  String get know_how_to_login => '不知道该怎么做？';

  @override
  String get follow_step_by_step_guide => '请按照以下指南进行';

  @override
  String spotify_cookie(Object name) {
    return 'Spotify $name Cookie';
  }

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
  String get login_if_not_logged_in => '如果尚未登录，请登录或者注册一个账户';

  @override
  String get step_2 => '步骤 2';

  @override
  String get step_2_steps => '1. 一旦你已经完成登录, 按 F12 键或者鼠标右击网页空白区域 > 选择“检查”以打开浏览器开发者工具（DevTools）\n2. 然后选择 \"应用（Application）\" 标签页（Chrome, Edge, Brave 等基于 Chromium 的浏览器） 或 \"存储（Storage）\" 标签页 （Firefox, Palemoon 等基于 Firefox 的浏览器））\n3. 选择 \"Cookies\" 栏目然后选择 \"https://accounts.spotify.com\" 子栏目';

  @override
  String get step_3 => '步骤 3';

  @override
  String get step_3_steps => '复制\"sp_dc\" Cookie的值';

  @override
  String get success_emoji => '成功🥳';

  @override
  String get success_message => '你已经成功使用 Spotify 登录。干得漂亮！';

  @override
  String get step_4 => '步骤 4';

  @override
  String get step_4_steps => '粘贴复制的\"sp_dc\"值';

  @override
  String get something_went_wrong => '某些地方出现了问题';

  @override
  String get piped_instance => '管道服务器实例';

  @override
  String get piped_description => '管道服务器实例用于匹配歌曲';

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
  String get download_warning => '如果你大量下载这些歌曲，你显然在侵犯音乐的版权并对音乐创作社区造成了伤害。我希望你能意识到这一点。永远要尊重并支持艺术家们的辛勤工作';

  @override
  String get download_ip_ban_warning => '小心，如果出现超出正常的下载请求那你的 IP 可能会被 YouTube 封禁，这意味着你的设备将在长达 2-3 个月的时间内无法使用该 IP 访问 YouTube（即使你没登录）。Spotube 对此不承担任何责任';

  @override
  String get by_clicking_accept_terms => '点击 \'同意\' 代表着你同意以下的条款';

  @override
  String get download_agreement_1 => '我明白侵犯音乐版权是一件不好的事情';

  @override
  String get download_agreement_2 => '我将尽可能支持艺术家的工作。我现在之所以做不到是因为缺乏资金来购买正版';

  @override
  String get download_agreement_3 => '我完全了解我的 IP 存在被 YouTube的风险。我同意 Spotube 的所有者与贡献者们无须对我目前的行为所导致的任何后果负责';

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
  String get encryption_failed_warning => 'Spotube使用加密来安全地存储您的数据。但是失败了。因此，它将回退到不安全的存储\n如果您使用Linux，请确保已安装gnome-keyring、kde-wallet和keepassxc等秘密服务';

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
  String get download_music_codec => '下载音乐编解码器';

  @override
  String get streaming_music_codec => '流媒体音乐编解码器';

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
  String get help_project_grow_description => 'Spotube是一个开源项目。您可以通过为项目做出贡献、报告错误或建议新功能来帮助该项目成长。';

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
  String get streaming_fees_hypothetical => '*基于 Spotify 每次播放的支付金额\n从 \$0.003 到 \$0.005 计算。这是一个假设性的\n计算，旨在让用户了解如果他们在 Spotify 上收听\n这些歌曲，可能会付给艺术家的金额。';

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
  String get spotify_hipotetical_calculation => '*根据 Spotify 每次流媒体的支付金额\n\$0.003 到 \$0.005 进行计算。这是一个假设性的\n计算，用于给用户了解他们如果在 Spotify 上\n收听歌曲会支付给艺术家的金额。';

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
  String get webview_not_found_description => '您的设备中未安装 Webview 运行时。\n如果已安装，请确保它在 environment PATH 中\n\n安装后，重新启动应用程序';

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
  String get youtube_engine_unix_issue_message => '在 macOS/Linux/Unix 类操作系统中，在 .zshrc/.bashrc/.bash_profile 等文件中设置路径无效。\n您需要在 shell 配置文件中设置路径';

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
}
