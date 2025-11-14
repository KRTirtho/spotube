// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tagalog (`tl`).
class AppLocalizationsTl extends AppLocalizations {
  AppLocalizationsTl([String locale = 'tl']) : super(locale);

  @override
  String get guest => 'Bisita';

  @override
  String get browse => 'Mag-browse';

  @override
  String get search => 'Maghanap';

  @override
  String get library => 'Silid-aklatan';

  @override
  String get lyrics => 'Mga Liriko';

  @override
  String get settings => 'Mga Setting';

  @override
  String get genre_categories_filter => 'I-filter ang mga kategorya o genre...';

  @override
  String get genre => 'Genre';

  @override
  String get personalized => 'Naka-personalize';

  @override
  String get featured => 'Tampok';

  @override
  String get new_releases => 'Mga Bagong Paglabas';

  @override
  String get songs => 'Mga Kanta';

  @override
  String playing_track(Object track) {
    return 'Tumutugtog ang $track';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return 'Ito ay magbubura ng kasalukuyang pila. $track_length na mga track ang tatanggalin\nGusto mo bang magpatuloy?';
  }

  @override
  String get load_more => 'Mag-load pa';

  @override
  String get playlists => 'Mga Playlist';

  @override
  String get artists => 'Mga Artista';

  @override
  String get albums => 'Mga Album';

  @override
  String get tracks => 'Mga Track';

  @override
  String get downloads => 'Mga Download';

  @override
  String get filter_playlists => 'I-filter ang iyong mga playlist...';

  @override
  String get liked_tracks => 'Mga Nagustuhang Track';

  @override
  String get liked_tracks_description =>
      'Lahat ng mga track na iyong nagustuhan';

  @override
  String get playlist => 'Playlist';

  @override
  String get create_a_playlist => 'Gumawa ng playlist';

  @override
  String get update_playlist => 'I-update ang playlist';

  @override
  String get create => 'Lumikha';

  @override
  String get cancel => 'Ikansela';

  @override
  String get update => 'I-update';

  @override
  String get playlist_name => 'Pangalan ng Playlist';

  @override
  String get name_of_playlist => 'Pangalan ng playlist';

  @override
  String get description => 'Paglalarawan';

  @override
  String get public => 'Pampubliko';

  @override
  String get collaborative => 'Pakikipagtulungan';

  @override
  String get search_local_tracks => 'Maghanap ng mga lokal na track...';

  @override
  String get play => 'I-play';

  @override
  String get delete => 'Burahin';

  @override
  String get none => 'Wala';

  @override
  String get sort_a_z => 'Ayusin ayon sa A-Z';

  @override
  String get sort_z_a => 'Ayusin ayon sa Z-A';

  @override
  String get sort_artist => 'Ayusin ayon sa Artista';

  @override
  String get sort_album => 'Ayusin ayon sa Album';

  @override
  String get sort_duration => 'Ayusin ayon sa Tagal';

  @override
  String get sort_tracks => 'Ayusin ang mga Track';

  @override
  String currently_downloading(Object tracks_length) {
    return 'Kasalukuyang Nagda-download ($tracks_length)';
  }

  @override
  String get cancel_all => 'Kanselahin Lahat';

  @override
  String get filter_artist => 'I-filter ang mga artista...';

  @override
  String followers(Object followers) {
    return '$followers na mga Tagasunod';
  }

  @override
  String get add_artist_to_blacklist => 'Idagdag ang artista sa blacklist';

  @override
  String get top_tracks => 'Mga Nangungunang Track';

  @override
  String get fans_also_like => 'Gusto rin ng mga tagahanga';

  @override
  String get loading => 'Naglo-load...';

  @override
  String get artist => 'Artista';

  @override
  String get blacklisted => 'Naka-blacklist';

  @override
  String get following => 'Sinusundan';

  @override
  String get follow => 'Sundan';

  @override
  String get artist_url_copied => 'Na-copy sa clipboard ang URL ng artista';

  @override
  String added_to_queue(Object tracks) {
    return 'Idinagdag ang $tracks na mga track sa pila';
  }

  @override
  String get filter_albums => 'I-filter ang mga album...';

  @override
  String get synced => 'Naka-sync';

  @override
  String get plain => 'Simpleng';

  @override
  String get shuffle => 'I-shuffle';

  @override
  String get search_tracks => 'Maghanap ng mga track...';

  @override
  String get released => 'Inilabas';

  @override
  String error(Object error) {
    return 'Error $error';
  }

  @override
  String get title => 'Pamagat';

  @override
  String get time => 'Oras';

  @override
  String get more_actions => 'Higit pang mga aksyon';

  @override
  String download_count(Object count) {
    return 'I-download ($count)';
  }

  @override
  String add_count_to_playlist(Object count) {
    return 'Idagdag ($count) sa Playlist';
  }

