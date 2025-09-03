// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Georgian (`ka`).
class AppLocalizationsKa extends AppLocalizations {
  AppLocalizationsKa([String locale = 'ka']) : super(locale);

  @override
  String get guest => 'სტუმარი';

  @override
  String get browse => 'ნახვა';

  @override
  String get search => 'ძებნა';

  @override
  String get library => 'ბიბლიოთეკა';

  @override
  String get lyrics => 'ტექსტები';

  @override
  String get settings => 'კონფიგურაციები';

  @override
  String get genre_categories_filter => 'კატეგორიების ან ჟანრების ფილტრი...';

  @override
  String get genre => 'ჟანრი';

  @override
  String get personalized => 'პეერსონალიზებული';

  @override
  String get featured => 'გამორჩეული';

  @override
  String get new_releases => 'ახალი გამოცემები';

  @override
  String get songs => 'სიმღერები';

  @override
  String playing_track(Object track) {
    return 'უკრავს $track';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return 'ეს გაასუფთავებს მიმდინარე რიგს. $track_length ტრეკი წაიშლება\nᲒინდა გააგრძელო?';
  }

  @override
  String get load_more => 'მეტის ჩატვირთვა';

  @override
  String get playlists => 'ფლეილისტები';

  @override
  String get artists => 'არტისტები';

  @override
  String get albums => 'ალბომები';

  @override
  String get tracks => 'ტრეკები';

  @override
  String get downloads => 'ჩამოტვირთვები';

  @override
  String get filter_playlists => 'ფლეილისტების გაფილტვრა...';

  @override
  String get liked_tracks => 'მოწონებული ტრეკები';

  @override
  String get liked_tracks_description => 'ყველა შენი მოწონებული ტრეკი';

  @override
  String get playlist => 'პლეისთი';

  @override
  String get create_a_playlist => 'ფლეილისტის შექმნა';

  @override
  String get update_playlist => 'ფლეილისტის განახლება';

  @override
  String get create => 'შექმნა';

  @override
  String get cancel => 'გაუქმება';

  @override
  String get update => 'განახლება';

  @override
  String get playlist_name => 'ფლეილისტის სახელი';

  @override
  String get name_of_playlist => 'ფლეილისტის სახელი';

  @override
  String get description => 'აღწერა';

  @override
  String get public => 'საჯარო';

  @override
  String get collaborative => 'კოლაბორაციული';

  @override
  String get search_local_tracks => 'ლოცალური ტრეკების ძებნა...';

  @override
  String get play => 'დაკვრა';

  @override
  String get delete => 'წაშლა';

  @override
  String get none => 'არცერთი';

  @override
  String get sort_a_z => 'დალაგება A-Z-ს მიხედვით';

  @override
  String get sort_z_a => 'დალაგება Z-A-ს მიხედვით';

  @override
  String get sort_artist => 'დალაგება არტისტის მიხედვით';

  @override
  String get sort_album => 'დალაგება ალბომის მიხედვით';

  @override
  String get sort_duration => 'დალაგება ხანგრძლივობის მიხედვით';

  @override
  String get sort_tracks => 'ტრეკების დალაგება';

  @override
  String currently_downloading(Object tracks_length) {
    return 'მიმდინარეობს ჩამოტვირთვა ($tracks_length)';
  }

  @override
  String get cancel_all => 'ყველას გაუქმება';

  @override
  String get filter_artist => 'არტისტების ფილტრი...';

  @override
  String followers(Object followers) {
    return '$followers ფოლოვერები';
  }

  @override
  String get add_artist_to_blacklist => 'არტისტის შავ სიაში დამატება';

  @override
  String get top_tracks => 'ტოპ ტრეკები';

  @override
  String get fans_also_like => 'ფანებს ასევე მოსწონთ';

  @override
  String get loading => 'იტვირთება...';

  @override
  String get artist => 'არტისტი';

  @override
  String get blacklisted => 'შავ სიაში მყოფი';

  @override
  String get following => 'ფოლოვინგი';

  @override
  String get follow => 'დაფოლოვება';

  @override
  String get artist_url_copied => 'არტისტის ლინკი დაკოპირებულია';

  @override
  String added_to_queue(Object tracks) {
    return '$tracks ტრეკი დაემატა რიგში';
  }

  @override
  String get filter_albums => 'ალბომების გაფილტვრა...';

  @override
  String get synced => 'სინქრონიზებული';

  @override
  String get plain => 'Plain';

  @override
  String get shuffle => 'რიგის არევა';

  @override
  String get search_tracks => 'ტრეკების ძებნა...';

  @override
  String get released => 'გამოშვებული';

  @override
  String error(Object error) {
    return 'შეცდომა $error';
  }

  @override
  String get title => 'სათაური';

  @override
  String get time => 'დრო';

