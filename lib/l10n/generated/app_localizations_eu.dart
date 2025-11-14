// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Basque (`eu`).
class AppLocalizationsEu extends AppLocalizations {
  AppLocalizationsEu([String locale = 'eu']) : super(locale);

  @override
  String get guest => 'Gonbidatua';

  @override
  String get browse => 'Arakatu';

  @override
  String get search => 'Bilatu';

  @override
  String get library => 'Liburutegia';

  @override
  String get lyrics => 'Hitzak';

  @override
  String get settings => 'Ezarpenak';

  @override
  String get genre_categories_filter => 'Kategoria edo generoak filtratu...';

  @override
  String get genre => 'Generoa';

  @override
  String get personalized => 'Pertsonalizatua';

  @override
  String get featured => 'Nabarmenduak';

  @override
  String get new_releases => 'Argitaratze berriak';

  @override
  String get songs => 'Abestiak';

  @override
  String playing_track(Object track) {
    return '$track erreproduzitzen';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return 'Uneko zerrenda ezabatuko da. $track_length abesti ezabatuko dira.\nJarraitu nahi duzu?';
  }

  @override
  String get load_more => 'Gehiago kargatu';

  @override
  String get playlists => 'Zerrendak';

  @override
  String get artists => 'Artistak';

  @override
  String get albums => 'Albumak';

  @override
  String get tracks => 'Kantak';

  @override
  String get downloads => 'Deskargak';

  @override
  String get filter_playlists => 'Zure zerrendak filtratu...';

  @override
  String get liked_tracks => 'Gustuko Kantak';

  @override
  String get liked_tracks_description => 'Zure gustuko kanta guztiak';

  @override
  String get playlist => 'Playlist';

  @override
  String get create_a_playlist => 'Sortu zerrenda bat';

  @override
  String get update_playlist => 'Eguneratu zerrenda';

  @override
  String get create => 'Sortu';

  @override
  String get cancel => 'Ezeztatu';

  @override
  String get update => 'Eguneratu';

  @override
  String get playlist_name => 'Zerrenda Izena';

  @override
  String get name_of_playlist => 'Zerrendaren izena';

  @override
  String get description => 'Deskribapena';

  @override
  String get public => 'Publikoa';

  @override
  String get collaborative => 'Kolaboratiboa';

  @override
  String get search_local_tracks => 'Bilatu kanta lokalak...';

  @override
  String get play => 'Erreproduzitu';

  @override
  String get delete => 'Ezabatu';

  @override
  String get none => 'Batere ez';

  @override
  String get sort_a_z => 'Ordenatu A-Z';

  @override
  String get sort_z_a => 'Ordenatu Z-A';

  @override
  String get sort_artist => 'Ordenatu Artistaren arabera';

  @override
  String get sort_album => 'Ordenatu Albumaren arabera';

  @override
  String get sort_duration => 'Ordenar Iraupenaren arabera';

  @override
  String get sort_tracks => 'Ordenatu Kantak';

  @override
  String currently_downloading(Object tracks_length) {
    return 'Oraintxe ($tracks_length) deskargatzen';
  }

  @override
  String get cancel_all => 'Ezeztatu dena';

  @override
  String get filter_artist => 'Filtratu artistak...';

  @override
  String followers(Object followers) {
    return '$followers Jarraitzaile';
  }

  @override
  String get add_artist_to_blacklist => 'Gehitu artista zerrenda beltzera';

  @override
  String get top_tracks => 'Top Kantak';

  @override
  String get fans_also_like => 'Fan-ek hau ere gustuko dute';

  @override
  String get loading => 'Kargatzen...';

  @override
  String get artist => 'Artista';

  @override
  String get blacklisted => 'Zerrenda beltzean';

  @override
  String get following => 'Jarraitzen';

  @override
  String get follow => 'Jarraitu';

  @override
  String get artist_url_copied => 'Artistaren URL-a arbelera kopiatua';

  @override
  String added_to_queue(Object tracks) {
    return '$tracks kanta zerrendara gehituak';
  }

  @override
  String get filter_albums => 'Albumak filtratu...';

  @override
  String get synced => 'Sinkronizatuta';

  @override
  String get plain => 'Arrunta';

  @override
  String get shuffle => 'Ausaz';

  @override
  String get search_tracks => 'Bilatu kantak...';

  @override
  String get released => 'Argitaratua';

  @override
  String error(Object error) {
    return 'Errorea: $error';
  }

  @override
  String get title => 'Izenburua';

  @override
  String get time => 'Iraupena';

  @override
  String get more_actions => 'Ekintza gehiago';

  @override
  String download_count(Object count) {
    return '($count) deskarga';
  }

  @override
  String add_count_to_playlist(Object count) {
    return 'Gehitu ($count) zerrendara';
  }