  @override
  String add_count_to_queue(Object count) {
    return 'Idagdag ($count) sa Pila';
  }

  @override
  String play_count_next(Object count) {
    return 'I-play ($count) kasunod';
  }

  @override
  String get album => 'Album';

  @override
  String copied_to_clipboard(Object data) {
    return 'Na-copy ang $data sa clipboard';
  }

  @override
  String add_to_following_playlists(Object track) {
    return 'Idagdag ang $track sa mga sumusunod na Playlist';
  }

  @override
  String get add => 'Idagdag';

  @override
  String added_track_to_queue(Object track) {
    return 'Idinagdag ang $track sa pila';
  }

  @override
  String get add_to_queue => 'Idagdag sa pila';

  @override
  String track_will_play_next(Object track) {
    return 'Ang $track ay tutugtog susunod';
  }

  @override
  String get play_next => 'I-play susunod';

  @override
  String removed_track_from_queue(Object track) {
    return 'Tinanggal ang $track mula sa pila';
  }

  @override
  String get remove_from_queue => 'Alisin mula sa pila';

  @override
  String get remove_from_favorites => 'Alisin mula sa mga paborito';

  @override
  String get save_as_favorite => 'I-save bilang paborito';

  @override
  String get add_to_playlist => 'Idagdag sa playlist';

  @override
  String get remove_from_playlist => 'Alisin mula sa playlist';

  @override
  String get add_to_blacklist => 'Idagdag sa blacklist';

  @override
  String get remove_from_blacklist => 'Alisin mula sa blacklist';

  @override
  String get share => 'Ibahagi';

  @override
  String get mini_player => 'Mini Player';

  @override
  String get slide_to_seek => 'I-slide para mag-seek pasulong o pabalik';

  @override
  String get shuffle_playlist => 'I-shuffle ang playlist';

  @override
  String get unshuffle_playlist => 'I-unshuffle ang playlist';

  @override
  String get previous_track => 'Nakaraang track';

  @override
  String get next_track => 'Susunod na track';

  @override
  String get pause_playback => 'I-pause ang Playback';

  @override
  String get resume_playback => 'Ipagpatuloy ang Playback';

  @override
  String get loop_track => 'I-loop ang track';

  @override
  String get no_loop => 'Walang loop';

  @override
  String get repeat_playlist => 'Ulitin ang playlist';

  @override
  String get queue => 'Pila';

  @override
  String get alternative_track_sources =>
      'Alternatibong mga pinagmulan ng track';

  @override
  String get download_track => 'I-download ang track';

  @override
  String tracks_in_queue(Object tracks) {
    return '$tracks na mga track sa pila';
  }

  @override
  String get clear_all => 'Burahin lahat';

  @override
  String get show_hide_ui_on_hover => 'Ipakita/Itago ang UI sa hover';

  @override
  String get always_on_top => 'Palaging nasa ibabaw';

  @override
  String get exit_mini_player => 'Lumabas sa Mini player';

  @override
  String get download_location => 'Lokasyon ng pag-download';

  @override
  String get local_library => 'Lokal na silid-aklatan';

  @override
  String get add_library_location => 'Idagdag sa silid-aklatan';

  @override
  String get remove_library_location => 'Alisin mula sa silid-aklatan';

  @override
  String get account => 'Account';

  @override
  String get logout => 'Mag-logout';

  @override
  String get logout_of_this_account => 'Mag-logout sa account na ito';

  @override
  String get language_region => 'Wika at Rehiyon';

  @override
  String get language => 'Wika';

  @override
  String get system_default => 'Default ng Sistema';

  @override
  String get market_place_region => 'Rehiyon ng Marketplace';

  @override
  String get recommendation_country => 'Bansang Inirerekomenda';

  @override
  String get appearance => 'Hitsura';

  @override
  String get layout_mode => 'Mode ng Layout';

  @override
  String get override_layout_settings =>
      'I-override ang mga setting ng responsive layout mode';

  @override
  String get adaptive => 'Umaangkop';

  @override
  String get compact => 'Kompakto';

  @override
  String get extended => 'Pinalawig';

  @override
  String get theme => 'Tema';

  @override
  String get dark => 'Madilim';

  @override
  String get light => 'Maliwanag';

  @override
  String get system => 'Sistema';

  @override
  String get accent_color => 'Kulay ng Accent';

  @override
  String get sync_album_color => 'I-sync ang kulay ng album';

  @override
  String get sync_album_color_description =>
      'Ginagamit ang pangunahing kulay ng album art bilang kulay ng accent';

  @override
  String get playback => 'Playback';

  @override
  String get audio_quality => 'Kalidad ng Audio';

  @override
  String get high => 'Mataas';

  @override
  String get low => 'Mababa';

  @override
  String get pre_download_play => 'Mag-pre-download at i-play';