  @override
  String get more_actions => 'მეტი მოქმედებები';

  @override
  String download_count(Object count) {
    return 'გადმოწერა ($count)';
  }

  @override
  String add_count_to_playlist(Object count) {
    return 'ფლეილისტში ($count)-ის დამატება';
  }

  @override
  String add_count_to_queue(Object count) {
    return 'რიგში ($count)-ის დამატება';
  }

  @override
  String play_count_next(Object count) {
    return 'შემდეგი ($count)-ის დაკვრა';
  }

  @override
  String get album => 'ალბომი';

  @override
  String copied_to_clipboard(Object data) {
    return '$data დაკოპირებულია';
  }

  @override
  String add_to_following_playlists(Object track) {
    return 'დაამატე $track ამ ფლეილისტებში';
  }

  @override
  String get add => 'დამატება';

  @override
  String added_track_to_queue(Object track) {
    return 'რიგში დაემატა $track';
  }

  @override
  String get add_to_queue => 'რიგში დამატება';

  @override
  String track_will_play_next(Object track) {
    return '$track დაუკრავს შემდეგს';
  }

  @override
  String get play_next => 'შემდეგის დაკვრა';

  @override
  String removed_track_from_queue(Object track) {
    return 'რიგიდან წაიშალა $track';
  }

  @override
  String get remove_from_queue => 'რიგიდან წაშლა';

  @override
  String get remove_from_favorites => 'ფავორიტებიდან წაშლა';

  @override
  String get save_as_favorite => 'ფავორიტებში დამატება';

  @override
  String get add_to_playlist => 'ფლეილისტში დამატება';

  @override
  String get remove_from_playlist => 'ფლეილისტიდან წაშლა';

  @override
  String get add_to_blacklist => 'შავ სიაში დამატება';

  @override
  String get remove_from_blacklist => 'შავი სიიდან წაშლა';

  @override
  String get share => 'გაზიარება';

  @override
  String get mini_player => 'მინი დამკვრელი';

  @override
  String get slide_to_seek => 'გადახვევისთვის გაასრიალეთ წინ ან უკან';

  @override
  String get shuffle_playlist => 'ფლეილისტის არევა';

  @override
  String get unshuffle_playlist => 'ფლეილისტის დალაგება';

  @override
  String get previous_track => 'წინა ტრეკი';

  @override
  String get next_track => 'შემდეგი ტრეკი';

  @override
  String get pause_playback => 'დაკვრის გაჩერება';

  @override
  String get resume_playback => 'დაკვრის გაგრძელება';

  @override
  String get loop_track => 'ტრეკის ლუპზე დაკვრა';

  @override
  String get no_loop => 'არ არის ციკლი';

  @override
  String get repeat_playlist => 'ფლეილისტის გამეორება';

  @override
  String get queue => 'რიგი';

  @override
  String get alternative_track_sources => 'ალტერნატიული ტრეკების წყაროები';

  @override
  String get download_track => 'გადმოწერე ტრეკი';

  @override
  String tracks_in_queue(Object tracks) {
    return '$tracks ტრეკი რიგში';
  }

  @override
  String get clear_all => 'ყველას წაშლა';

  @override
  String get show_hide_ui_on_hover => 'UI-ის ჩვენება/დამალვა ჰოვერზე';

  @override
  String get always_on_top => 'ტოველთვის ზემოდან';

  @override
  String get exit_mini_player => 'მინი დამკვრელიდან გამოსვლა';

  @override
  String get download_location => 'ჩამოტვირთვის მდებარეობა';

  @override
  String get local_library => 'ადგილობრივი ბიბლიოთეკა';

  @override
  String get add_library_location => 'ბიბლიოთეკაში დამატება';

  @override
  String get remove_library_location => 'ბიბლიოთეკიდან წაშლა';

  @override
  String get account => 'ანგარიში';

  @override
  String get logout => 'გასვლა';

  @override
  String get logout_of_this_account => 'ანგარიშიდან გასვლა';

  @override
  String get language_region => 'ენა და რეგიონი';

  @override
  String get language => 'ენა';

  @override
  String get system_default => 'სისტემის ნაგულისხმევი';

  @override
  String get market_place_region => 'მარკეტფლეისის რეგიონი';

  @override
  String get recommendation_country => 'რეკომენდირებული ქვეყანა';

  @override
  String get appearance => 'გარეგნობა';

  @override
  String get layout_mode => 'განლაგების რეჟიმი';

  @override
  String get override_layout_settings =>
      'რესფონსივ განლაგების რეჟიმის კონფიგურაციაზე გადაწერა';

  @override
  String get adaptive => 'ადაპტირებული';

  @override
  String get compact => 'კომპაქტური';

  @override
  String get extended => 'გაფართოებული';

  @override
  String get theme => 'თემა';

  @override
  String get dark => 'ბნელი';

