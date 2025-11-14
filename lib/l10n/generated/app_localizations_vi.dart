// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get guest => 'Khách';

  @override
  String get browse => 'Khám phá';

  @override
  String get search => 'Tìm kiếm';

  @override
  String get library => 'Thư viên';

  @override
  String get lyrics => 'Lời bài hát';

  @override
  String get settings => 'Cài đặt';

  @override
  String get genre_categories_filter => 'Lọc theo thể loại nhạc...';

  @override
  String get genre => 'Thể loại nhạc';

  @override
  String get personalized => 'Cá nhân hóa';

  @override
  String get featured => 'Nổi bật';

  @override
  String get new_releases => 'Bản phát hành mới';

  @override
  String get songs => 'Bài hát';

  @override
  String playing_track(Object track) {
    return 'Đang phát $track';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return 'Điều này sẽ xóa hàng đợi hiện tại. $track_length bài hát sẽ bị xóa\nBạn có muốn tiếp tục không?';
  }

  @override
  String get load_more => 'Tải thêm';

  @override
  String get playlists => 'Danh sách phát';

  @override
  String get artists => 'Nghệ sĩ';

  @override
  String get albums => 'Album';

  @override
  String get tracks => 'Bài hát';

  @override
  String get downloads => 'Tải về';

  @override
  String get filter_playlists => 'Lọc danh sách phát...';

  @override
  String get liked_tracks => 'Bài hát được thích';

  @override
  String get liked_tracks_description => 'Tất cả bài hát bạn đã thích';

  @override
  String get playlist => 'Danh sách phát';

  @override
  String get create_a_playlist => 'Tạo danh sách phát';

  @override
  String get update_playlist => 'Cập nhật danh sách phát';

  @override
  String get create => 'Tạo';

  @override
  String get cancel => 'Hủy';

  @override
  String get update => 'Cập nhật';

  @override
  String get playlist_name => 'Tên danh sách phát';

  @override
  String get name_of_playlist => 'Tên của danh sách phát';

  @override
  String get description => 'Mô tả';

  @override
  String get public => 'Công khai';

  @override
  String get collaborative => 'Hợp tác';

  @override
  String get search_local_tracks => 'Tìm kiếm bài hát trong máy...';

  @override
  String get play => 'Phát';

  @override
  String get delete => 'Xóa';

  @override
  String get none => 'Không có';

  @override
  String get sort_a_z => 'Sắp xếp theo A-Z';

  @override
  String get sort_z_a => 'Sắp xếp theo Z-A';

  @override
  String get sort_artist => 'Sắp xếp theo Nghệ sĩ';

  @override
  String get sort_album => 'Sắp xếp theo Album';

  @override
  String get sort_duration => 'Sắp xếp theo Thời lượng';

  @override
  String get sort_tracks => 'Sắp xếp các bài hát';

  @override
  String currently_downloading(Object tracks_length) {
    return 'Đang tải về ($tracks_length bài hát)';
  }

  @override
  String get cancel_all => 'Hủy tất cả';

  @override
  String get filter_artist => 'Lọc nghệ sĩ...';

  @override
  String followers(Object followers) {
    return '$followers Người theo dõi';
  }

  @override
  String get add_artist_to_blacklist => 'Thêm nghệ sĩ vào blacklist';

  @override
  String get top_tracks => 'Bài hát nổi bật';

  @override
  String get fans_also_like => 'Người hâm mộ cũng thích';

  @override
  String get loading => 'Đang tải...';

  @override
  String get artist => 'Nghệ sĩ';

  @override
  String get blacklisted => 'Đã đưa vào blacklist';

  @override
  String get following => 'Đang theo dõi';

  @override
  String get follow => 'Theo dõi';

  @override
  String get artist_url_copied => 'Đã sao chép URL nghệ sĩ';

  @override
  String added_to_queue(Object tracks) {
    return 'Đã thêm $tracks bài hát vào hàng đợi';
  }

  @override
  String get filter_albums => 'Lọc album...';

  @override
  String get synced => 'Đồng bộ';

  @override
  String get plain => 'Bình thường';

  @override
  String get shuffle => 'Trộn';

  @override
  String get search_tracks => 'Tìm kiếm bài hát...';

  @override
  String get released => 'Phát hành';

  @override
  String error(Object error) {
    return 'Lỗi $error';
  }

  @override
  String get title => 'Đề mục';

  @override
  String get time => 'Thời gian';

  @override
  String get more_actions => 'Thao tác khác';

  @override
  String download_count(Object count) {
    return 'Tải xuống ($count)';
  }

  @override
  String add_count_to_playlist(Object count) {
    return 'Thêm ($count) vào danh sách phát';
  }

  @override
  String add_count_to_queue(Object count) {
    return 'Thêm ($count) vào hàng đợi';
  }

  @override
  String play_count_next(Object count) {
    return 'Phát ($count) tiếp theo';
  }

  @override
  String get album => 'Album';

  @override
  String copied_to_clipboard(Object data) {
    return 'Đã sao chép $data vào clipboard';
  }

  @override
  String add_to_following_playlists(Object track) {
    return 'Thêm $track vào danh sách phát đang theo dõi';
  }

  @override
  String get add => 'Thêm';

  @override
  String added_track_to_queue(Object track) {
    return 'Đã thêm $track vào hàng đợi';
  }

  @override
  String get add_to_queue => 'Thêm vào hàng đợi';

  @override
  String track_will_play_next(Object track) {
    return '$track sẽ được phát tiếp theo';
  }

  @override
  String get play_next => 'Phát tiếp theo';

  @override
  String removed_track_from_queue(Object track) {
    return 'Đã xóa $track khỏi hàng đợi';
  }

  @override
  String get remove_from_queue => 'Xóa khỏi hàng đợi';

  @override
  String get remove_from_favorites => 'Xóa khỏi bài hát yêu thích';

  @override
  String get save_as_favorite => 'Thêm vào bài hát yêu thích';

  @override
  String get add_to_playlist => 'Thêm vào danh sách phát';

  @override
  String get remove_from_playlist => 'Xóa khỏi danh sách phát';

  @override
  String get add_to_blacklist => 'Thêm vào blacklist';

  @override
  String get remove_from_blacklist => 'Xóa khỏi blacklist';

  @override
  String get share => 'Chia sẻ';

  @override
  String get mini_player => 'Trình phát thu nhỏ';

  @override
  String get slide_to_seek => 'Trượt để tìm kiếm tiến hoặc lùi';

  @override
  String get shuffle_playlist => 'Xáo trộn bài hát';

  @override
  String get unshuffle_playlist => 'Hủy xáo trộn bài hát';

  @override
  String get previous_track => 'Bài hát trước';

  @override
  String get next_track => 'Bài hát tiếp theo';

  @override
  String get pause_playback => 'Tạm dừng phát';

  @override
  String get resume_playback => 'Tiếp tục phát';

  @override
  String get loop_track => 'Lặp lại bài hát';

  @override
  String get no_loop => 'Không lặp lại';

  @override
  String get repeat_playlist => 'Lặp lại danh sách phát';

  @override
  String get queue => 'Hàng đợi';

  @override
  String get alternative_track_sources => 'Đổi nguồn bài hát';

  @override
  String get download_track => 'Tải xuống';

  @override
  String tracks_in_queue(Object tracks) {
    return '$tracks bài hát trong hàng đợi';
  }

  @override
  String get clear_all => 'Xóa tất cả';

  @override
  String get show_hide_ui_on_hover =>
      'Hiển thị/Ẩn giao diện người dùng khi di chuột qua';

  @override
  String get always_on_top => 'Luôn ở trên cùng';

  @override
  String get exit_mini_player => 'Thoát khỏi trình phát thu nhỏ';

  @override
  String get download_location => 'Vị trí tải xuống';

  @override
  String get local_library => 'Thư viện địa phương';

  @override
  String get add_library_location => 'Thêm vào thư viện';

  @override
  String get remove_library_location => 'Xóa khỏi thư viện';

  @override
  String get account => 'Tài khoản';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get logout_of_this_account => 'Đăng xuất khỏi tài khoản này';

  @override
  String get language_region => 'Ngôn ngữ và Khu vực';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get system_default => 'Mặc định hệ thống';

  @override
  String get market_place_region => 'Khu vực Marketplace';

  @override
  String get recommendation_country => 'Quốc gia gợi ý';

  @override
  String get appearance => 'Giao diện';

  @override
  String get layout_mode => 'Chế độ layout';

  @override
  String get override_layout_settings => 'Ghi đè cài đặt layout';

  @override
  String get adaptive => 'Tương thích';

  @override
  String get compact => 'Nhỏ gọn';

  @override
  String get extended => 'Mở rộng';

  @override
  String get theme => 'Chủ đề';

  @override
  String get dark => 'Tối';

  @override
  String get light => 'Sáng';

  @override
  String get system => 'Hệ thống';

  @override
  String get accent_color => 'Màu nhấn';

  @override
  String get sync_album_color => 'Đồng bộ màu album';

  @override
  String get sync_album_color_description =>
      'Sử dụng màu chủ đạo của hình ảnh album làm màu nhấn';

  @override
  String get playback => 'Phát';

  @override
  String get audio_quality => 'Chất lượng âm thanh';

  @override
  String get high => 'Cao';

  @override
  String get low => 'Thấp';

  @override
  String get pre_download_play => 'Tải xuống và phát';

  @override
  String get pre_download_play_description =>
      'Thay vì stream âm thanh, tải xuống trước và phát (Khuyến nghị cho người dùng có băng thông cao)';

  @override
  String get skip_non_music => 'Bỏ qua các đoạn không phải nhạc (SponsorBlock)';

  @override
  String get blacklist_description => 'Các bài hát và nghệ sĩ trong blacklist';

  @override
  String get wait_for_download_to_finish =>
      'Vui lòng đợi quá trình tải xuống hiện tại hoàn thành';

  @override
  String get desktop => 'Máy tính';

  @override
  String get close_behavior => 'Thao tác đóng';

  @override
  String get close => 'Đóng';

  @override
  String get minimize_to_tray => 'Thu nhỏ vào khay hệ thống';

  @override
  String get show_tray_icon => 'Hiển thị biểu tượng trên khay hệ thống';

  @override
  String get about => 'Về chúng tôi';

  @override
  String get u_love_spotube => 'Chúng tôi biết bạn yêu Spotube';

  @override
  String get check_for_updates => 'Kiểm tra cập nhật';

  @override
  String get about_spotube => 'Về Spotube';

  @override
  String get blacklist => 'blacklist';

  @override
  String get please_sponsor => 'Vui lòng tài trợ/ủng hộ';

  @override
  String get spotube_description =>
      'Spotube, một ứng dụng Spotify nhẹ, đa nền tảng và miễn phí';

  @override
  String get version => 'Phiên bản';

  @override
  String get build_number => 'Số phiên bản';

  @override
  String get founder => 'Người sáng lập';

  @override
  String get repository => 'Mã nguồn';

  @override
  String get bug_issues => 'Báo cáo lỗi';

  @override
  String get made_with => 'Được làm bằng ❤️ ở Băng-la-đét';

  @override
  String get kingkor_roy_tirtho => 'Kingkor Roy Tirtho';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year Kingkor Roy Tirtho';
  }

  @override
  String get license => 'Giấy phép';

  @override
  String get credentials_will_not_be_shared_disclaimer =>
      'Đừng lo, thông tin đăng nhập của bạn sẽ không được thu thập hoặc chia sẻ với bất kỳ ai';

  @override
  String get know_how_to_login => 'Không biết cách lấy thông tin đăng nhập?';

  @override
  String get follow_step_by_step_guide => 'Các bước lấy thông tin đăng nhập';

  @override
  String cookie_name_cookie(Object name) {
    return 'Cookie $name';
  }

  @override
  String get fill_in_all_fields => 'Vui lòng điền đầy đủ thông tin';

  @override
  String get submit => 'Gửi';

  @override
  String get exit => 'Thoát';

  @override
  String get previous => 'Trước';

  @override
  String get next => 'Tiếp';

  @override
  String get done => 'Hoàn tất';

  @override
  String get step_1 => 'Bước 1';

  @override
  String get first_go_to => 'Đầu tiên, truy cập';

  @override
  String get something_went_wrong => 'Đã xảy ra lỗi';

  @override
  String get piped_instance => 'Phiên bản Server Piped';

  @override
  String get piped_description =>
      'Phiên bản Piped để sử dụng cho Track matching';

  @override
  String get piped_warning =>
      'Một số phiên bản Piped có thể không hoạt động tốt';

  @override
  String get invidious_instance => 'Phiên bản máy chủ Invidious';

  @override
  String get invidious_description =>
      'Phiên bản máy chủ Invidious để sử dụng để so khớp bản nhạc';

  @override
  String get invidious_warning =>
      'Một số có thể sẽ không hoạt động tốt. Vì vậy hãy sử dụng với rủi ro của riêng bạn';

  @override
  String get generate => 'Tạo';

  @override
  String track_exists(Object track) {
    return 'Bài hát $track đã tồn tại';
  }

  @override
  String get replace_downloaded_tracks => 'Thay thế tất cả các bài hát đã tải';

  @override
  String get skip_download_tracks =>
      'Bỏ qua tải xuống tất cả các bài hát đã tải';

  @override
  String get do_you_want_to_replace =>
      'Bạn có muốn thay thế bài hát hiện có không?';

  @override
  String get replace => 'Thay thế';

  @override
  String get skip => 'Bỏ qua';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return 'Chọn tối đa $count $type';
  }

  @override
  String get select_genres => 'Chọn Thể loại';

  @override
  String get add_genres => 'Thêm Thể loại';

  @override
  String get country => 'Quốc gia';

  @override
  String get number_of_tracks_generate => 'Số lượng bài hát để tạo';

  @override
  String get acousticness => 'Độ âm thanh';

  @override
  String get danceability => 'Khả năng nhảy';

  @override
  String get energy => 'Năng lượng';

  @override
  String get instrumentalness => 'Độ nhạc cụ';

  @override
  String get liveness => 'Sống động';

  @override
  String get loudness => 'Độ ồn';

  @override
  String get speechiness => 'Độ nói';

  @override
  String get valence => 'Tính tích cực';

  @override
  String get popularity => 'Độ phổ biến';

  @override
  String get key => 'Tông';

  @override
  String get duration => 'Thời lượng (giây)';

  @override
  String get tempo => 'Nhịp độ (BPM)';

  @override
  String get mode => 'Chế độ';

  @override
  String get time_signature => 'Chữ ký thời gian';

  @override
  String get short => 'Ngắn';

  @override
  String get medium => 'Trung bình';

  @override
  String get long => 'Dài';

  @override
  String get min => 'Tối thiểu';

  @override
  String get max => 'Tối đa';

  @override
  String get target => 'Mục tiêu';

  @override
  String get moderate => 'Trung bình';

  @override
  String get deselect_all => 'Bỏ chọn tất cả';

  @override
  String get select_all => 'Chọn tất cả';

  @override
  String get are_you_sure => 'Bạn có chắc chắn?';

  @override
  String get generating_playlist =>
      'Đang tạo danh sách phát tùy chỉnh của bạn...';

  @override
  String selected_count_tracks(Object count) {
    return 'Đã chọn $count bài hát';
  }

  @override
  String get download_warning =>
      'Tải xuống tất cả các bài hát một lần, sẽ vi phạm bản quyền âm nhạc và gây thiệt hại cho xã hội sáng tạo âm nhạc. Hy vọng bạn nhận thức được điều này. Hãy luôn tôn trọng và ủng hộ công sức của nghệ sĩ';

  @override
  String get download_ip_ban_warning =>
      'Địa chỉ IP của bạn có thể bị chặn trên YouTube do yêu cầu tải xuống quá mức so với bình thường. Chặn IP có nghĩa là bạn không thể sử dụng YouTube (ngay cả khi bạn đã đăng nhập) ít nhất 2-3 tháng từ thiết bị IP đó. Và Spotube không chịu trách nhiệm nếu điều này xảy ra';

  @override
  String get by_clicking_accept_terms =>
      'Bằng cách nhấp vào \'Chấp nhận\', bạn đồng ý với các điều khoản sau:';

  @override
  String get download_agreement_1 =>
      'Tôi biết mình đang vi phạm bản quyền âm nhạc. Đó là không tốt.';

  @override
  String get download_agreement_2 =>
      'Tôi sẽ ủng hộ nghệ sĩ bất cứ nơi nào tôi có thể và tôi chỉ làm điều này vì tôi không có tiền để mua tác phẩm của họ';

  @override
  String get download_agreement_3 =>
      'Tôi hoàn toàn nhận thức được rằng địa chỉ IP của tôi có thể bị chặn trên YouTube và tôi không đổ lỗi cho Spotube hoặc chủ sở hữu/người đóng góp của nó về bất kỳ tai nạn nào do hành động này của tôi';

  @override
  String get decline => 'Từ chối';

  @override
  String get accept => 'Chấp nhận';

  @override
  String get details => 'Chi tiết';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => 'Kênh';

  @override
  String get likes => 'Thích';

  @override
  String get dislikes => 'Không thích';

  @override
  String get views => 'Lượt xem';

  @override
  String get streamUrl => 'URL phát trực tiếp';

  @override
  String get stop => 'Dừng';

  @override
  String get sort_newest => 'Sắp xếp theo mới nhất';

  @override
  String get sort_oldest => 'Sắp xếp theo cũ nhất';

  @override
  String get sleep_timer => 'Hẹn giờ tắt';

  @override
  String mins(Object minutes) {
    return '$minutes Phút';
  }

  @override
  String hours(Object hours) {
    return '$hours Giờ';
  }

  @override
  String hour(Object hours) {
    return '$hours Giờ';
  }

  @override
  String get custom_hours => 'Giờ Tùy chỉnh';

  @override
  String get logs => 'Nhật ký';

  @override
  String get developers => 'Nhà phát triển';

  @override
  String get not_logged_in => 'Bạn chưa đăng nhập';

  @override
  String get search_mode => 'Chế độ tìm kiếm';

  @override
  String get audio_source => 'Nguồn âm thanh';

  @override
  String get ok => 'Ok';

  @override
  String get failed_to_encrypt => 'Mã hóa không thành công';

  @override
  String get encryption_failed_warning =>
      'Spotube không thành công trong việc mã hóa nhằm lưu trữ dữ liêu an toàn. vậy nên sẽ chuyển về lưu trữ không an toàn\nNếu bạn đang sử dụng Linux, đảm bảo rằng bạn có sử dụng dịch vụ bảo mật (gnome-keyring, kde-wallet, keepassxc, v.v.)';

  @override
  String get querying_info => 'Đang truy vấn thông tin...';

  @override
  String get piped_api_down => 'API Piped đang gặp sự cố';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return 'Phiên bản Piped $pipedInstance hiện đang gặp sự cố\n\nThay đổi phiên bản hoặc thay đổi \'Loại API\' thành API YouTube official\n\nKhởi động lai ứng dụng sau khi thay đổi.';
  }

  @override
  String get you_are_offline => 'Bạn đang ngoại tuyến';

  @override
  String get connection_restored =>
      'Kết nối internet của bạn đã được khôi phục';

  @override
  String get use_system_title_bar => 'Sử dụng thanh tiêu đề hệ thống';

  @override
  String get crunching_results => 'Đang tìm kiếm...';

  @override
  String get search_to_get_results => 'Chưa tìm kiếm';

  @override
  String get use_amoled_mode => 'Chủ đề tối hoàn toàn';

  @override
  String get pitch_dark_theme => 'Chế độ AMOLED';

  @override
  String get normalize_audio => 'Bình thường hóa âm thanh';

  @override
  String get change_cover => 'Thay đổi ảnh bìa';

  @override
  String get add_cover => 'Thêm ảnh bìa';

  @override
  String get restore_defaults => 'Khôi phục mặc định';

  @override
  String get download_music_format => 'Định dạng nhạc tải về';

  @override
  String get streaming_music_format => 'Định dạng nhạc phát trực tuyến';

  @override
  String get download_music_quality => 'Chất lượng nhạc tải về';

  @override
  String get streaming_music_quality => 'Chất lượng nhạc phát trực tuyến';

  @override
  String get login_with_lastfm => 'Đăng nhập bằng tài khoản Last.fm';

  @override
  String get connect => 'Liên kết';

  @override
  String get disconnect_lastfm => 'Dừng liên kết Last.fm';

  @override
  String get disconnect => 'Ngắt kết nối';

  @override
  String get username => 'Tên người dùng';

  @override
  String get password => 'Mật khẩu';

  @override
  String get login => 'Đăng nhập';

  @override
  String get login_with_your_lastfm =>
      'Đăng nhập bằng tài khoản Last.fm của bạn';

  @override
  String get scrobble_to_lastfm => 'Scrobble đến Last.fm';

  @override
  String get go_to_album => 'Đi đến Album';

  @override
  String get discord_rich_presence => 'Hiển thị trạng thái Discord';

  @override
  String get browse_all => 'Duyệt tất cả';

  @override
  String get genres => 'Thể loại';

  @override
  String get explore_genres => 'Khám phá Thể loại';

  @override
  String get friends => 'Bạn bè';

  @override
  String get no_lyrics_available =>
      'Xin lỗi, không tìm thấy lời cho bài hát này';

  @override
  String get start_a_radio => 'Bắt đầu Một Đài phát thanh';

  @override
  String get how_to_start_radio =>
      'Bạn muốn bắt đầu đài phát thanh như thế nào?';

  @override
  String get replace_queue_question =>
      'Bạn muốn thay thế hàng đợi hiện tại hay thêm vào?';

  @override
  String get endless_playback => 'Phát không giới hạn';

  @override
  String get delete_playlist => 'Xóa Danh sách phát';

  @override
  String get delete_playlist_confirmation =>
      'Bạn có chắc chắn muốn xóa danh sách phát này không?';

  @override
  String get local_tracks => 'Bài hát Địa phương';

  @override
  String get local_tab => 'Địa phương';

  @override
  String get song_link => 'Liên kết Bài hát';

  @override
  String get skip_this_nonsense => 'Bỏ qua bớt rối này';

  @override
  String get freedom_of_music => '“Sự Tự do của Âm nhạc”';

  @override
  String get freedom_of_music_palm =>
      '“Sự Tự do của Âm nhạc trong lòng bàn tay của bạn”';

  @override
  String get get_started => 'Bắt đầu thôi';

  @override
  String get youtube_source_description =>
      'Được đề xuất và hoạt động tốt nhất.';

  @override
  String get piped_source_description =>
      'Cảm thấy tự do? Giống như YouTube nhưng miễn phí hơn rất nhiều.';

  @override
  String get jiosaavn_source_description => 'Tốt nhất cho khu vực Nam Á.';

  @override
  String get invidious_source_description =>
      'Tương tự như Piped nhưng có tính khả dụng cao hơn.';

  @override
  String highest_quality(Object quality) {
    return 'Chất lượng Tốt nhất: $quality';
  }

  @override
  String get select_audio_source => 'Chọn Nguồn Âm thanh';

  @override
  String get endless_playback_description =>
      'Tự động thêm các bài hát mới\nvào cuối hàng đợi';

  @override
  String get choose_your_region => 'Chọn khu vực của bạn';

  @override
  String get choose_your_region_description =>
      'Điều này sẽ giúp Spotube hiển thị nội dung phù hợp cho vị trí của bạn.';

  @override
  String get choose_your_language => 'Chọn ngôn ngữ của bạn';

  @override
  String get help_project_grow => 'Hãy giúp dự án này phát triển';

  @override
  String get help_project_grow_description =>
      'Spotube là một dự án mã nguồn mở. Bạn có thể giúp dự án này phát triển bằng cách đóng góp vào dự án, báo cáo lỗi hoặc đề xuất tính năng mới.';

  @override
  String get contribute_on_github => 'Đóng góp trên GitHub';

  @override
  String get donate_on_open_collective => 'Quyên góp trên Open Collective';

  @override
  String get browse_anonymously => 'Duyệt Anonymously';

  @override
  String get enable_connect => 'Kích hoạt kết nối';

  @override
  String get enable_connect_description =>
      'Điều khiển Spotube từ các thiết bị khác';

  @override
  String get devices => 'Thiết bị';

  @override
  String get select => 'Chọn';

  @override
  String connect_client_alert(Object client) {
    return 'Bạn đang được điều khiển bởi $client';
  }

  @override
  String get this_device => 'Thiết bị này';

  @override
  String get remote => 'Từ xa';

  @override
  String get stats => 'Thống kê';

  @override
  String and_n_more(Object count) {
    return 'và $count cái khác';
  }

  @override
  String get recently_played => 'Gần đây đã phát';

  @override
  String get browse_more => 'Xem thêm';

  @override
  String get no_title => 'Không có tiêu đề';

  @override
  String get not_playing => 'Không phát';

  @override
  String get epic_failure => 'Thất bại hoàn toàn!';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return 'Đã thêm $tracks_length bài hát vào danh sách phát';
  }

  @override
  String get spotube_has_an_update => 'Spotube có bản cập nhật';

  @override
  String get download_now => 'Tải về ngay';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Spotube Nightly $nightlyBuildNum đã được phát hành';
  }

  @override
  String release_version(Object version) {
    return 'Spotube v$version đã được phát hành';
  }

  @override
  String get read_the_latest => 'Đọc tin mới nhất';

  @override
  String get release_notes => 'ghi chú phát hành';

  @override
  String get pick_color_scheme => 'Chọn chủ đề màu sắc';

  @override
  String get save => 'Lưu';

  @override
  String get choose_the_device => 'Chọn thiết bị:';

  @override
  String get multiple_device_connected =>
      'Có nhiều thiết bị kết nối.\nChọn thiết bị mà bạn muốn thực hiện hành động này';

  @override
  String get nothing_found => 'Không tìm thấy gì';

  @override
  String get the_box_is_empty => 'Hộp trống';

  @override
  String get top_artists => 'Những Nghệ Sĩ Hàng Đầu';

  @override
  String get top_albums => 'Những Album Hàng Đầu';

  @override
  String get this_week => 'Tuần này';

  @override
  String get this_month => 'Tháng này';

  @override
  String get last_6_months => '6 tháng qua';

  @override
  String get this_year => 'Năm nay';

  @override
  String get last_2_years => '2 năm qua';

  @override
  String get all_time => 'Mọi thời đại';

  @override
  String powered_by_provider(Object providerName) {
    return 'Cung cấp bởi $providerName';
  }

  @override
  String get email => 'Email';

  @override
  String get profile_followers => 'Người theo dõi';

  @override
  String get birthday => 'Ngày sinh';

  @override
  String get subscription => 'Gói cước';

  @override
  String get not_born => 'Chưa sinh';

  @override
  String get hacker => 'Tin tặc';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get no_name => 'Không có tên';

  @override
  String get edit => 'Chỉnh sửa';

  @override
  String get user_profile => 'Hồ sơ người dùng';

  @override
  String count_plays(Object count) {
    return '$count lần phát';
  }

  @override
  String get streaming_fees_hypothetical =>
      '*Tính toán dựa trên thanh toán của Spotify cho mỗi lần phát\ntừ \$0.003 đến \$0.005. Đây là một tính toán giả định để\ngive người dùng cái nhìn về số tiền họ sẽ chi trả cho các nghệ sĩ nếu họ nghe\nbài hát của họ trên Spotify.';

  @override
  String get minutes_listened => 'Thời gian nghe';

  @override
  String get streamed_songs => 'Bài hát đã phát';

  @override
  String count_streams(Object count) {
    return '$count lượt phát';
  }

  @override
  String get owned_by_you => 'Thuộc sở hữu của bạn';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return '$shareUrl đã sao chép vào bảng tạm';
  }

  @override
  String get hipotetical_calculation =>
      '*Điều này được tính toán dựa trên khoản thanh toán trung bình mỗi luồng của nền tảng phát nhạc trực tuyến là \$0,003 đến \$0,005. Đây là một phép tính giả định để cung cấp cho người dùng cái nhìn sâu sắc về số tiền họ đã trả cho các nghệ sĩ nếu họ nghe bài hát của họ trên các nền tảng phát nhạc trực tuyến khác nhau.';

  @override
  String count_mins(Object minutes) {
    return '$minutes phút';
  }

  @override
  String get summary_minutes => 'phút';

  @override
  String get summary_listened_to_music => 'Đã nghe nhạc';

  @override
  String get summary_songs => 'bài hát';

  @override
  String get summary_streamed_overall => 'Stream tổng cộng';

  @override
  String get summary_owed_to_artists => 'Nợ nghệ sĩ\ntrong tháng này';

  @override
  String get summary_artists => 'nghệ sĩ';

  @override
  String get summary_music_reached_you => 'Âm nhạc đã đến với bạn';

  @override
  String get summary_full_albums => 'album đầy đủ';

  @override
  String get summary_got_your_love => 'Nhận được tình yêu của bạn';

  @override
  String get summary_playlists => 'danh sách phát';

  @override
  String get summary_were_on_repeat => 'Đã được phát lại';

  @override
  String total_money(Object money) {
    return 'Tổng cộng $money';
  }

  @override
  String get webview_not_found => 'Không tìm thấy Webview';

  @override
  String get webview_not_found_description =>
      'Không có runtime Webview nào được cài đặt trên thiết bị của bạn.\nNếu đã cài đặt, hãy đảm bảo rằng nó nằm trong environment PATH\n\nSau khi cài đặt, hãy khởi động lại ứng dụng';

  @override
  String get unsupported_platform => 'Nền tảng không được hỗ trợ';

  @override
  String get cache_music => 'Lưu nhạc vào bộ nhớ đệm';

  @override
  String get open => 'Mở';

  @override
  String get cache_folder => 'Thư mục bộ nhớ đệm';

  @override
  String get export => 'Xuất';

  @override
  String get clear_cache => 'Xóa bộ nhớ đệm';

  @override
  String get clear_cache_confirmation => 'Bạn có muốn xóa bộ nhớ đệm không?';

  @override
  String get export_cache_files => 'Xuất các tệp được lưu trong bộ nhớ đệm';

  @override
  String found_n_files(Object count) {
    return 'Tìm thấy $count tệp';
  }

  @override
  String get export_cache_confirmation => 'Bạn có muốn xuất các tệp này đến';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return 'Đã xuất $filesExported trên $files tệp';
  }

  @override
  String get undo => 'Hoàn tác';

  @override
  String get download_all => 'Tải xuống tất cả';

  @override
  String get add_all_to_playlist => 'Thêm tất cả vào danh sách phát';

  @override
  String get add_all_to_queue => 'Thêm tất cả vào danh sách chờ';

  @override
  String get play_all_next => 'Chơi tất cả tiếp theo';

  @override
  String get pause => 'Tạm dừng';

  @override
  String get view_all => 'Xem tất cả';

  @override
  String get no_tracks_added_yet => 'Có vẻ bạn chưa thêm bất kỳ bài hát nào';

  @override
  String get no_tracks => 'Có vẻ không có bài hát nào ở đây';

  @override
  String get no_tracks_listened_yet => 'Có vẻ bạn chưa nghe gì cả';

  @override
  String get not_following_artists =>
      'Bạn không đang theo dõi bất kỳ nghệ sĩ nào';

  @override
  String get no_favorite_albums_yet =>
      'Có vẻ bạn chưa thêm album nào vào danh sách yêu thích';

  @override
  String get no_logs_found => 'Không tìm thấy nhật ký';

  @override
  String get youtube_engine => 'Công cụ YouTube';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engine chưa được cài đặt';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engine chưa được cài đặt trong hệ thống của bạn.';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return 'Đảm bảo nó có sẵn trong biến PATH hoặc\nđặt đường dẫn tuyệt đối đến tệp thực thi $engine dưới đây';
  }

  @override
  String get youtube_engine_unix_issue_message =>
      'Trên macOS/Linux/Unix, việc thiết lập đường dẫn trong .zshrc/.bashrc/.bash_profile v.v. sẽ không hoạt động.\nBạn cần thiết lập đường dẫn trong tệp cấu hình shell';

  @override
  String get download => 'Tải xuống';

  @override
  String get file_not_found => 'Không tìm thấy tệp';

  @override
  String get custom => 'Tùy chỉnh';

  @override
  String get add_custom_url => 'Thêm URL tùy chỉnh';

  @override
  String get edit_port => 'Chỉnh sửa cổng';

  @override
  String get port_helper_msg =>
      'Mặc định là -1, có nghĩa là số ngẫu nhiên. Nếu bạn đã cấu hình tường lửa, nên đặt điều này.';

  @override
  String connect_request(Object client) {
    return 'Cho phép $client kết nối?';
  }

  @override
  String get connection_request_denied =>
      'Kết nối bị từ chối. Người dùng đã từ chối quyền truy cập.';

  @override
  String get an_error_occurred => 'Đã xảy ra lỗi';

  @override
  String get copy_to_clipboard => 'Sao chép vào khay nhớ tạm';

  @override
  String get view_logs => 'Xem nhật ký';

  @override
  String get retry => 'Thử lại';

  @override
  String get no_default_metadata_provider_selected =>
      'Bạn chưa đặt nhà cung cấp siêu dữ liệu mặc định nào';

  @override
  String get manage_metadata_providers => 'Quản lý nhà cung cấp siêu dữ liệu';

  @override
  String get open_link_in_browser => 'Mở liên kết trong Trình duyệt?';

  @override
  String get do_you_want_to_open_the_following_link =>
      'Bạn có muốn mở liên kết sau không';

  @override
  String get unsafe_url_warning =>
      'Việc mở các liên kết từ các nguồn không đáng tin cậy có thể không an toàn. Hãy thận trọng!\nBạn cũng có thể sao chép liên kết vào khay nhớ tạm của mình.';

  @override
  String get copy_link => 'Sao chép liên kết';

  @override
  String get building_your_timeline =>
      'Đang xây dựng dòng thời gian của bạn dựa trên những gì bạn đã nghe...';

  @override
  String get official => 'Chính thức';

  @override
  String author_name(Object author) {
    return 'Tác giả: $author';
  }

  @override
  String get third_party => 'Bên thứ ba';

  @override
  String get plugin_requires_authentication => 'Plugin yêu cầu xác thực';

  @override
  String get update_available => 'Có bản cập nhật';

  @override
  String get supports_scrobbling => 'Hỗ trợ scrobbling';

  @override
  String get plugin_scrobbling_info =>
      'Plugin này scrobble nhạc của bạn để tạo lịch sử nghe của bạn.';

  @override
  String get default_metadata_source => 'Nguồn siêu dữ liệu mặc định';

  @override
  String get set_default_metadata_source => 'Đặt nguồn siêu dữ liệu mặc định';

  @override
  String get default_audio_source => 'Nguồn âm thanh mặc định';

  @override
  String get set_default_audio_source => 'Đặt nguồn âm thanh mặc định';

  @override
  String get set_default => 'Đặt làm mặc định';

  @override
  String get support => 'Hỗ trợ';

  @override
  String get support_plugin_development => 'Hỗ trợ phát triển plugin';

  @override
  String can_access_name_api(Object name) {
    return '- Có thể truy cập API **$name**';
  }

  @override
  String get do_you_want_to_install_this_plugin =>
      'Bạn có muốn cài đặt plugin này không?';

  @override
  String get third_party_plugin_warning =>
      'Plugin này đến từ một kho lưu trữ của bên thứ ba. Vui lòng đảm bảo rằng bạn tin tưởng nguồn trước khi cài đặt.';

  @override
  String get author => 'Tác giả';

  @override
  String get this_plugin_can_do_following =>
      'Plugin này có thể làm những việc sau';

  @override
  String get install => 'Cài đặt';

  @override
  String get install_a_metadata_provider =>
      'Cài đặt một Nhà cung cấp siêu dữ liệu';

  @override
  String get no_tracks_playing => 'Hiện không có bản nhạc nào đang phát';

  @override
  String get synced_lyrics_not_available =>
      'Lời bài hát được đồng bộ hóa không có sẵn cho bài hát này. Vui lòng sử dụng';

  @override
  String get plain_lyrics => 'Lời bài hát thuần túy';

  @override
  String get tab_instead => 'thay thế.';

  @override
  String get disclaimer => 'Miễn trừ trách nhiệm';

  @override
  String get third_party_plugin_dmca_notice =>
      'Nhóm Spotube không chịu bất kỳ trách nhiệm nào (bao gồm cả pháp lý) đối với bất kỳ plugin \"Bên thứ ba\" nào.\nVui lòng sử dụng chúng với rủi ro của riêng bạn. Đối với bất kỳ lỗi/vấn đề nào, vui lòng báo cáo chúng cho kho lưu trữ plugin.\n\nNếu bất kỳ plugin \"Bên thứ ba\" nào vi phạm ToS/DMCA của bất kỳ dịch vụ/thực thể pháp lý nào, vui lòng yêu cầu tác giả plugin \"Bên thứ ba\" hoặc nền tảng lưu trữ, ví dụ: GitHub/Codeberg, thực hiện hành động. Tất cả các plugin được liệt kê ở trên (được gắn nhãn \"Bên thứ ba\") đều là các plugin công cộng/do cộng đồng duy trì. Chúng tôi không quản lý chúng, vì vậy chúng tôi không thể thực hiện bất kỳ hành động nào đối với chúng.\n\n';

  @override
  String get input_does_not_match_format =>
      'Đầu vào không khớp với định dạng yêu cầu';

  @override
  String get plugins => 'Tiện ích bổ sung';

  @override
  String get paste_plugin_download_url =>
      'Dán url tải xuống hoặc url kho lưu trữ GitHub/Codeberg hoặc liên kết trực tiếp đến tệp .smplug';

  @override
  String get download_and_install_plugin_from_url =>
      'Tải xuống và cài đặt plugin từ url';

  @override
  String failed_to_add_plugin_error(Object error) {
    return 'Không thể thêm plugin: $error';
  }

  @override
  String get upload_plugin_from_file => 'Tải lên plugin từ tệp';

  @override
  String get installed => 'Đã cài đặt';

  @override
  String get available_plugins => 'Các plugin có sẵn';

  @override
  String get configure_plugins =>
      'Cấu hình nhà cung cấp siêu dữ liệu và tiện ích nguồn âm thanh riêng';

  @override
  String get audio_scrobblers => 'Bộ scrobbler âm thanh';

  @override
  String get scrobbling => 'Scrobbling';

  @override
  String get source => 'Nguồn: ';

  @override
  String get uncompressed => 'Không nén';

  @override
  String get dab_music_source_description =>
      'Dành cho người yêu âm nhạc chất lượng cao. Cung cấp luồng âm thanh chất lượng cao/không nén. Phù hợp bài hát dựa trên ISRC chính xác.';
}