  @override
  String add_count_to_queue(Object count) {
    return 'Gehitu ($count) ilarara';
  }

  @override
  String play_count_next(Object count) {
    return 'Erreproduzitu hurrengo ($count)-ak';
  }

  @override
  String get album => 'Albuma';

  @override
  String copied_to_clipboard(Object data) {
    return '$data arbelean kopiatua';
  }

  @override
  String add_to_following_playlists(Object track) {
    return 'Gehitu $track hurrengo erreprodukzio-zerrendetara';
  }

  @override
  String get add => 'Gehitu';

  @override
  String added_track_to_queue(Object track) {
    return '$track zerrendan gehitua';
  }

  @override
  String get add_to_queue => 'Gehitu zerrendan';

  @override
  String track_will_play_next(Object track) {
    return '$track erreproduzituko da ondoren';
  }

  @override
  String get play_next => 'Hurrengo erreprodukzioa';

  @override
  String removed_track_from_queue(Object track) {
    return '$track zerrendatik ezabatua';
  }

  @override
  String get remove_from_queue => 'Ezabatu ilaratik';

  @override
  String get remove_from_favorites => 'Ezabatu gogokoetatik';

  @override
  String get save_as_favorite => 'Gorde gogokoetan';

  @override
  String get add_to_playlist => 'Gehitu zerrendara';

  @override
  String get remove_from_playlist => 'Ezabatu zerrendatik';

  @override
  String get add_to_blacklist => 'Gehitu zerrenda beltzera';

  @override
  String get remove_from_blacklist => 'Ezabatu zerrenda beltzetik';

  @override
  String get share => 'Elkarbanatu';

  @override
  String get mini_player => 'Mini Erreproduzitzailea';

  @override
  String get slide_to_seek => 'Arrastatu aurrerantz edo atzearantz bilatzeko';

  @override
  String get shuffle_playlist => 'Erreproduzitu zerrenda ausazko ordenean';

  @override
  String get unshuffle_playlist => 'Desgaitu ausazko erreprodukzioa';

  @override
  String get previous_track => 'Aurreko pista';

  @override
  String get next_track => 'Hurrengo pista';

  @override
  String get pause_playback => 'Pausatu erreprodukzioa';

  @override
  String get resume_playback => 'Berrabiarazi erreprodukzioa';

  @override
  String get loop_track => 'Kanta begiztan';

  @override
  String get no_loop => 'Ez dago loop-ik';

  @override
  String get repeat_playlist => 'Errepikatu lista';

  @override
  String get queue => 'Ilara';

  @override
  String get alternative_track_sources => 'Kanten iturri alternatiboak';

  @override
  String get download_track => 'Deskargatu kanta';

  @override
  String tracks_in_queue(Object tracks) {
    return '$tracks kanta zerrendan';
  }

  @override
  String get clear_all => 'Garbitu dena';

  @override
  String get show_hide_ui_on_hover =>
      'Erakutsi/Ezkutatu interfazea kurtsorea pasatzean';

  @override
  String get always_on_top => 'Beti ikusgai';

  @override
  String get exit_mini_player => 'Irten mini erreproduzitzailetik';

  @override
  String get download_location => 'Deskargen kokapena';

  @override
  String get local_library => 'Liburutegi lokala';

  @override
  String get add_library_location => 'Gehitu liburutegira';

  @override
  String get remove_library_location => 'Kendu liburutegitik';

  @override
  String get account => 'Kontua';

  @override
  String get logout => 'Itxi saioa';

  @override
  String get logout_of_this_account => 'Itxi kontu honen saioa';

  @override
  String get language_region => 'Hizkuntza eta Herrialdea';

  @override
  String get language => 'Hizkuntza';

  @override
  String get system_default => 'Sisteman lehenetsia';

  @override
  String get market_place_region => 'Dendaren herrialdea';

  @override
  String get recommendation_country => 'Gomendio herrialdea';

  @override
  String get appearance => 'Itxura';

  @override
  String get layout_mode => 'Diseinua';

  @override
  String get override_layout_settings =>
      'Responsive diseinuaren ezarpenak ezeztatu';

  @override
  String get adaptive => 'Moldagarria';

  @override
  String get compact => 'Trinkoa';

  @override
  String get extended => 'Hedatua';

  @override
  String get theme => 'Gaia';

  @override
  String get dark => 'Iluna';

  @override
  String get light => 'Argia';

  @override
  String get system => 'Sistema';

  @override
  String get accent_color => 'Azentu kolorea';

  @override
  String get sync_album_color => 'Sinkronizatu albumaren kolorea';

  @override
  String get sync_album_color_description =>
      'Albumaren artearen kolore nagusia erabili azentu kolore bezala';

  @override
  String get playback => 'Erreprodukzioa';

  @override
  String get audio_quality => 'Audioaren kalitatea';

  @override
  String get high => 'Altua';