  @override
  String get light => 'ღია';

  @override
  String get system => 'სისტემის';

  @override
  String get accent_color => 'აქცენტის ფერი';

  @override
  String get sync_album_color => 'ალბომის ფერის სინქრონიზაცია';

  @override
  String get sync_album_color_description =>
      'დომინანტური ალბომის ფერის აქცენტის ფერად გამოყენება';

  @override
  String get playback => 'დაკვრა';

  @override
  String get audio_quality => 'აუდიოს ხარისხი';

  @override
  String get high => 'მაღალი';

  @override
  String get low => 'დაბალი';

  @override
  String get pre_download_play => 'წინასწარ ჩამოტვირთვა და დაკვრა';

  @override
  String get pre_download_play_description =>
      'აუდიოს სტრიმინგის ნაცვლად, ბაიტების ჩამოტვირთვა და დაკვრა (რეკომენდებულია უფრო მაღალი გამტარუნარიანობის მომხმარებლებისთვის)';

  @override
  String get skip_non_music =>
      'არა მუსიკალური ნაწილის გამოტოვება (სპონსორის ბლოკი)';

  @override
  String get blacklist_description => 'შავ სიაში მყოფი არტისტები და ტრეკები';

  @override
  String get wait_for_download_to_finish =>
      'გთხოვთ, დაელოდოთ მიმდინარე ჩამოტვირთვის დასრულებას';

  @override
  String get desktop => 'დესკტოპი';

  @override
  String get close_behavior => 'დახურვის ქცევა';

  @override
  String get close => 'დახურვა';

  @override
  String get minimize_to_tray => 'მინიმიზაცია';

  @override
  String get show_tray_icon => 'სისტემის აიკონის ჩვენება';

  @override
  String get about => 'ჩვენს შესახებ';

  @override
  String get u_love_spotube => 'We know you love Spotube';

  @override
  String get check_for_updates => 'განახლებების შემოწმება';

  @override
  String get about_spotube => 'Spotube-ს შესახებ';

  @override
  String get blacklist => 'შავი სია';

  @override
  String get please_sponsor => 'გთხოვთ დაგვასპონსოროთ';

  @override
  String get spotube_description =>
      'Spotube, a lightweight, cross-platform, free-for-all spotify client';

  @override
  String get version => 'ვერსია';

  @override
  String get build_number => 'Build Number';

  @override
  String get founder => 'დამფუძნებელი';

  @override
  String get repository => 'რეპოზიტორია';

  @override
  String get bug_issues => 'Bug+Issues';

  @override
  String get made_with => 'Made with ❤️ in Bangladesh🇧🇩';