  @override
  String get pre_download_play_description =>
      'Sa halip na mag-stream ng audio, mag-download ng bytes at i-play sa halip (Inirerekomenda para sa mga gumagamit ng mataas na bandwidth)';

  @override
  String get skip_non_music =>
      'Laktawan ang mga segment na hindi musika (SponsorBlock)';

  @override
  String get blacklist_description => 'Mga track at artista na nasa blacklist';

  @override
  String get wait_for_download_to_finish =>
      'Mangyaring maghintay para matapos ang kasalukuyang pag-download';

  @override
  String get desktop => 'Desktop';

  @override
  String get close_behavior => 'Pag-uugali ng Pagsara';

  @override
  String get close => 'Isara';

  @override
  String get minimize_to_tray => 'I-minimize sa tray';

  @override
  String get show_tray_icon => 'Ipakita ang icon ng System tray';

  @override
  String get about => 'Tungkol sa';

  @override
  String get u_love_spotube => 'Alam naming gusto mo ang Spotube';

  @override
  String get check_for_updates => 'Maghanap ng mga update';

  @override
  String get about_spotube => 'Tungkol sa Spotube';

  @override
  String get blacklist => 'Blacklist';

  @override
  String get please_sponsor => 'Mangyaring Mag-sponsor/Mag-donate';

  @override
  String get spotube_description =>
      'Spotube, isang magaan, cross-platform, libreng-para-sa-lahat na spotify client';

  @override
  String get version => 'Bersyon';

  @override
  String get build_number => 'Build Number';

  @override
  String get founder => 'Nagtatag';

  @override
  String get repository => 'Repository';

  @override
  String get bug_issues => 'Bug+Mga Isyu';

  @override
  String get made_with => 'Ginawa nang may ❤️ sa Bangladesh🇧🇩';