  @override
  String get low => 'Baxua';

  @override
  String get pre_download_play => 'Aurre-deskargatu eta erreproduzitu';

  @override
  String get pre_download_play_description =>
      'Streaming egin beharrean, byte-ak deskargatu eta erreproduzitu (banda-zabalera handia duten erabiltzaileentzat gomendagarria)';

  @override
  String get skip_non_music =>
      'Musika ez diren segmentuak baztertu (SponsorBlock)';

  @override
  String get blacklist_description => 'Zerrenda beltzeko abesti eta artistak';

  @override
  String get wait_for_download_to_finish =>
      'Mesedez, itxaron uneko deskarga bukatu arte';

  @override
  String get desktop => 'Mahaigaina';

  @override
  String get close_behavior => 'Ixterako Portaera';

  @override
  String get close => 'Itxi';

  @override
  String get minimize_to_tray => 'Sistemako erretilura minimizatu';

  @override
  String get show_tray_icon => 'Erakutsi ikonoa sistemaren erretiluan';

  @override
  String get about => 'Honi buruz';

  @override
  String get u_love_spotube => 'Badakigu Spotube maite duzula';

  @override
  String get check_for_updates => 'Bilatu eguneraketak';

  @override
  String get about_spotube => 'Spotube-ri buruz';

  @override
  String get blacklist => 'Zerrenda beltza';

  @override
  String get please_sponsor => 'Mesedez, babestu/diruz lagundu';

  @override
  String get spotube_description =>
      'Spotube, arina, plataforma-anitza eta doakoa den Spotify-ren bezeroa';

  @override
  String get version => 'Bertsioa';

  @override
  String get build_number => 'Konpilazio zenbakia';

  @override
  String get founder => 'Sortzailea';

  @override
  String get repository => 'Errepositorioa';

  @override
  String get bug_issues => 'Erroreak eta arazoak';

  @override
  String get made_with => 'Bangladesh🇧🇩-en ❤️-z egina';