  @override
  String get kingkor_roy_tirtho => 'Kingkor Roy Tirtho';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year Kingkor Roy Tirtho';
  }

  @override
  String get license => 'ლიცენზია';

  @override
  String get credentials_will_not_be_shared_disclaimer =>
      'არ ინერვიულოთ, თქვენი მონაცემები არ იქნება შეგროვებული ან გაზიარებული ვინმესთან';

  @override
  String get know_how_to_login => 'არ იცით როგორ გააკეთოთ ეს?';

  @override
  String get follow_step_by_step_guide =>
      'მიჰყევით ნაბიჯ-ნაბიჯ სახელმძღვანელოს';

  @override
  String cookie_name_cookie(Object name) {
    return '$name ქუქი';
  }

  @override
  String get fill_in_all_fields => 'გთხოვთ შეავსოთ ყველა ველი';

  @override
  String get submit => 'გაგზავნა';

  @override
  String get exit => 'გამოსვლა';

  @override
  String get previous => 'წინა';

  @override
  String get next => 'შემდეგი';

  @override
  String get done => 'მზადაა';

  @override
  String get step_1 => 'ნაბიჯი 1';

  @override
  String get first_go_to => 'პირველი, გადადით';

  @override
  String get something_went_wrong => 'Რაღაც არასწორად წავიდა';

  @override
  String get piped_instance => 'Piped Server Instance';

  @override
  String get piped_description =>
      'The Piped server instance to use for track matching';

  @override
  String get piped_warning => 'ზოგიერთი მათგანმა შეიძლება კარგად არ იმუშაოს. ';

  @override
  String get invidious_instance => 'Invidious სერვერის ინსტანცია';

  @override
  String get invidious_description =>
      'Invidious სერვერის ინსტანცია, რომელიც გამოიყენება ტრეკის შესატყვისად';

  @override
  String get invidious_warning =>
      'ზოგიერთი შეიძლება კარგად არ მუშაობდეს. გამოიყენეთ თქვენს პასუხისმგებლობაზე';

  @override
  String get generate => 'გააგენერირეთ';

  @override
  String track_exists(Object track) {
    return 'ტრეკი $track უკვე არსებობს';
  }

  @override
  String get replace_downloaded_tracks => 'ყველა ჩამოტვირთული ტრეკის შეცვლა';

  @override
  String get skip_download_tracks => 'ყველა ჩამოტვირთული ტრეკის გამოტოვება';

  @override
  String get do_you_want_to_replace => 'გსურთ შეცვალოთ არსებული ტრეკი??';

  @override
  String get replace => 'შეცვლა';

  @override
  String get skip => 'გამოტოვება';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return 'აირჩიე $count-მდე $type';
  }

  @override
  String get select_genres => 'ჟანრების არჩევა';

  @override
  String get add_genres => 'ჟანრების დამატება';

  @override
  String get country => 'ქვეყანა';

  @override
  String get number_of_tracks_generate => 'დასაგენერირებელი ტრეკების რაოდენობა';

  @override
  String get acousticness => 'Acousticness';

  @override
  String get danceability => 'Danceability';

  @override
  String get energy => 'Energy';

  @override
  String get instrumentalness => 'Instrumentalness';

  @override
  String get liveness => 'Liveness';

  @override
  String get loudness => 'Loudness';

  @override
  String get speechiness => 'Speechiness';

  @override
  String get valence => 'Valence';

  @override
  String get popularity => 'Popularity';

  @override
  String get key => 'Key';

  @override
  String get duration => 'Duration (s)';

  @override
  String get tempo => 'Tempo (BPM)';

  @override
  String get mode => 'Mode';

  @override
  String get time_signature => 'Time Signature';

  @override
  String get short => 'Short';

  @override
  String get medium => 'საშუალო';

  @override
  String get long => 'გრძელი';

  @override
  String get min => 'მინიმალური';

  @override
  String get max => 'მაქსიმალური';

  @override
  String get target => 'სამიზნე';

  @override
  String get moderate => 'საშუალო';

  @override
  String get deselect_all => 'ყველა მონიშვნის გაუქმება';

  @override
  String get select_all => 'ყველას მონიშვნა';

  @override
  String get are_you_sure => 'Დარწმუნებული ხართ?';

  @override
  String get generating_playlist =>
      'მიმდინარეობს თქვენი მორგებული ფლეილისტის გენერირება...';

  @override
  String selected_count_tracks(Object count) {
    return 'არჩეულია $count ტრეკი';
  }

  @override
  String get download_warning =>
      'If you download all Tracks at bulk you\'re clearly pirating Music & causing damage to the creative society of Music. I hope you are aware of this. Always, try respecting & supporting Artist\'s hard work';

  @override
  String get download_ip_ban_warning =>
      'BTW, your IP can get blocked on YouTube due excessive download requests than usual. IP block means you can\'t use YouTube (even if you\'re logged in) for at least 2-3 months from that IP device. And Spotube doesn\'t hold any responsibility if this ever happens';

  @override
  String get by_clicking_accept_terms =>
      'By clicking \'accept\' you agree to following terms:';

  @override
  String get download_agreement_1 => 'I know I\'m pirating Music. I\'m bad';

  @override
  String get download_agreement_2 =>
      'I\'ll support the Artist wherever I can and I\'m only doing this because I don\'t have money to buy their art';

  @override
  String get download_agreement_3 =>
      'I\'m completely aware that my IP can get blocked on YouTube & I don\'t hold Spotube or his owners/contributors responsible for any accidents caused by my current action';

  @override
  String get decline => 'უარყოფა';

  @override
  String get accept => 'დათანხმება';

  @override
  String get details => 'დეტალები';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => 'Channel';

  @override
  String get likes => 'მოწონებები';

  @override
  String get dislikes => 'არ მოწონებები';

  @override
  String get views => 'ნახვები';

  @override
  String get streamUrl => 'სტრიმის ლინკი';

  @override
  String get stop => 'გაჩერება';

  @override
  String get sort_newest => 'ფალაგება სიახლის მიხედიტ';

  @override
  String get sort_oldest => 'დალაგება სიძველის მიხედვით';

  @override
  String get sleep_timer => 'ძილის ტაიმერი';

  @override
  String mins(Object minutes) {
    return '$minutes წუთი';
  }

  @override
  String hours(Object hours) {
    return '$hours საათი';
  }

  @override
  String hour(Object hours) {
    return '$hours საათი';
  }

  @override
  String get custom_hours => 'მორგებული საათები';

  @override
  String get logs => 'ლოგები';

  @override
  String get developers => 'დეველოპერები';

  @override
  String get not_logged_in => 'არ ხარ დალოგინებული';

  @override
  String get search_mode => 'ძებნის რეჟიმი';

  @override
  String get audio_source => 'აუდიოს წყარო';

  @override
  String get ok => 'ოკ';

  @override
  String get failed_to_encrypt => 'დაშიფვრა ვერ მოხერხდა';

  @override
  String get encryption_failed_warning =>
      'Spotube uses encryption to securely store your data. But failed to do so. So it\'ll fallback to insecure storage\nIf you\'re using linux, please make sure you\'ve any secret-service (gnome-keyring, kde-wallet, keepassxc etc) installed';

  @override
  String get querying_info => 'Querying info...';

  @override
  String get piped_api_down => 'Piped API is down';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return 'The Piped instance $pipedInstance is currently down\n\nEither change the instance or change the \'API type\' to official YouTube API\n\nMake sure to restart the app after change';
  }

  @override
  String get you_are_offline => 'ამჟამად ხაზგარეშე ხართ';

  @override
  String get connection_restored => 'თქვენი ინტერნეტ კავშირი აღდგა';

  @override
  String get use_system_title_bar => 'სისტემის სათაურის ზოლის გამოყენება';

  @override
  String get crunching_results => 'იტვირთება შედეგები...';

  @override
  String get search_to_get_results => 'მოძებნეთ შედეგების მისაღებად';

  @override
  String get use_amoled_mode => 'Pitch black dark theme';

  @override
  String get pitch_dark_theme => 'AMOLED Mode';

  @override
  String get normalize_audio => 'აუდიოს ნორმალიზება';

  @override
  String get change_cover => 'Ქავერის შეცვლა';

  @override
  String get add_cover => 'Ქავერის ფოტოს დამატება';

  @override
  String get restore_defaults => 'ნაგულისხმევი პარამეტრების აღდგენა';

  @override
  String get download_music_codec => 'მუსიკის კოდეკის გადმოწერა';

  @override
  String get streaming_music_codec => 'სტრიმინგ მუსიკის კოდეკი';

  @override
  String get login_with_lastfm => 'Last.fm-ით შესვლა';

  @override
  String get connect => 'დაკავშირება';

  @override
  String get disconnect_lastfm => 'Last.fm-იდან გამოსვლა';

  @override
  String get disconnect => 'გამოსვლა';

  @override
  String get username => 'მომხმარებელი';

  @override
  String get password => 'პაროლი';

  @override
  String get login => 'შესვლა';

  @override
  String get login_with_your_lastfm => 'Last.fm ანგარიშით შესვლა';

  @override
  String get scrobble_to_lastfm => 'Scrobble to Last.fm';

  @override
  String get go_to_album => 'ალბომზე გადასვლა';

  @override
  String get discord_rich_presence => 'Discord Rich Presence';

  @override
  String get browse_all => 'ყველას ნახვა';

  @override
  String get genres => 'ჟანრები';

  @override
  String get explore_genres => 'შეისწავლეთ ჟანრები';

  @override
  String get friends => 'მეგობრები';

  @override
  String get no_lyrics_available =>
      'უკაცრავად, ამ ტრეკისთვის ტექსტის პოვნა შეუძლებელია';

  @override
  String get start_a_radio => 'რადიოს ჩართვა';

  @override
  String get how_to_start_radio => 'როგორ გნებავთ რადიოს ჩართვა?';

  @override
  String get replace_queue_question =>
      'გნებავთ ჩაანაცვლოთ არსებული რიგი თუ დაამატოთ მასზე?';

  @override
  String get endless_playback => 'დაუსრულებელი დაკვრა';

  @override
  String get delete_playlist => 'ფლეილისტის წაშლა';

  @override
  String get delete_playlist_confirmation =>
      'დარწმუნებული ხართ რომ გნებავთ ფლეილისტის წაშლა?';

  @override
  String get local_tracks => 'ლოკალური ტრეკები';

  @override
  String get local_tab => 'ადგილობრივი';

  @override
  String get song_link => 'ტრეკის ლინკი';

  @override
  String get skip_this_nonsense => 'ამ სისულელის გამოტოვება';

  @override
  String get freedom_of_music => '“მუსიკის თავისუფლება”';

  @override
  String get freedom_of_music_palm => '“მუსიკის თავისუფლება შენს ხელის გულზე”';

  @override
  String get get_started => 'დავიწყოთ';

  @override
  String get youtube_source_description =>
      'რეკომენდებულია და მუშაობს საუკეთესოდ.';

  @override
  String get piped_source_description =>
      'თავისუფლად გრძნობთ თავს? იგივეა, რაც YouTube, მაგრამ ბევრი თავისუფალი.';

  @override
  String get jiosaavn_source_description =>
      'საუკეთესოა სამხრეთ აზიის რეგიონისთვის.';

  @override
  String get invidious_source_description =>
      'მსგავსია Piped-ის, მაგრამ მაღალი ხელმისაწვდომობით.';

  @override
  String highest_quality(Object quality) {
    return 'საუკეთესო ხარისხი: $quality';
  }

  @override
  String get select_audio_source => 'აუდიოს წყაროს არჩევა';

  @override
  String get endless_playback_description =>
      'ახალი სიმთერების ავტომატურად რიგის ბოლოში დამატება';

  @override
  String get choose_your_region => 'აირჩიე შენი რეგიონი';

  @override
  String get choose_your_region_description =>
      'This will help Spotube show you the right content\nfor your location.';

  @override
  String get choose_your_language => 'აირჩიე ენა';

  @override
  String get help_project_grow => 'დაეხმარეთ ამ პროექტს განვითარებაში';

  @override
  String get help_project_grow_description =>
      'Spotube is an open-source project. You can help this project grow by contributing to the project, reporting bugs, or suggesting new features.';

  @override
  String get contribute_on_github => 'GitHub-ზე კონტრიბუცია';

  @override
  String get donate_on_open_collective => 'Open Collective-ზე დონაცია';

  @override
  String get browse_anonymously => 'ანონიმურად ნახვა';

  @override
  String get enable_connect => 'დაკავშირების ჩართვა';

  @override
  String get enable_connect_description =>
      'აკონტროლე Spotube სხვა მოწყობილობებიდან';

  @override
  String get devices => 'მოწყობილობები';

  @override
  String get select => 'არჩევა';

  @override
  String connect_client_alert(Object client) {
    return 'თქვენ კონტროლირებული ხართ $client მოწყობილობით';
  }

  @override
  String get this_device => 'ეს მოწყობილობა';

  @override
  String get remote => 'დისტანციური';

  @override
  String get stats => 'სტატისტიკა';

  @override
  String and_n_more(Object count) {
    return 'და $count მეტი';
  }

  @override
  String get recently_played => 'მიუწვდელი';

  @override
  String get browse_more => 'დაიცალეთ მეტი';

  @override
  String get no_title => 'არ აქვს სათაური';

  @override
  String get not_playing => 'არ ერთვის';

  @override
  String get epic_failure => 'ეპიკური მარცხი!';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return 'დამატებული $tracks_length ტრეკი რიგში';
  }

  @override
  String get spotube_has_an_update => 'Spotube-ს აქვს განახლება';

  @override
  String get download_now => 'ჩამოტვირთეთ ახლავე';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Spotube Nightly $nightlyBuildNum გამოშვებულია';
  }

  @override
  String release_version(Object version) {
    return 'Spotube v$version გამოშვებულია';
  }

  @override
  String get read_the_latest => 'წაიკითხეთ უახლესი ';

  @override
  String get release_notes => 'გამოშვების შენიშვნები';

  @override
  String get pick_color_scheme => 'აირჩიეთ ფერის სქემა';

  @override
  String get save => 'შეინახეთ';

  @override
  String get choose_the_device => 'აირჩიეთ მოწყობილობა:';

  @override
  String get multiple_device_connected =>
      'დაკავშირებულია რამდენიმე მოწყობილობა.\nაირჩიეთ მოწყობილობა, რომელზეც უნდა განხორციელდეს ეს მოქმედება';

  @override
  String get nothing_found => 'არაფერი მოიძებნა';

  @override
  String get the_box_is_empty => 'კვადრატია ცარიელი';

  @override
  String get top_artists => 'ტოპ არტისტები';

  @override
  String get top_albums => 'ტოპ ალბომები';

  @override
  String get this_week => 'ამ კვირას';

  @override
  String get this_month => 'ამ თვეში';

  @override
  String get last_6_months => 'ბოლო 6 თვე';

  @override
  String get this_year => 'ამ წელს';

  @override
  String get last_2_years => 'ბოლო 2 წელი';

  @override
  String get all_time => 'ყველა დრო';

  @override
  String powered_by_provider(Object providerName) {
    return '$providerName-ით გაწვდილი';
  }

  @override
  String get email => 'ელ. ფოსტა';

  @override
  String get profile_followers => 'გამყვანები';

  @override
  String get birthday => 'დაბადების დღე';

  @override
  String get subscription => 'გამოწერა';

  @override
  String get not_born => 'არ დაბადებულა';

  @override
  String get hacker => 'ჰაკერი';

  @override
  String get profile => 'პროფილი';

  @override
  String get no_name => 'არ არის სახელი';

  @override
  String get edit => 'რედაქტირება';

  @override
  String get user_profile => 'მომხმარებლის პროფილი';

  @override
  String count_plays(Object count) {
    return '$count გაწვდვა';
  }

  @override
  String get streaming_fees_hypothetical =>
      '*ეს рассчитывается на основе выплат за поток от Spotify\nот \$0.003 до \$0.005. ეს ჰიპოთეტური გამოთვლა იძლევა მომხმარებელს წარმოდგენას იმაზე, რამდენად\nგადახდილი იქნებოდა არტისტებისთვის, თუ მათ მოუსმინოს Spotify-ს ტრეკებს.';

  @override
  String get minutes_listened => 'წუთები მოუსმინეს';

  @override
  String get streamed_songs => 'სტრიმირებული სიმღერები';

  @override
  String count_streams(Object count) {
    return '$count სტრიმი';
  }

  @override
  String get owned_by_you => 'შენ მიერ საკუთრებული';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return '$shareUrl აიღო კლიპბორდზე';
  }

  @override
  String get hipotetical_calculation =>
      '*This is calculated based on average online music streaming platform\'s per stream\npayout of \$0.003 to \$0.005. This is a hypothetical\ncalculation to give user insight about how much they\nwould have paid to the artists if they were to listen\ntheir song in different music streaming platform.';

  @override
  String count_mins(Object minutes) {
    return '$minutes წუთი';
  }

  @override
  String get summary_minutes => 'წუთები';

  @override
  String get summary_listened_to_music => 'მუსიკა გაწვდილი';

  @override
  String get summary_songs => 'მელოდია';

  @override
  String get summary_streamed_overall => 'გაწვდილი საერთო';

  @override
  String get summary_owed_to_artists => 'გადასახადი არტისტებს\nამ თვეში';

  @override
  String get summary_artists => 'არტისტების';

  @override
  String get summary_music_reached_you => 'მუსიკა ჩაგივარდა';

  @override
  String get summary_full_albums => 'სრული ალბომები';

  @override
  String get summary_got_your_love => 'მოსულა თქვენი სიყვარული';

  @override
  String get summary_playlists => 'პლეილისტები';

  @override
  String get summary_were_on_repeat => 'გადაწვდილი იყო';

  @override
  String total_money(Object money) {
    return 'მთლიანი $money';
  }

  @override
  String get webview_not_found => 'ვებვიუ ვერ მოიძებნა';

  @override
  String get webview_not_found_description =>
      'თქვენს მოწყობილობაზე ვებვიუის შესრულების დრო არ არის დაყენებული.\nთუ დაყენებულია, დარწმუნდით, რომ ის environment PATH-შია\n\nდაყენების შემდეგ, გადატვირთეთ აპი';

  @override
  String get unsupported_platform => 'მოუხერხებელი პლატფორმა';

  @override
  String get cache_music => 'მუსიკის ქეში';

  @override
  String get open => 'გახსენით';

  @override
  String get cache_folder => 'ქეშის საქაღალდე';

  @override
  String get export => 'ექსპორტი';

  @override
  String get clear_cache => 'ქეშის გასუფთავება';

  @override
  String get clear_cache_confirmation => 'გსურთ ქეშის გასუფთავება?';

  @override
  String get export_cache_files => 'ქეშირებული ფაილების ექსპორტი';

  @override
  String found_n_files(Object count) {
    return 'ნაპოვნია $count ფაილი';
  }

  @override
  String get export_cache_confirmation => 'გსურთ ამ ფაილების ექსპორტი';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return '$filesExported ფაილი $files-დან ექსპორტირებულია';
  }

  @override
  String get undo => 'დაბრუნება';

  @override
  String get download_all => 'ყველას ჩამოტვირთვა';

  @override
  String get add_all_to_playlist => 'ყველა დაამატეთ პლეისთში';

  @override
  String get add_all_to_queue => 'ყველა დაამატეთ რიგში';

  @override
  String get play_all_next => 'ყველა შემდეგ ითამაშე';

  @override
  String get pause => 'შეჩერება';

  @override
  String get view_all => 'ყველა ნახვა';

  @override
  String get no_tracks_added_yet =>
      'გაჩნდება რომ ჯერ არ გაქვთ დამატებული ტრეკები';

  @override
  String get no_tracks => 'გავლებული არ ჩანს არ არსებობს ტრეკები';

  @override
  String get no_tracks_listened_yet =>
      'გქონდეთ გრძნობა, რომ ჯერ არაფერი უსმენია';

  @override
  String get not_following_artists => 'არ მიჰყვებით რომელიმე არტისტს';

  @override
  String get no_favorite_albums_yet =>
      'გაჩნდება რომ ჯერ არ გაქვთ დამატებული ალბომები თქვენს ფავორიტებში';

  @override
  String get no_logs_found => 'ჩაწერები ვერ მოიძებნა';

  @override
  String get youtube_engine => 'YouTube ძრავა';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engine არ არის ინსტალირებული';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engine არ არის ინსტალირებული თქვენს სისტემაში.';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return 'დარწმუნდით, რომ ის ხელმისაწვდომია PATH ცვლადში ან\nდაუყავით $engine პროგრამის ფაილის სრული გზა';
  }

  @override
  String get youtube_engine_unix_issue_message =>
      'macOS/Linux/Unix მსგავსი ოპერაციული სისტემებში, .zshrc/.bashrc/.bash_profile-ით პათის დაყენება ვერ იმუშავებს.\nთქვენ უნდა დააყენოთ პათი შელ ფაილში';

  @override
  String get download => 'ჩამოტვირთვა';

  @override
  String get file_not_found => 'ფაილი ვერ მოიძებნა';

  @override
  String get custom => 'პერსონალიზირებული';

  @override
  String get add_custom_url => 'დამატება პერსონალური URL';

  @override
  String get edit_port => 'პორტის რედაქტირება';

  @override
  String get port_helper_msg =>
      'ნაგულისხმევი არის -1, რაც შემთხვევითი ნომრის მითითებას ნიშნავს. თუ لديك firewall настроен, рекомендуется установить это.';

  @override
  String connect_request(Object client) {
    return '$client-ის დაკავშირების ნებართვა?';
  }

  @override
  String get connection_request_denied =>
      'კავშირი უარყოფილია. მომხმარებელმა უარყო წვდომა.';

  @override
  String get an_error_occurred => 'An error occurred';

  @override
  String get copy_to_clipboard => 'Copy to clipboard';

  @override
  String get view_logs => 'View logs';

  @override
  String get retry => 'Retry';

  @override
  String get no_default_metadata_provider_selected =>
      'You\'ve no default metadata provider set';

  @override
  String get manage_metadata_providers => 'Manage metadata providers';

  @override
  String get open_link_in_browser => 'Open Link in Browser?';

  @override
  String get do_you_want_to_open_the_following_link =>
      'Do you want to open the following link';

  @override
  String get unsafe_url_warning =>
      'It can be unsafe to open links from untrusted sources. Be cautious!\nYou can also copy the link to your clipboard.';

  @override
  String get copy_link => 'Copy Link';

  @override
  String get building_your_timeline =>
      'Building your timeline based on your listenings...';

  @override
  String get official => 'Official';

  @override
  String author_name(Object author) {
    return 'Author: $author';
  }

  @override
  String get third_party => 'Third-party';

  @override
  String get plugin_requires_authentication => 'Plugin requires authentication';

  @override
  String get update_available => 'Update available';

  @override
  String get supports_scrobbling => 'Supports scrobbling';

  @override
  String get plugin_scrobbling_info =>
      'This plugin scrobbles your music to generate your listening history.';

  @override
  String get default_plugin => 'Default';

  @override
  String get set_default => 'Set default';

  @override
  String get support => 'Support';

  @override
  String get support_plugin_development => 'Support plugin development';

  @override
  String can_access_name_api(Object name) {
    return '- Can access **$name** API';
  }

  @override
  String get do_you_want_to_install_this_plugin =>
      'Do you want to install this plugin?';

  @override
  String get third_party_plugin_warning =>
      'This plugin is from a third-party repository. Please ensure you trust the source before installing.';

  @override
  String get author => 'Author';

  @override
  String get this_plugin_can_do_following => 'This plugin can do following';

  @override
  String get install => 'Install';

  @override
  String get install_a_metadata_provider => 'Install a Metadata Provider';

  @override
  String get no_tracks_playing => 'No Track being played currently';

  @override
  String get synced_lyrics_not_available =>
      'Synced lyrics are not available for this song. Please use the';

  @override
  String get plain_lyrics => 'Plain Lyrics';

  @override
  String get tab_instead => 'tab instead.';

  @override
  String get disclaimer => 'Disclaimer';

  @override
  String get third_party_plugin_dmca_notice =>
      'The Spotube team does not hold any responsibility (including legal) for any \"Third-party\" plugins.\nPlease use them at your own risk. For any bugs/issues, please report them to the plugin repository.\n\nIf any \"Third-party\" plugin is breaking ToS/DMCA of any service/legal entity, please ask the \"Third-party\" plugin author or the hosting platform .e.g GitHub/Codeberg to take action. Above listed (\"Third-party\" labelled) are all public/community maintained plugins. We\'re not curating them, so we cannot take any action on them.\n\n';

  @override
  String get input_does_not_match_format =>
      'Input doesn\'t match the required format';

  @override
  String get metadata_provider_plugins => 'Metadata Provider Plugins';

  @override
  String get paste_plugin_download_url =>
      'Paste download url or GitHub/Codeberg repo url or direct link to .smplug file';

  @override
  String get download_and_install_plugin_from_url =>
      'Download and install plugin from url';

  @override
  String failed_to_add_plugin_error(Object error) {
    return 'Failed to add plugin: $error';
  }

  @override
  String get upload_plugin_from_file => 'Upload plugin from file';

  @override
  String get installed => 'Installed';

  @override
  String get available_plugins => 'Available plugins';

  @override
  String get configure_your_own_metadata_plugin =>
      'Configure your own playlist/album/artist/feed metadata provider';

  @override
  String get audio_scrobblers => 'Audio Scrobblers';

  @override
  String get scrobbling => 'Scrobbling';
}
