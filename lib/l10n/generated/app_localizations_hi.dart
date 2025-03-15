// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get guest => 'अतिथि';

  @override
  String get browse => 'ब्राउज़ करें';

  @override
  String get search => 'खोजें';

  @override
  String get library => 'लाइब्रेरी';

  @override
  String get lyrics => 'गीतों के बोल';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get genre_categories_filter => 'श्रेणियों या जानरों को फिल्टर करें...';

  @override
  String get genre => 'जानर';

  @override
  String get personalized => 'व्यक्तिगत';

  @override
  String get featured => 'विशेष रुप से प्रदर्शित';

  @override
  String get new_releases => 'नई रिलीज़';

  @override
  String get songs => 'गाने';

  @override
  String playing_track(Object track) {
    return '$track चल रहा है';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return 'यह मौजूदा कतार को साफ़ कर देगा। $track_length ट्रैक हटा दिए जाएंगे\nक्या आप जारी रखना चाहते हैं?';
  }

  @override
  String get load_more => 'और लोड करें';

  @override
  String get playlists => 'प्लेलिस्ट';

  @override
  String get artists => 'कलाकार';

  @override
  String get albums => 'एल्बम';

  @override
  String get tracks => 'ट्रैक';

  @override
  String get downloads => 'डाउनलोड';

  @override
  String get filter_playlists => 'अपनी प्लेलिस्टों को फ़िल्टर करें...';

  @override
  String get liked_tracks => 'पसंदीदा ट्रैक';

  @override
  String get liked_tracks_description => 'आपके सभी पसंदीदा ट्रैक';

  @override
  String get playlist => 'प्लेलिस्ट';

  @override
  String get create_a_playlist => 'एक प्लेलिस्ट बनाएं';

  @override
  String get update_playlist => 'प्लेलिस्ट अपडेट करें';

  @override
  String get create => 'बनाएं';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get update => 'अपडेट करें';

  @override
  String get playlist_name => 'प्लेलिस्ट का नाम';

  @override
  String get name_of_playlist => 'प्लेलिस्ट का नाम';

  @override
  String get description => 'विवरण';

  @override
  String get public => 'सार्वजनिक';

  @override
  String get collaborative => 'सहयोगी';

  @override
  String get search_local_tracks => 'स्थानीय ट्रैक खोजें...';

  @override
  String get play => 'चलाएँ';

  @override
  String get delete => 'हटाएँ';

  @override
  String get none => 'कोई नहीं';

  @override
  String get sort_a_z => 'A-Z सॉर्ट करें';

  @override
  String get sort_z_a => 'Z-A सॉर्ट करें';

  @override
  String get sort_artist => 'कलाकार के अनुसार सॉर्ट करें';

  @override
  String get sort_album => 'एल्बम के अनुसार सॉर्ट करें';

  @override
  String get sort_duration => 'समय के आधार पर क्रमबद्ध करें';

  @override
  String get sort_tracks => 'ट्रैक को सॉर्ट करें';

  @override
  String currently_downloading(Object tracks_length) {
    return 'वर्तमान में डाउनलोड हो रहा है ($tracks_length)';
  }

  @override
  String get cancel_all => 'सभी को रद्द करें';

  @override
  String get filter_artist => 'कलाकारों को फ़िल्टर करें...';

  @override
  String followers(Object followers) {
    return '$followers फॉलोअर्स';
  }

  @override
  String get add_artist_to_blacklist => 'काल सूची में कलाकार जोड़ें';

  @override
  String get top_tracks => 'शीर्ष ट्रैक';

  @override
  String get fans_also_like => 'फैंस भी पसंद करते हैं';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get artist => 'कलाकार';

  @override
  String get blacklisted => 'काल सूची में है';

  @override
  String get following => 'फॉलो करना';

  @override
  String get follow => 'फॉलो करें';

  @override
  String get artist_url_copied => 'कलाकार URL क्लिपबोर्ड पर कॉपी हुआ';

  @override
  String added_to_queue(Object tracks) {
    return '$tracks ट्रैक कतार में जोड़े गए';
  }

  @override
  String get filter_albums => 'एल्बमों को फ़िल्टर करें...';

  @override
  String get synced => 'सिंक किया गया';

  @override
  String get plain => 'सादा';

  @override
  String get shuffle => 'शफल';

  @override
  String get search_tracks => 'ट्रैक खोजें...';

  @override
  String get released => 'जारी हुआ';

  @override
  String error(Object error) {
    return 'त्रुटि $error';
  }

  @override
  String get title => 'शीर्षक';

  @override
  String get time => 'समय';

  @override
  String get more_actions => 'अधिक कार्रवाई';

  @override
  String download_count(Object count) {
    return 'डाउनलोड ($count)';
  }

  @override
  String add_count_to_playlist(Object count) {
    return '($count) को प्लेलिस्ट में जोड़ें';
  }

  @override
  String add_count_to_queue(Object count) {
    return '($count) को कतार में जोड़ें';
  }

  @override
  String play_count_next(Object count) {
    return '($count) अगले में चलाएँ';
  }

  @override
  String get album => 'एल्बम';

  @override
  String copied_to_clipboard(Object data) {
    return '$data क्लिपबोर्ड पर कॉपी किया गया';
  }

  @override
  String add_to_following_playlists(Object track) {
    return '$track को निम्नलिखित प्लेलिस्ट में जोड़ें';
  }

  @override
  String get add => 'जोड़ें';

  @override
  String added_track_to_queue(Object track) {
    return '$track को कतार में जोड़ दिया गया';
  }

  @override
  String get add_to_queue => 'कतार में जोड़ें';

  @override
  String track_will_play_next(Object track) {
    return '$track अगले में चलेगा';
  }

  @override
  String get play_next => 'अगले में चलाएँ';

  @override
  String removed_track_from_queue(Object track) {
    return '$track को कतार से हटा दिया गया';
  }

  @override
  String get remove_from_queue => 'कतार से हटाएँ';

  @override
  String get remove_from_favorites => 'पसंदीदा से हटाएँ';

  @override
  String get save_as_favorite => 'पसंदीदा के रूप में सहेजें';

  @override
  String get add_to_playlist => 'प्लेलिस्ट में जोड़ें';

  @override
  String get remove_from_playlist => 'प्लेलिस्ट से हटाएँ';

  @override
  String get add_to_blacklist => 'ब्लैकलिस्ट में जोड़ें';

  @override
  String get remove_from_blacklist => 'ब्लैकलिस्ट से हटाएँ';

  @override
  String get share => 'साझा करें';

  @override
  String get mini_player => 'मिनी प्लेयर';

  @override
  String get slide_to_seek => 'आगे या पीछे खोजने के लिए स्लाइड करें';

  @override
  String get shuffle_playlist => 'प्लेलिस्ट शफल करें';

  @override
  String get unshuffle_playlist => 'अनशफल प्लेलिस्ट';

  @override
  String get previous_track => 'पिछला ट्रैक';

  @override
  String get next_track => 'अगला ट्रैक';

  @override
  String get pause_playback => 'वापसी बंद करें';

  @override
  String get resume_playback => 'पुनः चलाना';

  @override
  String get loop_track => 'लूप ट्रैक';

  @override
  String get no_loop => 'कोई लूप नहीं';

  @override
  String get repeat_playlist => 'प्लेलिस्ट दोहराएं';

  @override
  String get queue => 'कतार';

  @override
  String get alternative_track_sources => 'वैकल्पिक ट्रैक स्रोत';

  @override
  String get download_track => 'ट्रैक डाउनलोड करें';

  @override
  String tracks_in_queue(Object tracks) {
    return '$tracks ट्रैक कतार में हैं';
  }

  @override
  String get clear_all => 'सभी हटाएं';

  @override
  String get show_hide_ui_on_hover => 'होवर पर यूआई दिखाएँ/छिपाएँ';

  @override
  String get always_on_top => 'हमेशा ऊपर हो';

  @override
  String get exit_mini_player => 'मिनी प्लेयर से बाहर निकलें';

  @override
  String get download_location => 'डाउनलोड स्थान';

  @override
  String get local_library => 'स्थानीय पुस्तकालय';

  @override
  String get add_library_location => 'पुस्तकालय में जोड़ें';

  @override
  String get remove_library_location => 'पुस्तकालय से हटाएं';

  @override
  String get account => 'खाता';

  @override
  String get login_with_spotify => 'अपने Spotify खाते से लॉग इन करें';

  @override
  String get connect_with_spotify => 'Spotify से कनेक्ट करें';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get logout_of_this_account => 'इस खाते से लॉगआउट करें';

  @override
  String get language_region => 'भाषा और क्षेत्र';

  @override
  String get language => 'भाषा';

  @override
  String get system_default => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get market_place_region => 'मार्केटप्लेस क्षेत्र';

  @override
  String get recommendation_country => 'सिफ़ारिश देने वाला देश';

  @override
  String get appearance => 'दिखने में';

  @override
  String get layout_mode => 'लेआउट मोड';

  @override
  String get override_layout_settings => 'ओवरराइड रेस्पॉन्सिव लेआउट मोड सेटिंग्स';

  @override
  String get adaptive => 'अनुकूल';

  @override
  String get compact => 'कॉम्पैक्ट';

  @override
  String get extended => 'विस्तृत';

  @override
  String get theme => 'थीम';

  @override
  String get dark => 'डार्क';

  @override
  String get light => 'लाइट';

  @override
  String get system => 'सिस्टम';

  @override
  String get accent_color => 'अक्षरशैली का रंग';

  @override
  String get sync_album_color => 'एल्बम का रंग सिंक करें';

  @override
  String get sync_album_color_description => 'एल्बम कला का प्रधान रंग एक्सेंट रंग के रूप में उपयोग किया जाता है';

  @override
  String get playback => 'प्लेबैक';

  @override
  String get audio_quality => 'ऑडियो क्वालिटी';

  @override
  String get high => 'उच्च';

  @override
  String get low => 'निम्न';

  @override
  String get pre_download_play => 'पूर्वावत डाउनलोड और प्ले करें';

  @override
  String get pre_download_play_description => 'ऑडियो स्ट्रीमिंग की बजाय बाइट्स डाउनलोड करें और बजाय में प्ले करें (उच्च बैंडविड्थ उपयोगकर्ताओं के लिए सिफारिश किया जाता है)';

  @override
  String get skip_non_music => 'गाने के अलावा सेगमेंट्स को छोड़ें (स्पॉन्सरब्लॉक)';

  @override
  String get blacklist_description => 'ब्लैकलिस्ट में शामिल ट्रैक और कलाकार';

  @override
  String get wait_for_download_to_finish => 'वर्तमान डाउनलोड समाप्त होने तक कृपया प्रतीक्षा करें';

  @override
  String get desktop => 'डेस्कटॉप';

  @override
  String get close_behavior => 'बंद करने का व्यवहार';

  @override
  String get close => 'बंद करें';

  @override
  String get minimize_to_tray => 'ट्रे में कम करें';

  @override
  String get show_tray_icon => 'सिस्टम ट्रे आइकन दिखाएं';

  @override
  String get about => 'के बारे में';

  @override
  String get u_love_spotube => 'हम जानते हैं कि आप Spotube से प्यार करते हैं';

  @override
  String get check_for_updates => 'अपडेट के लिए जाँच करें';

  @override
  String get about_spotube => 'Spotube के बारे में';

  @override
  String get blacklist => 'ब्लैकलिस्ट';

  @override
  String get please_sponsor => 'कृपया स्पॉन्सर / डोनेट करें';

  @override
  String get spotube_description => 'Spotube, एक हल्का, सभी प्लेटफॉर्मों पर चलने वाला, मुफ्त स्पॉटिफाई क्लाइंट';

  @override
  String get version => 'संस्करण';

  @override
  String get build_number => 'बिल्ड नंबर';

  @override
  String get founder => 'संस्थापक';

  @override
  String get repository => 'भण्डार';

  @override
  String get bug_issues => 'बग+मुद्दे';

  @override
  String get made_with => 'बांग्लादेश🇧🇩 में दिल से बनाया गया';

  @override
  String get kingkor_roy_tirtho => 'किंगकोर रॉय तिर्थो';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year किंगकोर रॉय तिर्थो';
  }

  @override
  String get license => 'लाइसेंस';

  @override
  String get add_spotify_credentials => 'शुरू होने के लिए अपने स्पॉटिफाई क्रेडेंशियल जोड़ें';

  @override
  String get credentials_will_not_be_shared_disclaimer => 'चिंता न करें, आपके क्रेडेंशियल किसी भी तरह से नहीं एकत्रित या साझा किए जाएंगे';

  @override
  String get know_how_to_login => 'इसे कैसे करें पता नहीं?';

  @override
  String get follow_step_by_step_guide => 'कदम से कदम गाइड के साथ चलें';

  @override
  String spotify_cookie(Object name) {
    return 'स्पॉटिफाई $name कुकी';
  }

  @override
  String cookie_name_cookie(Object name) {
    return '$name कुकी';
  }

  @override
  String get fill_in_all_fields => 'कृपया सभी फ़ील्ड भरें';

  @override
  String get submit => 'सबमिट';

  @override
  String get exit => 'बाहर निकलें';

  @override
  String get previous => 'पिछला';

  @override
  String get next => 'अगला';

  @override
  String get done => 'किया हुआ';

  @override
  String get step_1 => '1 चरण';

  @override
  String get first_go_to => 'पहले, जाएं';

  @override
  String get login_if_not_logged_in => 'और यदि आप लॉगिन नहीं हैं तो लॉगिन / साइनअप करें';

  @override
  String get step_2 => '2 चरण';

  @override
  String get step_2_steps => '1. जब आप लॉगिन हो जाएँ, तो F12 दबाएं या माउस राइट क्लिक> निरीक्षण करें ताकि ब्राउज़र डेवटूल्स खुलें।\n2. फिर ब्राउज़र के \"एप्लिकेशन\" टैब (Chrome, Edge, Brave आदि) या \"स्टोरेज\" टैब (Firefox, Palemoon आदि) में जाएं\n3. \"कुकीज़\" अनुभाग में जाएं फिर \"https: //accounts.spotify.com\" उप-अनुभाग में जाएं';

  @override
  String get step_3 => 'स्टेप 3';

  @override
  String get step_3_steps => '\"sp_dc\" कुकी का मूल्य कॉपी करें';

  @override
  String get success_emoji => 'सफलता🥳';

  @override
  String get success_message => 'अब आप अपने स्पॉटिफाई अकाउंट से सफलतापूर्वक लॉगइन हो गए हैं। अच्छा काम किया!';

  @override
  String get step_4 => 'स्टेप 4';

  @override
  String get step_4_steps => 'कॉपी किए गए \"sp_dc\" मूल्य को पेस्ट करें';

  @override
  String get something_went_wrong => 'कुछ गलत हो गया';

  @override
  String get piped_instance => 'पाइप्ड सर्वर';

  @override
  String get piped_description => 'पाइप किए गए सर्वर';

  @override
  String get piped_warning => 'गानों का मिलान करने के लिए उपयोग किए जाते हैं, हो सकता है कि उनमें से कुछ के साथ ठीक से काम न करें इसलिए अपने जोखिम पर उपयोग करें';

  @override
  String get invidious_instance => 'इन्विडियस सर्वर इंस्टेंस';

  @override
  String get invidious_description => 'ट्रैक मिलान के लिए इन्विडियस सर्वर इंस्टेंस';

  @override
  String get invidious_warning => 'कुछ इंस्टेंस अच्छी तरह से काम नहीं कर सकते। अपने जोखिम पर उपयोग करें';

  @override
  String get generate => 'उत्पन्न करें';

  @override
  String track_exists(Object track) {
    return 'ट्रैक $track पहले से मौजूद है';
  }

  @override
  String get replace_downloaded_tracks => 'सभी डाउनलोड किए गए ट्रैक्स को बदलें';

  @override
  String get skip_download_tracks => 'सभी डाउनलोड किए गए ट्रैक्स को छोड़ें';

  @override
  String get do_you_want_to_replace => 'क्या आप मौजूदा ट्रैक को बदलना चाहते हैं?';

  @override
  String get replace => 'बदलें';

  @override
  String get skip => 'छोड़ें';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return '$count $type तक चुनें';
  }

  @override
  String get select_genres => 'जान्र चुनें';

  @override
  String get add_genres => 'जान्र जोड़ें';

  @override
  String get country => 'देश';

  @override
  String get number_of_tracks_generate => 'उत्पन्न करने के लिए ट्रैक की संख्या';

  @override
  String get acousticness => 'ध्वनिकता';

  @override
  String get danceability => 'नृत्यता';

  @override
  String get energy => 'ऊर्जा';

  @override
  String get instrumentalness => 'आलापिकता';

  @override
  String get liveness => 'जीवंतता';

  @override
  String get loudness => 'शोर';

  @override
  String get speechiness => 'बोलचालता';

  @override
  String get valence => 'मनोदयता';

  @override
  String get popularity => 'लोकप्रियता';

  @override
  String get key => 'कुंजी';

  @override
  String get duration => 'अवधि (सेकंड)';

  @override
  String get tempo => 'गति (BPM)';

  @override
  String get mode => 'मोड';

  @override
  String get time_signature => 'समय छाप';

  @override
  String get short => 'संक्षेप';

  @override
  String get medium => 'मध्यम';

  @override
  String get long => 'लंबा';

  @override
  String get min => 'न्यूनतम';

  @override
  String get max => 'अधिकतम';

  @override
  String get target => 'लक्ष्य';

  @override
  String get moderate => 'मध्यम';

  @override
  String get deselect_all => 'सभी को अचयनित करें';

  @override
  String get select_all => 'सभी को चुनें';

  @override
  String get are_you_sure => 'क्या आपको यकीन है?';

  @override
  String get generating_playlist => 'आपकी कस्टम प्लेलिस्ट बनाई जा रही है...';

  @override
  String selected_count_tracks(Object count) {
    return '$count ट्रैक्स चयनित हैं';
  }

  @override
  String get download_warning => 'यदि आप सभी ट्रैक्स को बल्क में डाउनलोड करते हैं, तो आप स्पष्ट रूप से संगीत की अवैध नकली बना रहे हैं और संगीत के रचनात्मक समाज को क्षति पहुंचा रहे हैं। मुझे आशा है कि आप इसके बारे में जागरूक हैं। हमेशा कोशिश करें कि कलाकार के मेहनत का सम्मान और समर्थन करें।';

  @override
  String get download_ip_ban_warning => 'बाहरी डाउनलोड अनुरोधों के कारण आपका आईपी YouTube पर अधिक से अधिक ब्लॉक हो सकता है। आईपी ब्लॉक का अर्थ है कि आप उसी आईपी उपकरण से कम से कम 2-3 महीनों तक YouTube का उपयोग नहीं कर सकेंगे (यदि आप लॉग इन हैं तो भी)। और स्पोट्यूब किसी भी जिम्मेदारी को नहीं उठाता है अगर ऐसा कभी होता है।';

  @override
  String get by_clicking_accept_terms => '\'स्वीकार\' पर क्लिक करके आप निम्नलिखित शर्तों से सहमत होते हैं:';

  @override
  String get download_agreement_1 => 'मुझे पता है कि मैं संगीत की अवैध नकली बना रहा हूं। मैं बुरा हूं';

  @override
  String get download_agreement_2 => 'मैं कलाकार का समर्थन करूंगा जहां भी मुझे संभव हो और मैं केवल इसल  िए ऐसा कर रहा हूं क्योंकि मेरे पास उनकी कला खरीदने के लिए पैसे नहीं हैं।';

  @override
  String get download_agreement_3 => 'मैं पूरी तरह से जागरूक हूं कि मेरा आईपी YouTube पर ब्लॉक हो सकता है और मैं स्पोट्यूब या उसके मालिकों / सहयोगियों को किसी भी दुर्घटना के लिए जिम्मेदार नहीं मानता।';

  @override
  String get decline => 'इनकार करें';

  @override
  String get accept => 'स्वीकार करें';

  @override
  String get details => 'विवरण';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => 'चैनल';

  @override
  String get likes => 'पसंद';

  @override
  String get dislikes => 'अप्रिय';

  @override
  String get views => 'दृश्य';

  @override
  String get streamUrl => 'स्ट्रीम URL';

  @override
  String get stop => 'रोकें';

  @override
  String get sort_newest => 'नवीनतम जोड़े गए के अनुसार क्रमबद्ध करें';

  @override
  String get sort_oldest => 'सबसे पुराने जोड़े गए के अनुसार क्रमबद्ध करें';

  @override
  String get sleep_timer => 'स्लीप टाइमर';

  @override
  String mins(Object minutes) {
    return '$minutes मिनट';
  }

  @override
  String hours(Object hours) {
    return '$hours घंटे';
  }

  @override
  String hour(Object hours) {
    return '$hours घंटा';
  }

  @override
  String get custom_hours => 'कस्टम घंटे';

  @override
  String get logs => 'लॉग';

  @override
  String get developers => 'डेवलपर्स';

  @override
  String get not_logged_in => 'आप लॉग इन नहीं हैं';

  @override
  String get search_mode => 'खोज मोड';

  @override
  String get audio_source => 'ऑडियो स्रोत';

  @override
  String get ok => 'ठीक है';

  @override
  String get failed_to_encrypt => 'एन्क्रिप्ट करने में विफल रहा';

  @override
  String get encryption_failed_warning => 'Spotube आपके डेटा को सुरक्षित रूप से स्टोर करने के लिए एन्क्रिप्शन का उपयोग करता है। लेकिन इसमें विफल रहा। इसलिए, यह असुरक्षित स्टोरेज पर फॉलबैक करेगा\nयदि आप Linux का उपयोग कर रहे हैं, तो कृपया सुनिश्चित करें कि आपके पास gnome-keyring, kde-wallet, keepassxc आदि जैसी कोई सीक्रेट-सर्विस इंस्टॉल की गई है';

  @override
  String get querying_info => 'जानकारी प्राप्त करना';

  @override
  String get piped_api_down => 'पाइप्ड एपीआई डाउन है';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return 'पाइप्ड इंस्टेंस $pipedInstance वर्तमान में डाउन है\n\nइंस्टेंस बदलें या \'एपीआई प्रकार\' को आधिकृत YouTube एपीआई में बदलें\n\nपरिवर्तन के बाद ऐप को फिर से चालने की सुनिश्चित करें';
  }

  @override
  String get you_are_offline => 'आप वर्तमान में ऑफ़लाइन हैं';

  @override
  String get connection_restored => 'आपका इंटरनेट कनेक्शन बहाल हो गया है';

  @override
  String get use_system_title_bar => 'सिस्टम शीर्षक पट्टी का उपयोग करें';

  @override
  String get crunching_results => 'परिणाम को प्रसंस्कृत किया जा रहा है...';

  @override
  String get search_to_get_results => 'परिणाम प्राप्त करने के लिए खोजें';

  @override
  String get use_amoled_mode => 'AMOLED मोड का उपयोग करें';

  @override
  String get pitch_dark_theme => 'पिच ब्लैक डार्ट थीम';

  @override
  String get normalize_audio => 'ऑडियो को सामान्य करें';

  @override
  String get change_cover => 'कवर बदलें';

  @override
  String get add_cover => 'कवर जोड़ें';

  @override
  String get restore_defaults => 'डिफ़ॉल्ट सेटिंग्स को बहाल करें';

  @override
  String get download_music_codec => 'संगीत कोडेक डाउनलोड करें';

  @override
  String get streaming_music_codec => 'स्ट्रीमिंग संगीत कोडेक';

  @override
  String get login_with_lastfm => 'Last.fm से लॉगिन करें';

  @override
  String get connect => 'कनेक्ट करें';

  @override
  String get disconnect_lastfm => 'Last.fm से डिस्कनेक्ट करें';

  @override
  String get disconnect => 'डिस्कनेक्ट करें';

  @override
  String get username => 'उपयोगकर्ता नाम';

  @override
  String get password => 'पासवर्ड';

  @override
  String get login => 'लॉग इन करें';

  @override
  String get login_with_your_lastfm => 'अपने Last.fm अकाउंट से लॉगिन करें';

  @override
  String get scrobble_to_lastfm => 'Last.fm पर स्क्रॉबल करें';

  @override
  String get go_to_album => 'एल्बम पर जाएं';

  @override
  String get discord_rich_presence => 'डिस्कॉर्ड रिच प्रेजेंस';

  @override
  String get browse_all => 'सभी को ब्राउज़ करें';

  @override
  String get genres => 'शैलियाँ';

  @override
  String get explore_genres => 'शैलियों का अन्वेषण करें';

  @override
  String get friends => 'दोस्त';

  @override
  String get no_lyrics_available => 'क्षमा करें, इस ट्रैक के लिए गाने नहीं मिल सके';

  @override
  String get start_a_radio => 'रेडियो शुरू करें';

  @override
  String get how_to_start_radio => 'रेडियो कैसे शुरू करना चाहते हैं?';

  @override
  String get replace_queue_question => 'क्या आप वर्तमान कतार को बदलना चाहते हैं या इसे जोड़ना चाहते हैं?';

  @override
  String get endless_playback => 'अंतहीन प्लेबैक';

  @override
  String get delete_playlist => 'प्लेलिस्ट हटाएं';

  @override
  String get delete_playlist_confirmation => 'क्या आप वाकई इस प्लेलिस्ट को हटाना चाहते हैं?';

  @override
  String get local_tracks => 'स्थानीय ट्रैक्स';

  @override
  String get local_tab => 'स्थानीय';

  @override
  String get song_link => 'गाने का लिंक';

  @override
  String get skip_this_nonsense => 'इस माया को छोड़ें';

  @override
  String get freedom_of_music => '“संगीत की स्वतंत्रता”';

  @override
  String get freedom_of_music_palm => '“हाथ में संगीत की स्वतंत्रता”';

  @override
  String get get_started => 'आइए शुरू करें';

  @override
  String get youtube_source_description => 'सिफारिश किया गया और सबसे अच्छा काम करता है।';

  @override
  String get piped_source_description => 'मुफ्त महसूस कर रहे हैं? YouTube के समान लेकिन काफी अधिक मुफ्त।';

  @override
  String get jiosaavn_source_description => 'दक्षिण एशियाई क्षेत्र के लिए सर्वोत्तम।';

  @override
  String get invidious_source_description => 'पाइप्ड के समान, लेकिन अधिक उपलब्धता के साथ';

  @override
  String highest_quality(Object quality) {
    return 'सर्वोत्तम गुणवत्ता: $quality';
  }

  @override
  String get select_audio_source => 'ऑडियो स्रोत चुनें';

  @override
  String get endless_playback_description => 'क्रमबद्ध कतार के अंत में नए गाने स्वचालित रूप से जोड़ें';

  @override
  String get choose_your_region => 'अपना क्षेत्र चुनें';

  @override
  String get choose_your_region_description => 'यह Spotube को आपके स्थान के लिए सही सामग्री दिखाने में मदद करेगा।';

  @override
  String get choose_your_language => 'अपनी भाषा चुनें';

  @override
  String get help_project_grow => 'इस परियोजना को बढ़ावा दें';

  @override
  String get help_project_grow_description => 'Spotube एक ओपन सोर्स परियोजना है। आप इस परियोजना को योगदान देकर, बग रिपोर्ट करके या नई विशेषताओं का सुझाव देकर इस परियोजना को बढ़ा सकते हैं।';

  @override
  String get contribute_on_github => 'GitHub पर योगदान करें';

  @override
  String get donate_on_open_collective => 'ओपन कलेक्टिव पर दान करें';

  @override
  String get browse_anonymously => 'बिना नाम के ब्राउज़ करें';

  @override
  String get enable_connect => 'कनेक्ट सक्षम करें';

  @override
  String get enable_connect_description => 'अन्य उपकरणों से Spotube को नियंत्रित करें';

  @override
  String get devices => 'उपकरण';

  @override
  String get select => 'चयन करें';

  @override
  String connect_client_alert(Object client) {
    return 'आप $client द्वारा नियंत्रित हो रहे हैं';
  }

  @override
  String get this_device => 'यह उपकरण';

  @override
  String get remote => 'रिमोट';

  @override
  String get stats => 'आंकड़े';

  @override
  String and_n_more(Object count) {
    return 'और $count और';
  }

  @override
  String get recently_played => 'हाल ही में खेले गए';

  @override
  String get browse_more => 'अधिक ब्राउज़ करें';

  @override
  String get no_title => 'कोई शीर्षक नहीं';

  @override
  String get not_playing => 'नहीं चल रहा';

  @override
  String get epic_failure => 'महान असफलता!';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return '$tracks_length ट्रैक्स कतार में जोड़े गए';
  }

  @override
  String get spotube_has_an_update => 'Spotube में एक अपडेट है';

  @override
  String get download_now => 'अभी डाउनलोड करें';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Spotube Nightly $nightlyBuildNum जारी किया गया है';
  }

  @override
  String release_version(Object version) {
    return 'Spotube v$version जारी किया गया है';
  }

  @override
  String get read_the_latest => 'नवीनतम पढ़ें';

  @override
  String get release_notes => 'रिलीज़ नोट्स';

  @override
  String get pick_color_scheme => 'रंग योजना चुनें';

  @override
  String get save => 'सहेजें';

  @override
  String get choose_the_device => 'उपकरण चुनें:';

  @override
  String get multiple_device_connected => 'कई उपकरण जुड़े हुए हैं।\nउस उपकरण को चुनें जिस पर आप यह क्रिया करना चाहते हैं';

  @override
  String get nothing_found => 'कुछ भी नहीं मिला';

  @override
  String get the_box_is_empty => 'बॉक्स खाली है';

  @override
  String get top_artists => 'शीर्ष कलाकार';

  @override
  String get top_albums => 'शीर्ष एल्बम';

  @override
  String get this_week => 'इस हफ्ते';

  @override
  String get this_month => 'इस महीने';

  @override
  String get last_6_months => 'पिछले 6 महीने';

  @override
  String get this_year => 'इस साल';

  @override
  String get last_2_years => 'पिछले 2 साल';

  @override
  String get all_time => 'सभी समय';

  @override
  String powered_by_provider(Object providerName) {
    return '$providerName द्वारा संचालित';
  }

  @override
  String get email => 'ईमेल';

  @override
  String get profile_followers => 'अनुयायी';

  @override
  String get birthday => 'जन्मदिन';

  @override
  String get subscription => 'सदस्यता';

  @override
  String get not_born => 'अभी पैदा नहीं हुआ';

  @override
  String get hacker => 'हैकर';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get no_name => 'कोई नाम नहीं';

  @override
  String get edit => 'संपादित करें';

  @override
  String get user_profile => 'उपयोगकर्ता प्रोफ़ाइल';

  @override
  String count_plays(Object count) {
    return '$count प्ले';
  }

  @override
  String get streaming_fees_hypothetical => '*Spotify की प्रति स्ट्रीम भुगतान के आधार पर\n\$0.003 से \$0.005 तक गणना की गई है। यह एक काल्पनिक\nगणना है जो उपयोगकर्ता को यह जानकारी देती है कि वे कितना भुगतान\nकरते यदि वे Spotify पर गाने सुनते।';

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
    return '$minutes मिनट';
  }

  @override
  String get summary_minutes => 'मिनट';

  @override
  String get summary_listened_to_music => 'सुनी गई संगीत';

  @override
  String get summary_songs => 'गाने';

  @override
  String get summary_streamed_overall => 'कुल स्ट्रीम';

  @override
  String get summary_owed_to_artists => 'कलाकारों को देनदार\nइस महीने';

  @override
  String get summary_artists => 'कलाकार';

  @override
  String get summary_music_reached_you => 'संगीत आपके पास पहुंच गया';

  @override
  String get summary_full_albums => 'पूरा एल्बम';

  @override
  String get summary_got_your_love => 'आपका प्यार मिला';

  @override
  String get summary_playlists => 'प्लेलिस्ट';

  @override
  String get summary_were_on_repeat => 'दोहराया गया';

  @override
  String total_money(Object money) {
    return 'कुल $money';
  }

  @override
  String get webview_not_found => 'वेबव्यू नहीं मिला';

  @override
  String get webview_not_found_description => 'आपके डिवाइस पर वेबव्यू रनटाइम इंस्टॉल नहीं है।\nअगर इंस्टॉल है, तो सुनिश्चित करें कि यह environment PATH में है\n\nइंस्टॉल करने के बाद, ऐप को पुनः शुरू करें';

  @override
  String get unsupported_platform => 'असमर्थित प्लेटफार्म';

  @override
  String get cache_music => 'संगीत को कैश करें';

  @override
  String get open => 'खोलें';

  @override
  String get cache_folder => 'कैश फ़ोल्डर';

  @override
  String get export => 'निर्यात करें';

  @override
  String get clear_cache => 'कैश साफ़ करें';

  @override
  String get clear_cache_confirmation => 'क्या आप कैश साफ़ करना चाहते हैं?';

  @override
  String get export_cache_files => 'कैश फ़ाइलें निर्यात करें';

  @override
  String found_n_files(Object count) {
    return '$count फ़ाइलें मिलीं';
  }

  @override
  String get export_cache_confirmation => 'क्या आप इन फ़ाइलों को निर्यात करना चाहते हैं';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return '$filesExported फ़ाइलें निर्यात की गईं $files में से';
  }

  @override
  String get undo => 'पूर्ववत करें';

  @override
  String get download_all => 'सभी डाउनलोड करें';

  @override
  String get add_all_to_playlist => 'सभी को प्लेलिस्ट में जोड़ें';

  @override
  String get add_all_to_queue => 'सभी को कतार में जोड़ें';

  @override
  String get play_all_next => 'सभी को अगले खेलने के लिए';

  @override
  String get pause => 'रोकें';

  @override
  String get view_all => 'सभी देखें';

  @override
  String get no_tracks_added_yet => 'लगता है आपने अभी तक कोई ट्रैक नहीं जोड़ा है।';

  @override
  String get no_tracks => 'लगता है यहाँ कोई ट्रैक नहीं है।';

  @override
  String get no_tracks_listened_yet => 'लगता है आपने अभी तक कुछ नहीं सुना है।';

  @override
  String get not_following_artists => 'आप किसी भी कलाकार को फॉलो नहीं कर रहे हैं।';

  @override
  String get no_favorite_albums_yet => 'लगता है आपने अभी तक कोई एल्बम अपनी पसंदीदा सूची में नहीं जोड़ा है।';

  @override
  String get no_logs_found => 'कोई लॉग नहीं मिला';

  @override
  String get youtube_engine => 'YouTube इंजन';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engine स्थापित नहीं है';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engine आपके सिस्टम में स्थापित नहीं है।';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return 'यह सुनिश्चित करें कि यह PATH वेरिएबल में उपलब्ध हो या\nनीचे $engine निष्पादन योग्य फ़ाइल का पूर्ण पथ सेट करें।';
  }

  @override
  String get youtube_engine_unix_issue_message => 'macOS/Linux/यूनिक्स जैसे OS में, .zshrc/.bashrc/.bash_profile आदि में पथ सेट करना काम नहीं करेगा।\nआपको पथ को शेल कॉन्फ़िगरेशन फ़ाइल में सेट करना होगा।';

  @override
  String get download => 'डाउनलोड करें';

  @override
  String get file_not_found => 'फाइल नहीं मिली';

  @override
  String get custom => 'कस्टम';

  @override
  String get add_custom_url => 'कस्टम URL जोड़ें';
}
