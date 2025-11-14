// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get guest => 'অতিথি';

  @override
  String get browse => 'ব্রাউজ করুন';

  @override
  String get search => 'অনুসন্ধান করুন';

  @override
  String get library => 'লাইব্রেরী';

  @override
  String get lyrics => 'গানের কথা';

  @override
  String get settings => 'সেটিংস';

  @override
  String get genre_categories_filter => 'গানের ধরণ বা শ্রেণি খুঁজুন';

  @override
  String get genre => 'গানের ধরণ';

  @override
  String get personalized => 'আপনার জন্য';

  @override
  String get featured => 'বৈশিষ্ট্যযুক্ত';

  @override
  String get new_releases => 'সাম্প্রতিক মুক্তি প্রাপ্ত';

  @override
  String get songs => 'গান';

  @override
  String playing_track(Object track) {
    return '$track চালানো হচ্ছে';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return 'এটি বর্তমান প্লেলিষ্ট সাফ করে দিবে। $track_lengthটি গান বাদ দেওয়া হবে\nআপনি কি চালিয়ে যেতে চান?';
  }

  @override
  String get load_more => 'আরো লোড করুন';

  @override
  String get playlists => 'প্লেলিস্ট';

  @override
  String get artists => 'শিল্পী';

  @override
  String get albums => 'অ্যালবাম';

  @override
  String get tracks => 'গানের ট্র্যাক';

  @override
  String get downloads => 'ডাউনলোড';

  @override
  String get filter_playlists => 'প্লেলিস্ট অনুসন্ধান করুন...';

  @override
  String get liked_tracks => 'পছন্দের গান';

  @override
  String get liked_tracks_description => 'আপনার পছন্দের গান সমূহ';

  @override
  String get playlist => 'প্লেলিস্ট';

  @override
  String get create_a_playlist => 'একটি প্লেলিস্ট তৈরি করুন';

  @override
  String get update_playlist => 'প্লেলিস্ট আপডেট করুন';

  @override
  String get create => 'তৈরি করুন';

  @override
  String get cancel => 'বাতিল করুন';

  @override
  String get update => 'আপডেট';

  @override
  String get playlist_name => 'প্লেলিস্টের নাম';

  @override
  String get name_of_playlist => 'প্লেলিস্টের নাম';

  @override
  String get description => 'বিবরণ';

  @override
  String get public => 'পাবলিক';

  @override
  String get collaborative => 'সহযোগিতামূলক';

  @override
  String get search_local_tracks => 'ডাউনলোডকৃত গান অনুসন্ধান করুন...';

  @override
  String get play => 'চালান';

  @override
  String get delete => 'মুছে ফেলুন';

  @override
  String get none => 'কোনটিই না';

  @override
  String get sort_a_z => 'A-Z ক্রমে সাজান';

  @override
  String get sort_z_a => 'Z-A ক্রমে সাজান';

  @override
  String get sort_artist => 'শিল্পীর ক্রমে সাজান';

  @override
  String get sort_album => 'অ্যালবামের ক্রমে সাজান';

  @override
  String get sort_duration => 'দৈর্ঘ্য অনুযায়ী বাছাই করুন';

  @override
  String get sort_tracks => 'গানের ক্রম';

  @override
  String currently_downloading(Object tracks_length) {
    return 'ডাউনলোড করা হচ্ছে ($tracks_length)';
  }

  @override
  String get cancel_all => 'সব বাতিল করুন';

  @override
  String get filter_artist => 'শিল্পীর অনুসন্ধান করুন...';

  @override
  String followers(Object followers) {
    return '$followers অনুসরণকারী';
  }

  @override
  String get add_artist_to_blacklist => 'শিল্পীকে ব্ল্যাকলিস্টে যোগ করুন';

  @override
  String get top_tracks => 'শীর্ষ গানের ট্র্যাক';

  @override
  String get fans_also_like => 'অনুসরণকারীদের পছন্দ';

  @override
  String get loading => 'লোড হচ্ছে...';

  @override
  String get artist => 'শিল্পী';

  @override
  String get blacklisted => 'ব্ল্যাকলিস্টে আছে';

  @override
  String get following => 'অনুসরণ করছেন';

  @override
  String get follow => 'অনুসরণ করুন';

  @override
  String get artist_url_copied => 'শিল্পীর URL কপি করা হয়েছে';

  @override
  String added_to_queue(Object tracks) {
    return '$tracksটি গানের ট্র্যাক কিউতে যোগ করা হয়েছে';
  }

  @override
  String get filter_albums => 'অ্যালবাম অনুসন্ধান করুন...';

  @override
  String get synced => 'সময় সুসংগত';

  @override
  String get plain => 'অসুসংগত';

  @override
  String get shuffle => 'অদলবদল';

  @override
  String get search_tracks => 'গান অনুসন্ধান করুন...';

  @override
  String get released => 'প্রকাশিত হয়েছে';

  @override
  String error(Object error) {
    return 'ত্রুটি $error';
  }

  @override
  String get title => 'শিরোনাম';

  @override
  String get time => 'সময়';

  @override
  String get more_actions => 'আরও অপশন';

  @override
  String download_count(Object count) {
    return 'ডাউনলোড ($countটি)';
  }

  @override
  String add_count_to_playlist(Object count) {
    return 'প্লেলিস্টে যোগ করুন ($countটি)';
  }

  @override
  String add_count_to_queue(Object count) {
    return 'কিউতে যোগ করুন ($countটি)';
  }

  @override
  String play_count_next(Object count) {
    return 'পরবর্তীতে চালান ($countটি)';
  }

  @override
  String get album => 'অ্যালবাম';

  @override
  String copied_to_clipboard(Object data) {
    return '$data ক্লিপবোর্ডে কপি করা হয়েছে';
  }

  @override
  String add_to_following_playlists(Object track) {
    return 'নিম্নলিখিত প্লেলিস্টে $track যোগ করুন';
  }

  @override
  String get add => 'যোগ করুন';

  @override
  String added_track_to_queue(Object track) {
    return 'কিউতে $track যোগ করা হয়েছে';
  }

  @override
  String get add_to_queue => 'কিউতে যোগ করুন';

  @override
  String track_will_play_next(Object track) {
    return '$track পরবর্তীতে চালানো হবে';
  }

  @override
  String get play_next => 'পরবর্তীতে চালান';

  @override
  String removed_track_from_queue(Object track) {
    return 'কিউ থেকে $track সরিয়ে নেওয়া হয়েছে';
  }

  @override
  String get remove_from_queue => 'কিউ থেকে সরান';

  @override
  String get remove_from_favorites => 'পছন্দের তালিকা থেকে অপসারণ করুন';

  @override
  String get save_as_favorite => 'পছন্দের তালিকায় সংরক্ষণ করুন';

  @override
  String get add_to_playlist => 'প্লেলিস্টে যোগ করুন';

  @override
  String get remove_from_playlist => 'প্লেলিস্ট থেকে সরান';

  @override
  String get add_to_blacklist => 'ব্ল্যাকলিস্টে যোগ করুন';

  @override
  String get remove_from_blacklist => 'ব্ল্যাকলিস্ট থেকে সরান';

  @override
  String get share => 'শেয়ার করুন';

  @override
  String get mini_player => 'মিনি প্লেয়ার';

  @override
  String get slide_to_seek => 'গান সামনে বা পিছনে নিতে স্লাইড করুন';

  @override
  String get shuffle_playlist => 'প্লেলিস্ট এলোমেলো করুন';

  @override
  String get unshuffle_playlist => 'প্লেলিস্ট আগের মতো করুন';

  @override
  String get previous_track => 'আগের গানের ট্র্যাক';

  @override
  String get next_track => 'পরের গানের ট্র্যাক';

  @override
  String get pause_playback => 'গান বন্ধ করুন';

  @override
  String get resume_playback => 'গান চালু করুন';

  @override
  String get loop_track => 'গান শেষে পুনরায় চালান';

  @override
  String get no_loop => 'কোনো লুপ নেই';

  @override
  String get repeat_playlist => 'প্লেলিস্ট শেষে পুনরায় চালান';

  @override
  String get queue => 'গানের কিউ';

  @override
  String get alternative_track_sources => 'বিকল্প গানের উৎস';

  @override
  String get download_track => 'গান ডাউনলোড করুন';

  @override
  String tracks_in_queue(Object tracks) {
    return '$tracksটি গান কিউতে রয়েছে';
  }

  @override
  String get clear_all => 'সব মুছে ফেলুন';

  @override
  String get show_hide_ui_on_hover => 'হভার করলে UI দেখান/লুকান';

  @override
  String get always_on_top => 'সর্বদা উপরে';

  @override
  String get exit_mini_player => 'মিনি প্লেয়ার থেকে বের হয়ে যান';

  @override
  String get download_location => 'ডাউনলোড স্থান';

  @override
  String get local_library => 'স্থানীয় লাইব্রেরি';

  @override
  String get add_library_location => 'লাইব্রেরিতে যোগ করুন';

  @override
  String get remove_library_location => 'লাইব্রেরি থেকে সরান';

  @override
  String get account => 'অ্যাকাউন্ট';

  @override
  String get logout => 'লগআউট করুন';

  @override
  String get logout_of_this_account => 'অ্যাকাউন্ট থেকে লগআউট করুন';

  @override
  String get language_region => 'ভাষা ও অঞ্চল';

  @override
  String get language => 'ভাষা';

  @override
  String get system_default => 'সিস্টেম ডিফল্ট';

  @override
  String get market_place_region => 'মার্কেটপ্লেস অঞ্চল';

  @override
  String get recommendation_country => 'দেশভিত্তিক সঙ্গীত পরামর্শের জন্য দেশ';

  @override
  String get appearance => 'রুপ';

  @override
  String get layout_mode => 'UI বিন্যাস রূপ';

  @override
  String get override_layout_settings =>
      'প্রতিক্রিয়াশীল UI বিন্যাস রূপের সেটিংস পরিবর্তন করুন';

  @override
  String get adaptive => 'অভিযোজিত';

  @override
  String get compact => 'আঁটসাঁট UI';

  @override
  String get extended => 'বিস্তৃত UI';

  @override
  String get theme => 'থিম';

  @override
  String get dark => 'অন্ধকার';

  @override
  String get light => 'উজ্জল';

  @override
  String get system => 'সিস্টেম থিম';

  @override
  String get accent_color => 'প্রভাবশালী রং';

  @override
  String get sync_album_color => 'অ্যালবাম সুসংগত UI এর রং';

  @override
  String get sync_album_color_description =>
      'অ্যালবাম কভারের প্রভাবশালী রঙ UI অ্যাকসেন্ট রঙ হিসাবে ব্যবহার করে';

  @override
  String get playback => 'সংগীতের প্লেব্যাক';

  @override
  String get audio_quality => 'শব্দের গুণমান';

  @override
  String get high => 'উচ্চ';

  @override
  String get low => 'নিম্ন';

  @override
  String get pre_download_play => 'আগে গান ডাউনলোড করে পরে চালান ';

  @override
  String get pre_download_play_description =>
      'গান স্ট্রিম করার পরিবর্তে, ডাউনলোড করুন এবং প্লে করুন (উচ্চ ব্যান্ডউইথ ব্যবহারকারীদের জন্য প্রস্তাবিত)';

  @override
  String get skip_non_music =>
      'গানের নন-মিউজিক সেগমেন্ট এড়িয়ে যান (SponsorBlock)';

  @override
  String get blacklist_description =>
      'কালো তালিকাভুক্ত গানের ট্র্যাক এবং শিল্পী';

  @override
  String get wait_for_download_to_finish =>
      'ডাউনলোড শেষ হওয়ার জন্য অপেক্ষা করুন';

  @override
  String get desktop => 'ডেস্কটপ';

  @override
  String get close_behavior => 'বন্ধ করার প্রক্রিয়া';

  @override
  String get close => 'বন্ধ করুন';

  @override
  String get minimize_to_tray => 'সিস্টেম ট্রেতে রাখুন';

  @override
  String get show_tray_icon => 'সিস্টেম ট্রে আইকন দেখান';

  @override
  String get about => 'বিস্তারিত';

  @override
  String get u_love_spotube => 'আমরা জানি আপনি Spotube কে ভালবাসেন';

  @override
  String get check_for_updates => 'আপডেট চেক করুন';

  @override
  String get about_spotube => 'Spotube সম্পর্কে বিস্তারিত';

  @override
  String get blacklist => 'কালো তালিকা';

  @override
  String get please_sponsor => 'স্পনসর/সহায়তা করুন';

  @override
  String get spotube_description =>
      'Spotube, একটি কর্মদক্ষ, ক্রস-প্ল্যাটফর্ম, বিনামূল্যের জন্য Spotify ক্লায়েন্ট';

  @override
  String get version => 'সংস্করণ';

  @override
  String get build_number => 'বিল্ড নম্বর';

  @override
  String get founder => 'প্রতিষ্ঠাতা';

  @override
  String get repository => 'সংগ্রহস্থল';

  @override
  String get bug_issues => 'বাগ/সমস্যা';

  @override
  String get made_with => '❤️ দিয়ে বাংলাদেশে🇧🇩 তৈরি';

  @override
  String get kingkor_roy_tirtho => 'কিংকর রায় তীর্থ';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year কিংকর রায় তীর্থ';
  }

  @override
  String get license => 'লাইসেন্স';

  @override
  String get credentials_will_not_be_shared_disclaimer =>
      'চিন্তা করবেন না, আপনার কোনো লগইন তথ্য সংগ্রহ করা হবে না বা কারো সাথে শেয়ার করা হবে না';

  @override
  String get know_how_to_login => 'আপনি কিভাবে লগইন করবেন তা জানেন না?';

  @override
  String get follow_step_by_step_guide => 'ধাপে ধাপে নির্দেশিকা অনুসরণ করুন';

  @override
  String cookie_name_cookie(Object name) {
    return '$name কুকি';
  }

  @override
  String get fill_in_all_fields => 'সমস্ত ফর্ম ক্ষেত্র পূরণ করুন';

  @override
  String get submit => 'জমা দিন';

  @override
  String get exit => 'প্রস্থান';

  @override
  String get previous => 'পূর্ববর্তী';

  @override
  String get next => 'পরবর্তী';

  @override
  String get done => 'সম্পন্ন';

  @override
  String get step_1 => 'ধাপ 1';

  @override
  String get first_go_to => 'প্রথমে যান';

  @override
  String get something_went_wrong => 'কিছু ভুল হয়েছে';

  @override
  String get piped_instance => 'Piped সার্ভার এড্রেস';

  @override
  String get piped_description => 'গান ম্যাচ করার জন্য ব্যবহৃত পাইপড সার্ভার';

  @override
  String get piped_warning =>
      'এগুলোর মধ্যে কিছু ভাল কাজ নাও করতে পারে৷ তাই নিজ দায়িত্বে ব্যবহার করুন';

  @override
  String get invidious_instance => 'ইনভিডিয়াস সার্ভার ইন্সটেন্স';

  @override
  String get invidious_description =>
      'ট্রাক মিলানোর জন্য ব্যবহৃত ইনভিডিয়াস সার্ভার';

  @override
  String get invidious_warning =>
      'কিছু সার্ভার ভাল কাজ নাও করতে পারে। নিজের ঝুঁকিতে ব্যবহার করুন';

  @override
  String get generate => 'উৎপন্ন করুন';

  @override
  String track_exists(Object track) {
    return 'ট্র্যাক $track ইতিমধ্যে বিদ্যমান';
  }

  @override
  String get replace_downloaded_tracks =>
      'সমস্ত ডাউনলোড করা ট্র্যাক প্রতিস্থাপন করুন';

  @override
  String get skip_download_tracks => 'সমস্ত ডাউনলোড করা ট্র্যাক এ স্কিপ করুন';

  @override
  String get do_you_want_to_replace =>
      'আপনি কি বিদ্যমান ট্র্যাকটি প্রতিস্থাপন করতে চান?';

  @override
  String get replace => 'প্রতিস্থাপন করুন';

  @override
  String get skip => 'স্কিপ করুন';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return '$count $type পর্যন্ত নির্বাচন করুন';
  }

  @override
  String get select_genres => 'গানের ধরণ নির্বাচন করুন';

  @override
  String get add_genres => 'গানের ধরণ যুক্ত করুন';

  @override
  String get country => 'দেশ';

  @override
  String get number_of_tracks_generate => 'উত্পাদিত ট্র্যাকের সংখ্যা';

  @override
  String get acousticness => 'অধ্যাত্মিকতা';

  @override
  String get danceability => 'নৃত্যমূলকতা';

  @override
  String get energy => 'শক্তি';

  @override
  String get instrumentalness => 'সাধারণতা';

  @override
  String get liveness => 'জীবনমুক্ততা';

  @override
  String get loudness => 'স্বরের উচ্চতা';

  @override
  String get speechiness => 'বক্তব্যমূলকতা';

  @override
  String get valence => 'সন্তোষমূলকতা';

  @override
  String get popularity => 'জনপ্রিয়তা';

  @override
  String get key => 'কী';

  @override
  String get duration => 'সময়কাল (সেকেন্ড)';

  @override
  String get tempo => 'গতি (বিপিএম)';

  @override
  String get mode => 'মোড';

  @override
  String get time_signature => 'সময়ের স্বাক্ষর';

  @override
  String get short => 'সংক্ষিপ্ত';

  @override
  String get medium => 'মাঝারি';

  @override
  String get long => 'দীর্ঘ';

  @override
  String get min => 'সর্বনিম্ন';

  @override
  String get max => 'সর্বাধিক';

  @override
  String get target => 'লক্ষ্য';

  @override
  String get moderate => 'মাঝারি';

  @override
  String get deselect_all => 'সমস্ত অপচুন করুন';

  @override
  String get select_all => 'সমস্ত নির্বাচন করুন';

  @override
  String get are_you_sure => 'আপনি কি নিশ্চিত?';

  @override
  String get generating_playlist => 'আপনার কাস্টম প্লেলিস্ট তৈরি হচ্ছে...';

  @override
  String selected_count_tracks(Object count) {
    return '$count ট্র্যাক নির্বাচিত';
  }

  @override
  String get download_warning =>
      'যদি আপনি সমস্ত ট্র্যাকগুলি একসঙ্গে ডাউনলোড করেন, তবে আপনি নিশ্চিতভাবে সঙ্গীত চুরি করছেন এবং সৃষ্টিশীল সমাজে ক্ষতি দিচ্ছেন। আমি আশা করি আপনি এটা সম্পর্কে জানেন। সর্বদা, শিল্পীদের কঠিন পরিশ্রমকে সম্মান করতে চেষ্টা করুন এবং সমর্থন করুন';

  @override
  String get download_ip_ban_warning =>
      'তথ্যবিশ্বস্ত করে নেওয়া যায় যে, আপনার IP ঠিকানাটি YouTube দ্বারা স্থানান্তরিত করা হতে পারে যখন সাধারন থেকে বেশি ডাউনলোড অনুরোধ হয়। IP ব্লকের মাধ্যমে আপনি কমপক্ষে ২-৩ মাস ধরে (ঐ IP ডিভাইস থেকে) YouTube ব্যবহার করতে পারবেন না। এবং Spotube কোনও দায়িত্ব সম্পর্কে দায়িত্ব বহন করে না যদি এটি ঘটে।';

  @override
  String get by_clicking_accept_terms =>
      '\'গ্রহণ\' ক্লিক করে আপনি নিম্নলিখিত শর্তাদি স্বীকার করছেন:';

  @override
  String get download_agreement_1 => 'আমি জানি আমি সঙ্গীত চুরি করছি। আমি খারাপ';

  @override
  String get download_agreement_2 =>
      'আমি কেবলমাত্র তাদের কাজ কেনার জন্য অর্থ নেই কিন্তু যেখানে প্রয়োজন সেখানে আমি শিল্পীদের সমর্থন করব।';

  @override
  String get download_agreement_3 =>
      'আমি সম্পূর্ণরূপে জানি যে আমার IP YouTube-তে ব্লক হতে পারে এবং আমি Spotube বা তার মালিকানাধীন কোনও দায়িত্ব পেতে পারিনি আমার বর্তমান ক্রিয়াটি দ্বারা সৃষ্ট দুর্ঘটনা করার জন্য';

  @override
  String get decline => 'অগ্রায়ন করুন';

  @override
  String get accept => 'গ্রহণ করুন';

  @override
  String get details => 'বিস্তারিত';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => 'চ্যানেল';

  @override
  String get likes => 'লাইক';

  @override
  String get dislikes => 'অপছন্দ';

  @override
  String get views => 'দর্শনার্থী';

  @override
  String get streamUrl => 'স্ট্রিম URL';

  @override
  String get stop => 'বন্ধ করুন';

  @override
  String get sort_newest => 'নতুনতম অনুসারে সাজান';

  @override
  String get sort_oldest => 'পুরানোতম অনুসারে সাজান';

  @override
  String get sleep_timer => 'স্লীপ টাইমার';

  @override
  String mins(Object minutes) {
    return '$minutes মিনিট';
  }

  @override
  String hours(Object hours) {
    return '$hours ঘন্টা';
  }

  @override
  String hour(Object hours) {
    return '$hours ঘন্টা';
  }

  @override
  String get custom_hours => 'কাস্টম ঘন্টা';

  @override
  String get logs => 'লগ';

  @override
  String get developers => 'ডেভেলপার';

  @override
  String get not_logged_in => 'আপনি লগইন করা নেই';

  @override
  String get search_mode => 'অনুসন্ধান মোড';

  @override
  String get audio_source => 'অডিও উৎস';

  @override
  String get ok => 'ঠিক আছে';

  @override
  String get failed_to_encrypt => 'এনক্রিপ্ট করা ব্যর্থ হয়েছে';

  @override
  String get encryption_failed_warning =>
      'Spotube আপনার তথ্যগুলি নিরাপদভাবে স্টোর করতে এনক্রিপশন ব্যবহার করে। কিন্তু এটি ব্যর্থ হয়েছে। তাই এটি অনিরাপদ স্টোরে ফলফল হবে\nযদি আপনি Linux ব্যবহার করেন, তবে দয়া করে নিশ্চিত হউন যে আপনার কোনও সিক্রেট-সার্ভিস gnome-keyring, kde-wallet, keepassxc ইত্যাদি ইনস্টল করা আছে';

  @override
  String get querying_info => 'তথ্য অনুসন্ধান করা হচ্ছে';

  @override
  String get piped_api_down => 'পাইপড API ডাউন আছে';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return 'বর্তমানে পাইপড ইনস্ট্যান্স $pipedInstance ডাউন আছে\n\nইনস্ট্যান্স পরিবর্তন করুন অথবা \'API টাইপ\' পরিবর্তন করুন অফিসিয়াল ইউটিউব API হতে\n\nপরিবর্তনের পরে অ্যাপটি পুনরায় চালানোর নিশ্চিত করুন';
  }

  @override
  String get you_are_offline => 'আপনি বর্তমানে অফলাইন';

  @override
  String get connection_restored => 'আপনার ইন্টারনেট সংযোগ পুনরুদ্ধার হয়েছে';

  @override
  String get use_system_title_bar => 'সিস্টেম শিরোনাম বার ব্যবহার করুন';

  @override
  String get crunching_results => 'ফলাফল বিশ্লেষণ করা হচ্ছে...';

  @override
  String get search_to_get_results => 'ফলাফল পেতে খোঁজ করুন';

  @override
  String get use_amoled_mode => 'AMOLED মোড ব্যবহার করুন';

  @override
  String get pitch_dark_theme => 'পিচ ব্ল্যাক ডার্ট থিম';

  @override
  String get normalize_audio => 'অডিও স্তরমান করুন';

  @override
  String get change_cover => 'কভার পরিবর্তন করুন';

  @override
  String get add_cover => 'কভার যোগ করুন';

  @override
  String get restore_defaults => 'ডিফল্ট সেটিংস পুনরুদ্ধার করুন';

  @override
  String get download_music_format => 'গান ডাউনলোডের বিন্যাস';

  @override
  String get streaming_music_format => 'গান স্ট্রিমিং এর বিন্যাস';

  @override
  String get download_music_quality => 'গান ডাউনলোডের মান';

  @override
  String get streaming_music_quality => 'গান স্ট্রিমিং এর মান';

  @override
  String get login_with_lastfm => 'Last.fm দিয়ে লগইন করুন';

  @override
  String get connect => 'সংযোগ করুন';

  @override
  String get disconnect_lastfm => 'Last.fm সংযোগ বিচ্ছিন্ন করুন';

  @override
  String get disconnect => 'সংযোগ বিচ্ছিন্ন করুন';

  @override
  String get username => 'ব্যবহারকারীর নাম';

  @override
  String get password => 'পাসওয়ার্ড';

  @override
  String get login => 'লগইন';

  @override
  String get login_with_your_lastfm =>
      'আপনার Last.fm অ্যাকাউন্ট দিয়ে লগইন করুন';

  @override
  String get scrobble_to_lastfm => 'Last.fm এ স্ক্রবল করুন';

  @override
  String get go_to_album => 'الانتقال إلى الألبوم';

  @override
  String get discord_rich_presence => 'وجود ديسكورد الغني';

  @override
  String get browse_all => 'تصفح الكل';

  @override
  String get genres => 'الأنواع الموسيقية';

  @override
  String get explore_genres => 'استكشاف الأنواع';

  @override
  String get friends => 'বন্ধু';

  @override
  String get no_lyrics_available =>
      'দুঃখিত, এই ট্র্যাকের জন্য কথা খুঁজে পাওয়া গেলনা';

  @override
  String get start_a_radio => 'রেডিও শুরু করুন';

  @override
  String get how_to_start_radio => 'রেডিও কিভাবে শুরু করতে চান?';

  @override
  String get replace_queue_question =>
      'আপনি বর্তমান কিউটি প্রতিস্থাপন করতে চান কিনা বা এর সাথে যুক্ত করতে চান?';

  @override
  String get endless_playback => 'অবিরাম প্রচার';

  @override
  String get delete_playlist => 'প্লেলিস্ট মুছুন';

  @override
  String get delete_playlist_confirmation =>
      'আপনি কি নিশ্চিত যে আপনি এই প্লেলিস্টটি মুছতে চান?';

  @override
  String get local_tracks => 'স্থানীয় ট্র্যাক';

  @override
  String get local_tab => 'স্থানীয়';

  @override
  String get song_link => 'গানের লিংক';

  @override
  String get skip_this_nonsense => 'এই বাকবাস পালান';

  @override
  String get freedom_of_music => '“সংগীতের স্বাধীনতা”';

  @override
  String get freedom_of_music_palm => '“তোমার হাতের কাছে সংগীতের স্বাধীনতা”';

  @override
  String get get_started => 'শুরু করা যাক';

  @override
  String get youtube_source_description => 'প্রস্তাবিত এবং সেরা কাজ করে।';

  @override
  String get piped_source_description => 'মন খারাপ? ইউটিউবের মতো আবার ফ্রি।';

  @override
  String get jiosaavn_source_description => 'দক্ষিণ এশিয়ান অঞ্চলের জন্য সেরা।';

  @override
  String get invidious_source_description =>
      'পাইপের মতো কিন্তু আরও বেশি উপলব্ধতা সহ';

  @override
  String highest_quality(Object quality) {
    return 'সর্বোচ্চ গুণগতি: $quality';
  }

  @override
  String get select_audio_source => 'অডিও উৎস নির্বাচন করুন';

  @override
  String get endless_playback_description =>
      'নতুন গান নিজে নিজে প্লেলিস্টের শেষে\nসংযুক্ত করুন';

  @override
  String get choose_your_region => 'আপনার অঞ্চল নির্বাচন করুন';

  @override
  String get choose_your_region_description =>
      'এটি স্পটুবে আপনাকে আপনার অবস্থানের জন্য ঠিক কন্টেন্ট দেখানোর সাহায্য করবে।';

  @override
  String get choose_your_language => 'আপনার ভাষা নির্বাচন করুন';

  @override
  String get help_project_grow => 'এই প্রকল্পের বৃদ্ধি করুন';

  @override
  String get help_project_grow_description =>
      'স্পটুব একটি ওপেন সোর্স প্রকল্প। আপনি প্রকল্পে অবদান রাখেন, বাগ রিপোর্ট করেন, বা নতুন বৈশিষ্ট্যগুলি সুপারিশ করেন।';

  @override
  String get contribute_on_github => 'গিটহাবে অবদান রাখুন';

  @override
  String get donate_on_open_collective => 'ওপেন কলেক্টিভে অনুদান করুন';

  @override
  String get browse_anonymously => 'অজানে ব্রাউজ করুন';

  @override
  String get enable_connect => 'সংযোগ সক্রিয় করুন';

  @override
  String get enable_connect_description =>
      'অন্যান্য ডিভাইস থেকে Spotube নিয়ন্ত্রণ করুন';

  @override
  String get devices => 'ডিভাইস';

  @override
  String get select => 'নির্বাচন করুন';

  @override
  String connect_client_alert(Object client) {
    return 'আপনি $client দ্বারা নিয়ন্ত্রিত হচ্ছেন';
  }

  @override
  String get this_device => 'এই ডিভাইস';

  @override
  String get remote => 'রিমোট';

  @override
  String get stats => 'পরিসংখ্যান';

  @override
  String and_n_more(Object count) {
    return 'এবং $count আরও';
  }

  @override
  String get recently_played => 'সম্প্রতি বাজানো';

  @override
  String get browse_more => 'আরও ব্রাউজ করুন';

  @override
  String get no_title => 'কোনো শিরোনাম নেই';

  @override
  String get not_playing => 'চালানো হচ্ছে না';

  @override
  String get epic_failure => 'বিরাট ব্যর্থতা!';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return '$tracks_length ট্র্যাক সারিতে যোগ করা হয়েছে';
  }

  @override
  String get spotube_has_an_update => 'স্পটিউবে একটি আপডেট আছে';

  @override
  String get download_now => 'এখনই ডাউনলোড করুন';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'স্পটিউব নাইটলি $nightlyBuildNum প্রকাশিত হয়েছে';
  }

  @override
  String release_version(Object version) {
    return 'স্পটিউব v$version প্রকাশিত হয়েছে';
  }

  @override
  String get read_the_latest => 'সর্বশেষ পড়ুন';

  @override
  String get release_notes => 'রিলিজ নোট';

  @override
  String get pick_color_scheme => 'রঙের থিম নির্বাচন করুন';

  @override
  String get save => 'সংরক্ষণ করুন';

  @override
  String get choose_the_device => 'ডিভাইস নির্বাচন করুন:';

  @override
  String get multiple_device_connected =>
      'একাধিক ডিভাইস সংযুক্ত রয়েছে।\nযে ডিভাইসে আপনি এই ক্রিয়াটি চালাতে চান সেটি নির্বাচন করুন';

  @override
  String get nothing_found => 'কিছুই পাওয়া যায়নি';

  @override
  String get the_box_is_empty => 'বাক্সটি খালি';

  @override
  String get top_artists => 'শীর্ষ শিল্পী';

  @override
  String get top_albums => 'শীর্ষ অ্যালবাম';

  @override
  String get this_week => 'এই সপ্তাহ';

  @override
  String get this_month => 'এই মাস';

  @override
  String get last_6_months => 'গত ৬ মাস';

  @override
  String get this_year => 'এই বছর';

  @override
  String get last_2_years => 'গত ২ বছর';

  @override
  String get all_time => 'সব সময়';

  @override
  String powered_by_provider(Object providerName) {
    return '$providerName দ্বারা চালিত';
  }

  @override
  String get email => 'ইমেইল';

  @override
  String get profile_followers => 'অনুসারী';

  @override
  String get birthday => 'জন্মদিন';

  @override
  String get subscription => 'সাবস্ক্রিপশন';

  @override
  String get not_born => 'জন্মগ্রহণ করেনি';

  @override
  String get hacker => 'হ্যাকার';

  @override
  String get profile => 'প্রোফাইল';

  @override
  String get no_name => 'কোন নাম নেই';

  @override
  String get edit => 'সম্পাদনা করুন';

  @override
  String get user_profile => 'ব্যবহারকারীর প্রোফাইল';

  @override
  String count_plays(Object count) {
    return '$count বার প্লে হয়েছে';
  }

  @override
  String get streaming_fees_hypothetical => 'স্ট্রিমিং ফি (ধারণাগত)';

  @override
  String get minutes_listened => 'শুনেছেন মিনিট';

  @override
  String get streamed_songs => 'স্ট্রিম করা গান';

  @override
  String count_streams(Object count) {
    return '$count বার স্ট্রিম';
  }

  @override
  String get owned_by_you => 'আপনার মালিকানাধীন';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return '$shareUrl ক্লিপবোর্ডে কপি করা হয়েছে';
  }

  @override
  String get hipotetical_calculation =>
      '*এটি নিরূপণ করা হয়েছে গড় অনলাইন মিউজিক স্ট্রিমিং প্ল্যাটফর্মের প্রতি স্ট্রিম 0.003–0.005 USD পেআউটের ভিত্তিতে। এটি একটি কাল্পনিক হিসাব যা ব্যবহারকারীকে ধারণা দিতে পারে তারা অন্যান্য স্ট্রিমিং প্ল্যাটফর্মে একই গান শোনার জন্য শিল্পীদের কত টাকা দিয়েছেন হোক।';

  @override
  String count_mins(Object minutes) {
    return '$minutes মিনিট';
  }

  @override
  String get summary_minutes => 'মিনিট';

  @override
  String get summary_listened_to_music => 'সঙ্গীত শুনেছেন';

  @override
  String get summary_songs => 'গান';

  @override
  String get summary_streamed_overall => 'মোট স্ট্রিম';

  @override
  String get summary_owed_to_artists => 'এই মাসে\nশিল্পীদেরকে ঋণী';

  @override
  String get summary_artists => 'শিল্পীর';

  @override
  String get summary_music_reached_you => 'আপনার কাছে পৌঁছেছে সঙ্গীত';

  @override
  String get summary_full_albums => 'সম্পূর্ণ অ্যালবাম';

  @override
  String get summary_got_your_love => 'আপনার ভালোবাসা পেয়েছে';

  @override
  String get summary_playlists => 'প্লেলিস্ট';

  @override
  String get summary_were_on_repeat => 'পুনরাবৃত্তিতে ছিল';

  @override
  String total_money(Object money) {
    return 'মোট $money';
  }

  @override
  String get webview_not_found => 'ওয়েবভিউ পাওয়া যায়নি';

  @override
  String get webview_not_found_description =>
      'আপনার ডিভাইসে কোনো ওয়েবভিউ রানটাইম ইনস্টল করা নেই।\nযদি ইনস্টল থাকে, তা নিশ্চিত করুন যে এটি environment PATH এ রয়েছে\n\nইনস্টল করার পর, অ্যাপটি পুনরায় চালু করুন';

  @override
  String get unsupported_platform => 'সমর্থিত প্ল্যাটফর্ম নয়';

  @override
  String get cache_music => 'ক্যাশে সংগীত';

  @override
  String get open => 'খুলুন';

  @override
  String get cache_folder => 'ক্যাশে ফোল্ডার';

  @override
  String get export => 'রপ্তানি';

  @override
  String get clear_cache => 'ক্যাশে পরিষ্কার';

  @override
  String get clear_cache_confirmation => 'আপনি কি ক্যাশে পরিষ্কার করতে চান?';

  @override
  String get export_cache_files => 'ক্যাশে ফাইল রপ্তানি';

  @override
  String found_n_files(Object count) {
    return '$count টি ফাইল পাওয়া গেছে';
  }

  @override
  String get export_cache_confirmation =>
      'আপনি কি এই ফাইলগুলি রপ্তানি করতে চান';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return '$filesExported টি ফাইল রপ্তানি করা হয়েছে $files এর মধ্যে';
  }

  @override
  String get undo => 'পূর্বাবস্থায় ফিরুন';

  @override
  String get download_all => 'সব ডাউনলোড করুন';

  @override
  String get add_all_to_playlist => 'সব প্লেলিস্টে যোগ করুন';

  @override
  String get add_all_to_queue => 'সব কিউতে যোগ করুন';

  @override
  String get play_all_next => 'সব পরবর্তী খেলুন';

  @override
  String get pause => 'বিরতি';

  @override
  String get view_all => 'সব দেখুন';

  @override
  String get no_tracks_added_yet => 'এখনও কোনো ট্র্যাক যোগ করা হয়নি মনে হচ্ছে';

  @override
  String get no_tracks => 'এখানে কোনো ট্র্যাক নেই মনে হচ্ছে';

  @override
  String get no_tracks_listened_yet => 'এখনও কিছু শোনা হয়নি মনে হচ্ছে';

  @override
  String get not_following_artists => 'আপনি কোনো শিল্পীকে অনুসরণ করছেন না';

  @override
  String get no_favorite_albums_yet =>
      'এখনও কোনো অ্যালবাম প্রিয় তালিকায় যোগ করা হয়নি মনে হচ্ছে';

  @override
  String get no_logs_found => 'কোনো লগ পাওয়া যায়নি';

  @override
  String get youtube_engine => 'ইউটিউব ইঞ্জিন';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engine ইনস্টল করা নেই';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engine আপনার সিস্টেমে ইনস্টল করা নেই।';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return 'এটি PATH ভেরিয়েবলে উপলব্ধ কিনা নিশ্চিত করুন অথবা\nনীচে $engine এক্সিকিউটেবল এর পূর্ণপথ সেট করুন';
  }

  @override
  String get youtube_engine_unix_issue_message =>
      'macOS/Linux/Unix-এর মতো অপারেটিং সিস্টেমে, .zshrc/.bashrc/.bash_profile ইত্যাদিতে পাথ সেট করা কাজ করবে না।\nআপনাকে শেল কনফিগারেশন ফাইলে পাথ সেট করতে হবে';

  @override
  String get download => 'ডাউনলোড';

  @override
  String get file_not_found => 'ফাইল পাওয়া যায়নি';

  @override
  String get custom => 'কাস্টম';

  @override
  String get add_custom_url => 'কাস্টম URL যোগ করুন';

  @override
  String get edit_port => 'পোর্ট সম্পাদনা করুন';

  @override
  String get port_helper_msg =>
      'ডিফল্ট হল -1 যা এলোমেলো সংখ্যা নির্দেশ করে। যদি আপনার ফায়ারওয়াল কনফিগার করা থাকে, তবে এটি সেট করা সুপারিশ করা হয়।';

  @override
  String connect_request(Object client) {
    return '$client কে সংযোগ করতে অনুমতি দেবেন?';
  }

  @override
  String get connection_request_denied =>
      'সংযোগ অস্বীকৃত। ব্যবহারকারী প্রবেশাধিকার অস্বীকার করেছে।';

  @override
  String get an_error_occurred => 'একটি ত্রুটি ঘটেছে';

  @override
  String get copy_to_clipboard => 'ক্লিপবোর্ডে কপি করুন';

  @override
  String get view_logs => 'লগ দেখুন';

  @override
  String get retry => 'পুনরায় চেষ্টা করুন';

  @override
  String get no_default_metadata_provider_selected =>
      'আপনি কোনো ডিফল্ট মেটাডেটা প্রদানকারী সেট করেননি';

  @override
  String get manage_metadata_providers => 'মেটাডেটা প্রদানকারীগণ পরিচালনা করুন';

  @override
  String get open_link_in_browser => 'লিংকটি ব্রাউজারে খুলবেন?';

  @override
  String get do_you_want_to_open_the_following_link =>
      'নিচের লিংকটি খুলতে চান?';

  @override
  String get unsafe_url_warning =>
      'অবিশ্বাসযোগ্য উৎস থেকে লিংক খোলা নিরাপদ নাও হতে পারে। সতর্ক থাকুন!\nআপনি এটি ক্লিপবোর্ডে কপি করতে পারেন।';

  @override
  String get copy_link => 'লিংক কপি করুন';

  @override
  String get building_your_timeline =>
      'আপনার শোনার ধারা অনুযায়ী টাইমলাইন তৈরি করা হচ্ছে...';

  @override
  String get official => 'সরকারি';

  @override
  String author_name(Object author) {
    return 'লেখক: $author';
  }

  @override
  String get third_party => 'তৃতীয় পক্ষ';

  @override
  String get plugin_requires_authentication => 'প্লাগইনটি প্রমাণীকরণ প্রয়োজন';

  @override
  String get update_available => 'হালনাগাদ উপলব্ধ';

  @override
  String get supports_scrobbling => 'স্ক্রোব্বলিং সমর্থিত';

  @override
  String get plugin_scrobbling_info =>
      'এই প্লাগইনটি আপনার সঙ্গীত স্ক্রোব্বল করে আপনার শোনা ইতিহাস তৈরি করে।';

  @override
  String get default_metadata_source => 'ডিফল্ট মেটাডেটা উৎস';

  @override
  String get set_default_metadata_source => 'ডিফল্ট মেটাডেটা উৎস সেট করুন';

  @override
  String get default_audio_source => 'ডিফল্ট অডিও উৎস';

  @override
  String get set_default_audio_source => 'ডিফল্ট অডিও উৎস সেট করুন';

  @override
  String get set_default => 'ডিফল্ট হিসাবে নির্ধারণ করুন';

  @override
  String get support => 'সমর্থন';

  @override
  String get support_plugin_development => 'প্লাগইন উন্নয়নকে সমর্থন করুন';

  @override
  String can_access_name_api(Object name) {
    return '- **$name** API-তে অ্যাক্সেস করতে পারে';
  }

  @override
  String get do_you_want_to_install_this_plugin =>
      'আপনি কি এই প্লাগইন ইনস্টল করতে চান?';

  @override
  String get third_party_plugin_warning =>
      'এই প্লাগইন একটি তৃতীয় পক্ষের রেপোজিটরির। ইনস্টল করার আগে উৎস বিশ্বস্ত কিনা নিশ্চিত করুন।';

  @override
  String get author => 'লেখক';

  @override
  String get this_plugin_can_do_following => 'এই প্লাগইন নিচের কাজ করতে পারে';

  @override
  String get install => 'ইনস্টল করুন';

  @override
  String get install_a_metadata_provider =>
      'একটি মেটাডেটা প্রদানকারী ইনস্টল করুন';

  @override
  String get no_tracks_playing => 'বর্তমানে কোনো ট্র্যাক শোনা হচ্ছে না';

  @override
  String get synced_lyrics_not_available =>
      'এই গানের জন্য সিঙ্ক্রোনাইজড লিরিক্স পাওয়া যায় না। অনুগ্রহ করে ব্যবহার করুন';

  @override
  String get plain_lyrics => 'সহজ লিরিক্স';

  @override
  String get tab_instead => 'তার পরিবর্তে ট্যাব ব্যবহার করুন।';

  @override
  String get disclaimer => 'অস্বীকৃতি';

  @override
  String get third_party_plugin_dmca_notice =>
      'Spotube দল কোনো “তৃতীয় পক্ষ” প্লাগইনের জন্য কোনো (আইনগত সহ) দায়িত্ব নেয় না। নিজের বিপদে ব্যবহার করুন। কোনো বাগ/সমস্যা হলে প্লাগইন রেপোজিটরিতে জানাতে অনুরোধ করা হচ্ছে।\n\nযদি কোনো “তৃতীয় পক্ষ” প্লাগইন কোনো পরিষেবা/আইনগত সংস্থার ToS/DMCA ভূঙ্গ করে, অনুগ্রহ করে “তৃতীয় পক্ষ” প্লাগইনের লেখক বা হোস্টিং প্ল্যাটফর্মে (যেমন GitHub/Codeberg) পদক্ষেপ নিতে বলুন। “তৃতীয় পক্ষ” লেবেলযুক্ত যুক্তিগুলি সকলই পাবলিক/কমিউনিটি দ্বারা রক্ষণাবেক্ষণ করা হয়; আমরা সেগুলি কিউরেট করি না, তাই আমরা কোনো পদক্ষেপ নিতে পারি না।\n\n';

  @override
  String get input_does_not_match_format =>
      'ইনপুট প্রয়োজনীয় ফরম্যাটের সাথে মেলে না';

  @override
  String get plugins => 'প্লাগইন';

  @override
  String get paste_plugin_download_url =>
      'ডাউনলোড URL বা GitHub/Codeberg রিপো URL বা .smplug ফাইলের সরাসরি লিঙ্ক পেস্ট করুন';

  @override
  String get download_and_install_plugin_from_url =>
      'URL থেকে প্লাগইন ডাউনলোড এবং ইনস্টল করুন';

  @override
  String failed_to_add_plugin_error(Object error) {
    return 'প্লাগইন যোগ করতে ব্যর্থ: $error';
  }

  @override
  String get upload_plugin_from_file => 'ফাইল থেকে প্লাগইন আপলোড করুন';

  @override
  String get installed => 'ইনস্টল করা হয়েছে';

  @override
  String get available_plugins => 'উপলব্ধ প্লাগইনগুলো';

  @override
  String get configure_plugins =>
      'আপনার নিজের মেটাডেটা প্রদানকারী এবং অডিও উৎস প্লাগইন কনফিগার করুন';

  @override
  String get audio_scrobblers => 'অডিও স্ক্রোব্বলার্স';

  @override
  String get scrobbling => 'স্ক্রোব্বলিং';

  @override
  String get source => 'উৎস: ';

  @override
  String get uncompressed => 'অ-সংকুচিত';

  @override
  String get dab_music_source_description =>
      'অডিওফাইলদের জন্য। উচ্চ-মানের/লসলেস অডিও স্ট্রিম প্রদান করে। সঠিক ISRC ভিত্তিক ট্র্যাক ম্যাচিং।';
}
