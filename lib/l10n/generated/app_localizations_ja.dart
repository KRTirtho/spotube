// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get guest => 'ゲスト';

  @override
  String get browse => '閲覧';

  @override
  String get search => '検索';

  @override
  String get library => 'ライブラリ';

  @override
  String get lyrics => '歌詞';

  @override
  String get settings => '設定';

  @override
  String get genre_categories_filter => 'カテゴリーやジャンルを絞り込み...';

  @override
  String get genre => 'ジャンル';

  @override
  String get personalized => 'あなたにおすすめ';

  @override
  String get featured => '注目';

  @override
  String get new_releases => '新着';

  @override
  String get songs => '曲';

  @override
  String playing_track(Object track) {
    return '$track を再生';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return '現在のキューを消去します。$track_length 曲を消去します。\n続行しますか？';
  }

  @override
  String get load_more => 'もっと読み込む';

  @override
  String get playlists => '再生リスト';

  @override
  String get artists => 'アーティスト';

  @override
  String get albums => 'アルバム';

  @override
  String get tracks => '曲';

  @override
  String get downloads => 'ダウンロード';

  @override
  String get filter_playlists => 'あなたの再生リストを絞り込み...';

  @override
  String get liked_tracks => 'いいねした曲';

  @override
  String get liked_tracks_description => 'いいねしたすべての曲';

  @override
  String get playlist => 'プレイリスト';

  @override
  String get create_a_playlist => '再生リストの作成';

  @override
  String get update_playlist => 'プレイリストを更新';

  @override
  String get create => '作成';

  @override
  String get cancel => 'キャンセル';

  @override
  String get update => '更新';

  @override
  String get playlist_name => '再生リスト名';

  @override
  String get name_of_playlist => '再生リストの名前';

  @override
  String get description => '説明';

  @override
  String get public => '公開';

  @override
  String get collaborative => 'コラボ';

  @override
  String get search_local_tracks => '端末内の曲を検索...';

  @override
  String get play => '再生';

  @override
  String get delete => '削除';

  @override
  String get none => 'なし';

  @override
  String get sort_a_z => 'A-Z 順に並び替え';

  @override
  String get sort_z_a => 'Z-A 順に並び替え';

  @override
  String get sort_artist => 'アーティスト順に並び替え';

  @override
  String get sort_album => 'アルバム順に並び替え';

  @override
  String get sort_duration => '時間で並べ替え';

  @override
  String get sort_tracks => '曲の並び替え';

  @override
  String currently_downloading(Object tracks_length) {
    return 'いまダウンロード中 ($tracks_length) 曲';
  }

  @override
  String get cancel_all => 'すべてキャンセル';

  @override
  String get filter_artist => 'アーティストを絞り込み...';

  @override
  String followers(Object followers) {
    return '$followers フォロワー';
  }

  @override
  String get add_artist_to_blacklist => 'このアーティストをブラックリストに追加';

  @override
  String get top_tracks => '人気の曲';

  @override
  String get fans_also_like => 'ファンの間で人気';

  @override
  String get loading => '読み込み中...';

  @override
  String get artist => 'アーティスト';

  @override
  String get blacklisted => 'ブラックリスト';

  @override
  String get following => 'フォロー中';

  @override
  String get follow => 'フォローする';

  @override
  String get artist_url_copied => 'アーティストの URL をクリップボードにコピーしました';

  @override
  String added_to_queue(Object tracks) {
    return '$tracks をキューに追加しました';
  }

  @override
  String get filter_albums => 'アルバムを絞り込み...';

  @override
  String get synced => '同期する';

  @override
  String get plain => 'そのまま';

  @override
  String get shuffle => 'シャッフル';

  @override
  String get search_tracks => '曲を検索...';

  @override
  String get released => 'リリース日';

  @override
  String error(Object error) {
    return 'エラー $error';
  }

  @override
  String get title => 'タイトル';

  @override
  String get time => '長さ';

  @override
  String get more_actions => 'ほかの操作';

  @override
  String download_count(Object count) {
    return 'ダウンロード ($count) 曲';
  }

  @override
  String add_count_to_playlist(Object count) {
    return '再生リストに ($count) 曲を追加';
  }

  @override
  String add_count_to_queue(Object count) {
    return 'キューに ($count) 曲を追加';
  }

  @override
  String play_count_next(Object count) {
    return '次に ($count) 曲を再生';
  }

  @override
  String get album => 'アルバム';

  @override
  String copied_to_clipboard(Object data) {
    return '$data をクリップボードにコピーしました';
  }

  @override
  String add_to_following_playlists(Object track) {
    return '$track をこの再生リストに追加';
  }

  @override
  String get add => '追加';

  @override
  String added_track_to_queue(Object track) {
    return 'キューに $track を追加しました';
  }

  @override
  String get add_to_queue => 'キューに追加';

  @override
  String track_will_play_next(Object track) {
    return '$track を次に再生';
  }

  @override
  String get play_next => '次に再生';

  @override
  String removed_track_from_queue(Object track) {
    return 'キューから $track を除去しました';
  }

  @override
  String get remove_from_queue => 'キューから除去';

  @override
  String get remove_from_favorites => 'お気に入りから除去';

  @override
  String get save_as_favorite => 'お気に入りに保存';

  @override
  String get add_to_playlist => '再生リストに追加';

  @override
  String get remove_from_playlist => '再生リストから除去';

  @override
  String get add_to_blacklist => 'ブラックリストに追加';

  @override
  String get remove_from_blacklist => 'ブラックリストから除去';

  @override
  String get share => '共有';

  @override
  String get mini_player => 'ミニプレイヤー';

  @override
  String get slide_to_seek => '前後にスライドしてシーク';

  @override
  String get shuffle_playlist => '再生リストをシャッフル';

  @override
  String get unshuffle_playlist => '再生リストのシャッフル解除';

  @override
  String get previous_track => '前の曲';

  @override
  String get next_track => '次の曲';

  @override
  String get pause_playback => '再生を停止';

  @override
  String get resume_playback => '再生を再開';

  @override
  String get loop_track => '曲をループ';

  @override
  String get no_loop => 'ループなし';

  @override
  String get repeat_playlist => '再生リストをリピート';

  @override
  String get queue => '再生キュー';

  @override
  String get alternative_track_sources => 'この曲の別の音源を選ぶ';

  @override
  String get download_track => '曲のダウンロード';

  @override
  String tracks_in_queue(Object tracks) {
    return '$tracks曲の再生キュー';
  }

  @override
  String get clear_all => 'すべて消去l';

  @override
  String get show_hide_ui_on_hover => 'マウスを乗せてUIを表示/隠す';

  @override
  String get always_on_top => '常に手前に表示';

  @override
  String get exit_mini_player => 'ミニプレイヤーを終了';

  @override
  String get download_location => 'ダウンロード先';

  @override
  String get local_library => 'ローカルライブラリ';

  @override
  String get add_library_location => 'ライブラリに追加';

  @override
  String get remove_library_location => 'ライブラリから削除';

  @override
  String get account => 'アカウント';

  @override
  String get login_with_spotify => 'Spotify アカウントでログイン';

  @override
  String get connect_with_spotify => 'Spotify に接続';

  @override
  String get logout => 'ログアウト';

  @override
  String get logout_of_this_account => 'このアカウントからログアウト';

  @override
  String get language_region => '言語 & 地域';

  @override
  String get language => '言語';

  @override
  String get system_default => 'システムの既定値';

  @override
  String get market_place_region => '市場の地域';

  @override
  String get recommendation_country => '推薦先の国';

  @override
  String get appearance => '外観';

  @override
  String get layout_mode => 'レイアウトの種類';

  @override
  String get override_layout_settings => 'レスポンシブなレイアウトの種類の設定を上書きする';

  @override
  String get adaptive => '適応的';

  @override
  String get compact => 'コンパクト';

  @override
  String get extended => '幅広';

  @override
  String get theme => 'テーマ';

  @override
  String get dark => 'ダーク';

  @override
  String get light => 'ライト';

  @override
  String get system => 'システムに従う';

  @override
  String get accent_color => 'アクセントカラー';

  @override
  String get sync_album_color => 'アルバムの色に合わせる';

  @override
  String get sync_album_color_description => 'アルバムアートの主張色をアクセントカラーとして使用';

  @override
  String get playback => '再生';

  @override
  String get audio_quality => '音声品質';

  @override
  String get high => '高';

  @override
  String get low => '低';

  @override
  String get pre_download_play => '事前ダウンロードと再生';

  @override
  String get pre_download_play_description => '音声をストリーミングする代わりに、データをバイト単位でダウンロードして再生 (回線速度が早いユーザーにおすすめ)';

  @override
  String get skip_non_music => '音楽でない部分をスキップ (SponsorBlock)';

  @override
  String get blacklist_description => '曲とアーティストのブラックリスト';

  @override
  String get wait_for_download_to_finish => '現在のダウンロードが完了するまでお待ちください';

  @override
  String get desktop => 'デスクトップ';

  @override
  String get close_behavior => '閉じた時の動作';

  @override
  String get close => '閉じる';

  @override
  String get minimize_to_tray => 'トレイに最小化';

  @override
  String get show_tray_icon => 'システムトレイにアイコンを表示';

  @override
  String get about => 'このアプリについて';

  @override
  String get u_love_spotube => 'Spotube が好きだと知っていますよ';

  @override
  String get check_for_updates => 'アップデートの確認';

  @override
  String get about_spotube => 'Spotube について';

  @override
  String get blacklist => 'ブラックリスト';

  @override
  String get please_sponsor => '出資/寄付もお待ちします';

  @override
  String get spotube_description => 'Spotube は、軽量でクロスプラットフォームな、すべて無料の spotify クライアント';

  @override
  String get version => 'バージョン';

  @override
  String get build_number => 'ビルド番号';

  @override
  String get founder => '創始者';

  @override
  String get repository => 'リポジトリ';

  @override
  String get bug_issues => 'バグや問題';

  @override
  String get made_with => '❤️ を込めてバングラディシュ🇧🇩で開発';

  @override
  String get kingkor_roy_tirtho => 'Kingkor Roy Tirtho';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year Kingkor Roy Tirtho';
  }

  @override
  String get license => 'ライセンス';

  @override
  String get add_spotify_credentials => 'Spotify のログイン情報を追加してはじめましょう';

  @override
  String get credentials_will_not_be_shared_disclaimer => '心配ありません。個人情報を収集したり、共有されることはありません';

  @override
  String get know_how_to_login => 'やり方が分からないですか？';

  @override
  String get follow_step_by_step_guide => 'やり方の説明を見る';

  @override
  String spotify_cookie(Object name) {
    return 'Spotify $name Cookies';
  }

  @override
  String cookie_name_cookie(Object name) {
    return '$name Cookies';
  }

  @override
  String get fill_in_all_fields => 'すべての欄に入力してください';

  @override
  String get submit => '送信';

  @override
  String get exit => '終了';

  @override
  String get previous => '前へ';

  @override
  String get next => '次へ';

  @override
  String get done => '完了';

  @override
  String get step_1 => 'ステップ 1';

  @override
  String get first_go_to => '最初にここを開き';

  @override
  String get login_if_not_logged_in => '、ログインしてないならログインまたは登録します';

  @override
  String get step_2 => 'ステップ 2';

  @override
  String get step_2_steps => '1. ログインしたら、F12を押すか、マウス右クリック ＞ 調査（検証）でブラウザの開発者ツール (devtools) を開きます。\n2. アプリケーション (Application) タブ (Chrome, Edge, Brave など) またはストレージタブ (Firefox, Palemoon など)\n3. Cookies 欄を選択し、https://accounts.spotify.com の枝を選びます';

  @override
  String get step_3 => 'ステップ 3';

  @override
  String get step_3_steps => '\"sp_dc\" Cookieの値をコピー';

  @override
  String get success_emoji => '成功🥳';

  @override
  String get success_message => 'アカウントへのログインに成功しました。よくできました！';

  @override
  String get step_4 => 'ステップ 4';

  @override
  String get step_4_steps => 'コピーした\"sp_dc\"の値を貼り付け';

  @override
  String get something_went_wrong => '何か誤りがあります';

  @override
  String get piped_instance => 'Piped サーバーのインスタンス';

  @override
  String get piped_description => '曲の一致に使う Piped サーバーのインスタンス';

  @override
  String get piped_warning => 'それらの一部ではうまく動作しないこともあります。自己責任で使用してください';

  @override
  String get invidious_instance => 'Invidiousサーバーインスタンス';

  @override
  String get invidious_description => 'トラックマッチングに使用するInvidiousサーバーインスタンス';

  @override
  String get invidious_warning => '一部はうまく機能しない可能性があります。自己責任で使用してください';

  @override
  String get generate => '生成';

  @override
  String track_exists(Object track) {
    return '曲 $track は既に存在します';
  }

  @override
  String get replace_downloaded_tracks => 'すべてのダウンロード済みの曲を置換';

  @override
  String get skip_download_tracks => 'すべてのダウンロード済みの曲をスキップ';

  @override
  String get do_you_want_to_replace => '既存の曲と置換しますか？';

  @override
  String get replace => '置換する';

  @override
  String get skip => 'スキップ';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return '$typeを最大$count 個まで選択';
  }

  @override
  String get select_genres => 'ジャンルを選択';

  @override
  String get add_genres => 'ジャンルを追加';

  @override
  String get country => '国';

  @override
  String get number_of_tracks_generate => '生成する曲数';

  @override
  String get acousticness => 'アコースティック感';

  @override
  String get danceability => 'ダンス感';

  @override
  String get energy => 'エネルギー';

  @override
  String get instrumentalness => 'インストゥルメンタル';

  @override
  String get liveness => 'ライブ感';

  @override
  String get loudness => 'ラウドネス';

  @override
  String get speechiness => '会話感';

  @override
  String get valence => '多幸性';

  @override
  String get popularity => '人気度';

  @override
  String get key => 'キー';

  @override
  String get duration => '長さ (秒)';

  @override
  String get tempo => 'テンポ (BPM)';

  @override
  String get mode => '長調';

  @override
  String get time_signature => '拍子記号';

  @override
  String get short => '短';

  @override
  String get medium => '中';

  @override
  String get long => '長';

  @override
  String get min => '最小';

  @override
  String get max => '最大';

  @override
  String get target => '目標';

  @override
  String get moderate => '中';

  @override
  String get deselect_all => 'すべて選択解除';

  @override
  String get select_all => 'すべて選択';

  @override
  String get are_you_sure => 'よろしいですか？';

  @override
  String get generating_playlist => 'カスタムの再生リストを生成中...';

  @override
  String selected_count_tracks(Object count) {
    return '$count 曲が選ばれました';
  }

  @override
  String get download_warning => '全曲の一括ダウンロードは明らかに音楽への海賊行為であり、音楽を生み出す共同体に損害を与えるでしょう。気づいてほしい。アーティストの多大な努力に敬意を払い、支援するようにしてください';

  @override
  String get download_ip_ban_warning => 'また、通常よりも過剰なダウンロード要求があれば、YouTubeはあなたのIPをブロックします。つまりそのIPの端末からは、少なくとも2-3か月の間、（ログインしても）YouTubeを利用できなくなりす。そうなっても Spotube は一切の責任を負いません';

  @override
  String get by_clicking_accept_terms => '「同意する」のクリックにより、以下への同意となります:';

  @override
  String get download_agreement_1 => 'ええ、音楽への海賊行為だ。私はよくない';

  @override
  String get download_agreement_2 => '芸術作品を買うお金がないのでそうするしかないが、アーティストをできる限り支援する';

  @override
  String get download_agreement_3 => '私のIPがYouTubeにブロックされることがあると完全に把握した。私のこの行動により起きたどんな事故も、Spotube やその所有者/貢献者に責任はありません。';

  @override
  String get decline => '同意しない';

  @override
  String get accept => '同意する';

  @override
  String get details => '詳細';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => 'チャンネル';

  @override
  String get likes => '高評価';

  @override
  String get dislikes => '低評価';

  @override
  String get views => '視聴回数';

  @override
  String get streamUrl => '動画の URL';

  @override
  String get stop => '中止';

  @override
  String get sort_newest => '追加日の新しい順に並び替え';

  @override
  String get sort_oldest => '追加日の古い順に並び替え';

  @override
  String get sleep_timer => 'スリープタイマー';

  @override
  String mins(Object minutes) {
    return '$minutes 分';
  }

  @override
  String hours(Object hours) {
    return '$hours 時間';
  }

  @override
  String hour(Object hours) {
    return '$hours 時間';
  }

  @override
  String get custom_hours => '時間を指定';

  @override
  String get logs => 'ログ';

  @override
  String get developers => '開発';

  @override
  String get not_logged_in => 'ログインしていません';

  @override
  String get search_mode => '検索モード';

  @override
  String get audio_source => '音声ソース';

  @override
  String get ok => '分かりました';

  @override
  String get failed_to_encrypt => '暗号化に失敗しました';

  @override
  String get encryption_failed_warning => 'Spotubeはデータを安全に保存するために暗号化を使用しています。しかし、失敗しました。したがって、安全でないストレージにフォールバックします\nLinuxを使用している場合は、gnome-keyring、kde-wallet、keepassxcなどのシークレットサービスがインストールされていることを確認してください';

  @override
  String get querying_info => '情報を取得中...';

  @override
  String get piped_api_down => 'Piped APIがダウンしています';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return 'Pipedインスタンス$pipedInstanceは現在ダウンしています\n\nインスタンスを変更するか、\'APIタイプ\'を公式のYouTube APIに変更してください\n\n変更後にアプリを再起動してください';
  }

  @override
  String get you_are_offline => '現在、オフラインです';

  @override
  String get connection_restored => 'インターネット接続が復旧しました';

  @override
  String get use_system_title_bar => 'システムタイトルバーを使用する';

  @override
  String get crunching_results => '結果を処理中...';

  @override
  String get search_to_get_results => '結果を取得するために検索';

  @override
  String get use_amoled_mode => 'AMOLEDモードを使用する';

  @override
  String get pitch_dark_theme => 'ピッチブラックダートテーマ';

  @override
  String get normalize_audio => 'オーディオを正規化する';

  @override
  String get change_cover => 'カバーを変更する';

  @override
  String get add_cover => 'カバーを追加する';

  @override
  String get restore_defaults => 'デフォルト値に戻す';

  @override
  String get download_music_codec => '音楽コーデックをダウンロードする';

  @override
  String get streaming_music_codec => 'ストリーミング音楽コーデック';

  @override
  String get login_with_lastfm => 'Last.fmでログインする';

  @override
  String get connect => '接続する';

  @override
  String get disconnect_lastfm => 'Last.fmから切断する';

  @override
  String get disconnect => '切断する';

  @override
  String get username => 'ユーザー名';

  @override
  String get password => 'パスワード';

  @override
  String get login => 'ログインする';

  @override
  String get login_with_your_lastfm => 'あなたのLast.fmアカウントでログインする';

  @override
  String get scrobble_to_lastfm => 'Last.fmにスクロブルする';

  @override
  String get go_to_album => 'アルバムに移動';

  @override
  String get discord_rich_presence => 'ディスコードリッチプレゼンス';

  @override
  String get browse_all => 'すべてを閲覧';

  @override
  String get genres => 'ジャンル';

  @override
  String get explore_genres => 'ジャンルを探索';

  @override
  String get friends => '友達';

  @override
  String get no_lyrics_available => '申し訳ありませんが、このトラックの歌詞を見つけることができません';

  @override
  String get start_a_radio => 'ラジオを開始';

  @override
  String get how_to_start_radio => 'ラジオをどのように開始しますか？';

  @override
  String get replace_queue_question => '現在のキューを置き換えるか、追加しますか？';

  @override
  String get endless_playback => 'エンドレス再生';

  @override
  String get delete_playlist => 'プレイリストを削除';

  @override
  String get delete_playlist_confirmation => 'このプレイリストを削除してもよろしいですか？';

  @override
  String get local_tracks => 'ローカルトラック';

  @override
  String get local_tab => 'ローカル';

  @override
  String get song_link => '曲のリンク';

  @override
  String get skip_this_nonsense => 'この愚かなことをスキップ';

  @override
  String get freedom_of_music => '“音楽の自由”';

  @override
  String get freedom_of_music_palm => '“手のひらの中の音楽の自由”';

  @override
  String get get_started => 'さあ始めましょう';

  @override
  String get youtube_source_description => '推奨され、最適に機能します。';

  @override
  String get piped_source_description => '自由に感じますか？ YouTubeと同じですが、はるかに無料です。';

  @override
  String get jiosaavn_source_description => '南アジア地域向けの最適です。';

  @override
  String get invidious_source_description => 'Pipedに似ていますが、より高い可用性があります。';

  @override
  String highest_quality(Object quality) {
    return '最高品質：$quality';
  }

  @override
  String get select_audio_source => 'オーディオソースを選択';

  @override
  String get endless_playback_description => '新しい曲をキューの最後に自動的に追加';

  @override
  String get choose_your_region => '地域を選択';

  @override
  String get choose_your_region_description => 'これにより、Spotubeがあなたの場所に適したコンテンツを表示できます。';

  @override
  String get choose_your_language => '言語を選択してください';

  @override
  String get help_project_grow => 'このプロジェクトの成長を支援する';

  @override
  String get help_project_grow_description => 'Spotubeはオープンソースプロジェクトです。プロジェクトに貢献したり、バグを報告したり、新しい機能を提案することで、このプロジェクトの成長に貢献できます。';

  @override
  String get contribute_on_github => 'GitHubで貢献する';

  @override
  String get donate_on_open_collective => 'Open Collectiveで寄付する';

  @override
  String get browse_anonymously => '匿名で閲覧する';

  @override
  String get enable_connect => '接続を有効にする';

  @override
  String get enable_connect_description => '他のデバイスからSpotubeを制御する';

  @override
  String get devices => 'デバイス';

  @override
  String get select => '選択する';

  @override
  String connect_client_alert(Object client) {
    return '$client によって操作されています';
  }

  @override
  String get this_device => 'このデバイス';

  @override
  String get remote => 'リモート';

  @override
  String get stats => '統計';

  @override
  String and_n_more(Object count) {
    return 'そして $count つのアイテム';
  }

  @override
  String get recently_played => '最近再生された';

  @override
  String get browse_more => 'もっと見る';

  @override
  String get no_title => 'タイトルなし';

  @override
  String get not_playing => '再生中ではありません';

  @override
  String get epic_failure => '壮大な失敗！';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return '$tracks_length 曲をキューに追加しました';
  }

  @override
  String get spotube_has_an_update => 'Spotube にアップデートがあります';

  @override
  String get download_now => '今すぐダウンロード';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Spotube Nightly $nightlyBuildNum がリリースされました';
  }

  @override
  String release_version(Object version) {
    return 'Spotube v$version がリリースされました';
  }

  @override
  String get read_the_latest => '最新の ';

  @override
  String get release_notes => 'リリースノート';

  @override
  String get pick_color_scheme => 'カラースキームを選択';

  @override
  String get save => '保存';

  @override
  String get choose_the_device => 'デバイスを選択：';

  @override
  String get multiple_device_connected => '複数のデバイスが接続されています。\nこのアクションを実行するデバイスを選択してください';

  @override
  String get nothing_found => '何も見つかりませんでした';

  @override
  String get the_box_is_empty => 'ボックスは空です';

  @override
  String get top_artists => 'トップアーティスト';

  @override
  String get top_albums => 'トップアルバム';

  @override
  String get this_week => '今週';

  @override
  String get this_month => '今月';

  @override
  String get last_6_months => '過去6か月';

  @override
  String get this_year => '今年';

  @override
  String get last_2_years => '過去2年間';

  @override
  String get all_time => '全期間';

  @override
  String powered_by_provider(Object providerName) {
    return '$providerName 提供';
  }

  @override
  String get email => 'メール';

  @override
  String get profile_followers => 'フォロワー';

  @override
  String get birthday => '誕生日';

  @override
  String get subscription => 'サブスクリプション';

  @override
  String get not_born => '未出生';

  @override
  String get hacker => 'ハッカー';

  @override
  String get profile => 'プロフィール';

  @override
  String get no_name => '名前なし';

  @override
  String get edit => '編集';

  @override
  String get user_profile => 'ユーザープロフィール';

  @override
  String count_plays(Object count) {
    return '$count 回再生';
  }

  @override
  String get streaming_fees_hypothetical => '*これは Spotify のストリームあたりの支払い\nが \$0.003 から \$0.005 であると仮定して計算されています。\nこれは、Spotify でその曲を聴いた場合にアーティストにいくら支払ったかの\n洞察を得るための仮定の計算です。';

  @override
  String get minutes_listened => 'リスニング時間';

  @override
  String get streamed_songs => 'ストリーミングされた曲';

  @override
  String count_streams(Object count) {
    return '$count 回のストリーム';
  }

  @override
  String get owned_by_you => 'あなたが所有';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return '$shareUrl をクリップボードにコピーしました';
  }

  @override
  String get spotify_hipotetical_calculation => '*これは、Spotifyのストリームごとの支払い\nが \$0.003 から \$0.005 の範囲で計算されています。これは仮想的な\n計算で、Spotify で曲を聴いた場合に、アーティストに\nどれくらい支払ったかをユーザーに示すためのものです。';

  @override
  String count_mins(Object minutes) {
    return '$minutes 分';
  }

  @override
  String get summary_minutes => '分';

  @override
  String get summary_listened_to_music => '音楽を聴いた';

  @override
  String get summary_songs => '曲';

  @override
  String get summary_streamed_overall => '全体のストリーミング';

  @override
  String get summary_owed_to_artists => '今月アーティストに支払うべき額';

  @override
  String get summary_artists => 'アーティストの';

  @override
  String get summary_music_reached_you => '音楽があなたに届いた';

  @override
  String get summary_full_albums => 'フルアルバム';

  @override
  String get summary_got_your_love => 'あなたの愛を受け取った';

  @override
  String get summary_playlists => 'プレイリスト';

  @override
  String get summary_were_on_repeat => 'リピートしていた';

  @override
  String total_money(Object money) {
    return '合計 $money';
  }

  @override
  String get webview_not_found => 'Webviewが見つかりません';

  @override
  String get webview_not_found_description => 'デバイスにWebviewランタイムがインストールされていません。\nインストールされている場合は、environment PATHにあることを確認してください\n\nインストール後、アプリを再起動してください';

  @override
  String get unsupported_platform => 'サポートされていないプラットフォーム';

  @override
  String get cache_music => '音楽をキャッシュ';

  @override
  String get open => '開く';

  @override
  String get cache_folder => 'キャッシュフォルダー';

  @override
  String get export => 'エクスポート';

  @override
  String get clear_cache => 'キャッシュをクリア';

  @override
  String get clear_cache_confirmation => 'キャッシュをクリアしますか？';

  @override
  String get export_cache_files => 'キャッシュされたファイルをエクスポート';

  @override
  String found_n_files(Object count) {
    return '$countファイルが見つかりました';
  }

  @override
  String get export_cache_confirmation => 'これらのファイルをエクスポートしますか';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return '$filesExported / $filesファイルがエクスポートされました';
  }

  @override
  String get undo => '元に戻す';

  @override
  String get download_all => 'すべてをダウンロード';

  @override
  String get add_all_to_playlist => 'すべてをプレイリストに追加';

  @override
  String get add_all_to_queue => 'すべてをキューに追加';

  @override
  String get play_all_next => '次にすべてを再生';

  @override
  String get pause => '一時停止';

  @override
  String get view_all => 'すべてを見る';

  @override
  String get no_tracks_added_yet => 'まだ曲を追加していないようです';

  @override
  String get no_tracks => 'ここには曲がないようです';

  @override
  String get no_tracks_listened_yet => 'まだ何も聞いていないようです';

  @override
  String get not_following_artists => 'アーティストをフォローしていません';

  @override
  String get no_favorite_albums_yet => 'まだお気に入りのアルバムを追加していないようです';

  @override
  String get no_logs_found => 'ログが見つかりませんでした';

  @override
  String get youtube_engine => 'YouTubeエンジン';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engineはインストールされていません';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engineはシステムにインストールされていません。';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return 'PATH変数に設定されていることを確認するか\n$engine実行ファイルの絶対パスを下記に設定してください';
  }

  @override
  String get youtube_engine_unix_issue_message => 'macOS/Linux/Unix系OSでは、.zshrc/.bashrc/.bash_profileなどでパスを設定しても動作しません。\nシェルの設定ファイルにパスを設定する必要があります';

  @override
  String get download => 'ダウンロード';

  @override
  String get file_not_found => 'ファイルが見つかりません';

  @override
  String get custom => 'カスタム';

  @override
  String get add_custom_url => 'カスタムURLを追加';
}