  @override
  String get kingkor_roy_tirtho => 'Kingkor Roy Tirtho';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year Kingkor Roy Tirtho';
  }

  @override
  String get license => 'Lisensya';

  @override
  String get credentials_will_not_be_shared_disclaimer =>
      'Huwag mag-alala, ang alinman sa iyong mga kredensyal ay hindi kokolektahin o ibabahagi sa sinuman';

  @override
  String get know_how_to_login => 'Hindi mo alam kung paano gawin ito?';

  @override
  String get follow_step_by_step_guide => 'Sundin ang Hakbang-hakbang na gabay';

  @override
  String cookie_name_cookie(Object name) {
    return '$name Cookie';
  }

  @override
  String get fill_in_all_fields => 'Mangyaring punan ang lahat ng field';

  @override
  String get submit => 'Isumite';

  @override
  String get exit => 'Lumabas';

  @override
  String get previous => 'Nakaraan';

  @override
  String get next => 'Susunod';

  @override
  String get done => 'Tapos na';

  @override
  String get step_1 => 'Hakbang 1';

  @override
  String get first_go_to => 'Una, Pumunta sa';

  @override
  String get something_went_wrong => 'May nangyaring mali';

  @override
  String get piped_instance => 'Instance ng Piped Server';

  @override
  String get piped_description =>
      'Ang instance ng Piped server na gagamitin para sa pagtutugma ng track';

  @override
  String get piped_warning =>
      'Maaaring hindi gumagana nang mabuti ang ilan sa mga ito. Kaya gamitin sa sarili mong peligro';

  @override
  String get invidious_instance => 'Instance ng Invidious Server';

  @override
  String get invidious_description =>
      'Ang instance ng Invidious server na gagamitin para sa pagtutugma ng track';

  @override
  String get invidious_warning =>
      'Maaaring hindi gumagana nang mabuti ang ilan sa mga ito. Kaya gamitin sa sarili mong peligro';

  @override
  String get generate => 'Gumawa';

  @override
  String track_exists(Object track) {
    return 'Ang Track na $track ay umiiral na';
  }

  @override
  String get replace_downloaded_tracks =>
      'Palitan ang lahat ng na-download na mga track';

  @override
  String get skip_download_tracks =>
      'Laktawan ang pag-download ng lahat ng na-download na mga track';

  @override
  String get do_you_want_to_replace =>
      'Gusto mo bang palitan ang umiiral na track??';

  @override
  String get replace => 'Palitan';

  @override
  String get skip => 'Laktawan';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return 'Pumili ng hanggang $count $type';
  }

  @override
  String get select_genres => 'Pumili ng mga Genre';

  @override
  String get add_genres => 'Magdagdag ng mga Genre';

  @override
  String get country => 'Bansa';

  @override
  String get number_of_tracks_generate => 'Bilang ng mga track na gagawin';

  @override
  String get acousticness => 'Acoustic-ness';

  @override
  String get danceability => 'Kakayahang Sayawin';

  @override
  String get energy => 'Enerhiya';

  @override
  String get instrumentalness => 'Instrumental-ness';

  @override
  String get liveness => 'Liveness';

  @override
  String get loudness => 'Lakas';

  @override
  String get speechiness => 'Pagsasalita';

  @override
  String get valence => 'Valence';

  @override
  String get popularity => 'Popularidad';

  @override
  String get key => 'Key';

  @override
  String get duration => 'Tagal (s)';

  @override
  String get tempo => 'Tempo (BPM)';

  @override
  String get mode => 'Mode';

  @override
  String get time_signature => 'Time Signature';

  @override
  String get short => 'Maikli';

  @override
  String get medium => 'Katamtaman';

  @override
  String get long => 'Mahaba';

  @override
  String get min => 'Min';

  @override
  String get max => 'Max';

  @override
  String get target => 'Target';

  @override
  String get moderate => 'Katamtaman';

  @override
  String get deselect_all => 'Alisin ang Pagkakapili sa Lahat';

  @override
  String get select_all => 'Piliin Lahat';

  @override
  String get are_you_sure => 'Sigurado ka ba?';

  @override
  String get generating_playlist => 'Gumagawa ng iyong custom na playlist...';

  @override
  String selected_count_tracks(Object count) {
    return 'Napili ang $count na mga track';
  }

  @override
  String get download_warning =>
      'Kung nag-download ka ng lahat ng Track sa maramihan, malinaw na nagpa-pirate ka ng Musika at nagsasanhi ng pinsala sa creative society ng Musika. Sana ay alam mo ito. Palaging, subukang igalang at suportahan ang masipag na paggawa ng Artist';

  @override
  String get download_ip_ban_warning =>
      'Sa nga pala, ang iyong IP ay maaaring ma-block sa YouTube dahil sa sobrang mga kahilingan sa pag-download kaysa sa karaniwan. Ang IP block ay nangangahulugang hindi mo magagamit ang YouTube (kahit na naka-log in ka) sa loob ng hindi bababa sa 2-3 buwan mula sa device na may IP na iyon. At hindi pinanghahawakan ng Spotube ang anumang responsibilidad kung mangyayari ito';

  @override
  String get by_clicking_accept_terms =>
      'Sa pamamagitan ng pag-click sa \'tanggapin\', sumasang-ayon ka sa mga sumusunod na tuntunin:';

  @override
  String get download_agreement_1 =>
      'Alam kong nagpa-pirate ako ng Musika. Masama ako';

  @override
  String get download_agreement_2 =>
      'Susuportahan ko ang Artist saan man ako maaari at ginagawa ko lang ito dahil wala akong pera para bumili ng kanilang sining';

  @override
  String get download_agreement_3 =>
      'Lubos kong nauunawaan na ang aking IP ay maaaring ma-block sa YouTube at hindi ko pinanghahawakan ang Spotube o ang kanyang mga may-ari/nag-ambag na responsable para sa anumang aksidente na sanhi ng aking kasalukuyang aksyon';

  @override
  String get decline => 'Tanggihan';

  @override
  String get accept => 'Tanggapin';

  @override
  String get details => 'Mga Detalye';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => 'Channel';

  @override
  String get likes => 'Mga Like';

  @override
  String get dislikes => 'Mga Dislike';

  @override
  String get views => 'Mga View';

  @override
  String get streamUrl => 'Stream URL';

  @override
  String get stop => 'Ihinto';

  @override
  String get sort_newest => 'Ayusin ayon sa pinakabagong idinagdag';

  @override
  String get sort_oldest => 'Ayusin ayon sa pinakalumang idinagdag';

  @override
  String get sleep_timer => 'Sleep Timer';

  @override
  String mins(Object minutes) {
    return '$minutes Minuto';
  }

  @override
  String hours(Object hours) {
    return '$hours Oras';
  }

  @override
  String hour(Object hours) {
    return '$hours Oras';
  }

  @override
  String get custom_hours => 'Custom na Oras';

  @override
  String get logs => 'Mga Log';

  @override
  String get developers => 'Mga Developer';

  @override
  String get not_logged_in => 'Hindi ka naka-log in';

  @override
  String get search_mode => 'Mode ng Paghahanap';

  @override
  String get audio_source => 'Pinagmulan ng Audio';

  @override
  String get ok => 'Ok';

  @override
  String get failed_to_encrypt => 'Nabigong i-encrypt';

  @override
  String get encryption_failed_warning =>
      'Gumagamit ng encryption ang Spotube para ligtas na i-store ang iyong data. Ngunit nabigo. Kaya babalik ito sa hindi secure na storage\nKung gumagamit ka ng linux, mangyaring tiyakin na mayroon kang anumang secret-service na naka-install (gnome-keyring, kde-wallet, keepassxc atbp)';

  @override
  String get querying_info => 'Kinukuha ang impormasyon...';

  @override
  String get piped_api_down => 'Ang Piped API ay hindi gumagana';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return 'Ang instance ng Piped na $pipedInstance ay kasalukuyang hindi gumagana\n\nMaaari mong baguhin ang instance o baguhin ang \'Uri ng API\' sa opisyal na YouTube API\n\nSiguraduhing i-restart ang app pagkatapos ng pagbabago';
  }

  @override
  String get you_are_offline => 'Kasalukuyan kang offline';

  @override
  String get connection_restored =>
      'Naibalik na ang iyong koneksyon sa internet';

  @override
  String get use_system_title_bar => 'Gamitin ang title bar ng system';

  @override
  String get crunching_results => 'Pinaproseso ang mga resulta...';

  @override
  String get search_to_get_results => 'Maghanap para makakuha ng mga resulta';

  @override
  String get use_amoled_mode => 'Matingkad na itim na madilim na tema';

  @override
  String get pitch_dark_theme => 'AMOLED Mode';

  @override
  String get normalize_audio => 'I-normalize ang audio';

  @override
  String get change_cover => 'Baguhin ang cover';

  @override
  String get add_cover => 'Magdagdag ng cover';

  @override
  String get restore_defaults => 'Ibalik ang mga default';

  @override
  String get download_music_format => 'I-download na format ng musika';

  @override
  String get streaming_music_format => 'Format ng streaming ng musika';

  @override
  String get download_music_quality => 'Kalidad ng i-download na musika';

  @override
  String get streaming_music_quality => 'Kalidad ng streaming ng musika';

  @override
  String get login_with_lastfm => 'Mag-login gamit ang Last.fm';

  @override
  String get connect => 'Kumonekta';

  @override
  String get disconnect_lastfm => 'Idiskonekta ang Last.fm';

  @override
  String get disconnect => 'Idiskonekta';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get login => 'Mag-login';

  @override
  String get login_with_your_lastfm =>
      'Mag-login gamit ang iyong Last.fm account';

  @override
  String get scrobble_to_lastfm => 'I-scrobble sa Last.fm';

  @override
  String get go_to_album => 'Pumunta sa Album';

  @override
  String get discord_rich_presence => 'Discord Rich Presence';

  @override
  String get browse_all => 'I-browse Lahat';

  @override
  String get genres => 'Mga Genre';

  @override
  String get explore_genres => 'Tuklasin ang mga Genre';

  @override
  String get friends => 'Mga Kaibigan';

  @override
  String get no_lyrics_available =>
      'Paumanhin, hindi mahanap ang lyrics para sa track na ito';

  @override
  String get start_a_radio => 'Magsimula ng Radio';

  @override
  String get how_to_start_radio => 'Paano mo gustong simulan ang radio?';

  @override
  String get replace_queue_question =>
      'Gusto mo bang palitan ang kasalukuyang pila o idagdag dito?';

  @override
  String get endless_playback => 'Walang Hanggang Playback';

  @override
  String get delete_playlist => 'Burahin ang Playlist';

  @override
  String get delete_playlist_confirmation =>
      'Sigurado ka bang gusto mong burahin ang playlist na ito?';

  @override
  String get local_tracks => 'Mga Lokal na Track';

  @override
  String get local_tab => 'Lokal';

  @override
  String get song_link => 'Link ng Kanta';

  @override
  String get skip_this_nonsense => 'Laktawan ang kalokohan na ito';

  @override
  String get freedom_of_music => '\"Kalayaan ng Musika\"';

  @override
  String get freedom_of_music_palm => '\"Kalayaan ng Musika sa iyong palad\"';

  @override
  String get get_started => 'Magsimula na tayo';

  @override
  String get youtube_source_description =>
      'Inirerekomenda at pinakamahusay na gumagana.';

  @override
  String get piped_source_description =>
      'Gusto ng kalayaan? Kapareho ng YouTube ngunit mas malaya.';

  @override
  String get jiosaavn_source_description =>
      'Pinakamahusay para sa rehiyon ng South Asia.';

  @override
  String get invidious_source_description =>
      'Katulad ng Piped ngunit may mas mataas na availability.';

  @override
  String highest_quality(Object quality) {
    return 'Pinakamataas na Kalidad: $quality';
  }

  @override
  String get select_audio_source => 'Pumili ng Pinagmulan ng Audio';

  @override
  String get endless_playback_description =>
      'Awtomatikong magdagdag ng mga bagong kanta\nsa dulo ng pila';

  @override
  String get choose_your_region => 'Piliin ang iyong rehiyon';

  @override
  String get choose_your_region_description =>
      'Ito ay tutulong sa Spotube na ipakita sa iyo ang tamang content\npara sa iyong lokasyon.';

  @override
  String get choose_your_language => 'Piliin ang iyong wika';

  @override
  String get help_project_grow => 'Tulungan ang proyektong ito na lumago';

  @override
  String get help_project_grow_description =>
      'Ang Spotube ay isang open-source na proyekto. Maaari mong tulungan ang proyektong ito na lumago sa pamamagitan ng pag-contribute sa proyekto, pag-ulat ng mga bug, o pagmungkahi ng mga bagong feature.';

  @override
  String get contribute_on_github => 'Mag-contribute sa GitHub';

  @override
  String get donate_on_open_collective => 'Mag-donate sa Open Collective';

  @override
  String get browse_anonymously => 'Mag-browse nang Anonymous';

  @override
  String get enable_connect => 'I-enable ang Connect';

  @override
  String get enable_connect_description =>
      'Kontrolin ang Spotube mula sa ibang mga device';

  @override
  String get devices => 'Mga Device';

  @override
  String get select => 'Pumili';

  @override
  String connect_client_alert(Object client) {
    return 'Ikaw ay kontrolado ng $client';
  }

  @override
  String get this_device => 'Ang Device na ito';

  @override
  String get remote => 'Remote';

  @override
  String get stats => 'Mga Stat';

  @override
  String and_n_more(Object count) {
    return 'at $count pa';
  }

  @override
  String get recently_played => 'Kamakailan Lang na Ni-play';

  @override
  String get browse_more => 'Mag-browse pa';

  @override
  String get no_title => 'Walang Pamagat';

  @override
  String get not_playing => 'Hindi tumutugtog';

  @override
  String get epic_failure => 'Epic na pagkabigo!';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return 'Nagdagdag ng $tracks_length na mga track sa pila';
  }

  @override
  String get spotube_has_an_update => 'Ang Spotube ay may update';

  @override
  String get download_now => 'I-download Ngayon';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Ang Spotube Nightly $nightlyBuildNum ay inilabas na';
  }

  @override
  String release_version(Object version) {
    return 'Ang Spotube v$version ay inilabas na';
  }

  @override
  String get read_the_latest => 'Basahin ang pinakabagong ';

  @override
  String get release_notes => 'release notes';

  @override
  String get pick_color_scheme => 'Pumili ng color scheme';

  @override
  String get save => 'I-save';

  @override
  String get choose_the_device => 'Piliin ang device:';

  @override
  String get multiple_device_connected =>
      'Mayroong maraming device na nakakonekta.\nPiliin ang device kung saan mo gustong maganap ang aksyon na ito';

  @override
  String get nothing_found => 'Walang nahanap';

  @override
  String get the_box_is_empty => 'Ang kahon ay walang laman';

  @override
  String get top_artists => 'Nangungunang mga Artista';

  @override
  String get top_albums => 'Nangungunang mga Album';

  @override
  String get this_week => 'Ngayong linggo';

  @override
  String get this_month => 'Ngayong buwan';

  @override
  String get last_6_months => 'Nakaraang 6 na buwan';

  @override
  String get this_year => 'Ngayong taon';

  @override
  String get last_2_years => 'Nakaraang 2 taon';

  @override
  String get all_time => 'Lahat ng panahon';

  @override
  String powered_by_provider(Object providerName) {
    return 'Pinapagana ng $providerName';
  }

  @override
  String get email => 'Email';

  @override
  String get profile_followers => 'Mga Tagasunod';

  @override
  String get birthday => 'Kaarawan';

  @override
  String get subscription => 'Subscription';

  @override
  String get not_born => 'Hindi pa ipinanganak';

  @override
  String get hacker => 'Hacker';

  @override
  String get profile => 'Profile';

  @override
  String get no_name => 'Walang Pangalan';

  @override
  String get edit => 'I-edit';

  @override
  String get user_profile => 'Profile ng User';

  @override
  String count_plays(Object count) {
    return '$count na mga play';
  }

  @override
  String get streaming_fees_hypothetical =>
      'Mga bayarin sa streaming (hypothetical)';

  @override
  String get minutes_listened => 'Mga minutong pinapakinggan';

  @override
  String get streamed_songs => 'Mga na-stream na kanta';

  @override
  String count_streams(Object count) {
    return '$count na mga stream';
  }

  @override
  String get owned_by_you => 'Pag-aari mo';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return 'Na-kopya ang $shareUrl sa clipboard';
  }

  @override
  String get hipotetical_calculation =>
      '*Ito ay kinakalkula batay sa average na payout ng online music streaming platform na \$0.003 hanggang \$0.005 kada stream. Ito ay isang hypothetical na kalkulasyon upang bigyan ang user ng insight kung magkano ang babayaran nila sa mga artist kung sakaling makinig sila ng kanilang kanta sa iba\'t ibang music streaming platform.';

  @override
  String count_mins(Object minutes) {
    return '$minutes minuto';
  }

  @override
  String get summary_minutes => 'minuto';

  @override
  String get summary_listened_to_music => 'Nakinig sa musika';

  @override
  String get summary_songs => 'mga kanta';

  @override
  String get summary_streamed_overall => 'Na-stream sa kabuuan';

  @override
  String get summary_owed_to_artists => 'Utang sa mga artista\nngayong buwan';

  @override
  String get summary_artists => 'artista';

  @override
  String get summary_music_reached_you => 'Umabot sa iyo ang musika';

  @override
  String get summary_full_albums => 'buong album';

  @override
  String get summary_got_your_love => 'Nakuha ang iyong pagmamahal';

  @override
  String get summary_playlists => 'mga playlist';

  @override
  String get summary_were_on_repeat => 'Pinu-playlst muli';

  @override
  String total_money(Object money) {
    return 'Kabuuang $money';
  }

  @override
  String get webview_not_found => 'Hindi nahanap ang Webview';

  @override
  String get webview_not_found_description =>
      'Walang webview runtime na naka-install sa iyong device.\nKung naka-install ito, siguraduhing nasa Environment PATH\n\nPagkatapos mag-install, i-restart ang app';

  @override
  String get unsupported_platform => 'Hindi suportadong platform';

  @override
  String get cache_music => 'I-cache ang musika';

  @override
  String get open => 'Buksan';

  @override
  String get cache_folder => 'Folder ng cache';

  @override
  String get export => 'I-export';

  @override
  String get clear_cache => 'Burahin ang cache';

  @override
  String get clear_cache_confirmation => 'Gusto mo bang burahin ang cache?';

  @override
  String get export_cache_files => 'I-export ang mga Naka-cache na File';

  @override
  String found_n_files(Object count) {
    return 'Nahanap ang $count na mga file';
  }

  @override
  String get export_cache_confirmation =>
      'Gusto mo bang i-export ang mga file na ito sa';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return 'Na-export ang $filesExported mula sa $files na mga file';
  }

  @override
  String get undo => 'I-undo';

  @override
  String get download_all => 'I-download lahat';

  @override
  String get add_all_to_playlist => 'Idagdag lahat sa playlist';

  @override
  String get add_all_to_queue => 'Idagdag lahat sa pila';

  @override
  String get play_all_next => 'I-play lahat susunod';

  @override
  String get pause => 'Pause';

  @override
  String get view_all => 'Tingnan lahat';

  @override
  String get no_tracks_added_yet =>
      'Mukhang wala ka pang idinaragdag na mga track';

  @override
  String get no_tracks => 'Mukhang walang mga track dito';

  @override
  String get no_tracks_listened_yet => 'Mukhang wala ka pang pinakikinggan';

  @override
  String get not_following_artists =>
      'Hindi ka sumusunod sa anumang mga artista';

  @override
  String get no_favorite_albums_yet =>
      'Mukhang wala ka pang idinagdag na anumang mga album sa iyong mga paborito';

  @override
  String get no_logs_found => 'Walang nahanap na mga log';

  @override
  String get youtube_engine => 'YouTube Engine';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return 'Hindi naka-install ang $engine';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return 'Hindi naka-install ang $engine sa iyong sistema.';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return 'Siguraduhing available ito sa PATH variable o\ni-set ang absolute path sa $engine executable sa ibaba';
  }

  @override
  String get youtube_engine_unix_issue_message =>
      'Sa macOS/Linux/unix tulad ng OS, ang pag-set ng path sa .zshrc/.bashrc/.bash_profile atbp. ay hindi gagana.\nKailangan mong i-set ang path sa configuration file ng shell';

  @override
  String get download => 'I-download';

  @override
  String get file_not_found => 'Hindi nahanap ang file';

  @override
  String get custom => 'Custom';

  @override
  String get add_custom_url => 'Magdagdag ng custom URL';

  @override
  String get edit_port => 'I-edit ang port';

  @override
  String get port_helper_msg =>
      'Ang default ay -1 na nagpapahiwatig ng random na numero. Kung na-configure mo ang firewall, inirerekomenda na itakda ito.';

  @override
  String connect_request(Object client) {
    return 'Payagan ang $client na kumonekta?';
  }

  @override
  String get connection_request_denied =>
      'Tanggihan ang koneksyon. Tinanggihan ng gumagamit ang pag-access.';

  @override
  String get an_error_occurred => 'May naganap na error';

  @override
  String get copy_to_clipboard => 'Kopyahin sa clipboard';

  @override
  String get view_logs => 'Tingnan ang mga log';

  @override
  String get retry => 'Subukang muli';

  @override
  String get no_default_metadata_provider_selected =>
      'Wala kang nakatakdang default na metadata provider';

  @override
  String get manage_metadata_providers =>
      'Pamahalaan ang mga metadata provider';

  @override
  String get open_link_in_browser => 'Buksan ang Link sa Browser?';

  @override
  String get do_you_want_to_open_the_following_link =>
      'Gusto mo bang buksan ang sumusunod na link';

  @override
  String get unsafe_url_warning =>
      'Maaaring hindi ligtas ang pagbukas ng mga link mula sa hindi pinagkakatiwalaang pinagmulan. Mag-ingat!\nMaaari mo ring kopyahin ang link sa iyong clipboard.';

  @override
  String get copy_link => 'Kopyahin ang Link';

  @override
  String get building_your_timeline =>
      'Binubuo ang iyong timeline batay sa iyong mga pinakinggan...';

  @override
  String get official => 'Opisyal';

  @override
  String author_name(Object author) {
    return 'May-akda: $author';
  }

  @override
  String get third_party => 'Third-party';

  @override
  String get plugin_requires_authentication =>
      'Nangangailangan ng authentication ang plugin';

  @override
  String get update_available => 'May available na update';

  @override
  String get supports_scrobbling => 'Sinusuportahan ang scrobbling';

  @override
  String get plugin_scrobbling_info =>
      'Sinis-scrobble ng plugin na ito ang iyong musika upang mabuo ang iyong kasaysayan ng pakikinig.';

  @override
  String get default_metadata_source => 'Default na pinagmulan ng metadata';

  @override
  String get set_default_metadata_source =>
      'Itakda ang default na pinagmulan ng metadata';

  @override
  String get default_audio_source => 'Default na pinagmulan ng audio';

  @override
  String get set_default_audio_source =>
      'Itakda ang default na pinagmulan ng audio';

  @override
  String get set_default => 'Itakda bilang default';

  @override
  String get support => 'Suporta';

  @override
  String get support_plugin_development => 'Suportahan ang pagbuo ng plugin';

  @override
  String can_access_name_api(Object name) {
    return '- Maaaring i-access ang **$name** API';
  }

  @override
  String get do_you_want_to_install_this_plugin =>
      'Gusto mo bang i-install ang plugin na ito?';

  @override
  String get third_party_plugin_warning =>
      'Ang plugin na ito ay mula sa third-party na repository. Mangyaring tiyakin na pinagkakatiwalaan mo ang pinagmulan bago mag-install.';

  @override
  String get author => 'May-akda';

  @override
  String get this_plugin_can_do_following =>
      'Maaaring gawin ng plugin na ito ang sumusunod';

  @override
  String get install => 'I-install';

  @override
  String get install_a_metadata_provider => 'Mag-install ng Metadata Provider';

  @override
  String get no_tracks_playing => 'Walang Track na kasalukuyang tumutugtog';

  @override
  String get synced_lyrics_not_available =>
      'Hindi available ang mga naka-sync na lyrics para sa kantang ito. Mangyaring gamitin ang';

  @override
  String get plain_lyrics => 'Simpleng Lyrics';

  @override
  String get tab_instead => 'na tab sa halip.';

  @override
  String get disclaimer => 'Disclaimer';

  @override
  String get third_party_plugin_dmca_notice =>
      'Ang Spotube team ay walang hawak na anumang responsibilidad (kabilang ang legal) para sa anumang \"Third-party\" plugins.\nMangyaring gamitin ang mga ito sa iyong sariling peligro. Para sa anumang mga bug/isyu, mangyaring iulat ang mga ito sa repository ng plugin.\n\nKung ang anumang \"Third-party\" plugin ay lumalabag sa ToS/DMCA ng anumang serbisyo/legal na entity, mangyaring hilingin sa \"Third-party\" plugin author o sa hosting platform e.g. GitHub/Codeberg na gumawa ng aksyon. Ang nakalista sa itaas (\"Third-party\" na may label) ay lahat ng pampubliko/komunidad na pinananatiling mga plugin. Hindi namin sila kinukurusado, kaya hindi kami makakagawa ng anumang aksyon sa kanila.\n\n';

  @override
  String get input_does_not_match_format =>
      'Ang input ay hindi tumutugma sa kinakailangang format';

  @override
  String get plugins => 'Mga plugin';

  @override
  String get paste_plugin_download_url =>
      'I-paste ang download url o GitHub/Codeberg repo url o direktang link sa .smplug file';

  @override
  String get download_and_install_plugin_from_url =>
      'I-download at i-install ang plugin mula sa url';

  @override
  String failed_to_add_plugin_error(Object error) {
    return 'Nabigo ang pagdagdag ng plugin: $error';
  }

  @override
  String get upload_plugin_from_file => 'I-upload ang plugin mula sa file';

  @override
  String get installed => 'Naka-install';

  @override
  String get available_plugins => 'Mga available na plugin';

  @override
  String get configure_plugins =>
      'I-configure ang sarili mong metadata provider at mga audio source plugin';

  @override
  String get audio_scrobblers => 'Mga Audio Scrobbler';

  @override
  String get scrobbling => 'Scrobbling';

  @override
  String get source => 'Pinagmulan: ';

  @override
  String get uncompressed => 'Hindi naka-compress';

  @override
  String get dab_music_source_description =>
      'Para sa mga audiophile. Nagbibigay ng de-kalidad/walang loss na audio streams. Tumpak na pagtutugma ng track batay sa ISRC.';
}