  @override
  String get kingkor_roy_tirtho => 'Kingkor Roy Tirtho';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year Kingkor Roy Tirtho';
  }

  @override
  String get license => 'Lizentzia';

  @override
  String get credentials_will_not_be_shared_disclaimer =>
      'Ez arduratu, zure kredentzialak ez ditugu bilduko edo inorekin elkarbanatuko';

  @override
  String get know_how_to_login => 'Ez dakizu nola egin?';

  @override
  String get follow_step_by_step_guide => 'Jarraitu pausoz-pausoko gida';

  @override
  String cookie_name_cookie(Object name) {
    return '$name cookiea';
  }

  @override
  String get fill_in_all_fields => 'Mesedez, osatu eremu guztiak';

  @override
  String get submit => 'Bidali';

  @override
  String get exit => 'Irten';

  @override
  String get previous => 'Aurrekoa';

  @override
  String get next => 'Hurrengoa';

  @override
  String get done => 'Eginda';

  @override
  String get step_1 => '1. pausua';

  @override
  String get first_go_to => 'Hasteko, joan hona';

  @override
  String get something_went_wrong => 'Zerbaitek huts egin du';

  @override
  String get piped_instance => 'Piped zerbitzariaren instantzia';

  @override
  String get piped_description =>
      'Kanten koizidentzietan erabiltzeko Piped zerbitzariaren instantzia';

  @override
  String get piped_warning =>
      'Batzuk agian ez dute ongi funtzionatuko, zure ardurapean erabili';

  @override
  String get invidious_instance => 'Invidious zerbitzari instantzia';

  @override
  String get invidious_description =>
      'Invidious zerbitzari instantzia, pistak bat egiteko';

  @override
  String get invidious_warning =>
      'Instantzia batzuek ez dute ondo funtzionatuko. Zure erantzukizunpean erabili';

  @override
  String get generate => 'Sortu';

  @override
  String track_exists(Object track) {
    return '$track kanta dagoeneko badago';
  }

  @override
  String get replace_downloaded_tracks =>
      'Ordezkatu deskargatutako kanta guztiak';

  @override
  String get skip_download_tracks =>
      'Deskargatutako kanta guztien deskarga baztertu';

  @override
  String get do_you_want_to_replace => 'Dagoen kanta ordezkatu nahi duzu??';

  @override
  String get replace => 'Ordezkatu';

  @override
  String get skip => 'Baztertu';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return 'Aukertu $count $type';
  }

  @override
  String get select_genres => 'Aukeratu Generoak';

  @override
  String get add_genres => 'Gehitu Generoak';

  @override
  String get country => 'Herrialdea';

  @override
  String get number_of_tracks_generate => 'Sortzeko kanta kopurua';

  @override
  String get acousticness => 'Akustikotasuna';

  @override
  String get danceability => 'Dantzagarritasuna';

  @override
  String get energy => 'Energia';

  @override
  String get instrumentalness => 'Instrumentaltasuna';

  @override
  String get liveness => 'Zuzenean';

  @override
  String get loudness => 'Ozentasuna';

  @override
  String get speechiness => 'Hitzaldia';

  @override
  String get valence => 'Balentzia';

  @override
  String get popularity => 'Populartasuna';

  @override
  String get key => 'Tonua';

  @override
  String get duration => 'Iraupena (s)';

  @override
  String get tempo => 'Tenpoa (BPM)';

  @override
  String get mode => 'Modua';

  @override
  String get time_signature => 'Konpasa';

  @override
  String get short => 'Motza';

  @override
  String get medium => 'Ertaina';

  @override
  String get long => 'Luzea';

  @override
  String get min => 'Min.';

  @override
  String get max => 'Max.';

  @override
  String get target => 'Helburua';

  @override
  String get moderate => 'Moderatua';

  @override
  String get deselect_all => 'Desaukeratu dena';

  @override
  String get select_all => 'Aukeratu dena';

  @override
  String get are_you_sure => 'Ziur zaude?';

  @override
  String get generating_playlist =>
      'Zure pertsonalizatutako zerrenda sortzen...';

  @override
  String selected_count_tracks(Object count) {
    return '$count kanta aukeratuta';
  }

  @override
  String get download_warning =>
      'Abesti guztiak aldi berean deskargatuz gero, argi dago musika pirateatzen ari zarela eta musikaren gizarte sortzaileari kalte egiten diozula. Honen jakitun izan eta artisten lan gogorra errespetatu eta babestea espero dut';

  @override
  String get download_ip_ban_warning =>
      'Bidenabar, baliteke zure IPa YouTuben blokeatzea deskarga eskera gehiegi egiten badituzu. IPa blokeatzeak esan nahi du ezin izango duzula YouTube erabili (nahiz eta saioa hasia izan) gutxienez 2-3 hilabetez IP helbide horretatik. Eta Spotube ez da erantzule izango hori gertatzen bazaizu';

  @override
  String get by_clicking_accept_terms =>
      '\'Onartu\' klikatzean, ondorengo baldintzak onartzen dituzu:';

  @override
  String get download_agreement_1 =>
      'Badakit musika pirateatzen ari naizela. Gaiztoa naiz';

  @override
  String get download_agreement_2 =>
      'Ahal dudanean lagunduko diot artistari baina oraingoz ez dut bere artea erosteko dirurik';

  @override
  String get download_agreement_3 =>
      'Erabat jakitun naiz YouTubek nire IPa blokea dezakeela eta ez diot Spotube-ri edo bere jabe/laguntzaileei erantzukizunik eskatuko nire oraingo jokaerak ekar ditzakeen arazoengatik';

  @override
  String get decline => 'Baztertu';

  @override
  String get accept => 'Onartu';

  @override
  String get details => 'Xehetasunak';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => 'Kanala';

  @override
  String get likes => 'Gustukoak';

  @override
  String get dislikes => 'Ez gustukoak';

  @override
  String get views => 'Ikuspenak';

  @override
  String get streamUrl => 'Streaming-aren URLa';

  @override
  String get stop => 'Gelditu';

  @override
  String get sort_newest => 'Ordenatu gehitu berrienetik';

  @override
  String get sort_oldest => 'Ordenatu gehitu zaharrenetik';

  @override
  String get sleep_timer => 'Itzaltzeko tenporizadorea';

  @override
  String mins(Object minutes) {
    return '$minutes minutu';
  }

  @override
  String hours(Object hours) {
    return '$hours ordu';
  }

  @override
  String hour(Object hours) {
    return '$hours ordu';
  }

  @override
  String get custom_hours => 'Ordu pertsonalizatuak';

  @override
  String get logs => 'Log-ak';

  @override
  String get developers => 'Garatzaileak';

  @override
  String get not_logged_in => 'Ez duzu saioa hasi';

  @override
  String get search_mode => 'Bilaketa modua';

  @override
  String get audio_source => 'Audio Iturria';

  @override
  String get ok => 'OK';

  @override
  String get failed_to_encrypt => 'Errorea zifratzean';

  @override
  String get encryption_failed_warning =>
      'Spotube-ek zifratzea darabil datuak modu seguruan biltegiratzeko. Baina huts egin du. Hori dela eta, biltegiratzea ez da segurua izango\nLinux erabiltzen ari bazara, ziurtatu edozein sekretu-zerbitzu (gnome-keyring, kde-wallet, keepassxc etab.) instalatuta duzula';

  @override
  String get querying_info => 'Informazioa egiaztatzen...';

  @override
  String get piped_api_down => 'Piped-en APIa ez dago eskuragarri';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return 'Piped-en $pipedInstance instantzia ez dago martxan une honetan\n\nAldatu instantzia edo aldatu \'API mota\' YouTuberen API ofizialera\n\nZiurtatu aplikazioa berrabiarazten duzula aldaketa eta gero';
  }

  @override
  String get you_are_offline => 'Une honetan konexiorik gabe zaude';

  @override
  String get connection_restored => 'Internet konexioa berrezarri egin da';

  @override
  String get use_system_title_bar => 'Erabili sistemako izenburu barra';

  @override
  String get crunching_results => 'Emaitzak prozesatzen...';

  @override
  String get search_to_get_results => 'Bilatu emaitzak lortzeko';

  @override
  String get use_amoled_mode => 'Erabili AMOLED modua';

  @override
  String get pitch_dark_theme => 'Dart-en gai iluna';

  @override
  String get normalize_audio => 'Normalizatu audioa';

  @override
  String get change_cover => 'Aldatu azala';

  @override
  String get add_cover => 'Gehitu azala';

  @override
  String get restore_defaults => 'Berrezarri berezko balioak';

  @override
  String get download_music_format => 'Musika deskargatzeko formatua';

  @override
  String get streaming_music_format => 'Musika streaming bidezko formatua';

  @override
  String get download_music_quality => 'Musika deskargaren kalitatea';

  @override
  String get streaming_music_quality => 'Streaming bidezko musika kalitatea';

  @override
  String get login_with_lastfm => 'Hasi saioa Last.fm-n';

  @override
  String get connect => 'Konektatu';

  @override
  String get disconnect_lastfm => 'Deskonektatu Last.fm-tik';

  @override
  String get disconnect => 'Deskonektatu';

  @override
  String get username => 'Erabiltzaile izena';

  @override
  String get password => 'Pasahitza';

  @override
  String get login => 'Hasi saioa';

  @override
  String get login_with_your_lastfm => 'Hasi saioa Last.fm-ko zure kontuarekin';

  @override
  String get scrobble_to_lastfm => 'Scrobble Last.fm-ra';

  @override
  String get go_to_album => 'Albumera joan';

  @override
  String get discord_rich_presence => 'Discord-en presentzia aberatsa';

  @override
  String get browse_all => 'Esploratu dena';

  @override
  String get genres => 'Generoak';

  @override
  String get explore_genres => 'Esploratu generoak';

  @override
  String get friends => 'Lagunak';

  @override
  String get no_lyrics_available =>
      'Sentitzen dugu, ezin dira kanta honen hitzak aurkitu';

  @override
  String get start_a_radio => 'Hasi Irrati bat';

  @override
  String get how_to_start_radio => 'Nola hasi nahi duzu irratia?';

  @override
  String get replace_queue_question =>
      'Uneko zerrenda ordezkatu nahi duzu edo bertan gehitu?';

  @override
  String get endless_playback => 'Amaigabeko erreprodukzioa';

  @override
  String get delete_playlist => 'Ezabatu zerrenda';

  @override
  String get delete_playlist_confirmation =>
      'Ziur zaude zerrenda ezabatu nahi duzula?';

  @override
  String get local_tracks => 'Kanta lokalak';

  @override
  String get local_tab => 'Lokalean';

  @override
  String get song_link => 'Kantaren lotura';

  @override
  String get skip_this_nonsense => 'Utzi txorakeria hau';

  @override
  String get freedom_of_music => '“Musika Askatasuna”';

  @override
  String get freedom_of_music_palm => '“Musika Askatasuna zure eskuetan”';

  @override
  String get get_started => 'Has gaitezen';

  @override
  String get youtube_source_description => 'Gomendatua eta hobekien dabilena.';

  @override
  String get piped_source_description =>
      'Aske zara? YouTube bezala, baino askeago.';

  @override
  String get jiosaavn_source_description =>
      'Asia hegoaldeko herrialdeetarako hoberena.';

  @override
  String get invidious_source_description =>
      'Piped-en antzekoa, baina eskuragarritasun handiagoarekin';

  @override
  String highest_quality(Object quality) {
    return 'Kalitate Onena: $quality';
  }

  @override
  String get select_audio_source => 'Aukeratu Audio Iturria';

  @override
  String get endless_playback_description =>
      'Gehitu automatikoki kanta berriak\n ilararen bukaeran';

  @override
  String get choose_your_region => 'Aukeratu zure herrialdea';

  @override
  String get choose_your_region_description =>
      'Honekin Spotube-k zure kokalerakuari dagokion edukia\neskeiniko dizu.';

  @override
  String get choose_your_language => 'Aukeratu zure hizkuntza';

  @override
  String get help_project_grow => 'Lagundu proiektu honi hazten';

  @override
  String get help_project_grow_description =>
      'Spotube kode irekiko proiektu bat da. Proiektu hau hazten lagundu dezakezu, erroreak jakinaraziz edo ezaugarri berriak proposatuz.';

  @override
  String get contribute_on_github => 'GitHub-en lagundu';

  @override
  String get donate_on_open_collective => 'Open Collective-en diruz lagundu';

  @override
  String get browse_anonymously => 'Nabigatu Anonimoki';

  @override
  String get enable_connect => 'Gaitu konexioa';

  @override
  String get enable_connect_description =>
      'Kontrolatu Spotube beste gailu batzuetatik';

  @override
  String get devices => 'Gailuak';

  @override
  String get select => 'Aukeratu';

  @override
  String connect_client_alert(Object client) {
    return '$client gailuak kontrolatzen zaitu';
  }

  @override
  String get this_device => 'Gailu hau';

  @override
  String get remote => 'Urrunekoa';

  @override
  String get stats => 'Estatistikak';

  @override
  String and_n_more(Object count) {
    return 'eta $count gehiago';
  }

  @override
  String get recently_played => 'Berriki entzunak';

  @override
  String get browse_more => 'Gehiago Bilatu';

  @override
  String get no_title => 'Titulurik ez';

  @override
  String get not_playing => 'Erreprodukziorik ez';

  @override
  String get epic_failure => 'Sekulako errorea!';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return '$tracks_length kanta gehitu dira zerrendara';
  }

  @override
  String get spotube_has_an_update => 'Spotube-ren eguneraketa bat dago';

  @override
  String get download_now => 'Orain deskargatu';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Spotube $nightlyBuildNum Nightly-a argitaratu da';
  }

  @override
  String release_version(Object version) {
    return 'Spotube v$version argitaratu da';
  }

  @override
  String get read_the_latest => 'Irakurri azken ';

  @override
  String get release_notes => 'argitatratze oharrak';

  @override
  String get pick_color_scheme => 'Aukeratu kolore eskema';

  @override
  String get save => 'Gorde';

  @override
  String get choose_the_device => 'Aukeratu gailua:';

  @override
  String get multiple_device_connected =>
      'Hainbat gailu daude konektatuta.\nAukeratu zein gailutan aplikatu nahi duzun ekintza hau';

  @override
  String get nothing_found => 'Ezer ez da aurkitu';

  @override
  String get the_box_is_empty => 'Kaxa hutsik dago';

  @override
  String get top_artists => 'Top Artistak';

  @override
  String get top_albums => 'Top Albumak';

  @override
  String get this_week => 'Aste honetan';

  @override
  String get this_month => 'Hilabete honetan';

  @override
  String get last_6_months => 'Azken 6 hilabeteetan';

  @override
  String get this_year => 'Aurten';

  @override
  String get last_2_years => 'Azken 2 urtetan';

  @override
  String get all_time => 'Betidanik';

  @override
  String powered_by_provider(Object providerName) {
    return '$providerName-ren eskutik';
  }

  @override
  String get email => 'Email';

  @override
  String get profile_followers => 'Jarraitzaileak';

  @override
  String get birthday => 'Jaiotze-data';

  @override
  String get subscription => 'Harpidetzak';

  @override
  String get not_born => 'Jaio gabe';

  @override
  String get hacker => 'Hacker';

  @override
  String get profile => 'Profila';

  @override
  String get no_name => 'Izenik Ez';

  @override
  String get edit => 'Editatu';

  @override
  String get user_profile => 'Erabiltzaile Profila';

  @override
  String count_plays(Object count) {
    return '$count erreprodukzio';
  }

  @override
  String get streaming_fees_hypothetical =>
      'Streaming ordainketa (hipotetikoa)';

  @override
  String get minutes_listened => 'Entzundako minutuak';

  @override
  String get streamed_songs => 'Streaming-ez entzundako kantak';

  @override
  String count_streams(Object count) {
    return '$count stream';
  }

  @override
  String get owned_by_you => 'Zure jabetzakoa';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return '$shareUrl arbelera kopiatua';
  }

  @override
  String get hipotetical_calculation =>
      '*Kalkulu hau online musika-streaming plataformetako batez besteko irteerako ordainari (0,003–0,005 USD) oinarrituta dago. Hipotetikoa da eta erabiltzaileari ideia bat ematen laguntzen dio artista nork zenbat kobratu zuen jakiteko, bere abestia plataform desberdinetan entzungo balu.';

  @override
  String count_mins(Object minutes) {
    return '$minutes minutu';
  }

  @override
  String get summary_minutes => 'minutu';

  @override
  String get summary_listened_to_music => 'Musika entzuten';

  @override
  String get summary_songs => 'kanta';

  @override
  String get summary_streamed_overall => 'Streaming abesti oro har';

  @override
  String get summary_owed_to_artists => 'Hilabete honetan\nartistei zor zaiena';

  @override
  String get summary_artists => 'artisten';

  @override
  String get summary_music_reached_you => 'Musika ailegatu zaizu';

  @override
  String get summary_full_albums => 'album osok';

  @override
  String get summary_got_your_love => 'Jaso dute zure maitasuna';

  @override
  String get summary_playlists => 'zerrenda';

  @override
  String get summary_were_on_repeat => 'Dituzu errepikatze moduan';

  @override
  String total_money(Object money) {
    return 'Guztira $money';
  }

  @override
  String get webview_not_found => 'Ez da Webview aurkitu';

  @override
  String get webview_not_found_description =>
      'Ez dago Webview abiarazte denbora-instalaziorik zure gailuan.\nInstalatuta badago, ziurtatu environment PATH-an dagoela\n\nInstalatu ondoren, berrabiarazi aplikazioa';

  @override
  String get unsupported_platform => 'Plataforma ez onartua';

  @override
  String get cache_music => 'Musika cachean';

  @override
  String get open => 'Ireki';

  @override
  String get cache_folder => 'Cache karpeta';

  @override
  String get export => 'Esportatu';

  @override
  String get clear_cache => 'Garbitu cachea';

  @override
  String get clear_cache_confirmation => 'Cachea garbitu nahi al duzu?';

  @override
  String get export_cache_files => 'Esportatu cache fitxategiak';

  @override
  String found_n_files(Object count) {
    return '$count fitxategi aurkitu dira';
  }

  @override
  String get export_cache_confirmation =>
      'Fitxategi hauek esportatu nahi al dituzu';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return '$filesExported fitxategi esportatu dira $files -tik';
  }

  @override
  String get undo => 'Desegondu';

  @override
  String get download_all => 'Guztia deskargatu';

  @override
  String get add_all_to_playlist => 'Guztia playlist-era gehitu';

  @override
  String get add_all_to_queue => 'Guztia zerrendara gehitu';

  @override
  String get play_all_next => 'Guztia hurrengoan jolastu';

  @override
  String get pause => 'Pausatu';

  @override
  String get view_all => 'Ikusi guztia';

  @override
  String get no_tracks_added_yet =>
      'Dirudienez, oraindik ez duzu abestirik gehitu.';

  @override
  String get no_tracks => 'Ez dirudi hemen abestirik dagoenik.';

  @override
  String get no_tracks_listened_yet =>
      'Dirudienez, oraindik ez duzu ezer entzun.';

  @override
  String get not_following_artists => 'Ez zaude artisten atzetik.';

  @override
  String get no_favorite_albums_yet =>
      'Dirudienez, oraindik ez duzu albumik gehitu zure gogokoen artean.';

  @override
  String get no_logs_found => 'Ez dira log-ak aurkitu';

  @override
  String get youtube_engine => 'YouTube Motorra';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engine ez dago instalatuta';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engine ez dago zure sisteman instalatuta.';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return 'Ziurtatu PATH aldagaiaren barruan dagoela edo\nezarri $engine exekutagarriaren helbide absolutua behean.';
  }

  @override
  String get youtube_engine_unix_issue_message =>
      'macOS/Linux/Unix bezalako sistemetan, .zshrc/.bashrc/.bash_profile bezalako fitxategietan bidearen ezarpenak ez dira funtzionatuko.\nBidearen ezarpena shell konfigurazio fitxategian egin behar duzu.';

  @override
  String get download => 'Deskargatu';

  @override
  String get file_not_found => 'Fitxategia ez da aurkitu';

  @override
  String get custom => 'Pertsonalizatua';

  @override
  String get add_custom_url => 'Gehitu URL pertsonalizatua';

  @override
  String get edit_port => 'Editatu portua';

  @override
  String get port_helper_msg =>
      'Lehenetsitako balioa -1 da, zenbaki aleatorioa adierazten duena. Su firewall konfiguratu baduzu, gomendatzen da hau ezartzea.';

  @override
  String connect_request(Object client) {
    return '$client konektatzea baimendu?';
  }

  @override
  String get connection_request_denied =>
      'Konektatzea ukatu da. Erabiltzaileak sarbidea ukatu du.';

  @override
  String get an_error_occurred => 'Errore bat gertatu da';

  @override
  String get copy_to_clipboard => 'Hiztegiraino kopiatzea';

  @override
  String get view_logs => 'Erregistroak ikusi';

  @override
  String get retry => 'Berriro saiatu';

  @override
  String get no_default_metadata_provider_selected =>
      'Ezarri ez duzu metadaten hornitzaile lehenetsirik';

  @override
  String get manage_metadata_providers => 'Metadaten hornitzaileak kudeatu';

  @override
  String get open_link_in_browser => 'Esteka nabigatzailean irekiko duzu?';

  @override
  String get do_you_want_to_open_the_following_link =>
      'Hurrengo esteka irekiko duzu?';

  @override
  String get unsafe_url_warning =>
      'Iturri seguru gabeko estekak irekiz gero, ez da seguru suerta daiteke. Arduratu zaitez!\nEsteka ere hiztegirainokoan kopiatu dezakezu.';

  @override
  String get copy_link => 'Esteka kopiatu';

  @override
  String get building_your_timeline =>
      'Zure entzuteen arabera zure kronologia eraikitzen…';

  @override
  String get official => 'Ofiziala';

  @override
  String author_name(Object author) {
    return 'Egilea: $author';
  }

  @override
  String get third_party => 'Hirugarrena';

  @override
  String get plugin_requires_authentication =>
      'Pluginak autentifikazioa eskatzen du';

  @override
  String get update_available => 'Eguneratze bat dago eskuragarri';

  @override
  String get supports_scrobbling => 'Scrobbling-a onartzen du';

  @override
  String get plugin_scrobbling_info =>
      'Plugin honek zure musika scrobbled egiten du zure entzuteen historia sortzeko.';

  @override
  String get default_metadata_source => 'Metadatu-iturburu lehenetsia';

  @override
  String get set_default_metadata_source =>
      'Ezarri metadatu-iturburu lehenetsia';

  @override
  String get default_audio_source => 'Audio-iturburu lehenetsia';

  @override
  String get set_default_audio_source => 'Ezarri audio-iturburu lehenetsia';

  @override
  String get set_default => 'Lehenetsi gisa ezarri';

  @override
  String get support => 'Laguntza';

  @override
  String get support_plugin_development => 'Pluginaren garapena lagundu';

  @override
  String can_access_name_api(Object name) {
    return '- **$name** API-ra sar daiteke';
  }

  @override
  String get do_you_want_to_install_this_plugin =>
      'Plugin hau instalatu nahiko zenuke?';

  @override
  String get third_party_plugin_warning =>
      'Plugin hau hirugarrenen biltegi batetik dator. Instalatu aurretik iturriari konfiantza behar diozu.';

  @override
  String get author => 'Egilea';

  @override
  String get this_plugin_can_do_following =>
      'Plugin honek honako hau egin dezake:';

  @override
  String get install => 'Instalatu';

  @override
  String get install_a_metadata_provider =>
      'Metadaten hornitzaile bat instalatu';

  @override
  String get no_tracks_playing =>
      'Une honetan ez dago abestirik erreproduzitzen';

  @override
  String get synced_lyrics_not_available =>
      'Abestiarentzako letra sinkronizatua ez dago erabilgarri. Mesedez, erabili';

  @override
  String get plain_lyrics => 'Letra arrunta';

  @override
  String get tab_instead => 'horren ordez, Tab teklatxaza erabili.';

  @override
  String get disclaimer => 'Aldez aurreko oharra';

  @override
  String get third_party_plugin_dmca_notice =>
      'Spotube taldea ezin da arduratu (“hirugarrenen”) plugin-en>gatik (barne legala). Erabili zure arriskuarekin. Erroreak/ arazoak dituzu, jakinarazi pluginaren biltegiari.\n\nPlugin batek edozein zerbitzu/legalki entitate baten ToS/DMCA hautsi baditu, eska iezaiozu pluginaren egileari edo hosting plataformari (adibidez GitHub/Codeberg) neurriak har ditzaten. “Hirugarrena” etiketatutako plugin guztiak komunitate publikoaren bidez mantentzen dira; ez ditugu kuratoriatu, beraz ezin dugu inplikatu.\n\n';

  @override
  String get input_does_not_match_format =>
      'Sarrera ezin da beharrezko formatutik desberdina izan';

  @override
  String get plugins => 'Pluginak';

  @override
  String get paste_plugin_download_url =>
      'Kopiatu deskarga-URLa, GitHub/Codeberg biltegi-URLa edo .smplug fitxategiaren esteka zuzena';

  @override
  String get download_and_install_plugin_from_url =>
      'Download eta instalatu plugin-a URL batetik';

  @override
  String failed_to_add_plugin_error(Object error) {
    return 'Plugin gehitu ezin izan da: $error';
  }

  @override
  String get upload_plugin_from_file => 'Plugin fitxategi batetik igo';

  @override
  String get installed => 'Instalatuta';

  @override
  String get available_plugins => 'Eskaintzen diren pluginak';

  @override
  String get configure_plugins =>
      'Konfiguratu zure metadatu-hornitzaile eta audio-iturburu pluginak';

  @override
  String get audio_scrobblers => 'Audio scrobbler-ak';

  @override
  String get scrobbling => 'Scrobbling';

  @override
  String get source => 'Iturburua: ';

  @override
  String get uncompressed => 'Konprimitu gabea';

  @override
  String get dab_music_source_description =>
      'Audiozaleentzat. Kalitate handiko/galerarik gabeko audio-streamak eskaintzen ditu. ISRC oinarritutako pistaren parekatze zehatza.';
}
