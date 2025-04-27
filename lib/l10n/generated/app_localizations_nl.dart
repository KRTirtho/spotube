// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get guest => 'Gast';

  @override
  String get browse => 'Bladeren';

  @override
  String get search => 'Zoeken';

  @override
  String get library => 'Bibliotheek';

  @override
  String get lyrics => 'Teksten';

  @override
  String get settings => 'Instellingen';

  @override
  String get genre_categories_filter => 'Categorieën of genres filteren…';

  @override
  String get genre => 'Genre';

  @override
  String get personalized => 'Gepersonaliseerd';

  @override
  String get featured => 'Aanbevolen';

  @override
  String get new_releases => 'Nieuwe uitgaves';

  @override
  String get songs => 'Liedjes';

  @override
  String playing_track(Object track) {
    return '$track afspelen';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return 'Dit zal de huidige wachtrij wissen. $track_length nummers worden verwijderd\nWil je doorgaan?';
  }

  @override
  String get load_more => 'Meer laden';

  @override
  String get playlists => 'Afspeellijsten';

  @override
  String get artists => 'Artiesten';

  @override
  String get albums => 'Albums';

  @override
  String get tracks => 'Nummers';

  @override
  String get downloads => 'Downloads';

  @override
  String get filter_playlists => 'Afspeellijsten filteren…';

  @override
  String get liked_tracks => 'Geliefde tracks';

  @override
  String get liked_tracks_description => 'Al je favoriete nummers';

  @override
  String get playlist => 'Afspeellijst';

  @override
  String get create_a_playlist => 'Een afspeellijst aanmaken';

  @override
  String get update_playlist => 'Afspeellijst bijwerken';

  @override
  String get create => 'Aanmaken';

  @override
  String get cancel => 'Annuleren';

  @override
  String get update => 'Bijwerken';

  @override
  String get playlist_name => 'Naam afspeellijst';

  @override
  String get name_of_playlist => 'Naam van de afspeellijst';

  @override
  String get description => 'Beschrijving';

  @override
  String get public => 'Openbaar';

  @override
  String get collaborative => 'Samenwerkend';

  @override
  String get search_local_tracks => 'Lokale nummers zoeken…';

  @override
  String get play => 'Afspelen';

  @override
  String get delete => 'Wissen';

  @override
  String get none => 'Geen';

  @override
  String get sort_a_z => 'Sorteren op A-Z';

  @override
  String get sort_z_a => 'Sorteren op Z-A';

  @override
  String get sort_artist => 'Sorteren op artiest';

  @override
  String get sort_album => 'Sorteren op album';

  @override
  String get sort_duration => 'Sorteer op Duur';

  @override
  String get sort_tracks => 'Nummers sorteren';

  @override
  String currently_downloading(Object tracks_length) {
    return 'Momenteel aan het downloaden ($tracks_length)';
  }

  @override
  String get cancel_all => 'Alle annuleren';

  @override
  String get filter_artist => 'Artiesten filteren…';

  @override
  String followers(Object followers) {
    return '$followers volgers';
  }

  @override
  String get add_artist_to_blacklist => 'Artiest toevoegen aan zwarte lijst';

  @override
  String get top_tracks => 'Topsporen';

  @override
  String get fans_also_like => 'Liefhebbers willen ook';

  @override
  String get loading => 'Laden…';

  @override
  String get artist => 'Artiest';

  @override
  String get blacklisted => 'Zwarte lijst';

  @override
  String get following => 'Volgen';

  @override
  String get follow => 'Volgen';

  @override
  String get artist_url_copied => 'URL artiest gekopieerd naar klembord';

  @override
  String added_to_queue(Object tracks) {
    return '$tracks nummers toegevoegd aan wachtrij';
  }

  @override
  String get filter_albums => 'Albums filteren…';

  @override
  String get synced => 'Gesynchroniseerd';

  @override
  String get plain => 'Eenvoudig';

  @override
  String get shuffle => 'Willekeurig';

  @override
  String get search_tracks => 'Nummers zoeken…';

  @override
  String get released => 'Uitgegeven';

  @override
  String error(Object error) {
    return 'Fout $error';
  }

  @override
  String get title => 'Titel';

  @override
  String get time => 'Tijd';

  @override
  String get more_actions => 'Meer acties';

  @override
  String download_count(Object count) {
    return '($count) downloads';
  }

  @override
  String add_count_to_playlist(Object count) {
    return '($count) aan afspeellijst toevoegen';
  }

  @override
  String add_count_to_queue(Object count) {
    return '($count) aan wachtrij toevoegen';
  }

  @override
  String play_count_next(Object count) {
    return 'Volgende ($count) afspelen';
  }

  @override
  String get album => 'Album';

  @override
  String copied_to_clipboard(Object data) {
    return '$data naar klembord gekopieerd';
  }

  @override
  String add_to_following_playlists(Object track) {
    return '$track aan volgende afspeellijsten toevoegen';
  }

  @override
  String get add => 'Toevoegen';

  @override
  String added_track_to_queue(Object track) {
    return '$track aan wachtrij toegevoegd';
  }

  @override
  String get add_to_queue => 'Toevoegen aan wachtrij';

  @override
  String track_will_play_next(Object track) {
    return '$track wordt hierna afgespeeld';
  }

  @override
  String get play_next => 'Volgende afspelen';

  @override
  String removed_track_from_queue(Object track) {
    return '$track van wachtrij verwijderd';
  }

  @override
  String get remove_from_queue => 'Van wachtrij verwijderen';

  @override
  String get remove_from_favorites => 'Van favorieten verwijderen';

  @override
  String get save_as_favorite => 'Opslaan als favoriet';

  @override
  String get add_to_playlist => 'Aan afspeellijst toevoegen';

  @override
  String get remove_from_playlist => 'Van afspeellijst verwijderen';

  @override
  String get add_to_blacklist => 'Aan zwarte lijst toevoegen';

  @override
  String get remove_from_blacklist => 'Van zwarte lijst verwijderen';

  @override
  String get share => 'Delen';

  @override
  String get mini_player => 'Minispeler';

  @override
  String get slide_to_seek => 'Schuiven om vooruit of achteruit te zoeken';

  @override
  String get shuffle_playlist => 'Afspeellijst schuifelen';

  @override
  String get unshuffle_playlist => 'Afspeellijst onschuifelen';

  @override
  String get previous_track => 'Vorige nummer';

  @override
  String get next_track => 'Volgende nummer';

  @override
  String get pause_playback => 'Afspelen pauzeren';

  @override
  String get resume_playback => 'Afspelen hervatten';

  @override
  String get loop_track => 'Nummer herhalen';

  @override
  String get no_loop => 'Geen herhaling';

  @override
  String get repeat_playlist => 'Afspeellijst herhalen';

  @override
  String get queue => 'Wachtrij';

  @override
  String get alternative_track_sources => 'Alternatieve nummerbronnen';

  @override
  String get download_track => 'Nummer downloaden';

  @override
  String tracks_in_queue(Object tracks) {
    return '$tracks nummers in wachtrij';
  }

  @override
  String get clear_all => 'Alles wissen';

  @override
  String get show_hide_ui_on_hover => 'UI tonen/verbergen bij zweven';

  @override
  String get always_on_top => 'Altijd bovenaan';

  @override
  String get exit_mini_player => 'Minispeler afsluiten';

  @override
  String get download_location => 'Downloadlocatie';

  @override
  String get local_library => 'Lokale bibliotheek';

  @override
  String get add_library_location => 'Toevoegen aan bibliotheek';

  @override
  String get remove_library_location => 'Verwijderen uit bibliotheek';

  @override
  String get account => 'Account';

  @override
  String get login_with_spotify => 'Inloggen met je Spotify-account';

  @override
  String get connect_with_spotify => 'Verbinden met Spotify';

  @override
  String get logout => 'Afmelden';

  @override
  String get logout_of_this_account => 'Afmelden van dit account';

  @override
  String get language_region => 'Taal & regio';

  @override
  String get language => 'Taal';

  @override
  String get system_default => 'Systeemstandaard';

  @override
  String get market_place_region => 'Marktplaats-regio';

  @override
  String get recommendation_country => 'Aanbeveling Land';

  @override
  String get appearance => 'Uiterlijk';

  @override
  String get layout_mode => 'Opmaakmodus';

  @override
  String get override_layout_settings => 'Instellingen voor responsieve opmaakmodus opheffen';

  @override
  String get adaptive => 'Adaptief';

  @override
  String get compact => 'Compact';

  @override
  String get extended => 'Uitgebreid';

  @override
  String get theme => 'Thema';

  @override
  String get dark => 'Donker';

  @override
  String get light => 'Licht';

  @override
  String get system => 'Systeem';

  @override
  String get accent_color => 'Accentkleur';

  @override
  String get sync_album_color => 'Albumkleur synchroniseren';

  @override
  String get sync_album_color_description => 'Gebruikt de overheersende kleur van het album als accentkleur';

  @override
  String get playback => 'Weergave';

  @override
  String get audio_quality => 'Audiokwaliteit';

  @override
  String get high => 'Hoog';

  @override
  String get low => 'Laag';

  @override
  String get pre_download_play => 'Vooraf downloaden en afspelen';

  @override
  String get pre_download_play_description => 'In plaats van audio te streamen, kun je bytes downloaden en afspelen (aanbevolen voor gebruikers met een hogere bandbreedte)';

  @override
  String get skip_non_music => 'Niet-muzieksegmenten overslaan (SponsorBlock)';

  @override
  String get blacklist_description => 'Nummers en artiesten op de zwarte lijst';

  @override
  String get wait_for_download_to_finish => 'Wacht tot de huidige download is voltooid';

  @override
  String get desktop => 'Bureaublad';

  @override
  String get close_behavior => 'Sluitgedrag';

  @override
  String get close => 'Afsluiten';

  @override
  String get minimize_to_tray => 'Minimaliseren naar systeemvak';

  @override
  String get show_tray_icon => 'Systeemvakpictogram tonen';

  @override
  String get about => 'Over';

  @override
  String get u_love_spotube => 'We weten dat je van Spotube houd';

  @override
  String get check_for_updates => 'Controleren op updates';

  @override
  String get about_spotube => 'Over Spotube';

  @override
  String get blacklist => 'Zwarte lijst';

  @override
  String get please_sponsor => 'Sponsor/Doneer a.u.b.';

  @override
  String get spotube_description => 'Spotube, een lichtgewicht, cross-platform, vrij-voor-alles Spotify-client';

  @override
  String get version => 'Versie';

  @override
  String get build_number => 'Bouwnummer';

  @override
  String get founder => 'Grondlegger';

  @override
  String get repository => 'Opslagplaats';

  @override
  String get bug_issues => 'Bug+problemen';

  @override
  String get made_with => 'Met ❤️ gemaakt in Bangladesh🇧🇩';

  @override
  String get kingkor_roy_tirtho => 'Kingkor Roy Tirtho';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year Kingkor Roy Tirtho';
  }

  @override
  String get license => 'Licentie';

  @override
  String get add_spotify_credentials => 'Voeg om te beginnen je spotify-aanmeldgegevens toe';

  @override
  String get credentials_will_not_be_shared_disclaimer => 'Maak je geen zorgen, je gegevens worden niet verzameld of gedeeld met anderen.';

  @override
  String get know_how_to_login => 'Weet je niet hoe je dit moet doen?';

  @override
  String get follow_step_by_step_guide => 'Volg de stapsgewijze handleiding';

  @override
  String spotify_cookie(Object name) {
    return 'Spotify $name Cookie';
  }

  @override
  String cookie_name_cookie(Object name) {
    return '$name Cookie';
  }

  @override
  String get fill_in_all_fields => 'Vul alle velden in a.u.b.';

  @override
  String get submit => 'Verzenden';

  @override
  String get exit => 'Afronden';

  @override
  String get previous => 'Vorige';

  @override
  String get next => 'Volgende';

  @override
  String get done => 'Klaar';

  @override
  String get step_1 => 'Stap 1';

  @override
  String get first_go_to => 'Ga eerst naar';

  @override
  String get login_if_not_logged_in => 'en Inloggen/Aanmelden als je niet bent ingelogd';

  @override
  String get step_2 => 'Stap 2';

  @override
  String get step_2_steps => '1. Zodra je bent aangemeld, druk je op F12 of klik je met de rechtermuisknop > Inspect om de Browser devtools te openen.\n2. Ga vervolgens naar het tabblad \"Toepassing\" (Chrome, Edge, Brave enz..) of naar het tabblad \"Opslag\" (Firefox, Palemoon enz..).\n3. Ga naar de sectie \"Cookies\" en vervolgens naar de subsectie \"https://accounts.spotify.com\".';

  @override
  String get step_3 => 'Stap 3';

  @override
  String get step_3_steps => 'De waarde van cookie \"sp_dc\" kopiëren';

  @override
  String get success_emoji => 'Succes🥳';

  @override
  String get success_message => 'Je bent nu ingelogd met je Spotify account. Goed gedaan!';

  @override
  String get step_4 => 'Stap 4';

  @override
  String get step_4_steps => 'De gekopieerde waarde \"sp_dc\" plakken';

  @override
  String get something_went_wrong => 'Er ging iets mis';

  @override
  String get piped_instance => 'Piped-serverinstantie';

  @override
  String get piped_description => 'De Piped-serverinstantie die moet worden gebruikt voor overeenkomstige nummers';

  @override
  String get piped_warning => 'Sommige werken misschien niet goed. Dus gebruik ze op eigen risico';

  @override
  String get invidious_instance => 'Invidious-serverinstantie';

  @override
  String get invidious_description => 'De Invidious-serverinstantie die gebruikt wordt voor trackmatching';

  @override
  String get invidious_warning => 'Sommigen werken mogelijk niet goed. Gebruik op eigen risico';

  @override
  String get generate => 'Genereren';

  @override
  String track_exists(Object track) {
    return 'Nummer $track bestaat al';
  }

  @override
  String get replace_downloaded_tracks => 'Alle gedownloade nummers vervangen';

  @override
  String get skip_download_tracks => 'Downloaden van alle gedownloade nummers overslaan';

  @override
  String get do_you_want_to_replace => 'Wil je het bestaande nummer vervangen?';

  @override
  String get replace => 'Vervangen';

  @override
  String get skip => 'Overslaan';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return 'Selecteer tot $count $type';
  }

  @override
  String get select_genres => 'Genres selecteren';

  @override
  String get add_genres => 'Genres toevoegen';

  @override
  String get country => 'Land';

  @override
  String get number_of_tracks_generate => 'Aantal nummers om te genereren';

  @override
  String get acousticness => 'Akoestiek';

  @override
  String get danceability => 'Dansbaarheid';

  @override
  String get energy => 'Energie';

  @override
  String get instrumentalness => 'Instrumentaliteit';

  @override
  String get liveness => 'Levendigheid';

  @override
  String get loudness => 'Luidheid';

  @override
  String get speechiness => 'Spraak';

  @override
  String get valence => 'Valentie';

  @override
  String get popularity => 'Populariteit';

  @override
  String get key => 'Sleutel';

  @override
  String get duration => 'Tijdsduur (s)';

  @override
  String get tempo => 'Tempo (SPM)';

  @override
  String get mode => 'Modus';

  @override
  String get time_signature => 'Tijdsnotatie';

  @override
  String get short => 'Kort';

  @override
  String get medium => 'Middel';

  @override
  String get long => 'Lang';

  @override
  String get min => 'Min';

  @override
  String get max => 'Max';

  @override
  String get target => 'Doel';

  @override
  String get moderate => 'Matig';

  @override
  String get deselect_all => 'Selectie opheffen';

  @override
  String get select_all => 'Alles selecteren';

  @override
  String get are_you_sure => 'Weet je het zeker?';

  @override
  String get generating_playlist => 'Aangepaste afspeellijst genereren…';

  @override
  String selected_count_tracks(Object count) {
    return '$count nummers geselecteerd';
  }

  @override
  String get download_warning => 'Als je alle nummers in bulk downloadt, ben je duidelijk bezig met muziekpiraterij en breng je schade toe aan de creatieve muziekmaatschappij. Ik hoop dat je je hiervan bewust bent. Probeer altijd het harde werk van artiesten te respecteren en te steunen.';

  @override
  String get download_ip_ban_warning => 'BTW, je IP-adres kan worden geblokkeerd op YouTube als gevolg van buitensporige downloadverzoeken. IP-blokkering betekent dat je YouTube niet kunt gebruiken (zelfs als je ingelogd bent) voor tenminste 2-3 maanden vanaf dat IP-apparaat. Spotube is niet verantwoordelijk als dit ooit gebeurt.';

  @override
  String get by_clicking_accept_terms => 'Door op \'accepteren\' te klikken ga je akkoord met de volgende voorwaarden:';

  @override
  String get download_agreement_1 => 'Ik weet dat ik muziek illegaal donload. Ik ben slecht.';

  @override
  String get download_agreement_2 => 'Ik steun de artiest waar ik kan en ik doe dit alleen omdat ik geen geld heb om hun kunst te kopen.';

  @override
  String get download_agreement_3 => 'Ik ben me er volledig van bewust dat mijn IP geblokkeerd kan worden op YouTube & ik houd Spotube of zijn eigenaars/contributeurs niet verantwoordelijk voor ongelukken die veroorzaakt worden door mijn huidige actie.';

  @override
  String get decline => 'Weigeren';

  @override
  String get accept => 'Accepteren';

  @override
  String get details => 'Bijzonderheden';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => 'Kanaal';

  @override
  String get likes => 'Liefs';

  @override
  String get dislikes => 'Hekels';

  @override
  String get views => 'Weergaven';

  @override
  String get streamUrl => 'Stream-URL';

  @override
  String get stop => 'Stoppen';

  @override
  String get sort_newest => 'Sorteren op nieuwste toegevoegd';

  @override
  String get sort_oldest => 'Sorteren op oudste toegevoegd';

  @override
  String get sleep_timer => 'Slaaptimer';

  @override
  String mins(Object minutes) {
    return '$minutes minuten';
  }

  @override
  String hours(Object hours) {
    return '$hours uren';
  }

  @override
  String hour(Object hours) {
    return '$hours uur';
  }

  @override
  String get custom_hours => 'Aangepaste uren';

  @override
  String get logs => 'Logboeken';

  @override
  String get developers => 'Ontwikkelaars';

  @override
  String get not_logged_in => 'Je bent niet aangemeld';

  @override
  String get search_mode => 'Zoekmodus';

  @override
  String get audio_source => 'Audiobron';

  @override
  String get ok => 'Oké';

  @override
  String get failed_to_encrypt => 'Versleuteling mislukt';

  @override
  String get encryption_failed_warning => 'Spotube gebruikt versleuteling om je gegevens veilig op te slaan. Maar dat is niet gelukt. Dus zal het terugvallen op onveilige opslag.\nAls je linux gebruikt, zorg er dan voor dat je een geheim-dienst (gnome-keyring, kde-wallet, keepassxc etc) hebt geïnstalleerd.';

  @override
  String get querying_info => 'Info opvragen…';

  @override
  String get piped_api_down => 'Piped API is uit';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return 'De Piped-instantie $pipedInstance is momenteel uitgevallen\n\nVerander de instantie of verander het \'API-type\' naar de officiële YouTube API.\n\nZorg ervoor dat u de app herstart na de wijziging';
  }

  @override
  String get you_are_offline => 'Je bent momenteel offline';

  @override
  String get connection_restored => 'Je internetverbinding is hersteld';

  @override
  String get use_system_title_bar => 'Systeemtitelbalk gebruiken';

  @override
  String get crunching_results => 'Resultaten verwerken…';

  @override
  String get search_to_get_results => 'Zoeken naar resultaten';

  @override
  String get use_amoled_mode => 'Pikzwart donkerthema';

  @override
  String get pitch_dark_theme => 'AMOLED-modus';

  @override
  String get normalize_audio => 'Audio normaliseren';

  @override
  String get change_cover => 'Hoes aanpassen';

  @override
  String get add_cover => 'Hoes toevoegen';

  @override
  String get restore_defaults => 'Standaardwaarden herstellen';

  @override
  String get download_music_codec => 'Download-codec';

  @override
  String get streaming_music_codec => 'Streaming-codec';

  @override
  String get login_with_lastfm => 'Inloggen met Last.fm';

  @override
  String get connect => 'Verbinden';

  @override
  String get disconnect_lastfm => 'Last.fm verbreken';

  @override
  String get disconnect => 'Verbeken';

  @override
  String get username => 'Gebruikersnaam';

  @override
  String get password => 'Wachtwoord';

  @override
  String get login => 'Inloggen';

  @override
  String get login_with_your_lastfm => 'Inloggen met je Last.fm account';

  @override
  String get scrobble_to_lastfm => 'Scrobbelen naar Last.fm';

  @override
  String get go_to_album => 'Ga naar album';

  @override
  String get discord_rich_presence => 'Discord Rich Presence';

  @override
  String get browse_all => 'Alles doorbladeren';

  @override
  String get genres => 'Genres';

  @override
  String get explore_genres => 'Genres verkennen';

  @override
  String get friends => 'Vrienden';

  @override
  String get no_lyrics_available => 'Sorry, geen teksten gevonden voor dit nummer';

  @override
  String get start_a_radio => 'Start een Radio';

  @override
  String get how_to_start_radio => 'Hoe wilt u de radio starten?';

  @override
  String get replace_queue_question => 'Wilt u de huidige wachtrij vervangen of eraan toevoegen?';

  @override
  String get endless_playback => 'Eindeloze Afspelen';

  @override
  String get delete_playlist => 'Verwijder Afspeellijst';

  @override
  String get delete_playlist_confirmation => 'Weet u zeker dat u deze afspeellijst wilt verwijderen?';

  @override
  String get local_tracks => 'Lokale Nummers';

  @override
  String get local_tab => 'Lokaal';

  @override
  String get song_link => 'Nummer Link';

  @override
  String get skip_this_nonsense => 'Sla deze onzin over';

  @override
  String get freedom_of_music => '“Vrijheid van Muziek”';

  @override
  String get freedom_of_music_palm => '“Vrijheid van Muziek in de palm van je hand”';

  @override
  String get get_started => 'Laten we beginnen';

  @override
  String get youtube_source_description => 'Aanbevolen en werkt het beste.';

  @override
  String get piped_source_description => 'Voel je vrij? Hetzelfde als YouTube maar veel gratis.';

  @override
  String get jiosaavn_source_description => 'Het beste voor de Zuid-Aziatische regio.';

  @override
  String get invidious_source_description => 'Vergelijkbaar met Piped, maar met een hogere beschikbaarheid.';

  @override
  String highest_quality(Object quality) {
    return 'Hoogste Kwaliteit: $quality';
  }

  @override
  String get select_audio_source => 'Selecteer Audiobron';

  @override
  String get endless_playback_description => 'Voeg automatisch nieuwe nummers toe aan het einde van de wachtrij';

  @override
  String get choose_your_region => 'Kies uw regio';

  @override
  String get choose_your_region_description => 'Dit zal Spotube helpen om de juiste inhoud voor uw locatie te tonen.';

  @override
  String get choose_your_language => 'Kies uw taal';

  @override
  String get help_project_grow => 'Help dit project groeien';

  @override
  String get help_project_grow_description => 'Spotube is een open-source project. U kunt dit project helpen groeien door bij te dragen aan het project, bugs te melden of nieuwe functies voor te stellen.';

  @override
  String get contribute_on_github => 'Bijdragen op GitHub';

  @override
  String get donate_on_open_collective => 'Doneren op Open Collective';

  @override
  String get browse_anonymously => 'Anoniem Bladeren';

  @override
  String get enable_connect => 'Verbinding inschakelen';

  @override
  String get enable_connect_description => 'Spotube bedienen vanaf andere apparaten';

  @override
  String get devices => 'Apparaten';

  @override
  String get select => 'Selecteren';

  @override
  String connect_client_alert(Object client) {
    return 'Je wordt gecontroleerd door $client';
  }

  @override
  String get this_device => 'Dit apparaat';

  @override
  String get remote => 'Afstandsbediening';

  @override
  String get stats => 'Statistieken';

  @override
  String and_n_more(Object count) {
    return 'en $count meer';
  }

  @override
  String get recently_played => 'Onlangs afgespeeld';

  @override
  String get browse_more => 'Meer bekijken';

  @override
  String get no_title => 'Geen titel';

  @override
  String get not_playing => 'Niet aan het afspelen';

  @override
  String get epic_failure => 'Epische mislukking!';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return '$tracks_length nummers aan de wachtrij toegevoegd';
  }

  @override
  String get spotube_has_an_update => 'Spotube heeft een update';

  @override
  String get download_now => 'Nu downloaden';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Spotube Nightly $nightlyBuildNum is uitgebracht';
  }

  @override
  String release_version(Object version) {
    return 'Spotube v$version is uitgebracht';
  }

  @override
  String get read_the_latest => 'Lees de nieuwste ';

  @override
  String get release_notes => 'release-opmerkingen';

  @override
  String get pick_color_scheme => 'Kies kleurenschema';

  @override
  String get save => 'Opslaan';

  @override
  String get choose_the_device => 'Kies het apparaat:';

  @override
  String get multiple_device_connected => 'Er zijn meerdere apparaten verbonden.\nKies het apparaat waarop je deze actie wilt uitvoeren';

  @override
  String get nothing_found => 'Niets gevonden';

  @override
  String get the_box_is_empty => 'De doos is leeg';

  @override
  String get top_artists => 'Topartiesten';

  @override
  String get top_albums => 'Topalbums';

  @override
  String get this_week => 'Deze week';

  @override
  String get this_month => 'Deze maand';

  @override
  String get last_6_months => 'Laatste 6 maanden';

  @override
  String get this_year => 'Dit jaar';

  @override
  String get last_2_years => 'Laatste 2 jaar';

  @override
  String get all_time => 'All time';

  @override
  String powered_by_provider(Object providerName) {
    return 'Aangedreven door $providerName';
  }

  @override
  String get email => 'E-mail';

  @override
  String get profile_followers => 'Volgers';

  @override
  String get birthday => 'Verjaardag';

  @override
  String get subscription => 'Abonnement';

  @override
  String get not_born => 'Niet geboren';

  @override
  String get hacker => 'Hacker';

  @override
  String get profile => 'Profiel';

  @override
  String get no_name => 'Geen naam';

  @override
  String get edit => 'Bewerken';

  @override
  String get user_profile => 'Gebruikersprofiel';

  @override
  String count_plays(Object count) {
    return '$count afspeelbeurten';
  }

  @override
  String get streaming_fees_hypothetical => '*Dit is berekend op basis van Spotify\'s uitbetaling per stream\nvan \$0.003 tot \$0.005. Dit is een hypothetische\nberekening om gebruikers inzicht te geven in hoeveel ze\naan de artiesten zouden hebben betaald als ze hun lied op Spotify zouden hebben beluisterd.';

  @override
  String get minutes_listened => 'Luistertijd';

  @override
  String get streamed_songs => 'Gestreamde nummers';

  @override
  String count_streams(Object count) {
    return '$count streams';
  }

  @override
  String get owned_by_you => 'Bezit door jou';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return '$shareUrl gekopieerd naar klembord';
  }

  @override
  String get spotify_hipotetical_calculation => '*Dit is berekend op basis van Spotify\'s betaling per stream\nvan \$0.003 tot \$0.005. Dit is een hypothetische\nberekening om de gebruiker inzicht te geven in hoeveel ze\naan de artiesten zouden hebben betaald als ze hun liedjes op Spotify\nzouden luisteren.';

  @override
  String count_mins(Object minutes) {
    return '$minutes min';
  }

  @override
  String get summary_minutes => 'minuten';

  @override
  String get summary_listened_to_music => 'Beluisterde muziek';

  @override
  String get summary_songs => 'nummers';

  @override
  String get summary_streamed_overall => 'Totaal gestreamd';

  @override
  String get summary_owed_to_artists => 'Te betalen aan artiesten\ndeze maand';

  @override
  String get summary_artists => 'van de artiest';

  @override
  String get summary_music_reached_you => 'Muziek heeft je bereikt';

  @override
  String get summary_full_albums => 'volledige albums';

  @override
  String get summary_got_your_love => 'Kreeg je liefde';

  @override
  String get summary_playlists => 'afspeellijsten';

  @override
  String get summary_were_on_repeat => 'Was op herhaling';

  @override
  String total_money(Object money) {
    return 'Totaal $money';
  }

  @override
  String get webview_not_found => 'Webview niet gevonden';

  @override
  String get webview_not_found_description => 'Er is geen Webview-runtime geïnstalleerd op uw apparaat.\nAls het is geïnstalleerd, zorg ervoor dat het in het environment PATH staat\n\nHerstart de app na installatie';

  @override
  String get unsupported_platform => 'Niet ondersteund platform';

  @override
  String get cache_music => 'Cache muziek';

  @override
  String get open => 'Open';

  @override
  String get cache_folder => 'Cachemap';

  @override
  String get export => 'Exporteren';

  @override
  String get clear_cache => 'Cache wissen';

  @override
  String get clear_cache_confirmation => 'Wilt u de cache wissen?';

  @override
  String get export_cache_files => 'Gecacheerde bestanden exporteren';

  @override
  String found_n_files(Object count) {
    return '$count bestanden gevonden';
  }

  @override
  String get export_cache_confirmation => 'Wilt u deze bestanden exporteren naar';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return '$filesExported van de $files bestanden geëxporteerd';
  }

  @override
  String get undo => 'Ongedaan maken';

  @override
  String get download_all => 'Alles downloaden';

  @override
  String get add_all_to_playlist => 'Voeg alles toe aan afspeellijst';

  @override
  String get add_all_to_queue => 'Voeg alles toe aan wachtrij';

  @override
  String get play_all_next => 'Speel alles volgende';

  @override
  String get pause => 'Pauzeren';

  @override
  String get view_all => 'Bekijk alles';

  @override
  String get no_tracks_added_yet => 'Het lijkt erop dat je nog geen nummers hebt toegevoegd';

  @override
  String get no_tracks => 'Het lijkt erop dat er hier geen nummers zijn';

  @override
  String get no_tracks_listened_yet => 'Het lijkt erop dat je nog niets hebt beluisterd';

  @override
  String get not_following_artists => 'Je volgt geen artiesten';

  @override
  String get no_favorite_albums_yet => 'Het lijkt erop dat je nog geen albums aan je favorieten hebt toegevoegd';

  @override
  String get no_logs_found => 'Geen logbestanden gevonden';

  @override
  String get youtube_engine => 'YouTube Engine';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engine is niet geïnstalleerd';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engine is niet geïnstalleerd op je systeem.';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return 'Zorg ervoor dat het beschikbaar is in de PATH-variabele of\nstel het absolute pad naar de $engine uitvoerbare bestanden in';
  }

  @override
  String get youtube_engine_unix_issue_message => 'Op macOS/Linux/unix-achtige besturingssystemen werkt het instellen van paden in .zshrc/.bashrc/.bash_profile enz. niet.\nJe moet het pad instellen in het shell-configuratiebestand';

  @override
  String get download => 'Downloaden';

  @override
  String get file_not_found => 'Bestand niet gevonden';

  @override
  String get custom => 'Aangepast';

  @override
  String get add_custom_url => 'Voeg aangepaste URL toe';

  @override
  String get edit_port => 'Poort bewerken';

  @override
  String get port_helper_msg => 'Standaard is -1, wat een willekeurig nummer aangeeft. Als je een firewall hebt geconfigureerd, wordt aanbevolen dit in te stellen.';

  @override
  String connect_request(Object client) {
    return 'Toestaan dat $client verbinding maakt?';
  }

  @override
  String get connection_request_denied => 'Verbinding geweigerd. Gebruiker heeft toegang geweigerd.';
}
