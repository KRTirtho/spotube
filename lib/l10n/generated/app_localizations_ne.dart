// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class AppLocalizationsNe extends AppLocalizations {
  AppLocalizationsNe([String locale = 'ne']) : super(locale);

  @override
  String get guest => 'अतिथि';

  @override
  String get browse => 'ब्राउज़ गर्नुहोस्';

  @override
  String get search => 'खोजी गर्नुहोस्';

  @override
  String get library => 'पुस्तकालय';

  @override
  String get lyrics => 'गीतको शब्द';

  @override
  String get settings => 'सेटिङ';

  @override
  String get genre_categories_filter => 'शैली वा शैलीहरू फिल्टर गर्नुहोस्...';

  @override
  String get genre => 'शैली';

  @override
  String get personalized => 'व्यक्तिगत';

  @override
  String get featured => 'विशेष';

  @override
  String get new_releases => 'नयाँ रिलिज';

  @override
  String get songs => 'गीतहरू';

  @override
  String playing_track(Object track) {
    return '$track बज्यो';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return 'यो हालको कतारलाई हटाउँछ। $track_length ट्र्याकहरू हटाईन्छ\nके तपाईं जारी राख्न चाहनुहुन्छ?';
  }

  @override
  String get load_more => 'थप लोड गर्नुहोस्';

  @override
  String get playlists => 'प्लेलिस्टहरू';

  @override
  String get artists => 'कलाकारहरू';

  @override
  String get albums => 'आल्बमहरू';

  @override
  String get tracks => 'ट्र्याकहरू';

  @override
  String get downloads => 'डाउनलोडहरू';

  @override
  String get filter_playlists => 'तपाईंको प्लेलिस्टहरू फिल्टर गर्नुहोस्...';

  @override
  String get liked_tracks => 'मन परेका ट्र्याकहरू';

  @override
  String get liked_tracks_description => 'तपाईंको मन परेका सबै ट्र्याकहरू';

  @override
  String get playlist => 'प्लेलिस्ट';

  @override
  String get create_a_playlist => 'प्लेलिस्ट बनाउनुहोस्';

  @override
  String get update_playlist => 'प्लेलिस्ट अपडेट गर्नुहोस्';

  @override
  String get create => 'बनाउनुहोस्';

  @override
  String get cancel => 'रद्द गर्नुहोस्';

  @override
  String get update => 'अपडेट गर्नुहोस्';

  @override
  String get playlist_name => 'प्लेलिस्टको नाम';

  @override
  String get name_of_playlist => 'प्लेलिस्टको नाम';

  @override
  String get description => 'विवरण';

  @override
  String get public => 'सार्वजनिक';

  @override
  String get collaborative => 'सहकारी';

  @override
  String get search_local_tracks => 'स्थानीय ट्र्याकहरू खोजी गर्नुहोस्...';

  @override
  String get play => 'बजाउनुहोस्';

  @override
  String get delete => 'मेटाउनुहोस्';

  @override
  String get none => 'कुनै पनि होइन';

  @override
  String get sort_a_z => 'A-Zमा क्रमबद्ध गर्नुहोस्';

  @override
  String get sort_z_a => 'Z-Aमा क्रमबद्ध गर्नुहोस्';

  @override
  String get sort_artist => 'कलाकारबाट क्रमबद्ध गर्नुहोस्';

  @override
  String get sort_album => 'आल्बमबाट क्रमबद्ध गर्नुहोस्';

  @override
  String get sort_duration => 'अवधिको अनुसार क्रमबद्ध गर्नुहोस्';

  @override
  String get sort_tracks => 'ट्र्याकहरूलाई क्रमबद्ध गर्नुहोस्';

  @override
  String currently_downloading(Object tracks_length) {
    return 'हाल डाउनलोड गर्दैछ ($tracks_length)';
  }

  @override
  String get cancel_all => 'सब रद्द गर्नुहोस्';

  @override
  String get filter_artist => 'कलाकारहरूलाई फिल्टर गर्नुहोस्...';

  @override
  String followers(Object followers) {
    return '$followers अनुयायीहरू';
  }

  @override
  String get add_artist_to_blacklist => 'कलाकारलाई कालोसूचीमा थप्नुहोस्';

  @override
  String get top_tracks => 'शीर्ष ट्र्याकहरू';

  @override
  String get fans_also_like => 'अनुयायीहरू पनि लाइक गर्छन्';

  @override
  String get loading => 'लोड हुँदैछ...';

  @override
  String get artist => 'कलाकार';

  @override
  String get blacklisted => 'कालोसूचीमा';

  @override
  String get following => 'फल्लो गर्दै';

  @override
  String get follow => 'फल्लो गर्नुहोस्';

  @override
  String get artist_url_copied => 'कलाकार URL क्लिपबोर्डमा प्रतिलिपि गरिएको छ';

  @override
  String added_to_queue(Object tracks) {
    return '$tracks ट्र्याकहरूलाई कतारमा थपिएको छ';
  }

  @override
  String get filter_albums => 'आल्बमहरूलाई फिल्टर गर्नुहोस्...';

  @override
  String get synced => 'सिङ्क गरिएको';

  @override
  String get plain => 'साधा';

  @override
  String get shuffle => 'शफल';

  @override
  String get search_tracks => 'ट्र्याकहरू खोजी गर्नुहोस्...';

  @override
  String get released => 'रिलिज गरिएको';

  @override
  String error(Object error) {
    return 'त्रुटि $error';
  }

  @override
  String get title => 'शीर्षक';

  @override
  String get time => 'समय';

  @override
  String get more_actions => 'थप कार्यहरू';

  @override
  String download_count(Object count) {
    return 'डाउनलोड ($count)';
  }

  @override
  String add_count_to_playlist(Object count) {
    return 'प्लेलिस्टमा थप्नुहोस् ($count)';
  }

  @override
  String add_count_to_queue(Object count) {
    return 'कतारमा थप्नुहोस् ($count)';
  }

  @override
  String play_count_next(Object count) {
    return 'प्लेगरी गर्नुहोस् ($count)';
  }

  @override
  String get album => 'आल्बम';

  @override
  String copied_to_clipboard(Object data) {
    return '$data क्लिपबोर्डमा प्रतिलिपि गरिएको छ';
  }

  @override
  String add_to_following_playlists(Object track) {
    return '$track लाई तलका प्लेलिस्टमा थप्नुहोस्';
  }

  @override
  String get add => 'थप्नुहोस्';

  @override
  String added_track_to_queue(Object track) {
    return '$track लाई कतारमा थपिएको छ';
  }

  @override
  String get add_to_queue => 'कतारमा थप्नुहोस्';

  @override
  String track_will_play_next(Object track) {
    return '$track अरूलाई पहिलोमा बज्नेछ';
  }

  @override
  String get play_next => 'पछिबजाउनुहोस्';

  @override
  String removed_track_from_queue(Object track) {
    return '$track लाई कतारबाट हटाइएको छ';
  }

  @override
  String get remove_from_queue => 'कतारबाट हटाउनुहोस्';

  @override
  String get remove_from_favorites => 'पसन्दीदामा बाट हटाउनुहोस्';

  @override
  String get save_as_favorite => 'पसन्दीदा बनाउनुहोस्';

  @override
  String get add_to_playlist => 'प्लेलिस्टमा थप्नुहोस्';

  @override
  String get remove_from_playlist => 'प्लेलिस्टबाट हटाउनुहोस्';

  @override
  String get add_to_blacklist => 'कालोसूचीमा थप्नुहोस्';

  @override
  String get remove_from_blacklist => 'कालोसूचीबाट हटाउनुहोस्';

  @override
  String get share => 'साझा गर्नुहोस्';

  @override
  String get mini_player => 'मिनि प्लेयर';

  @override
  String get slide_to_seek => 'अगाडि वा पछाडि खोजी गर्नका लागि स्लाइड गर्नुहोस्';

  @override
  String get shuffle_playlist => 'प्लेलिस्ट शफल गर्नुहोस्';

  @override
  String get unshuffle_playlist => 'प्लेलिस्ट शफल नगर्नुहोस्';

  @override
  String get previous_track => 'पूर्व ट्र्याक';

  @override
  String get next_track => 'अरू ट्र्याक';

  @override
  String get pause_playback => 'प्लेब्याक रोक्नुहोस्';

  @override
  String get resume_playback => 'प्लेब्याक पुनः सुरु गर्नुहोस्';

  @override
  String get loop_track => 'ट्र्याकलाई दोहोरोपट्टी बजाउनुहोस्';

  @override
  String get no_loop => 'कोई लूप नहीं';

  @override
  String get repeat_playlist => 'प्लेलिस्ट पुनः बजाउनुहोस्';

  @override
  String get queue => 'कतार';

  @override
  String get alternative_track_sources => 'वैकल्पिक ट्र्याक स्रोतहरू';

  @override
  String get download_track => 'ट्र्याक डाउनलोड गर्नुहोस्';

  @override
  String tracks_in_queue(Object tracks) {
    return 'कतारमा $tracks ट्र्याकहरू';
  }

  @override
  String get clear_all => 'सब मेटाउनुहोस्';

  @override
  String get show_hide_ui_on_hover => 'हवर गरेपछि UI देखाउनुहोस्/लुकाउनुहोस्';

  @override
  String get always_on_top => 'सधैं टपमा राख्नुहोस्';

  @override
  String get exit_mini_player => 'मिनि प्लेयर बाट बाहिर निस्कनुहोस्';

  @override
  String get download_location => 'डाउनलोड स्थान';

  @override
  String get local_library => 'स्थानिय पुस्तकालय';

  @override
  String get add_library_location => 'पुस्तकालयमा थप्नुहोस्';

  @override
  String get remove_library_location => 'पुस्तकालयबाट हटाउनुहोस्';

  @override
  String get account => 'खाता';

  @override
  String get login_with_spotify => 'तपाईंको Spotify खातासँग लगइन गर्नुहोस्';

  @override
  String get connect_with_spotify => 'Spotify सँग जडान गर्नुहोस्';

  @override
  String get logout => 'बाहिर निस्कनुहोस्';

  @override
  String get logout_of_this_account => 'यो खाताबाट बाहिर निस्कनुहोस्';

  @override
  String get language_region => 'भाषा र क्षेत्र';

  @override
  String get language => 'भाषा';

  @override
  String get system_default => 'सिस्टम पूर्वनिर्धारित';

  @override
  String get market_place_region => 'बजार स्थान';

  @override
  String get recommendation_country => 'सिफारिस गरिएको देश';

  @override
  String get appearance => 'दृष्टिकोण';

  @override
  String get layout_mode => 'लेआउट मोड';

  @override
  String get override_layout_settings => 'अनुकूलित प्रतिकृयात्मक लेआउट मोड सेटिङ्गहरू';

  @override
  String get adaptive => 'अनुकूलित';

  @override
  String get compact => 'संकुचित';

  @override
  String get extended => 'बढाइएको';

  @override
  String get theme => 'थिम';

  @override
  String get dark => 'गाढा';

  @override
  String get light => 'प्रकाश';

  @override
  String get system => 'सिस्टम';

  @override
  String get accent_color => 'एक्सेन्ट रङ्ग';

  @override
  String get sync_album_color => 'एल्बम रङ्ग सिङ्क गर्नुहोस्';

  @override
  String get sync_album_color_description => 'एल्बम कला को प्रमुख रङ्गलाई एक्सेन्ट रङ्गको रूपमा प्रयोग गर्दछ';

  @override
  String get playback => 'प्लेब्याक';

  @override
  String get audio_quality => 'आडियो गुणस्तर';

  @override
  String get high => 'उच्च';

  @override
  String get low => 'न्यून';

  @override
  String get pre_download_play => 'पूर्व-डाउनलोड र प्ले गर्नुहोस्';

  @override
  String get pre_download_play_description => 'आडियो स्ट्रिम गर्नु नगरी बाइटहरू डाउनलोड गरी बजाउँछ (उच्च ब्यान्डविथ उपयोगकर्ताहरूको लागि सिफारिस गरिएको)';

  @override
  String get skip_non_music => 'गीतहरू बाहेक कुनै अनुष्ठान छोड्नुहोस् (स्पन्सरब्लक)';

  @override
  String get blacklist_description => 'कालोसूची गीत र कलाकारहरू';

  @override
  String get wait_for_download_to_finish => 'कृपया हालको डाउनलोड समाप्त हुन लागि पर्खनुहोस्';

  @override
  String get desktop => 'डेस्कटप';

  @override
  String get close_behavior => 'बन्द व्यवहार';

  @override
  String get close => 'बन्द गर्नुहोस्';

  @override
  String get minimize_to_tray => 'ट्रेमा कम गर्नुहोस्';

  @override
  String get show_tray_icon => 'सिस्टम ट्रे आइकन देखाउनुहोस्';

  @override
  String get about => 'बारेमा';

  @override
  String get u_love_spotube => 'हामीले थाहा पारेका छौं तपाईंलाई Spotube मन पर्छ';

  @override
  String get check_for_updates => 'अपडेटहरूको लागि जाँच गर्नुहोस्';

  @override
  String get about_spotube => 'Spotube को बारेमा';

  @override
  String get blacklist => 'कालोसूची';

  @override
  String get please_sponsor => 'कृपया स्पन्सर/डोनेट गर्नुहोस्';

  @override
  String get spotube_description => 'Spotube, एक हल्का, समृद्ध, स्वतन्त्र Spotify क्लाइयन';

  @override
  String get version => 'संस्करण';

  @override
  String get build_number => 'निर्माण नम्बर';

  @override
  String get founder => 'संस्थापक';

  @override
  String get repository => 'पुनरावलोकन स्थल';

  @override
  String get bug_issues => 'त्रुटि + समस्याहरू';

  @override
  String get made_with => '❤️ 2021-2024 बाट बनाइएको';

  @override
  String get kingkor_roy_tirtho => 'किङ्कोर राय तिर्थो';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year किङ्कोर राय तिर्थो';
  }

  @override
  String get license => 'लाइसेन्स';

  @override
  String get add_spotify_credentials => 'सुरु हुनका लागि तपाईंको स्पटिफाई क्रेडेन्शियल थप्नुहोस्';

  @override
  String get credentials_will_not_be_shared_disclaimer => 'चिन्ता नगर्नुहोस्, तपाईंको कुनै पनि क्रेडेन्शियलहरूले कसैले संग्रह वा साझा गर्नेछैन';

  @override
  String get know_how_to_login => 'कसरी लगिन गर्ने भन्ने थाहा छैन?';

  @override
  String get follow_step_by_step_guide => 'चरणबद्ध मार्गदर्शनमा साथी बनाउनुहोस्';

  @override
  String spotify_cookie(Object name) {
    return 'Spotify $name कुकी';
  }

  @override
  String cookie_name_cookie(Object name) {
    return '$name कुकी';
  }

  @override
  String get fill_in_all_fields => 'कृपया सबै क्षेत्रहरू भर्नुहोस्';

  @override
  String get submit => 'पेश गर्नुहोस्';

  @override
  String get exit => 'बाहिर निस्कनुहोस्';

  @override
  String get previous => 'पूर्ववत';

  @override
  String get next => 'अरू';

  @override
  String get done => 'गरिएको';

  @override
  String get step_1 => 'कदम 1';

  @override
  String get first_go_to => 'पहिलो, जानुहोस्';

  @override
  String get login_if_not_logged_in => 'र लगइन/साइनअप गर्नुहोस् जुन तपाईंले लगइन गरेनन्';

  @override
  String get step_2 => 'कदम 2';

  @override
  String get step_2_steps => '1. एकबार तपाईं लगइन गरे पछि, F12 थिच्नुहोस् वा माउस राइट क्लिक गर्नुहोस् > इन्स्पेक्ट गर्नुहोस् भने ब्राउजर डेभटुलहरू खुलाउनका लागि।\n2. तपाईंको \"एप्लिकेसन\" ट्याबमा जानुहोस् (Chrome, Edge, Brave इत्यादि) वा \"स्टोरेज\" ट्याबमा जानुहोस् (Firefox, Palemoon इत्यादि)\n3. तपाईंको इन्सेक्ट गरेको ब्राउजर डेभटुलहरूमा \"कुकीहरू\" खण्डमा जानुहोस् अनि \"https://accounts.spotify.com\" उपकोणमा जानुहोस्';

  @override
  String get step_3 => 'कदम 3';

  @override
  String get step_3_steps => '\"sp_dc\" र \"sp_key\" (वा sp_gaid) कुकीहरूको मानहरू प्रतिलिपि गर्नुहोस्';

  @override
  String get success_emoji => 'सफलता 🥳';

  @override
  String get success_message => 'हाम्रो सानो भाइ, अब तपाईं सफलतापूर्वक आफ्नो Spotify खातामा लगइन गरेका छौं। राम्रो काम गरेको!';

  @override
  String get step_4 => 'कदम 4';

  @override
  String get step_4_steps => 'प्रतिलिपि गरेको \"sp_dc\" र \"sp_key\" (वा sp_gaid) मानहरूलाई आफ्नो ठाउँमा पेस्ट गर्नुहोस्';

  @override
  String get something_went_wrong => 'केहि गल्ति भएको छ';

  @override
  String get piped_instance => 'पाइपड सर्भर इन्स्ट्यान्स';

  @override
  String get piped_description => 'गीत मिलाउको लागि प्रयोग गर्ने पाइपड सर्भर इन्स्ट्यान्स';

  @override
  String get piped_warning => 'तिनीहरूमध्ये केहि ठिक गर्न सक्छ। यसलाई आफ्नो जोखिममा प्रयोग गर्नुहोस्';

  @override
  String get invidious_instance => 'Invidious सर्भर इन्स्टेन्स';

  @override
  String get invidious_description => 'ट्र्याक मिलाउनका लागि प्रयोग हुने Invidious सर्भर इन्स्टेन्स';

  @override
  String get invidious_warning => 'केहीले राम्रोसँग काम नगर्न सक्छ। आफ्नो जोखिममा प्रयोग गर्नुहोस्';

  @override
  String get generate => 'जनरेट';

  @override
  String track_exists(Object track) {
    return 'ट्र्याक $track पहिले नै छ';
  }

  @override
  String get replace_downloaded_tracks => 'सबै डाउनलोड गरिएका ट्र्याकहरूलाई परिवर्तन गर्नुहोस्';

  @override
  String get skip_download_tracks => 'सबै डाउनलोड गरिएका ट्र्याकहरूलाई छोड्नुहोस्';

  @override
  String get do_you_want_to_replace => 'के तपाईंले वर्तमान ट्र्याकलाई परिवर्तन गर्न चाहनुहुन्छ?';

  @override
  String get replace => 'परिवर्तन गर्नुहोस्';

  @override
  String get skip => 'छोड्नुहोस्';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return '$count $type सम्म चयन गर्नुहोस्';
  }

  @override
  String get select_genres => 'जनरहरू चयन गर्नुहोस्';

  @override
  String get add_genres => 'जनरहरू थप्नुहोस्';

  @override
  String get country => 'देश';

  @override
  String get number_of_tracks_generate => 'बनाउनका लागि ट्र्याकहरूको संख्या';

  @override
  String get acousticness => 'एकोस्टिकनेस';

  @override
  String get danceability => 'नृत्यक्षमता';

  @override
  String get energy => 'ऊर्जा';

  @override
  String get instrumentalness => 'साजा रहेकोता';

  @override
  String get liveness => 'प्राणिकता';

  @override
  String get loudness => 'शोर';

  @override
  String get speechiness => 'भाषण';

  @override
  String get valence => 'मानसिक स्वभाव';

  @override
  String get popularity => 'लोकप्रियता';

  @override
  String get key => 'कुञ्जी';

  @override
  String get duration => 'अवधि (सेकेण्ड)';

  @override
  String get tempo => 'गति (बीपीएम)';

  @override
  String get mode => 'मोड';

  @override
  String get time_signature => 'समय हस्ताक्षर';

  @override
  String get short => 'सानो';

  @override
  String get medium => 'मध्यम';

  @override
  String get long => 'लामो';

  @override
  String get min => 'न्यून';

  @override
  String get max => 'अधिक';

  @override
  String get target => 'लक्ष्य';

  @override
  String get moderate => 'मध्यस्थ';

  @override
  String get deselect_all => 'सबै छान्नुहोस्';

  @override
  String get select_all => 'सबै चयन गर्नुहोस्';

  @override
  String get are_you_sure => 'के तपाईं सुनिश्चित हुनुहुन्छ?';

  @override
  String get generating_playlist => 'तपाईंको विशेष प्लेलिस्ट बनाइएको छ...';

  @override
  String selected_count_tracks(Object count) {
    return '$count ट्र्याकहरू छन् चयन गरिएका';
  }

  @override
  String get download_warning => 'यदि तपाईं सबै ट्र्याकहरूलाई बल्कमा डाउनलोड गर्छनु हो भने तपाईं स्पष्ट रूपमा साङ्गीत चोरी गरिरहेका छन् र यो साङ्गीतको रचनात्मक समाजलाई क्षति पनि पुर्याउँछ। उमेराइएको छ कि तपाईं यसको बारेमा जागरूक छिनुहुन्छ। सधैं, कला गर्दै र कलाकारको कडा परम्परा समर्थन गर्दै आइन्छ।';

  @override
  String get download_ip_ban_warning => 'बितिएका डाउनलोड अनुरोधहरूका कारण तपाईंको आइपीले YouTube मा ब्लक हुन सक्छ। आइपी ब्लक भनेको कम्तीमा 2-3 महिनासम्म तपाईं त्यस आइपी यन्त्रबाट YouTube प्रयोग गर्न सक्नुहुन्छ। र यदि यो हुँदैछ भने स्पट्यूबले यसलाई कसैले गरेको बारेमा कुनै दायित्व लिन्छैन।';

  @override
  String get by_clicking_accept_terms => '\'स्वीकृत\' गरेर तपाईं निम्नलिखित निर्वाचन गर्दैछिन्:';

  @override
  String get download_agreement_1 => 'म मन्ने छु कि म साङ्गीत चोरी गरिरहेको छु। म बुरो हुँ';

  @override
  String get download_agreement_2 => 'म कहिल्यै कहिल्यै तिनीहरूलाई समर्थन गर्नेछु र म यो तिनीहरूको कला किन्ने पैसा छैन भने मा मात्र यो गरेको छु';

  @override
  String get download_agreement_3 => 'म पूरा रूपमा जान्छु कि मेरो आइपी YouTube मा ब्लक हुन सक्छ र म मन्छेहरूले मेरो चासोबाट भएको कुनै दुर्घटनामा स्पट्यूब वा तिनीहरूको मालिकहरू/सहयोगीहरूलाई दायित्वी ठान्छुँभन्ने पूर्ण जानकारी छैन';

  @override
  String get decline => 'अस्वीकृत';

  @override
  String get accept => 'स्वीकृत';

  @override
  String get details => 'विवरण';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => 'च्यानल';

  @override
  String get likes => 'लाइकहरू';

  @override
  String get dislikes => 'असुनुहरू';

  @override
  String get views => 'हेरिएको';

  @override
  String get streamUrl => 'स्ट्रिम यूआरएल';

  @override
  String get stop => 'रोक्नुहोस्';

  @override
  String get sort_newest => 'नयाँ थपिएकोमा क्रमबद्ध गर्नुहोस्';

  @override
  String get sort_oldest => 'पुरानो थपिएकोमा क्रमबद्ध गर्नुहोस्';

  @override
  String get sleep_timer => 'सुत्ने टाइमर';

  @override
  String mins(Object minutes) {
    return '$minutes मिनेटहरू';
  }

  @override
  String hours(Object hours) {
    return '$hours घण्टाहरू';
  }

  @override
  String hour(Object hours) {
    return '$hours घण्टा';
  }

  @override
  String get custom_hours => 'कस्टम घण्टाहरू';

  @override
  String get logs => 'लगहरू';

  @override
  String get developers => 'डेभेलपर्स';

  @override
  String get not_logged_in => 'तपाईंले लगइन गरेका छैनौं';

  @override
  String get search_mode => 'खोज मोड';

  @override
  String get audio_source => 'अडियो स्रोत';

  @override
  String get ok => 'ठिक छ';

  @override
  String get failed_to_encrypt => 'एन्क्रिप्ट गर्न सकिएन';

  @override
  String get encryption_failed_warning => 'स्पट्यूबले तपाईंको डेटा सुरक्षित रूपमा स्टोर गर्नका लागि एन्क्रिप्ट गर्न खोजेको छ। तर यसले गरेको छैन। यसले असुरक्षित स्टोरेजमा फल्लब्याक गर्दछ\nयदि तपाईंले लिनक्स प्रयोग गरिरहेका छन् भने कृपया सुनिश्चित गर्नुहोस् कि तपाईंले कुनै सीक्रेट-सर्भिस (गोनोम-किरिङ, केडीइ-वालेट, किपासेक्ससि इत्यादि) इन्स्टल गरेका छौं';

  @override
  String get querying_info => 'जानकारी हेर्दै...';

  @override
  String get piped_api_down => 'पाइपड एपीआई डाउन छ';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return 'पाइपड इन्स्ट्यान्स $pipedInstance हाल डाउन छ\n\nजीसनै इन्स्ट्यान्स परिवर्तन गर्नुहोस् वा \'एपीआई प्रकार\' लाइ YouTube आफिसियल एपीआईमा परिवर्तन गर्नुहोस्\n\nपरिवर्तनपछि एप्लिकेसन पुन: सुरु गर्नुहोस्';
  }

  @override
  String get you_are_offline => 'तपाईं वर्तमान अफलाइन हुनुहुन्छ';

  @override
  String get connection_restored => 'तपाईंको इन्टरनेट कनेक्सन पुन: स्थापित भएको छ';

  @override
  String get use_system_title_bar => 'सिस्टम शीर्षक पट्टी प्रयोग गर्नुहोस्';

  @override
  String get crunching_results => 'परिणामहरू कपालबाट पीस्दै...';

  @override
  String get search_to_get_results => 'परिणामहरू प्राप्त गर्नका लागि खोज्नुहोस्';

  @override
  String get use_amoled_mode => 'कृष्ण ब्ल्याक गाढा थिम प्रयोग गर्नुहोस्';

  @override
  String get pitch_dark_theme => 'एमोलेड मोड';

  @override
  String get normalize_audio => 'अडियो सामान्य गर्नुहोस्';

  @override
  String get change_cover => 'कवर परिवर्तन गर्नुहोस्';

  @override
  String get add_cover => 'कवर थप्नुहोस्';

  @override
  String get restore_defaults => 'पूर्वनिर्धारितहरू पुनः स्थापित गर्नुहोस्';

  @override
  String get download_music_codec => 'साङ्गीत कोडेक डाउनलोड गर्नुहोस्';

  @override
  String get streaming_music_codec => 'स्ट्रिमिङ साङ्गीत कोडेक';

  @override
  String get login_with_lastfm => 'लास्ट.एफ.एम सँग लगइन गर्नुहोस्';

  @override
  String get connect => 'जडान गर्नुहोस्';

  @override
  String get disconnect_lastfm => 'लास्ट.एफ.एम डिसकनेक्ट गर्नुहोस्';

  @override
  String get disconnect => 'डिसकनेक्ट';

  @override
  String get username => 'प्रयोगकर्ता नाम';

  @override
  String get password => 'पासवर्ड';

  @override
  String get login => 'लगइन';

  @override
  String get login_with_your_lastfm => 'तपाईंको लास्ट.एफ.एम खातामा लगइन गर्नुहोस्';

  @override
  String get scrobble_to_lastfm => 'लास्ट.एफ.एम मा स्क्रबल गर्नुहोस्';

  @override
  String get go_to_album => 'आल्बममा जानुहोस्';

  @override
  String get discord_rich_presence => 'डिस्कर्ड धनी उपस्थिति';

  @override
  String get browse_all => 'सबै हेर्नुहोस्';

  @override
  String get genres => 'शैलीहरू';

  @override
  String get explore_genres => 'शैलीहरू अन्वेषण गर्नुहोस्';

  @override
  String get friends => 'साथीहरू';

  @override
  String get no_lyrics_available => 'क्षमा गर्दैछौं, यस ट्र्याकका लागि गीतका शब्दहरू फेला परेन';

  @override
  String get start_a_radio => 'रेडियो सुरु गर्नुहोस्';

  @override
  String get how_to_start_radio => 'तपाईं रेडियो कसरी सुरु गर्न चाहानुहुन्छ?';

  @override
  String get replace_queue_question => 'के तपाईं वर्तमान कताक्ष कोट बदल्न चाहानुहुन्छ वा यसलाई थप्नुहुन्छ?';

  @override
  String get endless_playback => 'अनन्त प्लेब्याक';

  @override
  String get delete_playlist => 'प्लेलिस्ट मेटाउनुहोस्';

  @override
  String get delete_playlist_confirmation => 'के तपाईं यो प्लेलिस्ट मेटाउन निश्चित हुनुहुन्छ?';

  @override
  String get local_tracks => 'स्थानिय ट्र्याकहरू';

  @override
  String get local_tab => 'स्थानिय';

  @override
  String get song_link => 'गीत लिंक';

  @override
  String get skip_this_nonsense => 'यस अबश्यकता छोड्नुहोस्';

  @override
  String get freedom_of_music => '“संगीतको स्वतन्त्रता”';

  @override
  String get freedom_of_music_palm => '“तपाईंको हातमा संगीतको स्वतन्त्रता”';

  @override
  String get get_started => 'आइयाँ प्रारम्भ गरौं';

  @override
  String get youtube_source_description => 'सिफारिस गरिएको र बेस्ट काम गर्दछ।';

  @override
  String get piped_source_description => 'मुक्त सुस्त? YouTube जस्तै तर धेरै मुक्त।';

  @override
  String get jiosaavn_source_description => 'दक्षिण एशियाली क्षेत्रको लागि सर्वोत्तम।';

  @override
  String get invidious_source_description => 'Piped जस्तै तर उच्च उपलब्धतासँग।';

  @override
  String highest_quality(Object quality) {
    return 'उच्चतम गुणस्तर: $quality';
  }

  @override
  String get select_audio_source => 'आडियो स्रोत चयन गर्नुहोस्';

  @override
  String get endless_playback_description => 'नयाँ गीतहरूलाई स्वचालित रूपमा कताक्षको अन्तमा जोड्नुहोस्';

  @override
  String get choose_your_region => 'तपाईंको क्षेत्र छनौट गर्नुहोस्';

  @override
  String get choose_your_region_description => 'यो Spotubeलाई तपाईंको स्थानका लागि सहि सामग्री देखाउने मद्दत गर्नेछ।';

  @override
  String get choose_your_language => 'तपाईंको भाषा छनौट गर्नुहोस्';

  @override
  String get help_project_grow => 'यस परियोजनामा वृद्धि गराउनुहोस्';

  @override
  String get help_project_grow_description => 'Spotube एक खुला स्रोतको परियोजना हो। तपाईं परियोजनामा योगदान गरेर, त्रुटिहरू सूचिकै, वा नयाँ सुविधाहरू सुझाव दिएर यस परियोजनामा वृद्धि गर्न सक्नुहुन्छ।';

  @override
  String get contribute_on_github => 'GitHubमा योगदान गर्नुहोस्';

  @override
  String get donate_on_open_collective => 'खुला संगठनमा दान गर्नुहोस्';

  @override
  String get browse_anonymously => 'अनामित रूपमा ब्राउज़ गर्नुहोस्';

  @override
  String get enable_connect => 'कनेक्ट सक्रिय गर्नुहोस्';

  @override
  String get enable_connect_description => 'अन्य उपकरणहरूबाट Spotube कन्ट्रोल गर्नुहोस्';

  @override
  String get devices => 'उपकरणहरू';

  @override
  String get select => 'चयन गर्नुहोस्';

  @override
  String connect_client_alert(Object client) {
    return 'तपाईंलाई $client द्वारा नियन्त्रित गरिएको छ';
  }

  @override
  String get this_device => 'यो उपकरण';

  @override
  String get remote => 'दूरसंचार';

  @override
  String get stats => 'तथ्याङ्क';

  @override
  String and_n_more(Object count) {
    return 'राम्रो $count थप';
  }

  @override
  String get recently_played => 'हालै खेलेको';

  @override
  String get browse_more => 'थप हेर्नुहोस्';

  @override
  String get no_title => 'शीर्षक छैन';

  @override
  String get not_playing => 'खेलिरहेको छैन';

  @override
  String get epic_failure => 'महाकवि असफलता!';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return '$tracks_length ट्र्याकहरू तालिकामा थपिएका छन्';
  }

  @override
  String get spotube_has_an_update => 'Spotube मा अपडेट छ';

  @override
  String get download_now => 'अहिले डाउनलोड गर्नुहोस्';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Spotube Nightly $nightlyBuildNum रिलिज गरिएको छ';
  }

  @override
  String release_version(Object version) {
    return 'Spotube v$version रिलिज गरिएको छ';
  }

  @override
  String get read_the_latest => 'अर्को ';

  @override
  String get release_notes => 'रिलिज नोटहरू';

  @override
  String get pick_color_scheme => 'रंग योजना चयन गर्नुहोस्';

  @override
  String get save => 'सुरक्षित गर्नुहोस्';

  @override
  String get choose_the_device => 'उपकरण चयन गर्नुहोस्:';

  @override
  String get multiple_device_connected => 'धेरै उपकरण जडान गरिएको छ।\nयो क्रियाकलाप गर्ने उपकरण चयन गर्नुहोस्';

  @override
  String get nothing_found => 'केही फेला परेन';

  @override
  String get the_box_is_empty => 'बक्स खाली छ';

  @override
  String get top_artists => 'शीर्ष कलाकारहरू';

  @override
  String get top_albums => 'शीर्ष एल्बमहरू';

  @override
  String get this_week => 'यो हप्ता';

  @override
  String get this_month => 'यो महिना';

  @override
  String get last_6_months => 'पछिल्लो ६ महिना';

  @override
  String get this_year => 'यो वर्ष';

  @override
  String get last_2_years => 'पछिल्लो २ वर्ष';

  @override
  String get all_time => 'सबै समय';

  @override
  String powered_by_provider(Object providerName) {
    return '$providerName द्वारा शक्ति प्राप्त';
  }

  @override
  String get email => 'ईमेल';

  @override
  String get profile_followers => 'अनुयायीहरू';

  @override
  String get birthday => 'जन्मदिन';

  @override
  String get subscription => 'सदस्यता';

  @override
  String get not_born => 'जन्मिएको छैन';

  @override
  String get hacker => 'ह्याकर';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get no_name => 'नाम छैन';

  @override
  String get edit => 'सम्पादन गर्नुहोस्';

  @override
  String get user_profile => 'प्रयोगकर्ता प्रोफाइल';

  @override
  String count_plays(Object count) {
    return '$count खेलाइन्छ';
  }

  @override
  String get streaming_fees_hypothetical => '*यो Spotify को प्रति स्ट्रिमको आधारमा गणना गरिएको छ\n\$0.003 देखि \$0.005 बीचको भुक्तानी। यो एक काल्पनिक गणना हो\nउपयोगकर्तालाई यो थाहा दिनको लागि कि उनीहरूले अर्टिस्टहरूलाई\nSpotify मा गीत सुनेको भए कति भुक्तानी गर्ने थिए।';

  @override
  String get minutes_listened => 'सुनिएका मिनेटहरू';

  @override
  String get streamed_songs => 'स्ट्रीम गरिएका गीतहरू';

  @override
  String count_streams(Object count) {
    return '$count स्ट्रिम';
  }

  @override
  String get owned_by_you => 'तपाईंले स्वामित्व गरेको';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return '$shareUrl क्लिपबोर्डमा कपी गरियो';
  }

  @override
  String get spotify_hipotetical_calculation => '*यो Spotify को प्रति स्ट्रीम भुगतानको आधारमा\n\$0.003 देखि \$0.005 को बीचमा गणना गरिएको हो। यो एक काल्पनिक\nगणना हो जसले प्रयोगकर्तालाई देखाउँछ कि उनीहरूले कति\nअर्टिस्टहरूलाई तिनीहरूका गीतहरू Spotify मा सुनेमा\nभुक्तान गर्नुपर्ने थियो।';

  @override
  String count_mins(Object minutes) {
    return '$minutes मिनेट';
  }

  @override
  String get summary_minutes => 'मिनेट';

  @override
  String get summary_listened_to_music => 'सङ्गीत सुन्नु';

  @override
  String get summary_songs => 'गीतहरू';

  @override
  String get summary_streamed_overall => 'सामान्य रूपले स्ट्रीम गरिएको';

  @override
  String get summary_owed_to_artists => 'यस महिना कलाकारहरूलाई देन';

  @override
  String get summary_artists => 'कलाकारको';

  @override
  String get summary_music_reached_you => 'सङ्गीत तपाईंलाई पुग्यो';

  @override
  String get summary_full_albums => 'पूर्ण एल्बमहरू';

  @override
  String get summary_got_your_love => 'तपाईंको माया प्राप्त गरियो';

  @override
  String get summary_playlists => 'प्लेइस्ट';

  @override
  String get summary_were_on_repeat => 'पुनरावृत्ति गरियो';

  @override
  String total_money(Object money) {
    return 'कुल $money';
  }

  @override
  String get webview_not_found => 'वेबभ्यू फेला परेन';

  @override
  String get webview_not_found_description => 'तपाईंको उपकरणमा कुनै वेबभ्यू रनटाइम स्थापना गरिएको छैन।\nयदि स्थापना गरिएको छ भने, environment PATH मा छ कि छैन भनेर सुनिश्चित गर्नुहोस्\n\nस्थापना पछि, अनुप्रयोग पुनः सुरु गर्नुहोस्';

  @override
  String get unsupported_platform => 'असमर्थित प्लेटफार्म';

  @override
  String get cache_music => 'सङ्गीत क्यास गर्नुहोस्';

  @override
  String get open => 'खोल्नुहोस्';

  @override
  String get cache_folder => 'क्यास फोल्डर';

  @override
  String get export => 'निर्यात गर्नुहोस्';

  @override
  String get clear_cache => 'क्यास खाली गर्नुहोस्';

  @override
  String get clear_cache_confirmation => 'के तपाई क्यास खाली गर्न चाहनुहुन्छ?';

  @override
  String get export_cache_files => 'क्यास फाइलहरू निर्यात गर्नुहोस्';

  @override
  String found_n_files(Object count) {
    return '$count फाइलहरू फेला परे';
  }

  @override
  String get export_cache_confirmation => 'यी फाइलहरू निर्यात गर्न चाहनुहुन्छ';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return '$filesExported मध्ये $files फाइलहरू निर्यात गरियो';
  }

  @override
  String get undo => 'पूर्ववत';

  @override
  String get download_all => 'सभी डाउनलोड करें';

  @override
  String get add_all_to_playlist => 'सभी को प्लेलिस्ट में जोड़ें';

  @override
  String get add_all_to_queue => 'सभी को कतार में जोड़ें';

  @override
  String get play_all_next => 'सभी को अगला प्ले करें';

  @override
  String get pause => 'विराम';

  @override
  String get view_all => 'सभी देखें';

  @override
  String get no_tracks_added_yet => 'लगता है आपने अभी तक कोई ट्रैक नहीं जोड़ा है';

  @override
  String get no_tracks => 'यहाँ कोई ट्रैक नहीं दिख रहे हैं';

  @override
  String get no_tracks_listened_yet => 'आपने अभी तक कुछ नहीं सुना है ऐसा लगता है';

  @override
  String get not_following_artists => 'आप किसी कलाकार को फॉलो नहीं कर रहे हैं';

  @override
  String get no_favorite_albums_yet => 'लगता है आपने अभी तक कोई एल्बम पसंदीदा में नहीं जोड़ा है';

  @override
  String get no_logs_found => 'कोई लॉग नहीं मिला';

  @override
  String get youtube_engine => 'YouTube इंजन';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engine इंस्टॉल नहीं है';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engine आपके सिस्टम में इंस्टॉल नहीं है।';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return 'सुनिश्चित करें कि यह PATH वेरिएबल में उपलब्ध है या\nनीचे $engine एक्जीक्यूटेबल का पूर्ण पथ सेट करें';
  }

  @override
  String get youtube_engine_unix_issue_message => 'macOS/Linux/unix जैसे ऑपरेटिंग सिस्टम में, .zshrc/.bashrc/.bash_profile आदि में पथ सेट करना काम नहीं करेगा।\nआपको शेल कॉन्फ़िगरेशन फ़ाइल में पथ सेट करना होगा';

  @override
  String get download => 'डाउनलोड';

  @override
  String get file_not_found => 'फ़ाइल नहीं मिली';

  @override
  String get custom => 'कस्टम';

  @override
  String get add_custom_url => 'कस्टम URL जोड़ें';

  @override
  String get edit_port => 'पोर्ट सम्पादन गर्नुहोस्';

  @override
  String get port_helper_msg => 'डिफ़ॉल्ट -1 हो जुन यादृच्छिक संख्या जनाउँछ। यदि तपाईंले फायरवाल कन्फिगर गर्नुभएको छ भने, यसलाई सेट गर्न सिफारिस गरिन्छ।';

  @override
  String connect_request(Object client) {
    return '$client लाई जडान गर्न अनुमति दिनुहोस्?';
  }

  @override
  String get connection_request_denied => 'जडान अस्वीकृत। प्रयोगकर्ताले पहुँच अस्वीकृत गर्यो।';
}
