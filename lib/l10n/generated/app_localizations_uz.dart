// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get guest => 'Mehmon';

  @override
  String get browse => 'Koʻrib chiqish';

  @override
  String get search => 'Qidirish';

  @override
  String get library => 'Kutubxona';

  @override
  String get lyrics => 'Qoʻshiq matni';

  @override
  String get settings => 'Sozlamalar';

  @override
  String get genre_categories_filter =>
      'Kategoriya yoki janrlar boʻyicha filtrlash...';

  @override
  String get genre => 'Janr';

  @override
  String get personalized => 'Shaxsiylashtirilgan';

  @override
  String get featured => 'Tavsiya etilgan';

  @override
  String get new_releases => 'Yangi relizlar';

  @override
  String get songs => 'Qoʻshiqlar';

  @override
  String playing_track(Object track) {
    return 'Ijro etilmoqda: $track';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return 'Bu joriy navbatni tozalaydi. $track_length ta trek oʻchiriladi.\nDavom etishni xohlaysizmi?';
  }

  @override
  String get load_more => 'Koʻproq yuklash';

  @override
  String get playlists => 'Pleylistlar';

  @override
  String get artists => 'Ijrochilar';

  @override
  String get albums => 'Albomlar';

  @override
  String get tracks => 'Treklar';

  @override
  String get downloads => 'Yuklab olinganlar';

  @override
  String get filter_playlists => 'Pleylistlarni filtrlash...';

  @override
  String get liked_tracks => 'Sevimli treklar';

  @override
  String get liked_tracks_description => 'Barcha sevimli treklaringiz';

  @override
  String get playlist => 'Pleylist';

  @override
  String get create_a_playlist => 'Pleylist yaratish';

  @override
  String get update_playlist => 'Pleylistni yangilash';

  @override
  String get create => 'Yaratish';

  @override
  String get cancel => 'Bekor qilish';

  @override
  String get update => 'Yangilash';

  @override
  String get playlist_name => 'Pleylist nomi';

  @override
  String get name_of_playlist => 'Pleylist nomi';

  @override
  String get description => 'Tavsif';

  @override
  String get public => 'Ommaviy';

  @override
  String get collaborative => 'Hamkorlikdagi';

  @override
  String get search_local_tracks => 'Mahalliy treklarni qidirish...';

  @override
  String get play => 'Ijro etish';

  @override
  String get delete => 'Oʻchirish';

  @override
  String get none => 'Yoʻq';

  @override
  String get sort_a_z => 'A-Z boʻyicha saralash';

  @override
  String get sort_z_a => 'Z-A boʻyicha saralash';

  @override
  String get sort_artist => 'Ijrochi boʻyicha saralash';

  @override
  String get sort_album => 'Albom boʻyicha saralash';

  @override
  String get sort_duration => 'Davomiylik boʻyicha saralash';

  @override
  String get sort_tracks => 'Treklarni saralash';

  @override
  String currently_downloading(Object tracks_length) {
    return 'Yuklanmoqda ($tracks_length)';
  }

  @override
  String get cancel_all => 'Barchasini bekor qilish';

  @override
  String get filter_artist => 'Ijrochilarni filtrlash...';

  @override
  String followers(Object followers) {
    return '$followers Obunachilar';
  }

  @override
  String get add_artist_to_blacklist => 'Ijrochini qora roʻyxatga qoʻshish';

  @override
  String get top_tracks => 'Top treklar';

  @override
  String get fans_also_like => 'Muxlislarga ham yoqadi';

  @override
  String get loading => 'Yuklanmoqda...';

  @override
  String get artist => 'Ijrochi';

  @override
  String get blacklisted => 'Qora roʻyxatga kiritilgan';

  @override
  String get following => 'Obuna boʻlingan';

  @override
  String get follow => 'Obuna boʻlish';

  @override
  String get artist_url_copied => 'Ijrochi havolasi buferga nusxalandi';

  @override
  String added_to_queue(Object tracks) {
    return 'Navbatga $tracks ta trek qoʻshildi';
  }

  @override
  String get filter_albums => 'Albomlarni filtrlash...';

  @override
  String get synced => 'Sinxronlangan';

  @override
  String get plain => 'Oddiy';

  @override
  String get shuffle => 'Aralashtirish';

  @override
  String get search_tracks => 'Treklarni qidirish...';

  @override
  String get released => 'Chiqarilgan sana';

  @override
  String error(Object error) {
    return 'Xatolik $error';
  }

  @override
  String get title => 'Sarlavha';

  @override
  String get time => 'Vaqt';

  @override
  String get more_actions => 'Koʻproq amallar';

  @override
  String download_count(Object count) {
    return 'Yuklab olish ($count)';
  }

  @override
  String add_count_to_playlist(Object count) {
    return 'Pleylistga ($count) qoʻshish';
  }

  @override
  String add_count_to_queue(Object count) {
    return 'Navbatga ($count) qoʻshish';
  }

  @override
  String play_count_next(Object count) {
    return 'Keyingi ($count) ijro etish';
  }

  @override
  String get album => 'Albom';

  @override
  String copied_to_clipboard(Object data) {
    return '$data buferga nusxalandi';
  }

  @override
  String add_to_following_playlists(Object track) {
    return '$track ni quyidagi pleylistlarga qoʻshish';
  }

  @override
  String get add => 'Qoʻshish';

  @override
  String added_track_to_queue(Object track) {
    return '$track navbatga qoʻshildi';
  }

  @override
  String get add_to_queue => 'Navbatga qoʻshish';

  @override
  String track_will_play_next(Object track) {
    return '$track keyingi boʻlib ijro etiladi';
  }

  @override
  String get play_next => 'Keyingisini ijro etish';

  @override
  String removed_track_from_queue(Object track) {
    return '$track navbatdan olib tashlandi';
  }

  @override
  String get remove_from_queue => 'Navbatdan olib tashlash';

  @override
  String get remove_from_favorites => 'Sevimlilardan olib tashlash';

  @override
  String get save_as_favorite => 'Sevimlilarga saqlash';

  @override
  String get add_to_playlist => 'Pleylistga qoʻshish';

  @override
  String get remove_from_playlist => 'Pleylistdan olib tashlash';

  @override
  String get add_to_blacklist => 'Qora roʻyxatga qoʻshish';

  @override
  String get remove_from_blacklist => 'Qora roʻyxatdan olib tashlash';

  @override
  String get share => 'Ulashish';

  @override
  String get mini_player => 'Mini pleyer';

  @override
  String get slide_to_seek => 'Oldinga yoki orqaga oʻtkazish uchun suring';

  @override
  String get shuffle_playlist => 'Pleylistni aralashtirish';

  @override
  String get unshuffle_playlist => 'Pleylistni aralashtirmaslik';

  @override
  String get previous_track => 'Oldingi trek';

  @override
  String get next_track => 'Keyingi trek';

  @override
  String get pause_playback => 'Ijroni toʻxtatib turish';

  @override
  String get resume_playback => 'Ijroni davom ettirish';

  @override
  String get loop_track => 'Trekni takrorlash';

  @override
  String get no_loop => 'Takrorlamaslik';

  @override
  String get repeat_playlist => 'Pleylistni takrorlash';

  @override
  String get queue => 'Navbat';

  @override
  String get alternative_track_sources => 'Muqobil trek manbalari';

  @override
  String get download_track => 'Trekni yuklab olish';

  @override
  String tracks_in_queue(Object tracks) {
    return 'Navbatda $tracks ta trek';
  }

  @override
  String get clear_all => 'Barchasini tozalash';

  @override
  String get show_hide_ui_on_hover =>
      'Sichqoncha borganda interfeysni koʻrsatish/yashirish';

  @override
  String get always_on_top => 'Doim yuqorida';

  @override
  String get exit_mini_player => 'Mini pleyerdan chiqish';

  @override
  String get download_location => 'Yuklab olish manzili';

  @override
  String get local_library => 'Mahalliy kutubxona';

  @override
  String get add_library_location => 'Kutubxonaga qoʻshish';

  @override
  String get remove_library_location => 'Kutubxonadan olib tashlash';

  @override
  String get account => 'Hisob';

  @override
  String get logout => 'Chiqish';

  @override
  String get logout_of_this_account => 'Ushbu hisobdan chiqish';

  @override
  String get language_region => 'Til va mintaqa';

  @override
  String get language => 'Til';

  @override
  String get system_default => 'Tizim standarti';

  @override
  String get market_place_region => 'Bozor mintaqasi';

  @override
  String get recommendation_country => 'Tavsiyalar mamlakati';

  @override
  String get appearance => 'Koʻrinish';

  @override
  String get layout_mode => 'Joylashuv rejimi';

  @override
  String get override_layout_settings =>
      'Moslashuvchan joylashuv sozlamalarini bekor qilish';

  @override
  String get adaptive => 'Moslashuvchan';

  @override
  String get compact => 'Ixcham';

  @override
  String get extended => 'Kengaytirilgan';

  @override
  String get theme => 'Mavzu';

  @override
  String get dark => 'Tungi';

  @override
  String get light => 'Kunduzgi';

  @override
  String get system => 'Tizim';

  @override
  String get accent_color => 'Asosiy rang';

  @override
  String get sync_album_color => 'Albom rangini sinxronlash';

  @override
  String get sync_album_color_description =>
      'Albom muqovasining asosiy rangini aksent rang sifatida ishlatadi';

  @override
  String get playback => 'Ijro';

  @override
  String get audio_quality => 'Audio sifati';

  @override
  String get high => 'Yuqori';

  @override
  String get low => 'Past';

  @override
  String get pre_download_play => 'Oldindan yuklab olish va ijro etish';

  @override
  String get pre_download_play_description =>
      'Audio oqimini uzatish oʻrniga, baytlarni yuklab oling va ijro eting (Yuqori tezlikdagi internet foydalanuvchilari uchun tavsiya etiladi)';

  @override
  String get skip_non_music =>
      'Musiqa boʻlmagan qismlarni oʻtkazib yuborish (SponsorBlock)';

  @override
  String get blacklist_description => 'Qora roʻyxatdagi treklar va ijrochilar';

  @override
  String get wait_for_download_to_finish =>
      'Iltimos, joriy yuklab olish tugashini kuting';

  @override
  String get desktop => 'Ish stoli';

  @override
  String get close_behavior => 'Yopish harakati';

  @override
  String get close => 'Yopish';

  @override
  String get minimize_to_tray => 'Treymga kichraytirish';

  @override
  String get show_tray_icon => 'Tizim treyida belgini koʻrsatish';

  @override
  String get about => 'Dastur haqida';

  @override
  String get u_love_spotube => 'Spotube sizga yoqishini bilamiz';

  @override
  String get check_for_updates => 'Yangilanishlarni tekshirish';

  @override
  String get about_spotube => 'Spotube haqida';

  @override
  String get blacklist => 'Qora roʻyxat';

  @override
  String get please_sponsor => 'Iltimos, homiylik qiling/xayriya qiling';

  @override
  String get spotube_description =>
      'Ochiq kodli, kengaytiriluvchi musiqa striming platformasi va ilovasi, BYOMM (Oʻz musiqa metama\'lumotlaringizni keltiring) konsepsiyasiga asoslangan';

  @override
  String get version => 'Versiya';

  @override
  String get build_number => 'Tuzilma raqami';

  @override
  String get founder => 'Asoschi';

  @override
  String get repository => 'Repozitoriy';

  @override
  String get bug_issues => 'Xatolar va muammolar';

  @override
  String get made_with => 'Bangladeshda ❤️ bilan tayyorlangan🇧🇩';

  @override
  String get kingkor_roy_tirtho => 'Kingkor Roy Tirtho';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year Kingkor Roy Tirtho';
  }

  @override
  String get license => 'Litsenziya';

  @override
  String get credentials_will_not_be_shared_disclaimer =>
      'Xavotir olmang, hisob ma\'lumotlaringiz yigʻilmaydi va hech kim bilan ulashilmaydi';

  @override
  String get know_how_to_login => 'Buni qanday qilishni bilmayapsizmi?';

  @override
  String get follow_step_by_step_guide =>
      'Qadam-baqadam qoʻllanmaga amal qiling';

  @override
  String cookie_name_cookie(Object name) {
    return '$name Cookie';
  }

  @override
  String get fill_in_all_fields => 'Iltimos, barcha maydonlarni toʻldiring';

  @override
  String get submit => 'Yuborish';

  @override
  String get exit => 'Chiqish';

  @override
  String get previous => 'Oldingi';

  @override
  String get next => 'Keyingi';

  @override
  String get done => 'Tayyor';

  @override
  String get step_1 => '1-qadam';

  @override
  String get first_go_to => 'Avval, bu yerga oʻting:';

  @override
  String get something_went_wrong => 'Nimadir xato ketdi';

  @override
  String get piped_instance => 'Piped serveri namunasi';

  @override
  String get piped_description =>
      'Treklarni moslashtirish uchun ishlatiladigan Piped serveri namunasi';

  @override
  String get piped_warning =>
      'Ulardan baʻzilari yaxshi ishlamasligi mumkin. Shuning uchun oʻz xavf-xataringiz ostida ishlating';

  @override
  String get invidious_instance => 'Invidious serveri namunasi';

  @override
  String get invidious_description =>
      'Treklarni moslashtirish uchun ishlatiladigan Invidious serveri namunasi';

  @override
  String get invidious_warning =>
      'Ulardan baʻzilari yaxshi ishlamasligi mumkin. Shuning uchun oʻz xavf-xataringiz ostida ishlating';

  @override
  String get generate => 'Yaratish';

  @override
  String track_exists(Object track) {
    return '$track treki allaqachon mavjud';
  }

  @override
  String get replace_downloaded_tracks =>
      'Barcha yuklangan treklarni almashtirish';

  @override
  String get skip_download_tracks =>
      'Barcha yuklangan treklarni yuklashni oʻtkazib yuborish';

  @override
  String get do_you_want_to_replace =>
      'Mavjud trekni almashtirishni xohlaysizmi?';

  @override
  String get replace => 'Almashtirish';

  @override
  String get skip => 'Oʻtkazib yuborish';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return '$count tagacha $type tanlang';
  }

  @override
  String get select_genres => 'Janrlarni tanlang';

  @override
  String get add_genres => 'Janrlar qoʻshish';

  @override
  String get country => 'Mamlakat';

  @override
  String get number_of_tracks_generate => 'Yaratiladigan treklar soni';

  @override
  String get acousticness => 'Akustiklik';

  @override
  String get danceability => 'Raqsboplik';

  @override
  String get energy => 'Energiya';

  @override
  String get instrumentalness => 'Instrumentallik';

  @override
  String get liveness => 'Jonlilik';

  @override
  String get loudness => 'Balandlik';

  @override
  String get speechiness => 'Soʻzlashuvchanlik';

  @override
  String get valence => 'Ijobiylik (Valence)';

  @override
  String get popularity => 'Mashhurlik';

  @override
  String get key => 'Tonallik';

  @override
  String get duration => 'Davomiylik (s)';

  @override
  String get tempo => 'Temp (BPM)';

  @override
  String get mode => 'Rejim';

  @override
  String get time_signature => 'Oʻlchov';

  @override
  String get short => 'Qisqa';

  @override
  String get medium => 'Oʻrta';

  @override
  String get long => 'Uzun';

  @override
  String get min => 'Min';

  @override
  String get max => 'Maks';

  @override
  String get target => 'Maqsad';

  @override
  String get moderate => 'Oʻrtacha';

  @override
  String get deselect_all => 'Barchasini bekor qilish';

  @override
  String get select_all => 'Barchasini tanlash';

  @override
  String get are_you_sure => 'Ishonchingiz komilmi?';

  @override
  String get generating_playlist =>
      'Sizning maxsus pleylistingiz yaratilmoqda...';

  @override
  String selected_count_tracks(Object count) {
    return '$count ta trek tanlandi';
  }

  @override
  String get download_warning =>
      'Agar siz barcha treklarni ommaviy yuklab olsangiz, siz musiqani qaroqchilik yoʻli bilan oʻzlashtirayotgan boʻlasiz va musiqa ijodiy jamiyatiga zarar yetkazasiz. Umid qilamanki, bundan xabardorsiz. Har doim ijrochi mehnatini hurmat qilishga va qoʻllab-quvvatlashga harakat qiling';

  @override
  String get download_ip_ban_warning =>
      'Aytgancha, odatdagidan koʻra koʻproq yuklab olish soʻrovlari tufayli IP manzilingiz YouTube\'da bloklanishi mumkin. IP bloklanishi YouTube\'dan (hatto tizimga kirgan boʻlsangiz ham) ushbu IP qurilmadan kamida 2-3 oy davomida foydalana olmasligingizni anglatadi. Spotube bu sodir boʻlsa, hech qanday javobgarlikni oʻz zimmasiga olmaydi';

  @override
  String get by_clicking_accept_terms =>
      '\'Qabul qilish\' tugmasini bosish orqali siz quyidagi shartlarga rozilik bildirasiz:';

  @override
  String get download_agreement_1 =>
      'Men musiqani qaroqchilik yoʻli bilan olayotganimni bilaman. Men yomonman';

  @override
  String get download_agreement_2 =>
      'Men ijrochini imkon qadar qoʻllab-quvvatlayman va buni faqat ularning sanʻatini sotib olishga pulim yoʻqligi uchun qilyapman';

  @override
  String get download_agreement_3 =>
      'IP manzilim YouTube\'da bloklanishi mumkinligini toʻliq anglayman va joriy harakatim tufayli yuzaga kelgan har qanday baxtsiz hodisalar uchun Spotube yoki uning egalari/hissadorlarini javobgar deb bilmayman';

  @override
  String get decline => 'Rad etish';

  @override
  String get accept => 'Qabul qilish';

  @override
  String get details => 'Tafsilotlar';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => 'Kanal';

  @override
  String get likes => 'Layklar';

  @override
  String get dislikes => 'Dislayklar';

  @override
  String get views => 'Koʻrishlar';

  @override
  String get streamUrl => 'Oqim URL manzili';

  @override
  String get stop => 'Toʻxtatish';

  @override
  String get sort_newest => 'Yangi qoʻshilganlar boʻyicha saralash';

  @override
  String get sort_oldest => 'Eski qoʻshilganlar boʻyicha saralash';

  @override
  String get sleep_timer => 'Uyqu taymeri';

  @override
  String mins(Object minutes) {
    return '$minutes daqiqa';
  }

  @override
  String hours(Object hours) {
    return '$hours soat';
  }

  @override
  String hour(Object hours) {
    return '$hours soat';
  }

  @override
  String get custom_hours => 'Boshqa vaqt';

  @override
  String get logs => 'Loglar';

  @override
  String get developers => 'Dasturchilar';

  @override
  String get not_logged_in => 'Siz tizimga kirmagansiz';

  @override
  String get search_mode => 'Qidiruv rejimi';

  @override
  String get audio_source => 'Audio manbai';

  @override
  String get ok => 'Ok';

  @override
  String get failed_to_encrypt => 'Shifrlab boʻlmadi';

  @override
  String get encryption_failed_warning =>
      'Spotube ma\'lumotlaringizni xavfsiz saqlash uchun shifrlashdan foydalanadi. Lekin bu amalga oshmadi. Shuning uchun u xavfsiz boʻlmagan saqlashga oʻtadi\nAgar siz Linux ishlatayotgan boʻlsangiz, iltimos, biror maxfiy xizmat (gnome-keyring, kde-wallet, keepassxc va h.k.) oʻrnatilganligiga ishonch hosil qiling';

  @override
  String get querying_info => 'Ma\'lumot soʻralmoqda...';

  @override
  String get piped_api_down => 'Piped API ishlamayapti';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return '$pipedInstance Piped namunasi hozirda ishlamayapti\n\nNamunasini oʻzgartiring yoki \'API turi\'ni rasmiy YouTube API ga oʻzgartiring\n\nOʻzgartirishdan soʻng ilovani qayta ishga tushirganingizga ishonch hosil qiling';
  }

  @override
  String get you_are_offline => 'Siz hozir oflaynsiz';

  @override
  String get connection_restored => 'Internet aloqangiz tiklandi';

  @override
  String get use_system_title_bar => 'Tizim sarlavha panelidan foydalanish';

  @override
  String get crunching_results => 'Natijalar qayta ishlanmoqda...';

  @override
  String get search_to_get_results => 'Natijalarni olish uchun qidiring';

  @override
  String get use_amoled_mode => 'Qop-qora (AMOLED) mavzu';

  @override
  String get pitch_dark_theme => 'AMOLED rejimi';

  @override
  String get normalize_audio => 'Audioni normallashtirish';

  @override
  String get change_cover => 'Muqovani oʻzgartirish';

  @override
  String get add_cover => 'Muqova qoʻshish';

  @override
  String get restore_defaults => 'Standart sozlamalarni tiklash';

  @override
  String get download_music_format => 'Musiqa yuklab olish formati';

  @override
  String get streaming_music_format => 'Striming musiqa formati';

  @override
  String get download_music_quality => 'Yuklab olish sifati';

  @override
  String get streaming_music_quality => 'Striming sifati';

  @override
  String get login_with_lastfm => 'Last.fm bilan kirish';

  @override
  String get connect => 'Ulanish';

  @override
  String get disconnect_lastfm => 'Last.fm dan uzilish';

  @override
  String get disconnect => 'Uzish';

  @override
  String get username => 'Foydalanuvchi nomi';

  @override
  String get password => 'Parol';

  @override
  String get login => 'Kirish';

  @override
  String get login_with_your_lastfm => 'Last.fm hisobingiz bilan kiring';

  @override
  String get scrobble_to_lastfm => 'Last.fm ga skrobbling qilish';

  @override
  String get go_to_album => 'Albomga oʻtish';

  @override
  String get discord_rich_presence => 'Discord Rich Presence';

  @override
  String get browse_all => 'Barchasini koʻrish';

  @override
  String get genres => 'Janrlar';

  @override
  String get explore_genres => 'Janrlarni oʻrganish';

  @override
  String get friends => 'Doʻstlar';

  @override
  String get no_lyrics_available => 'Kechirasiz, bu trek uchun matn topilmadi';

  @override
  String get start_a_radio => 'Radio boshlash';

  @override
  String get how_to_start_radio => 'Radioni qanday boshlashni xohlaysiz?';

  @override
  String get replace_queue_question =>
      'Joriy navbatni almashtirishni xohlaysizmi yoki unga qoʻshishnimi?';

  @override
  String get endless_playback => 'Cheksiz ijro';

  @override
  String get delete_playlist => 'Pleylistni oʻchirish';

  @override
  String get delete_playlist_confirmation =>
      'Ushbu pleylistni oʻchirishni xohlayotganingizga ishonchingiz komilmi?';

  @override
  String get local_tracks => 'Mahalliy treklar';

  @override
  String get local_tab => 'Mahalliy';

  @override
  String get song_link => 'Qoʻshiq havolasi';

  @override
  String get skip_this_nonsense => 'Bu bema\'nilikni oʻtkazib yuborish';

  @override
  String get freedom_of_music => '“Musiqa erkinligi”';

  @override
  String get freedom_of_music_palm => '“Musiqa erkinligi sizning kaftingizda”';

  @override
  String get get_started => 'Keling, boshlaymiz';

  @override
  String get youtube_source_description =>
      'Tavsiya etiladi va eng yaxshi ishlaydi.';

  @override
  String get piped_source_description =>
      'Erkin his qilyapsizmi? YouTube bilan bir xil, lekin ancha erkinroq.';

  @override
  String get jiosaavn_source_description =>
      'Janubiy Osiyo mintaqasi uchun eng yaxshisi.';

  @override
  String get invidious_source_description =>
      'Piped ga oʻxshash, lekin yuqori mavjudlikka ega.';

  @override
  String highest_quality(Object quality) {
    return 'Eng yuqori sifat: $quality';
  }

  @override
  String get select_audio_source => 'Audio manbasini tanlang';

  @override
  String get endless_playback_description =>
      'Navbat oxiriga yangi qoʻshiqlarni avtomatik qoʻshish';

  @override
  String get choose_your_region => 'Mintaqangizni tanlang';

  @override
  String get choose_your_region_description =>
      'Bu Spotube-ga joylashuvingiz uchun toʻgʻri kontentni koʻrsatishga yordam beradi.';

  @override
  String get choose_your_language => 'Tilingizni tanlang';

  @override
  String get help_project_grow => 'Ushbu loyihaning oʻsishiga yordam bering';

  @override
  String get help_project_grow_description =>
      'Spotube ochiq kodli loyihadir. Siz loyihaga hissa qoʻshish, xatolar haqida xabar berish yoki yangi xususiyatlarni taklif qilish orqali ushbu loyihaning oʻsishiga yordam berishingiz mumkin.';

  @override
  String get contribute_on_github => 'GitHub-da hissa qoʻshish';

  @override
  String get donate_on_open_collective => 'Open Collective-da xayriya qilish';

  @override
  String get browse_anonymously => 'Anonim koʻrish';

  @override
  String get enable_connect => 'Ulanishni yoqish';

  @override
  String get enable_connect_description =>
      'Spotube-ni boshqa qurilmalardan boshqarish';

  @override
  String get devices => 'Qurilmalar';

  @override
  String get select => 'Tanlash';

  @override
  String connect_client_alert(Object client) {
    return 'Sizni $client boshqarmoqda';
  }

  @override
  String get this_device => 'Ushbu qurilma';

  @override
  String get remote => 'Masofaviy';

  @override
  String get stats => 'Statistika';

  @override
  String and_n_more(Object count) {
    return 'va yana $count ta';
  }

  @override
  String get recently_played => 'Yaqinda ijro etilgan';

  @override
  String get browse_more => 'Koʻproq koʻrish';

  @override
  String get no_title => 'Sarlavhasiz';

  @override
  String get not_playing => 'Ijro etilmayapti';

  @override
  String get epic_failure => 'Epik muvaffaqiyatsizlik!';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return 'Navbatga $tracks_length ta trek qoʻshildi';
  }

  @override
  String get spotube_has_an_update => 'Spotube yangilanishga ega';

  @override
  String get download_now => 'Hozir yuklab olish';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Spotube Nightly $nightlyBuildNum chiqarildi';
  }

  @override
  String release_version(Object version) {
    return 'Spotube v$version chiqarildi';
  }

  @override
  String get read_the_latest => 'Eng soʻnggi';

  @override
  String get release_notes => 'reliz qaydlarini oʻqish';

  @override
  String get pick_color_scheme => 'Rang sxemasini tanlang';

  @override
  String get save => 'Saqlash';

  @override
  String get choose_the_device => 'Qurilmani tanlang:';

  @override
  String get multiple_device_connected =>
      'Bir nechta qurilma ulangan.\nUshbu amal bajarilishi kerak boʻlgan qurilmani tanlang';

  @override
  String get nothing_found => 'Hech narsa topilmadi';

  @override
  String get the_box_is_empty => 'Quti boʻsh';

  @override
  String get top_artists => 'Top ijrochilar';

  @override
  String get top_albums => 'Top albomlar';

  @override
  String get this_week => 'Shu hafta';

  @override
  String get this_month => 'Shu oy';

  @override
  String get last_6_months => 'Soʻnggi 6 oy';

  @override
  String get this_year => 'Shu yil';

  @override
  String get last_2_years => 'Soʻnggi 2 yil';

  @override
  String get all_time => 'Barcha vaqtlar';

  @override
  String powered_by_provider(Object providerName) {
    return '$providerName tomonidan taqdim etilgan';
  }

  @override
  String get email => 'Elektron pochta';

  @override
  String get profile_followers => 'Obunachilar';

  @override
  String get birthday => 'Tugʻilgan kun';

  @override
  String get subscription => 'Obuna';

  @override
  String get not_born => 'Tugʻilmagan';

  @override
  String get hacker => 'Xaker';

  @override
  String get profile => 'Profil';

  @override
  String get no_name => 'Ismsiz';

  @override
  String get edit => 'Tahrirlash';

  @override
  String get user_profile => 'Foydalanuvchi profili';

  @override
  String count_plays(Object count) {
    return '$count marta ijro';
  }

  @override
  String get streaming_fees_hypothetical => 'Striming toʻlovlari (faraziy)';

  @override
  String get minutes_listened => 'Tinglangan daqiqalar';

  @override
  String get streamed_songs => 'Strim qilingan qoʻshiqlar';

  @override
  String count_streams(Object count) {
    return '$count ta strim';
  }

  @override
  String get owned_by_you => 'Sizga tegishli';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return '$shareUrl buferga nusxalandi';
  }

  @override
  String get hipotetical_calculation =>
      '*Bu oʻrtacha onlayn musiqa striming platformasining har bir oqim uchun toʻlovi \$0.003 dan \$0.005 gacha ekanligiga asoslangan hisob-kitob. Bu foydalanuvchiga agar ular qoʻshiqni boshqa musiqa striming platformasida tinglaganlarida ijrochilarga qancha toʻlagan boʻlishlari haqida tushuncha berish uchun faraziy hisob-kitobdir.';

  @override
  String count_mins(Object minutes) {
    return '$minutes daq';
  }

  @override
  String get summary_minutes => 'daqiqa';

  @override
  String get summary_listened_to_music => 'Musiqa tinglandi';

  @override
  String get summary_songs => 'qoʻshiq';

  @override
  String get summary_streamed_overall => 'Jami strim qilindi';

  @override
  String get summary_owed_to_artists => 'Bu oy ijrochilarga toʻlanishi kerak';

  @override
  String get summary_artists => 'ijrochining';

  @override
  String get summary_music_reached_you => 'Musiqa sizga yetib bordi';

  @override
  String get summary_full_albums => 'toʻliq albomlar';

  @override
  String get summary_got_your_love => 'Mehrini qozondi';

  @override
  String get summary_playlists => 'pleylistlar';

  @override
  String get summary_were_on_repeat => 'Takrorlashda boʻldi';

  @override
  String total_money(Object money) {
    return 'Jami $money';
  }

  @override
  String get webview_not_found => 'Webview topilmadi';

  @override
  String get webview_not_found_description =>
      'Qurilmangizda Webview ishga tushirish muhiti oʻrnatilmagan.\nAgar oʻrnatilgan boʻlsa, u Environment PATH da ekanligiga ishonch hosil qiling\n\nOʻrnatgandan soʻng, ilovani qayta ishga tushiring';

  @override
  String get unsupported_platform => 'Qoʻllab-quvvatlanmaydigan platforma';

  @override
  String get cache_music => 'Musiqani keshlas';

  @override
  String get open => 'Ochish';

  @override
  String get cache_folder => 'Kesh papkasi';

  @override
  String get export => 'Eksport';

  @override
  String get clear_cache => 'Keshni tozalash';

  @override
  String get clear_cache_confirmation => 'Keshni tozalashni xohlaysizmi?';

  @override
  String get export_cache_files => 'Keshlangan fayllarni eksport qilish';

  @override
  String found_n_files(Object count) {
    return '$count ta fayl topildi';
  }

  @override
  String get export_cache_confirmation =>
      'Ushbu fayllarni quyidagi joyga eksport qilishni xohlaysizmi';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return '$files fayldan $filesExported tasi eksport qilindi';
  }

  @override
  String get undo => 'Bekor qilish';

  @override
  String get download_all => 'Barchasini yuklab olish';

  @override
  String get add_all_to_playlist => 'Barchasini pleylistga qoʻshish';

  @override
  String get add_all_to_queue => 'Barchasini navbatga qoʻshish';

  @override
  String get play_all_next => 'Barchasini keyingi qilib ijro etish';

  @override
  String get pause => 'Toʻxtatish';

  @override
  String get view_all => 'Barchasini koʻrish';

  @override
  String get no_tracks_added_yet =>
      'Hozircha hech qanday trek qoʻshmaganga oʻxshaysiz';

  @override
  String get no_tracks => 'Bu yerda treklar yoʻqga oʻxshaydi';

  @override
  String get no_tracks_listened_yet =>
      'Hozircha hech narsa tinglamaganga oʻxshaysiz';

  @override
  String get not_following_artists =>
      'Siz hech qaysi ijrochiga obuna boʻlmagansiz';

  @override
  String get no_favorite_albums_yet =>
      'Sevimlilaringizga hali hech qanday albom qoʻshmaganga oʻxshaysiz';

  @override
  String get no_logs_found => 'Loglar topilmadi';

  @override
  String get youtube_engine => 'YouTube dvigateli';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engine oʻrnatilmagan';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engine tizimingizda oʻrnatilmagan.';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return 'U PATH oʻzgaruvchisida mavjudligiga ishonch hosil qiling yoki quyida $engine bajariluvchi fayliga mutlaq yoʻlni oʻrnating';
  }

  @override
  String get youtube_engine_unix_issue_message =>
      'macOS/Linux/Unix kabi operatsion tizimlarda yoʻlni .zshrc/.bashrc/.bash_profile va hokazolarda oʻrnatish ishlamaydi.\nSiz yoʻlni qobiq konfiguratsiya faylida oʻrnatishingiz kerak';

  @override
  String get download => 'Yuklab olish';

  @override
  String get file_not_found => 'Fayl topilmadi';

  @override
  String get custom => 'Maxsus';

  @override
  String get add_custom_url => 'Maxsus URL qoʻshish';

  @override
  String get edit_port => 'Portni tahrirlash';

  @override
  String get port_helper_msg =>
      'Standart qiymat -1, bu tasodifiy raqamni bildiradi. Agar sizda xavfsizlik devori sozlangan boʻlsa, buni oʻrnatish tavsiya etiladi.';

  @override
  String connect_request(Object client) {
    return '$client ulanishiga ruxsat berasizmi?';
  }

  @override
  String get connection_request_denied =>
      'Ulanish rad etildi. Foydalanuvchi ruxsat bermadi.';

  @override
  String get an_error_occurred => 'Xatolik yuz berdi';

  @override
  String get copy_to_clipboard => 'Buferga nusxalash';

  @override
  String get view_logs => 'Loglarni koʻrish';

  @override
  String get retry => 'Qayta urinish';

  @override
  String get no_default_metadata_provider_selected =>
      'Sizda standart metama\'lumotlar provayderi oʻrnatilmagan';

  @override
  String get manage_metadata_providers =>
      'Metama\'lumotlar provayderlarini boshqarish';

  @override
  String get open_link_in_browser => 'Havolani brauzerda ochish?';

  @override
  String get do_you_want_to_open_the_following_link =>
      'Quyidagi havolani ochishni xohlaysizmi';

  @override
  String get unsafe_url_warning =>
      'Ishonchsiz manbalardan havolalarni ochish xavfli boʻlishi mumkin. Ehtiyot boʻling!\nShuningdek, havolani buferga nusxalashingiz mumkin.';

  @override
  String get copy_link => 'Havolani nusxalash';

  @override
  String get building_your_timeline =>
      'Tinglashlaringiz asosida vaqt shkalangiz tuzilmoqda...';

  @override
  String get official => 'Rasmiy';

  @override
  String author_name(Object author) {
    return 'Muallif: $author';
  }

  @override
  String get third_party => 'Uchinchi tomon';

  @override
  String get plugin_requires_authentication =>
      'Plagin autentifikatsiyani talab qiladi';

  @override
  String get update_available => 'Yangilanish mavjud';

  @override
  String get supports_scrobbling => 'Skrobblingni qoʻllab-quvvatlaydi';

  @override
  String get plugin_scrobbling_info =>
      'Ushbu plagin tinglash tarixingizni yaratish uchun musiqangizni skrobbling qiladi.';

  @override
  String get default_metadata_source => 'Standart metama\'lumotlar manbai';

  @override
  String get set_default_metadata_source =>
      'Standart metama\'lumotlar manbaini oʻrnatish';

  @override
  String get default_audio_source => 'Standart audio manbai';

  @override
  String get set_default_audio_source => 'Standart audio manbaini oʻrnatish';

  @override
  String get set_default => 'Standart qilib belgilash';

  @override
  String get support => 'Qoʻllab-quvvatlash';

  @override
  String get support_plugin_development =>
      'Plagin rivojlanishini qoʻllab-quvvatlash';

  @override
  String can_access_name_api(Object name) {
    return '- **$name** API ga kirish imkoniga ega';
  }

  @override
  String get do_you_want_to_install_this_plugin =>
      'Ushbu plaginni oʻrnatishni xohlaysizmi?';

  @override
  String get third_party_plugin_warning =>
      'Ushbu plagin uchinchi tomon repozitoriysidan. Iltimos, oʻrnatishdan oldin manbaga ishonishingizga ishonch hosil qiling.';

  @override
  String get author => 'Muallif';

  @override
  String get this_plugin_can_do_following =>
      'Ushbu plagin quyidagilarni bajarishi mumkin';

  @override
  String get install => 'Oʻrnatish';

  @override
  String get install_a_metadata_provider =>
      'Metama\'lumotlar provayderini oʻrnatish';

  @override
  String get no_tracks_playing => 'Hozirda hech qanday trek ijro etilmayapti';

  @override
  String get synced_lyrics_not_available =>
      'Bu qoʻshiq uchun sinxronlangan matn mavjud emas. Iltimos,';

  @override
  String get plain_lyrics => 'Oddiy matn';

  @override
  String get tab_instead => 'tabidan foydalaning.';

  @override
  String get disclaimer => 'Mas\'uliyatni rad etish';

  @override
  String get third_party_plugin_dmca_notice =>
      'Spotube jamoasi har qanday \"Uchinchi tomon\" plaginlari uchun hech qanday javobgarlikni (shu jumladan qonuniy) oʻz zimmasiga olmaydi.\nIltimos, ulardan oʻz xavf-xataringiz ostida foydalaning. Har qanday xatolar/muammolar uchun plagin repozitoriysiga xabar bering.\n\nAgar biron bir \"Uchinchi tomon\" plagini biron bir xizmat/yuridik shaxsning ToS/DMCA qoidalarini buzsa, iltimos, \"Uchinchi tomon\" plagin muallifi yoki xosting platformasidan (masalan, GitHub/Codeberg) chora koʻrishni soʻrang. Yuqorida sanab oʻtilganlar (\"Uchinchi tomon\" deb belgilangan) barchasi ommaviy/hamjamiyat tomonidan qoʻllab-quvvatlanadigan plaginlardir. Biz ularni nazorat qilmaymiz, shuning uchun ularga nisbatan hech qanday chora koʻra olmaymiz.\n\n';

  @override
  String get input_does_not_match_format =>
      'Kiritilgan ma\'lumot talab qilingan formatga mos kelmaydi';

  @override
  String get plugins => 'Plaginlar';

  @override
  String get paste_plugin_download_url =>
      'Yuklab olish URL manzilini yoki GitHub/Codeberg repo URL manzilini yoki .smplug fayliga toʻgʻridan-toʻgʻri havolani joylashtiring';

  @override
  String get download_and_install_plugin_from_url =>
      'URL orqali plaginni yuklab olish va oʻrnatish';

  @override
  String failed_to_add_plugin_error(Object error) {
    return 'Plagin qoʻshib boʻlmadi: $error';
  }

  @override
  String get upload_plugin_from_file => 'Fayldan plagin yuklash';

  @override
  String get installed => 'Oʻrnatilgan';

  @override
  String get available_plugins => 'Mavjud plaginlar';

  @override
  String get configure_plugins =>
      'Metama\'lumotlar provayderingiz va audio manba plaginlaringizni sozlang';

  @override
  String get audio_scrobblers => 'Audio skrobblerlar';

  @override
  String get scrobbling => 'Skrobbling';

  @override
  String get source => 'Manba: ';

  @override
  String get uncompressed => 'Siqilmagan';

  @override
  String get dab_music_source_description =>
      'Audiofillar uchun. Yuqori sifatli/yoʻqotishsiz audio oqimlarini taqdim etadi. ISRC asosidagi treklarni aniq moslashtirish.';
}
