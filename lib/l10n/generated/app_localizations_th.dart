// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get guest => 'ผู้มาเยือน';

  @override
  String get browse => 'เรียกดู';

  @override
  String get search => 'ค้นหา';

  @override
  String get library => 'คลัง';

  @override
  String get lyrics => 'เนื้อเพลง';

  @override
  String get settings => 'ตั้งค่า';

  @override
  String get genre_categories_filter => 'กรองประเภทหรือแนวเพลง...';

  @override
  String get genre => 'ประเภท';

  @override
  String get personalized => 'ปรับแต่ง';

  @override
  String get featured => 'เด่น';

  @override
  String get new_releases => 'เพิ่งปล่อยใหม่';

  @override
  String get songs => 'เพลง';

  @override
  String playing_track(Object track) {
    return 'กำลังเล่น $track';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return 'การดำเนินการนี้จะล้างคิวปัจจุบัน $track_length แทร็ก จะถูกลบออก\nคุณต้องการดำเนินการต่อหรือไม่?';
  }

  @override
  String get load_more => 'โหลดเพิ่มเติม';

  @override
  String get playlists => 'เพลย์ลิสต์';

  @override
  String get artists => 'ศิลปิน';

  @override
  String get albums => 'อัลบั้ม';

  @override
  String get tracks => 'แทร็ก';

  @override
  String get downloads => 'ดาวน์โหลด';

  @override
  String get filter_playlists => 'กรองเพลย์ลิสต์...';

  @override
  String get liked_tracks => 'เพลงที่ชอบ';

  @override
  String get liked_tracks_description => 'เพลงที่คุณชื่นชอบทั้งหมด';

  @override
  String get playlist => 'เพลย์ลิสต์';

  @override
  String get create_a_playlist => 'สร้างเพลย์ลิสต์';

  @override
  String get update_playlist => 'อัพเดทเพลย์ลิสต์';

  @override
  String get create => 'สร้าง';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get update => 'อัพเดท';

  @override
  String get playlist_name => 'ชื่อเพลย์ลิสต์';

  @override
  String get name_of_playlist => 'ชื่อของเพลย์ลิสต์';

  @override
  String get description => 'คำอธิบาย';

  @override
  String get public => 'สาธารณะ';

  @override
  String get collaborative => 'ร่วมมือกัน';

  @override
  String get search_local_tracks => 'ค้นหาเพลงในเครื่อง...';

  @override
  String get play => 'เล่น';

  @override
  String get delete => 'ลบ';

  @override
  String get none => 'ไม่มี';

  @override
  String get sort_a_z => 'เรียงตาม A-Z';

  @override
  String get sort_z_a => 'เรียงตาม Z-A';

  @override
  String get sort_artist => 'เรียงตามศิลปิน';

  @override
  String get sort_album => 'เรียงตามอัลบั้ม';

  @override
  String get sort_duration => 'เรียงตามความยาว';

  @override
  String get sort_tracks => 'เรียงตามเพลง';

  @override
  String currently_downloading(Object tracks_length) {
    return 'กำลังดาวน์โหลด ($tracks_length)';
  }

  @override
  String get cancel_all => 'ยกเลิกทั้งหมด';

  @override
  String get filter_artist => 'กรองศิลปิน...';

  @override
  String followers(Object followers) {
    return '$followers ผู้ติดตาม';
  }

  @override
  String get add_artist_to_blacklist => 'เพิ่มศิลปินในบัญชีดำ';

  @override
  String get top_tracks => 'เพลงฮิต';

  @override
  String get fans_also_like => 'แฟนๆ ยังชอบ';

  @override
  String get loading => 'กำลังโหลด...';

  @override
  String get artist => 'ศิลปิน';

  @override
  String get blacklisted => 'อยู่ในบัญชีดำ';

  @override
  String get following => 'กำลังติดตาม';

  @override
  String get follow => 'ติดตาม';

  @override
  String get artist_url_copied => 'คัดลอก URL ศิลปินไปยังคลิปบอร์ด';

  @override
  String added_to_queue(Object tracks) {
    return 'เพิ่ม $tracks เพลงลงในคิว';
  }

  @override
  String get filter_albums => 'กรองอัลบั้ม...';

  @override
  String get synced => 'ซิงค์';

  @override
  String get plain => 'เรียบง่าย';

  @override
  String get shuffle => 'สุ่ม';

  @override
  String get search_tracks => 'ค้นหาเพลง...';

  @override
  String get released => 'เผยแพร่';

  @override
  String error(Object error) {
    return 'ข้อผิดพลาด $error';
  }

  @override
  String get title => 'ชื่อ';

  @override
  String get time => 'เวลา';

  @override
  String get more_actions => 'เพิ่มเติม';

  @override
  String download_count(Object count) {
    return 'ดาวน์โหลด ($count)';
  }

  @override
  String add_count_to_playlist(Object count) {
    return 'เพิ่ม ($count) ลงในเพลย์ลิสต์';
  }

  @override
  String add_count_to_queue(Object count) {
    return 'เพิ่ม ($count) ลงในคิว';
  }

  @override
  String play_count_next(Object count) {
    return 'เล่น ($count) ต่อไป';
  }

  @override
  String get album => 'อัลบั้ม';

  @override
  String copied_to_clipboard(Object data) {
    return 'คัดลอก $data ไปยังคลิปบอร์ด';
  }

  @override
  String add_to_following_playlists(Object track) {
    return 'เพิ่ม $track ลงในเพลย์ลิสต์';
  }

  @override
  String get add => 'เพิ่ม';

  @override
  String added_track_to_queue(Object track) {
    return 'เพิ่ม $track ลงในคิว';
  }

  @override
  String get add_to_queue => 'เพิ่มลงในคิว';

  @override
  String track_will_play_next(Object track) {
    return '$track จะเล่นต่อไป';
  }

  @override
  String get play_next => 'เล่นต่อไป';

  @override
  String removed_track_from_queue(Object track) {
    return 'ลบ $track ออกจากคิว';
  }

  @override
  String get remove_from_queue => 'ลบออกจากคิว';

  @override
  String get remove_from_favorites => 'ลบออกจากรายการโปรด';

  @override
  String get save_as_favorite => 'บันทึกเป็นรายการโปรด';

  @override
  String get add_to_playlist => 'เพิ่มลงในเพลย์ลิสต์';

  @override
  String get remove_from_playlist => 'ลบออกจากเพลย์ลิสต์';

  @override
  String get add_to_blacklist => 'เพิ่มลงในบัญชีดำ';

  @override
  String get remove_from_blacklist => 'ลบออกจากบัญชีดำ';

  @override
  String get share => 'แชร์';

  @override
  String get mini_player => 'มินิเพลเยอร์';

  @override
  String get slide_to_seek => 'เลื่อนเพื่อไปข้างหน้าหรือถอยหลัง';

  @override
  String get shuffle_playlist => 'สุ่มเพลย์ลิสต์';

  @override
  String get unshuffle_playlist => 'ยกเลิกการสุ่มเพลย์ลิสต์';

  @override
  String get previous_track => 'แทร็กก่อนหน้า';

  @override
  String get next_track => 'แทร็กถัดไป';

  @override
  String get pause_playback => 'หยุดการเล่น';

  @override
  String get resume_playback => 'เล่นต่อ';

  @override
  String get loop_track => 'วนเพลง';

  @override
  String get no_loop => 'ไม่มีการวนซ้ำ';

  @override
  String get repeat_playlist => 'ซ้ำเพลย์ลิสต์';

  @override
  String get queue => 'คิว';

  @override
  String get alternative_track_sources => 'แหล่งแทร็กอื่น';

  @override
  String get download_track => 'ดาวน์โหลดแทร็ก';

  @override
  String tracks_in_queue(Object tracks) {
    return '$tracks แทร็กในคิว';
  }

  @override
  String get clear_all => 'ล้างทั้งหมด';

  @override
  String get show_hide_ui_on_hover => 'แสดง/ซ่อน UI เมื่อโฮเวอร์';

  @override
  String get always_on_top => 'อยู่ด้านบนเสมอ';

  @override
  String get exit_mini_player => 'ออกจากมินิเพลย์เยอร์';

  @override
  String get download_location => 'ตำแหน่งดาวน์โหลด';

  @override
  String get local_library => 'ห้องสมุดท้องถิ่น';

  @override
  String get add_library_location => 'เพิ่มในห้องสมุด';

  @override
  String get remove_library_location => 'ลบออกจากห้องสมุด';

  @override
  String get account => 'บัญชี';

  @override
  String get logout => 'ออกจากระบบ';

  @override
  String get logout_of_this_account => 'ออกจากระบบบัญชีนี้';

  @override
  String get language_region => 'ภาษาและภูมิภาค';

  @override
  String get language => 'ภาษา';

  @override
  String get system_default => 'ค่าเริ่มต้นของระบบ';

  @override
  String get market_place_region => 'ภูมิภาค Marketplace';

  @override
  String get recommendation_country => 'ประเทศที่แนะนำ';

  @override
  String get appearance => 'ลักษณะที่ปรากฏ';

  @override
  String get layout_mode => 'โหมดเค้าโครง';

  @override
  String get override_layout_settings =>
      'แทนที่การตั้งค่าโหมดเค้าโครงแบบตอบสนอง';

  @override
  String get adaptive => 'ปรับเปลี่ยน';

  @override
  String get compact => 'กระชับ';

  @override
  String get extended => 'ขยาย';

  @override
  String get theme => 'ธีม';

  @override
  String get dark => 'มืด';

  @override
  String get light => 'สว่าง';

  @override
  String get system => 'ระบบ';

  @override
  String get accent_color => 'สีเน้น';

  @override
  String get sync_album_color => 'ซิงค์สีอัลบั้ม';

  @override
  String get sync_album_color_description =>
      'ใช้สีเด่นของอาร์ตอัลบั้มเป็นสีเน้น';

  @override
  String get playback => 'การเล่น';

  @override
  String get audio_quality => 'คุณภาพเสียง';

  @override
  String get high => 'สูง';

  @override
  String get low => 'ต่ำ';

  @override
  String get pre_download_play => 'ดาวน์โหลดล่วงหน้าและเล่น';

  @override
  String get pre_download_play_description =>
      'แทนที่จะสตรีมเสียง ดาวน์โหลดข้อมูลและเล่นแทน (แนะนำสำหรับผู้ใช้แบนด์วิดธ์สูง)';

  @override
  String get skip_non_music => 'ข้ามส่วนที่ไม่ใช่เพลง (SponsorBlock)';

  @override
  String get blacklist_description => 'แทร็กและศิลปินที่บล็อก';

  @override
  String get wait_for_download_to_finish =>
      'โปรดรอให้การดาวน์โหลดปัจจุบันเสร็จสิ้น';

  @override
  String get desktop => 'เดสก์ท็อป';

  @override
  String get close_behavior => 'ปิดพฤติกรรม';

  @override
  String get close => 'ปิด';

  @override
  String get minimize_to_tray => 'ลดขนาดลงถาด';

  @override
  String get show_tray_icon => 'แสดงไอคอนถาดระบบ';

  @override
  String get about => 'เกี่ยวกับ';

  @override
  String get u_love_spotube => 'เรารู้ว่าคุณรัก Spotube';

  @override
  String get check_for_updates => 'ตรวจสอบการปรับปรุง';

  @override
  String get about_spotube => 'เกี่ยวกับ Spotube';

  @override
  String get blacklist => 'แบล็กลิสต์';

  @override
  String get please_sponsor => 'กรุณาสนับสนุน/บริจาค';

  @override
  String get spotube_description =>
      'Spotube โปรแกรมเล่น Spotify ฟรีสำหรับทุกคน น้ำหนักเบา รองรับหลายแพลตฟอร์ม';

  @override
  String get version => 'รุ่น';

  @override
  String get build_number => 'หมายเลขบิลด์';

  @override
  String get founder => 'ผู้ก่อตั้ง';

  @override
  String get repository => 'ที่เก็บ';

  @override
  String get bug_issues => 'ข้อผิดพลาด+ปัญหา';

  @override
  String get made_with => 'ทำด้วย❤️ใน บังคลาเทศ🇧🇩';

  @override
  String get kingkor_roy_tirtho => 'Kingkor Roy Tirtho';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year Kingkor Roy Tirtho';
  }

  @override
  String get license => 'ใบอนุญาต';

  @override
  String get credentials_will_not_be_shared_disclaimer =>
      'ไม่ต้องกังวล ข้อมูลรับรองใดๆ ของคุณจะไม่ถูกเก็บรวบรวมหรือแชร์กับใคร';

  @override
  String get know_how_to_login => 'ไม่รู้จักวิธีดำเนินการนี้ใช่ไหม';

  @override
  String get follow_step_by_step_guide => 'ทำตามคู่มือทีละขั้น';

  @override
  String cookie_name_cookie(Object name) {
    return 'คุกกี้ $name';
  }

  @override
  String get fill_in_all_fields => 'กรุณากรอกข้อมูลทุกช่อง';

  @override
  String get submit => 'ยื่น';

  @override
  String get exit => 'ออก';

  @override
  String get previous => 'ย้อนกลับ';

  @override
  String get next => 'ถัดไป';

  @override
  String get done => 'เสร็จ';

  @override
  String get step_1 => 'ขั้นที่ 1';

  @override
  String get first_go_to => 'ก่อนอื่น ไปที่';

  @override
  String get something_went_wrong => 'มีอะไรผิดพลาด';

  @override
  String get piped_instance => 'อินสแตนซ์เซิร์ฟเวอร์แบบ Pipe';

  @override
  String get piped_description =>
      'อินสแตนซ์เซิร์ฟเวอร์แบบ Pipe ที่ใช้สำหรับการจับคู่แทร็ก';

  @override
  String get piped_warning =>
      'บางอย่างอาจใช้งานไม่ได้ผล คุณจึงต้องรับความเสี่ยงเอง';

  @override
  String get invidious_instance => 'อินสแตนซ์เซิร์ฟเวอร์ Invidious';

  @override
  String get invidious_description =>
      'อินสแตนซ์เซิร์ฟเวอร์ Invidious ที่ใช้สำหรับการจับคู่เพลง';

  @override
  String get invidious_warning =>
      'บางอันอาจใช้งานไม่ดี ใช้ด้วยความเสี่ยงของคุณเอง';

  @override
  String get generate => 'สร้าง';

  @override
  String track_exists(Object track) {
    return 'แทร็ก $track มีอยู่แล้ว';
  }

  @override
  String get replace_downloaded_tracks => 'แทนที่แทร็กที่ดาวน์โหลดทั้งหมด';

  @override
  String get skip_download_tracks => 'ข้ามการดาวน์โหลดแทร็กที่ดาวน์โหลดทั้งหมด';

  @override
  String get do_you_want_to_replace => 'คุณต้องการแทนที่แทร็กที่มีอยู่หรือไม่';

  @override
  String get replace => 'แทนที่';

  @override
  String get skip => 'ข้าม';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return 'เลือกสูงสุด $count $type';
  }

  @override
  String get select_genres => 'เลือกประเภท';

  @override
  String get add_genres => 'เพิ่มประเภท';

  @override
  String get country => 'ประเทศ';

  @override
  String get number_of_tracks_generate => 'จำนวนแทร็กที่จะสร้าง';

  @override
  String get acousticness => 'อะคูสติก';

  @override
  String get danceability => 'ความสามารถในการเต้น';

  @override
  String get energy => 'พลัง';

  @override
  String get instrumentalness => 'บรรเลง';

  @override
  String get liveness => 'ความสด';

  @override
  String get loudness => 'ความดัง';

  @override
  String get speechiness => 'การพูด';

  @override
  String get valence => 'ความสุข';

  @override
  String get popularity => 'ความนิยม';

  @override
  String get key => 'คีย์';

  @override
  String get duration => 'ระยะเวลา (วินาที)';

  @override
  String get tempo => 'ความเร็ว (BPM)';

  @override
  String get mode => 'โหมด';

  @override
  String get time_signature => 'ลายเซ็นเวลา';

  @override
  String get short => 'สั้น';

  @override
  String get medium => 'กลาง';

  @override
  String get long => 'ยาว';

  @override
  String get min => 'ต่ำสุด';

  @override
  String get max => 'สูงสุด';

  @override
  String get target => 'เป้าหมาย';

  @override
  String get moderate => 'ปานกลาง';

  @override
  String get deselect_all => 'ยกเลิกการเลือกทั้งหมด';

  @override
  String get select_all => 'เลือกทั้งหมด';

  @override
  String get are_you_sure => 'คุณแน่ใจไหม?';

  @override
  String get generating_playlist => 'กำลังสร้างเพลย์ลิสต์ที่คุณกำหนดเอง...';

  @override
  String selected_count_tracks(Object count) {
    return 'เลือก $count แทร็ก';
  }

  @override
  String get download_warning =>
      'ถ้าคุณดาวน์โหลดเพลงทั้งหมดเป็นจำนวนมาก คุณกำลังละเมิดลิขสิทธิ์เพลงและสร้างความเสียหายให้กับสังคมดนตรี สร้างสรรค์ หวังว่าคุณจะรับรู้เรื่องนี้ เสมอ พยายามเคารพและสนับสนุนผลงานหนักของศิลปิน';

  @override
  String get download_ip_ban_warning =>
      'นอกเหนือจากนั้น IP ของคุณอาจถูกบล็อกบน YouTube เนื่องจากคำขอดาวน์โหลดมากเกินกว่าปกติ การบล็อก IP หมายความว่าคุณไม่สามารถใช้ YouTube (แม้ว่าคุณจะล็อกอินอยู่) เป็นเวลาอย่างน้อย 2-3 เดือนจากอุปกรณ์ IP นั้น และ Spotube จะไม่รับผิดชอบใด ๆ หากสิ่งนี้เกิดขึ้น';

  @override
  String get by_clicking_accept_terms =>
      'คลิก \'ยอมรับ\' คุณยินยอมตามเงื่อนไขต่อไปนี้:';

  @override
  String get download_agreement_1 =>
      'ฉันรู้ว่าฉันกำลังละเมิดลิขสิทธิ์เพลง ฉันเลว';

  @override
  String get download_agreement_2 =>
      'ฉันจะสนับสนุนศิลปินทุกที่ที่ฉันทำได้และฉันทำสิ่งนี้เพียงเพราะฉันไม่มีเงินซื้อผลงานศิลปะของพวกเขา';

  @override
  String get download_agreement_3 =>
      'ฉันรับทราบอย่างสมบูรณ์ว่า IP ของฉันอาจถูกบล็อกบน YouTube และฉันจะไม่ถือ Spotube หรือเจ้าของ/ผู้มีส่วนร่วมใด ๆ รับผิดชอบต่ออุบัติเหตุใด ๆ ที่เกิดจากการกระทำปัจจุบันของฉัน';

  @override
  String get decline => 'ปฏิเสธ';

  @override
  String get accept => 'ยอมรับ';

  @override
  String get details => 'รายละเอียด';

  @override
  String get youtube => 'youtube';

  @override
  String get channel => 'ช่อง';

  @override
  String get likes => 'ถูกใจ';

  @override
  String get dislikes => 'ไม่ชอบ';

  @override
  String get views => 'วิว';

  @override
  String get streamUrl => 'สตรีม URL';

  @override
  String get stop => 'หยุด';

  @override
  String get sort_newest => 'เรียงตามการเพิ่มใหม่ล่าสุด';

  @override
  String get sort_oldest => 'เรียงตามการเพิ่มเก่าสุด';

  @override
  String get sleep_timer => 'ตั้งเวลาปิด';

  @override
  String mins(Object minutes) {
    return '$minutes นาที';
  }

  @override
  String hours(Object hours) {
    return '$hours ชั่วโมง';
  }

  @override
  String hour(Object hours) {
    return '$hours ชั่วโมง';
  }

  @override
  String get custom_hours => 'ชั่วโมงที่กำหนดเอง';

  @override
  String get logs => 'บันทึก';

  @override
  String get developers => 'นักพัฒนา';

  @override
  String get not_logged_in => 'คุณไม่ได้เข้าสู่ระบบ';

  @override
  String get search_mode => 'โหมดการค้นหา';

  @override
  String get audio_source => 'แหล่งที่มาของเสียง';

  @override
  String get ok => 'ตกลง';

  @override
  String get failed_to_encrypt => 'เข้ารหัสล้มเหลว';

  @override
  String get encryption_failed_warning =>
      'Spotube ใช้การเข้ารหัสเพื่อเก็บข้อมูลของคุณอย่างปลอดภัย แต่ไม่สามารถทำได้ ดังนั้นจะเปลี่ยนเป็นการจัดเก็บที่ไม่ปลอดภัย\nหากคุณใช้ Linux โปรดตรวจสอบว่าคุณได้ติดตั้งบริการลับ (gnome-keyring, kde-wallet, keepassxc เป็นต้น)';

  @override
  String get querying_info => 'กำลังดึงข้อมูล...';

  @override
  String get piped_api_down => 'Piped API ไม่ทำงาน';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return 'Piped instance $pipedInstance ไม่ทำงานขณะนี้\n\nเปลี่ยนอินสแตนซ์หรือเปลี่ยน \'ประเภท API\' เป็น YouTube API อย่างเป็นทางการ\n\nอย่าลืมรีสตาร์ทแอปหลังจากเปลี่ยน';
  }

  @override
  String get you_are_offline => 'คุณออฟไลน์อยู่';

  @override
  String get connection_restored =>
      'การเชื่อมต่ออินเทอร์เน็ตของคุณได้รับการกู้คืน';

  @override
  String get use_system_title_bar => 'ใช้แถบชื่อระบบ';

  @override
  String get crunching_results => 'กำลังประมวลผล...';

  @override
  String get search_to_get_results => 'ค้นหาเพื่อดูผลลัพธ์';

  @override
  String get use_amoled_mode => 'ธีมมืดสนิท';

  @override
  String get pitch_dark_theme => 'โหมด AMOLED';

  @override
  String get normalize_audio => 'ปรับระดับเสียง';

  @override
  String get change_cover => 'เปลี่ยนปก';

  @override
  String get add_cover => 'เพิ่มปก';

  @override
  String get restore_defaults => 'คืนค่าเริ่มต้น';

  @override
  String get download_music_format => 'รูปแบบการดาวน์โหลดเพลง';

  @override
  String get streaming_music_format => 'รูปแบบการสตรีมเพลง';

  @override
  String get download_music_quality => 'คุณภาพการดาวน์โหลด';

  @override
  String get streaming_music_quality => 'คุณภาพการสตรีม';

  @override
  String get login_with_lastfm => 'เข้าสู่ระบบด้วย Last.fm';

  @override
  String get connect => 'เชื่อมต่อ';

  @override
  String get disconnect_lastfm => 'ตัดการเชื่อมต่อ Last.fm';

  @override
  String get disconnect => 'ตัดการเชื่อมต่อ';

  @override
  String get username => 'ชื่อผู้ใช้';

  @override
  String get password => 'รหัสผ่าน';

  @override
  String get login => 'เข้าสู่ระบบ';

  @override
  String get login_with_your_lastfm => 'เข้าสู่ระบบด้วย Last.fm';

  @override
  String get scrobble_to_lastfm => 'Scrobble ไปเป็น Last.fm';

  @override
  String get go_to_album => 'ไปที่อัลบั้ม';

  @override
  String get discord_rich_presence => 'Discord Rich Presence';

  @override
  String get browse_all => 'เรียกดูทั้งหมด';

  @override
  String get genres => 'ประเภท';

  @override
  String get explore_genres => 'สำรวจประเภท';

  @override
  String get friends => 'เพื่อน';

  @override
  String get no_lyrics_available => 'ขออภัย ไม่พบเนื้อเพลงสำหรับเพลงนี้';

  @override
  String get start_a_radio => 'เปิดวิทยุ';

  @override
  String get how_to_start_radio => 'หากต้องการเปิดวิทยุฟังยังไง?';

  @override
  String get replace_queue_question =>
      'คุณต้องการแทนที่คิวปัจจุบันหรือเพิ่มเข้าไปหรือไม่';

  @override
  String get endless_playback => 'เล่นซ้ำ';

  @override
  String get delete_playlist => 'ลบเพลย์ลิสต์';

  @override
  String get delete_playlist_confirmation =>
      'คุณแน่ใจที่จะลบเพลย์ลิสต์นี้หรือไม่';

  @override
  String get local_tracks => 'เพลงในเครื่อง';

  @override
  String get local_tab => 'ท้องถิ่น';

  @override
  String get song_link => 'ลิงค์เพลง';

  @override
  String get skip_this_nonsense => 'ข้ามสิ่งไร้สาระนี้';

  @override
  String get freedom_of_music => '“เสรีภาพแห่งเสียงเพลง”';

  @override
  String get freedom_of_music_palm => '“เสรีภาพแห่งเสียงเพลง ในมือของคุณ”';

  @override
  String get get_started => 'เริ่มต้น';

  @override
  String get youtube_source_description => 'แนะนำและใช้งานได้ดีที่สุด';

  @override
  String get piped_source_description =>
      'รู้สึกอิสระ? เหมือน YouTube แต่ฟรีกว่าเยอะ';

  @override
  String get jiosaavn_source_description => 'ดีที่สุดสำหรับภูมิภาคเอเชียใต้';

  @override
  String get invidious_source_description =>
      'คล้ายกับ Piped แต่มีความพร้อมใช้งานสูงกว่า';

  @override
  String highest_quality(Object quality) {
    return 'คุณภาพสูงสุด: $quality';
  }

  @override
  String get select_audio_source => 'เลือกแหล่งเสียง';

  @override
  String get endless_playback_description => 'เพิ่มเพลงใหม่ลงในคิวโดยอัตโนมัติ';

  @override
  String get choose_your_region => 'เลือกภูมิภาคของคุณ';

  @override
  String get choose_your_region_description =>
      'สิ่งนี้จะช่วยให้ Spotube แสดงเนื้อหาที่เหมาะสมสำหรับคุณ';

  @override
  String get choose_your_language => 'เลือกภาษาของคุณ';

  @override
  String get help_project_grow => 'ช่วยให้โครงการนี้เติบโต';

  @override
  String get help_project_grow_description =>
      'Spotube เป็นโครงการโอเพนซอร์ส คุณสามารถช่วยให้โครงการนี้เติบโตได้โดยการมีส่วนร่วมในโครงการ รายงานข้อบกพร่อง หรือเสนอคุณสมบัติใหม่';

  @override
  String get contribute_on_github => 'มีส่วนร่วมบน GitHub';

  @override
  String get donate_on_open_collective => 'บริจาคบน Open Collective';

  @override
  String get browse_anonymously => 'เรียกดูแบบไม่ระบุตัวตน';

  @override
  String get enable_connect => 'เปิดใช้งานการเชื่อมต่อ';

  @override
  String get enable_connect_description => 'ควบคุม Spotube จากอุปกรณ์อื่น';

  @override
  String get devices => 'อุปกรณ์';

  @override
  String get select => 'เลือก';

  @override
  String connect_client_alert(Object client) {
    return 'คุณกำลังถูกควบคุมโดย $client';
  }

  @override
  String get this_device => 'อุปกรณ์นี้';

  @override
  String get remote => 'ระยะไกล';

  @override
  String get stats => 'สถิติ';

  @override
  String and_n_more(Object count) {
    return 'และ $count อีก';
  }

  @override
  String get recently_played => 'เพลงที่เพิ่งเล่น';

  @override
  String get browse_more => 'ดูเพิ่มเติม';

  @override
  String get no_title => 'ไม่มีชื่อ';

  @override
  String get not_playing => 'ไม่เล่น';

  @override
  String get epic_failure => 'ล้มเหลวอย่างยิ่ง!';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return 'เพิ่ม $tracks_length เพลงในคิว';
  }

  @override
  String get spotube_has_an_update => 'Spotube มีการอัปเดต';

  @override
  String get download_now => 'ดาวน์โหลดตอนนี้';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Spotube Nightly $nightlyBuildNum ได้รับการปล่อยออกมา';
  }

  @override
  String release_version(Object version) {
    return 'Spotube v$version ได้รับการปล่อยออกมา';
  }

  @override
  String get read_the_latest => 'อ่านข่าวสารล่าสุด ';

  @override
  String get release_notes => 'บันทึกการปล่อย';

  @override
  String get pick_color_scheme => 'เลือกธีมสี';

  @override
  String get save => 'บันทึก';

  @override
  String get choose_the_device => 'เลือกอุปกรณ์:';

  @override
  String get multiple_device_connected =>
      'มีอุปกรณ์เชื่อมต่อหลายเครื่อง\nเลือกอุปกรณ์ที่คุณต้องการให้การดำเนินการนี้เกิดขึ้น';

  @override
  String get nothing_found => 'ไม่พบข้อมูล';

  @override
  String get the_box_is_empty => 'กล่องว่างเปล่า';

  @override
  String get top_artists => 'ศิลปินยอดนิยม';

  @override
  String get top_albums => 'อัลบั้มยอดนิยม';

  @override
  String get this_week => 'สัปดาห์นี้';

  @override
  String get this_month => 'เดือนนี้';

  @override
  String get last_6_months => '6 เดือนที่ผ่านมา';

  @override
  String get this_year => 'ปีนี้';

  @override
  String get last_2_years => '2 ปีที่ผ่านมา';

  @override
  String get all_time => 'ตลอดกาล';

  @override
  String powered_by_provider(Object providerName) {
    return 'ขับเคลื่อนโดย $providerName';
  }

  @override
  String get email => 'อีเมล';

  @override
  String get profile_followers => 'ผู้ติดตาม';

  @override
  String get birthday => 'วันเกิด';

  @override
  String get subscription => 'การสมัครสมาชิก';

  @override
  String get not_born => 'ยังไม่เกิด';

  @override
  String get hacker => 'แฮ็กเกอร์';

  @override
  String get profile => 'โปรไฟล์';

  @override
  String get no_name => 'ไม่มีชื่อ';

  @override
  String get edit => 'แก้ไข';

  @override
  String get user_profile => 'โปรไฟล์ผู้ใช้';

  @override
  String count_plays(Object count) {
    return '$count การเล่น';
  }

  @override
  String get streaming_fees_hypothetical =>
      '*คำนวณจากการจ่ายเงินต่อการสตรีมของ Spotify\nระหว่าง \$0.003 ถึง \$0.005 นี่เป็นการคำนวณสมมุติ\nเพื่อให้ข้อมูลแก่ผู้ใช้เกี่ยวกับจำนวนเงินที่พวกเขา\nอาจจะจ่ายให้กับศิลปินหากพวกเขาฟังเพลงของพวกเขาใน Spotify';

  @override
  String get minutes_listened => 'เวลาที่ฟัง';

  @override
  String get streamed_songs => 'เพลงที่สตรีม';

  @override
  String count_streams(Object count) {
    return '$count สตรีม';
  }

  @override
  String get owned_by_you => 'เป็นเจ้าของโดยคุณ';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return '$shareUrl คัดลอกไปที่คลิปบอร์ดแล้ว';
  }

  @override
  String get hipotetical_calculation =>
      '*การคำนวณนี้อิงจากค่าเฉลี่ยการจ่ายเงินต่อสตรีมของแพลตฟอร์มสตรีมมิ่งเพลงออนไลน์ที่ \$0.003 ถึง \$0.005 นี่เป็นการคำนวณสมมติฐานเพื่อให้ผู้ใช้เข้าใจว่าพวกเขาจะต้องจ่ายเงินให้ศิลปินเท่าไหร่หากพวกเขาฟังเพลงบนแพลตฟอร์มสตรีมมิ่งเพลงที่แตกต่างกัน';

  @override
  String count_mins(Object minutes) {
    return '$minutes นาที';
  }

  @override
  String get summary_minutes => 'นาที';

  @override
  String get summary_listened_to_music => 'ฟังเพลง';

  @override
  String get summary_songs => 'เพลง';

  @override
  String get summary_streamed_overall => 'สตรีมทั้งหมด';

  @override
  String get summary_owed_to_artists => 'ค้างชำระให้ศิลปิน\nในเดือนนี้';

  @override
  String get summary_artists => 'ศิลปิน';

  @override
  String get summary_music_reached_you => 'เพลงมาถึงคุณ';

  @override
  String get summary_full_albums => 'อัลบั้มเต็ม';

  @override
  String get summary_got_your_love => 'ได้รับความรักของคุณ';

  @override
  String get summary_playlists => 'เพลย์ลิสต์';

  @override
  String get summary_were_on_repeat => 'อยู่ในโหมดซ้ำ';

  @override
  String total_money(Object money) {
    return 'รวม $money';
  }

  @override
  String get webview_not_found => 'ไม่พบ Webview';

  @override
  String get webview_not_found_description =>
      'ไม่พบ runtime ของ Webview บนอุปกรณ์ของคุณ\nหากติดตั้งแล้วตรวจสอบให้แน่ใจว่าอยู่ใน environment PATH\n\nหลังจากติดตั้งแล้ว ให้รีสตาร์ทแอป';

  @override
  String get unsupported_platform => 'แพลตฟอร์มไม่รองรับ';

  @override
  String get cache_music => 'แคชเพลง';

  @override
  String get open => 'เปิด';

  @override
  String get cache_folder => 'โฟลเดอร์แคช';

  @override
  String get export => 'ส่งออก';

  @override
  String get clear_cache => 'ล้างแคช';

  @override
  String get clear_cache_confirmation => 'คุณต้องการล้างแคชหรือไม่?';

  @override
  String get export_cache_files => 'ส่งออกไฟล์แคช';

  @override
  String found_n_files(Object count) {
    return 'พบ $count ไฟล์';
  }

  @override
  String get export_cache_confirmation => 'คุณต้องการส่งออกไฟล์เหล่านี้ไปยัง';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return 'ส่งออก $filesExported จาก $files ไฟล์';
  }

  @override
  String get undo => 'ย้อนกลับ';

  @override
  String get download_all => 'ดาวน์โหลดทั้งหมด';

  @override
  String get add_all_to_playlist => 'เพิ่มทั้งหมดในเพลย์ลิสต์';

  @override
  String get add_all_to_queue => 'เพิ่มทั้งหมดในคิว';

  @override
  String get play_all_next => 'เล่นทั้งหมดถัดไป';

  @override
  String get pause => 'หยุดชั่วคราว';

  @override
  String get view_all => 'ดูทั้งหมด';

  @override
  String get no_tracks_added_yet => 'ดูเหมือนคุณยังไม่ได้เพิ่มเพลงใด ๆ';

  @override
  String get no_tracks => 'ดูเหมือนจะไม่มีเพลงที่นี่';

  @override
  String get no_tracks_listened_yet => 'ดูเหมือนคุณยังไม่ได้ฟังอะไรเลย';

  @override
  String get not_following_artists => 'คุณไม่ได้ติดตามศิลปินใด ๆ';

  @override
  String get no_favorite_albums_yet =>
      'ดูเหมือนคุณยังไม่ได้เพิ่มอัลบัมใด ๆ ในรายการโปรด';

  @override
  String get no_logs_found => 'ไม่พบบันทึก';

  @override
  String get youtube_engine => 'เครื่องมือ YouTube';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engine ยังไม่ได้ติดตั้ง';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engine ยังไม่ได้ติดตั้งในระบบของคุณ';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return 'ตรวจสอบให้แน่ใจว่ามันมีอยู่ในตัวแปร PATH หรือ\nตั้งค่าพาธที่แท้จริงของไฟล์ที่สามารถทำงานได้ $engine ด้านล่าง';
  }

  @override
  String get youtube_engine_unix_issue_message =>
      'ใน macOS/Linux/Unix อย่าง OS การตั้งค่าพาธใน .zshrc/.bashrc/.bash_profile เป็นต้น จะไม่ทำงาน\nคุณต้องตั้งค่าพาธในไฟล์การกำหนดค่า shell';

  @override
  String get download => 'ดาวน์โหลด';

  @override
  String get file_not_found => 'ไม่พบไฟล์';

  @override
  String get custom => 'กำหนดเอง';

  @override
  String get add_custom_url => 'เพิ่ม URL แบบกำหนดเอง';

  @override
  String get edit_port => 'แก้ไขพอร์ต';

  @override
  String get port_helper_msg =>
      'ค่าเริ่มต้นคือ -1 ซึ่งหมายถึงหมายเลขสุ่ม หากคุณได้กำหนดค่าไฟร์วอลล์แล้ว แนะนำให้ตั้งค่านี้';

  @override
  String connect_request(Object client) {
    return 'อนุญาตให้ $client เชื่อมต่อหรือไม่?';
  }

  @override
  String get connection_request_denied =>
      'การเชื่อมต่อล้มเหลว ผู้ใช้ปฏิเสธการเข้าถึง';

  @override
  String get an_error_occurred => 'เกิดข้อผิดพลาด';

  @override
  String get copy_to_clipboard => 'คัดลอกไปยังคลิปบอร์ด';

  @override
  String get view_logs => 'ดูบันทึก';

  @override
  String get retry => 'ลองใหม่';

  @override
  String get no_default_metadata_provider_selected =>
      'คุณไม่ได้ตั้งค่าผู้ให้บริการเมตาดาต้าเริ่มต้น';

  @override
  String get manage_metadata_providers => 'จัดการผู้ให้บริการเมตาดาต้า';

  @override
  String get open_link_in_browser => 'เปิดลิงก์ในเบราว์เซอร์หรือไม่?';

  @override
  String get do_you_want_to_open_the_following_link =>
      'คุณต้องการเปิดลิงก์ต่อไปนี้หรือไม่';

  @override
  String get unsafe_url_warning =>
      'การเปิดลิงก์จากแหล่งที่ไม่น่าเชื่อถืออาจไม่ปลอดภัย โปรดระมัดระวัง!\nคุณยังสามารถคัดลอกลิงก์ไปยังคลิปบอร์ดของคุณได้';

  @override
  String get copy_link => 'คัดลอกลิงก์';

  @override
  String get building_your_timeline =>
      'กำลังสร้างไทม์ไลน์ของคุณตามการฟังของคุณ...';

  @override
  String get official => 'อย่างเป็นทางการ';

  @override
  String author_name(Object author) {
    return 'ผู้เขียน: $author';
  }

  @override
  String get third_party => 'บุคคลที่สาม';

  @override
  String get plugin_requires_authentication =>
      'ปลั๊กอินต้องมีการรับรองความถูกต้อง';

  @override
  String get update_available => 'มีการอัปเดต';

  @override
  String get supports_scrobbling => 'รองรับการ scrobbling';

  @override
  String get plugin_scrobbling_info =>
      'ปลั๊กอินนี้จะ scrobble เพลงของคุณเพื่อสร้างประวัติการฟังของคุณ';

  @override
  String get default_metadata_source => 'แหล่งเมตาดาต้าพื้นฐาน';

  @override
  String get set_default_metadata_source => 'ตั้งค่าแหล่งเมตาดาต้าพื้นฐาน';

  @override
  String get default_audio_source => 'แหล่งเสียงพื้นฐาน';

  @override
  String get set_default_audio_source => 'ตั้งค่าแหล่งเสียงพื้นฐาน';

  @override
  String get set_default => 'ตั้งค่าเริ่มต้น';

  @override
  String get support => 'สนับสนุน';

  @override
  String get support_plugin_development => 'สนับสนุนการพัฒนาปลั๊กอิน';

  @override
  String can_access_name_api(Object name) {
    return '- สามารถเข้าถึง API **$name**';
  }

  @override
  String get do_you_want_to_install_this_plugin =>
      'คุณต้องการติดตั้งปลั๊กอินนี้หรือไม่?';

  @override
  String get third_party_plugin_warning =>
      'ปลั๊กอินนี้มาจากที่เก็บของบุคคลที่สาม โปรดตรวจสอบให้แน่ใจว่าคุณเชื่อถือแหล่งที่มาก่อนทำการติดตั้ง';

  @override
  String get author => 'ผู้เขียน';

  @override
  String get this_plugin_can_do_following => 'ปลั๊กอินนี้สามารถทำสิ่งต่อไปนี้';

  @override
  String get install => 'ติดตั้ง';

  @override
  String get install_a_metadata_provider => 'ติดตั้งผู้ให้บริการเมตาดาต้า';

  @override
  String get no_tracks_playing => 'ขณะนี้ไม่มีเพลงที่กำลังเล่นอยู่';

  @override
  String get synced_lyrics_not_available =>
      'ไม่มีเนื้อเพลงที่ซิงค์สำหรับเพลงนี้ กรุณาใช้แท็บ';

  @override
  String get plain_lyrics => 'เนื้อเพลงธรรมดา';

  @override
  String get tab_instead => 'แทน';

  @override
  String get disclaimer => 'ข้อสงวนสิทธิ์';

  @override
  String get third_party_plugin_dmca_notice =>
      'ทีม Spotube ไม่รับผิดชอบใดๆ (รวมถึงทางกฎหมาย) สำหรับปลั๊กอิน \"บุคคลที่สาม\" ใดๆ\nโปรดใช้งานด้วยความเสี่ยงของคุณเอง สำหรับข้อบกพร่อง/ปัญหาใดๆ โปรดรายงานไปยังที่เก็บปลั๊กอิน\n\nหากปลั๊กอิน \"บุคคลที่สาม\" ใดๆ ละเมิด ToS/DMCA ของบริการ/นิติบุคคลใดๆ โปรดขอให้ผู้เขียนปลั๊กอิน \"บุคคลที่สาม\" หรือแพลตฟอร์มโฮสติ้ง เช่น GitHub/Codeberg ดำเนินการ ที่ระบุไว้ข้างต้น (ที่ติดป้าย \"บุคคลที่สาม\") เป็นปลั๊กอินสาธารณะ/ที่ดูแลโดยชุมชนทั้งหมด เราไม่ได้จัดการดูแล ดังนั้นเราจึงไม่สามารถดำเนินการใดๆ กับพวกเขาได้\n\n';

  @override
  String get input_does_not_match_format => 'อินพุตไม่ตรงกับรูปแบบที่ต้องการ';

  @override
  String get plugins => 'ปลั๊กอิน';

  @override
  String get paste_plugin_download_url =>
      'วาง url ดาวน์โหลดหรือ url ที่เก็บ GitHub/Codeberg หรือลิงก์โดยตรงไปยังไฟล์ .smplug';

  @override
  String get download_and_install_plugin_from_url =>
      'ดาวน์โหลดและติดตั้งปลั๊กอินจาก url';

  @override
  String failed_to_add_plugin_error(Object error) {
    return 'ไม่สามารถเพิ่มปลั๊กอินได้: $error';
  }

  @override
  String get upload_plugin_from_file => 'อัปโหลดปลั๊กอินจากไฟล์';

  @override
  String get installed => 'ติดตั้งแล้ว';

  @override
  String get available_plugins => 'ปลั๊กอินที่มีอยู่';

  @override
  String get configure_plugins =>
      'กำหนดค่าปลั๊กอินผู้ให้บริการเมตาดาต้าและแหล่งเสียงของคุณเอง';

  @override
  String get audio_scrobblers => 'เครื่อง scrobbler เสียง';

  @override
  String get scrobbling => 'Scrobbling';

  @override
  String get source => 'แหล่งที่มา: ';

  @override
  String get uncompressed => 'ไม่บีบอัด';

  @override
  String get dab_music_source_description =>
      'สำหรับคนรักเสียงเพลง ให้สตรีมเสียงคุณภาพสูง/ไร้การสูญเสียการบีบอัด การจับคู่แทร็กแม่นยำตาม ISRC';
}
