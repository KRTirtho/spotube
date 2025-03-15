// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get guest => 'Host';

  @override
  String get browse => 'Procházet';

  @override
  String get search => 'Hledat';

  @override
  String get library => 'Knihovna';

  @override
  String get lyrics => 'Texty';

  @override
  String get settings => 'Nastavení';

  @override
  String get genre_categories_filter => 'Filtrovat kategorie nebo žánry...';

  @override
  String get genre => 'Žánr';

  @override
  String get personalized => 'Personalizované';

  @override
  String get featured => 'Doporučené';

  @override
  String get new_releases => 'Nově vydané';

  @override
  String get songs => 'Skladby';

  @override
  String playing_track(Object track) {
    return 'Hraje $track';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return 'Toto vymaže aktuální frontu. $track_length skladeb bude odstraněno\nChcete pokračovat?';
  }

  @override
  String get load_more => 'Načíst více';

  @override
  String get playlists => 'Playlisty';

  @override
  String get artists => 'Umělci';

  @override
  String get albums => 'Alba';

  @override
  String get tracks => 'Skladby';

  @override
  String get downloads => 'Stahování';

  @override
  String get filter_playlists => 'Filtrovat playlisty...';

  @override
  String get liked_tracks => 'Oblíbené skladby';

  @override
  String get liked_tracks_description => 'Všechny vaše oblíbené skladby';

  @override
  String get playlist => 'Seznam skladeb';

  @override
  String get create_a_playlist => 'Vytvořit playlist';

  @override
  String get update_playlist => 'Aktualizovat playlist';

  @override
  String get create => 'Vytvořit';

  @override
  String get cancel => 'Zrušit';

  @override
  String get update => 'Aktualizovat';

  @override
  String get playlist_name => 'Název playlistu';

  @override
  String get name_of_playlist => 'Název playlistu';

  @override
  String get description => 'Popis';

  @override
  String get public => 'Veřejné';

  @override
  String get collaborative => 'Společný';

  @override
  String get search_local_tracks => 'Hledat místní skladby...';

  @override
  String get play => 'Přehrát';

  @override
  String get delete => 'Smazat';

  @override
  String get none => 'Žádné';

  @override
  String get sort_a_z => 'Seřadit od A-Z';

  @override
  String get sort_z_a => 'Seřadit od Z-A';

  @override
  String get sort_artist => 'Seřadit podle umělce';

  @override
  String get sort_album => 'Seřadit podle alba';

  @override
  String get sort_duration => 'Seřadit podle délky';

  @override
  String get sort_tracks => 'Seřadit skladby';

  @override
  String currently_downloading(Object tracks_length) {
    return 'Právě se stahuje ($tracks_length)';
  }

  @override
  String get cancel_all => 'Zrušit vše';

  @override
  String get filter_artist => 'Filtrovat umělce...';

  @override
  String followers(Object followers) {
    return '$followers Sledující';
  }

  @override
  String get add_artist_to_blacklist => 'Přidat umělce na černou listinu';

  @override
  String get top_tracks => 'Top skladby';

  @override
  String get fans_also_like => 'Fanoušci mají také rádi';

  @override
  String get loading => 'Načítání...';

  @override
  String get artist => 'Umělec';

  @override
  String get blacklisted => 'Na černé listině';

  @override
  String get following => 'Sleduje';

  @override
  String get follow => 'Sledovat';

  @override
  String get artist_url_copied => 'URL umělce zkopírována do schránky';

  @override
  String added_to_queue(Object tracks) {
    return 'Přidáno $tracks skladeb do fronty';
  }

  @override
  String get filter_albums => 'Filtrovat alba...';

  @override
  String get synced => 'Synchronizováno';

  @override
  String get plain => 'Jednoduché';

  @override
  String get shuffle => 'Zamíchat';

  @override
  String get search_tracks => 'Hledat skladby...';

  @override
  String get released => 'Vydáno';

  @override
  String error(Object error) {
    return 'Chyba $error';
  }

  @override
  String get title => 'Název';

  @override
  String get time => 'Čas';

  @override
  String get more_actions => 'Více akcí';

  @override
  String download_count(Object count) {
    return 'Stáhnout ($count)';
  }

  @override
  String add_count_to_playlist(Object count) {
    return 'Přidat ($count) do playlistu';
  }

  @override
  String add_count_to_queue(Object count) {
    return 'Přidat ($count) do fronty';
  }

  @override
  String play_count_next(Object count) {
    return 'Přehrát ($count) dalších';
  }

  @override
  String get album => 'Album';

  @override
  String copied_to_clipboard(Object data) {
    return 'Zkopírováno $data do schránky';
  }

  @override
  String add_to_following_playlists(Object track) {
    return 'Přidat $track do následujících playlistů';
  }

  @override
  String get add => 'Přidat';

  @override
  String added_track_to_queue(Object track) {
    return 'Přidána skladba $track do fronty';
  }

  @override
  String get add_to_queue => 'Přidat do fronty';

  @override
  String track_will_play_next(Object track) {
    return '$track se přehraje jako další';
  }

  @override
  String get play_next => 'Přehrát další';

  @override
  String removed_track_from_queue(Object track) {
    return 'Odstraněna skladba $track z fronty';
  }

  @override
  String get remove_from_queue => 'Odstranit z fronty';

  @override
  String get remove_from_favorites => 'Odstranit z oblíbených';

  @override
  String get save_as_favorite => 'Uložit jako oblíbené';

  @override
  String get add_to_playlist => 'Přidat do playlistu';

  @override
  String get remove_from_playlist => 'Odstranit z playlistu';

  @override
  String get add_to_blacklist => 'Přidat na černou listinu';

  @override
  String get remove_from_blacklist => 'Odstranit z černé listiny';

  @override
  String get share => 'Sdílet';

  @override
  String get mini_player => 'Mini přehrávač';

  @override
  String get slide_to_seek => 'Táhněte pro posunutí vpřed nebo vzad';

  @override
  String get shuffle_playlist => 'Zamíchat playlist';

  @override
  String get unshuffle_playlist => 'Zrušit zamíchání playlistu';

  @override
  String get previous_track => 'Předchozí skladba';

  @override
  String get next_track => 'Další skladba';

  @override
  String get pause_playback => 'Pozastavit přehrávání';

  @override
  String get resume_playback => 'Pokračovat v přehrávání';

  @override
  String get loop_track => 'Opakovat skladbu';

  @override
  String get no_loop => 'Žádné opakování';

  @override
  String get repeat_playlist => 'Opakovat playlist';

  @override
  String get queue => 'Fronta';

  @override
  String get alternative_track_sources => 'Alternativní zdroje skladeb';

  @override
  String get download_track => 'Stáhnout skladbu';

  @override
  String tracks_in_queue(Object tracks) {
    return '$tracks skladeb ve frontě';
  }

  @override
  String get clear_all => 'Vymazat vše';

  @override
  String get show_hide_ui_on_hover => 'Zobrazit/Skrýt UI při najetí';

  @override
  String get always_on_top => 'Vždy nahoře';

  @override
  String get exit_mini_player => 'Zavřít mini přehrávač';

  @override
  String get download_location => 'Umístění stahování';

  @override
  String get local_library => 'Místní knihovna';

  @override
  String get add_library_location => 'Přidat do knihovny';

  @override
  String get remove_library_location => 'Odebrat z knihovny';

  @override
  String get account => 'Účet';

  @override
  String get login_with_spotify => 'Přihlásit se pomocí Spotify účtu';

  @override
  String get connect_with_spotify => 'Připojit k Spotify';

  @override
  String get logout => 'Odhlásit se';

  @override
  String get logout_of_this_account => 'Odhlásit se z tohoto účtu';

  @override
  String get language_region => 'Jazyk a region';

  @override
  String get language => 'Jazyk';

  @override
  String get system_default => 'Systém';

  @override
  String get market_place_region => 'Region';

  @override
  String get recommendation_country => 'Země pro doporučení';

  @override
  String get appearance => 'Vzhled';

  @override
  String get layout_mode => 'Režim rozložení';

  @override
  String get override_layout_settings => 'Přepsat režim rozložení';

  @override
  String get adaptive => 'Adaptivní';

  @override
  String get compact => 'Kompaktní';

  @override
  String get extended => 'Rozšířený';

  @override
  String get theme => 'Téma';

  @override
  String get dark => 'Tmavé';

  @override
  String get light => 'Světlé';

  @override
  String get system => 'Systém';

  @override
  String get accent_color => 'Barva akcentu';

  @override
  String get sync_album_color => 'Synchronizovat barvu alba';

  @override
  String get sync_album_color_description => 'Používá dominantní barvu obalu alba jako barvu akcentu';

  @override
  String get playback => 'Přehrávání';

  @override
  String get audio_quality => 'Kvalita zvuku';

  @override
  String get high => 'Vysoká';

  @override
  String get low => 'Nízká';

  @override
  String get pre_download_play => 'Předstáhnout a přehrát';

  @override
  String get pre_download_play_description => 'Místo streamování audia stáhnout skladbu a přehrát (doporučeno pro uživatele s rychlejším internetem)';

  @override
  String get skip_non_music => 'Přeskočit nehudební segmenty (SponsorBlock)';

  @override
  String get blacklist_description => 'Zakázané skladby a umělci';

  @override
  String get wait_for_download_to_finish => 'Počkejte, až se dokončí stahování';

  @override
  String get desktop => 'Desktop';

  @override
  String get close_behavior => 'Chování při zavření';

  @override
  String get close => 'Zavřít';

  @override
  String get minimize_to_tray => 'Minimalizovat do lišty';

  @override
  String get show_tray_icon => 'Zobrazit ikonu v systémové liště';

  @override
  String get about => 'O aplikaci';

  @override
  String get u_love_spotube => 'Víme, že milujete Spotube';

  @override
  String get check_for_updates => 'Zkontrolovat aktualizace';

  @override
  String get about_spotube => 'O Spotube';

  @override
  String get blacklist => 'Černá listina';

  @override
  String get please_sponsor => 'Sponzorovat/darovat';

  @override
  String get spotube_description => 'Spotube, rychlý, multiplatformní, bezplatný Spotify klient';

  @override
  String get version => 'Verze';

  @override
  String get build_number => 'Číslo sestavení';

  @override
  String get founder => 'Zakladatel';

  @override
  String get repository => 'Repozitář';

  @override
  String get bug_issues => 'Chyby+Problémy';

  @override
  String get made_with => 'Vytvořeno s ❤️ v Bangladéši🇧🇩';

  @override
  String get kingkor_roy_tirtho => 'Kingkor Roy Tirtho';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year Kingkor Roy Tirtho';
  }

  @override
  String get license => 'Licence';

  @override
  String get add_spotify_credentials => 'Přidejte své přihlašovací údaje Spotify a začněte';

  @override
  String get credentials_will_not_be_shared_disclaimer => 'Nebojte, žádné z vašich údajů nebudou shromažďovány ani s nikým sdíleny';

  @override
  String get know_how_to_login => 'Nevíte, jak na to?';

  @override
  String get follow_step_by_step_guide => 'Postupujte podle návodu';

  @override
  String spotify_cookie(Object name) {
    return 'Cookie Spotify $name';
  }

  @override
  String cookie_name_cookie(Object name) {
    return 'Cookie $name';
  }

  @override
  String get fill_in_all_fields => 'Vyplňte prosím všechna pole';

  @override
  String get submit => 'Odeslat';

  @override
  String get exit => 'Ukončit';

  @override
  String get previous => 'Předchozí';

  @override
  String get next => 'Další';

  @override
  String get done => 'Hotovo';

  @override
  String get step_1 => 'Krok 1';

  @override
  String get first_go_to => 'Nejprve jděte na';

  @override
  String get login_if_not_logged_in => 'a přihlašte se nebo se zaregistrujte, pokud nejste přihlášeni';

  @override
  String get step_2 => 'Krok 2';

  @override
  String get step_2_steps => '1. Jakmile jste přihlášeni, stiskněte F12 nebo pravé tlačítko myši > Prozkoumat, abyste otevřeli nástroje pro vývojáře prohlížeče.\n2. Poté přejděte na kartu \"Aplikace\" (Chrome, Edge, Brave atd.) nebo kartu \"Úložiště\" (Firefox, Palemoon atd.)\n3. Přejděte do sekce \"Cookies\" a pak do podsekce \"https://accounts.spotify.com\"';

  @override
  String get step_3 => 'Krok 3';

  @override
  String get step_3_steps => 'Zkopírujte hodnotu cookie \"sp_dc\"';

  @override
  String get success_emoji => 'Úspěch🥳';

  @override
  String get success_message => 'Nyní jste úspěšně přihlášeni pomocí svého Spotify účtu. Dobrá práce, kamaráde!';

  @override
  String get step_4 => 'Krok 4';

  @override
  String get step_4_steps => 'Vložte zkopírovanou hodnotu \"sp_dc\"';

  @override
  String get something_went_wrong => 'Něco se pokazilo';

  @override
  String get piped_instance => 'Instance serveru Piped';

  @override
  String get piped_description => 'Instance serveru Piped, kterou použít pro hledání skladeb';

  @override
  String get piped_warning => 'Některé z nich nemusí dobře fungovat. Používejte na vlastní riziko';

  @override
  String get invidious_instance => 'Instance serveru Invidious';

  @override
  String get invidious_description => 'Instance serveru Invidious pro párování stop';

  @override
  String get invidious_warning => 'Některé instance nemusí fungovat správně. Používejte na vlastní riziko';

  @override
  String get generate => 'Generovat';

  @override
  String track_exists(Object track) {
    return 'Skladba $track již existuje';
  }

  @override
  String get replace_downloaded_tracks => 'Nahradit všechny stažené skladby';

  @override
  String get skip_download_tracks => 'Přeskočit stahování všech stažených skladeb';

  @override
  String get do_you_want_to_replace => 'Chcete nahradit existující skladbu??';

  @override
  String get replace => 'Nahradit';

  @override
  String get skip => 'Přeskočit';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return 'Vyberte až $count $type';
  }

  @override
  String get select_genres => 'Vyberte žánry';

  @override
  String get add_genres => 'Přidat žánry';

  @override
  String get country => 'Země';

  @override
  String get number_of_tracks_generate => 'Počet skladeb k vygenerování';

  @override
  String get acousticness => 'Akustičnost';

  @override
  String get danceability => 'Tanečnost';

  @override
  String get energy => 'Energie';

  @override
  String get instrumentalness => 'Instrumentálnost';

  @override
  String get liveness => 'Živost';

  @override
  String get loudness => 'Hlasitost';

  @override
  String get speechiness => 'Mluvnost';

  @override
  String get valence => 'Valence';

  @override
  String get popularity => 'Popularita';

  @override
  String get key => 'Klíč';

  @override
  String get duration => 'Délka (s)';

  @override
  String get tempo => 'Tempo (BPM)';

  @override
  String get mode => 'Režim';

  @override
  String get time_signature => 'Udání taktu';

  @override
  String get short => 'Krátký';

  @override
  String get medium => 'Střední';

  @override
  String get long => 'Dlouhý';

  @override
  String get min => 'Min';

  @override
  String get max => 'Max';

  @override
  String get target => 'Cíl';

  @override
  String get moderate => 'Mírný';

  @override
  String get deselect_all => 'Zrušit výběr';

  @override
  String get select_all => 'Vybrat vše';

  @override
  String get are_you_sure => 'Jste si jisti?';

  @override
  String get generating_playlist => 'Generování vašeho vlastního playlistu...';

  @override
  String selected_count_tracks(Object count) {
    return 'Vybráno $count skladeb';
  }

  @override
  String get download_warning => 'Pokud stáhnete všechny skladby najednou, pirátíte tím hudbu a škodíte kreativní společnosti hudby. Doufám, že jste si toho vědomi. Vždy se snažte respektovat a podporovat tvrdou práci umělců';

  @override
  String get download_ip_ban_warning => 'Mimochodem, vaše IP může být na YouTube zablokována kvůli nadměrným požadavkům na stahování. Blokování IP znamená, že nemůžete používat YouTube (i když jste přihlášeni) alespoň 2-3 měsíce ze zařízení s touto IP. A Spotube nenese žádnou odpovědnost, pokud se to někdy stane';

  @override
  String get by_clicking_accept_terms => 'Kliknutím na \'přijmout\' souhlasíte s následujícími podmínkami:';

  @override
  String get download_agreement_1 => 'Vím, že pirátím hudbu. Jsem špatný';

  @override
  String get download_agreement_2 => 'Budu podporovat umělce, kdekoliv to bude možné, a dělám to jen proto, že nemám peníze na koupi jejich umění';

  @override
  String get download_agreement_3 => 'Jsem si naprosto vědom toho, že moje IP může být na YouTube zablokována a nenesu žádnou odpovědnost za nehody způsobené mým současným jednáním';

  @override
  String get decline => 'Odmítnout';

  @override
  String get accept => 'Přijmout';

  @override
  String get details => 'Podrobnosti';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => 'Kanál';

  @override
  String get likes => 'Líbí se';

  @override
  String get dislikes => 'Nelíbí se';

  @override
  String get views => 'Zobrazení';

  @override
  String get streamUrl => 'URL streamu';

  @override
  String get stop => 'Zastavit';

  @override
  String get sort_newest => 'Seřadit od nejnovějších';

  @override
  String get sort_oldest => 'Seřadit od nejstarších';

  @override
  String get sleep_timer => 'Časovač spánku';

  @override
  String mins(Object minutes) {
    return '$minutes Minut';
  }

  @override
  String hours(Object hours) {
    return '$hours Hodin';
  }

  @override
  String hour(Object hours) {
    return '$hours Hodina';
  }

  @override
  String get custom_hours => 'Vlastní hodiny';

  @override
  String get logs => 'Protokoly';

  @override
  String get developers => 'Vývojáři';

  @override
  String get not_logged_in => 'Nejste přihlášeni';

  @override
  String get search_mode => 'Režim hledání';

  @override
  String get audio_source => 'Zdroj zvuku';

  @override
  String get ok => 'Ok';

  @override
  String get failed_to_encrypt => 'Šifrování selhalo';

  @override
  String get encryption_failed_warning => 'Spotube používá šifrování k bezpečnému ukládání vašich dat. Ale selhalo. Takže se vrátí k nezabezpečenému úložišti\nPokud používáte linux, ujistěte se, že máte nainstalovanou jakoukoli službu k ukládání bezpečnostních pověření (gnome-keyring, kde-wallet, keepassxc atd.)';

  @override
  String get querying_info => 'Získávání informací...';

  @override
  String get piped_api_down => 'Piped API je mimo provoz';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return 'Instance Piped $pipedInstance je momentálně mimo provoz\n\nBuď změňte instanci nebo změňte \'Typ API\' na oficiální YouTube API\n\nPo změně se ujistěte, že aplikaci restartujete';
  }

  @override
  String get you_are_offline => 'Momentálně jste offline';

  @override
  String get connection_restored => 'Vaše internetové připojení bylo obnoveno';

  @override
  String get use_system_title_bar => 'Použít systémové záhlaví okna';

  @override
  String get crunching_results => 'Zpracovávání výsledků...';

  @override
  String get search_to_get_results => 'Hledejte pro získání výsledků';

  @override
  String get use_amoled_mode => 'Úplně černé téma';

  @override
  String get pitch_dark_theme => 'AMOLED režim';

  @override
  String get normalize_audio => 'Normalizovat audio';

  @override
  String get change_cover => 'Změnit obal';

  @override
  String get add_cover => 'Přidat obal';

  @override
  String get restore_defaults => 'Obnovit výchozí';

  @override
  String get download_music_codec => 'Kodek pro stahování';

  @override
  String get streaming_music_codec => 'Kodek pro streamování';

  @override
  String get login_with_lastfm => 'Přihlásit se pomocí Last.fm';

  @override
  String get connect => 'Připojit';

  @override
  String get disconnect_lastfm => 'Odpojit Last.fm';

  @override
  String get disconnect => 'Odpojit';

  @override
  String get username => 'Uživatelské jméno';

  @override
  String get password => 'Heslo';

  @override
  String get login => 'Přihlásit se';

  @override
  String get login_with_your_lastfm => 'Přihlásit se pomocí vašeho Last.fm účtu';

  @override
  String get scrobble_to_lastfm => 'Scrobble na Last.fm';

  @override
  String get go_to_album => 'Přejít na album';

  @override
  String get discord_rich_presence => 'Discord Rich Presence';

  @override
  String get browse_all => 'Procházet vše';

  @override
  String get genres => 'Žánry';

  @override
  String get explore_genres => 'Prozkoumat žánry';

  @override
  String get friends => 'Přátelé';

  @override
  String get no_lyrics_available => 'Omlouváme se, není možné najít texty pro tuto skladbu';

  @override
  String get start_a_radio => 'Vytvořit rádio';

  @override
  String get how_to_start_radio => 'Jak chcete vytvořit rádio?';

  @override
  String get replace_queue_question => 'Chcete nahradit aktuální frontu nebo k ní přidat?';

  @override
  String get endless_playback => 'Nekonečné přehrávání';

  @override
  String get delete_playlist => 'Smazat playlist';

  @override
  String get delete_playlist_confirmation => 'Jste si jisti, že chcete smazat tento playlist?';

  @override
  String get local_tracks => 'Místní skladby';

  @override
  String get local_tab => 'Místní';

  @override
  String get song_link => 'Odkaz na skladbu';

  @override
  String get skip_this_nonsense => 'Přeskočit tenhle nesmysl';

  @override
  String get freedom_of_music => '“Svobodná hudba”';

  @override
  String get freedom_of_music_palm => '“Svobodná hudba ve vaší dlani”';

  @override
  String get get_started => 'Začít';

  @override
  String get youtube_source_description => 'Doporučeno a funguje nejlépe.';

  @override
  String get piped_source_description => 'Nechcete být sledováni? Stejné jako YouTube, ale respektuje soukromí.';

  @override
  String get jiosaavn_source_description => 'Nejlepší pro jihoasijský region.';

  @override
  String get invidious_source_description => 'Podobné Piped, ale s vyšší dostupností';

  @override
  String highest_quality(Object quality) {
    return 'Nejvyšší kvalita: $quality';
  }

  @override
  String get select_audio_source => 'Vyberte zdroj zvuku';

  @override
  String get endless_playback_description => 'Automaticky přidávat nové skladby\nna konec fronty';

  @override
  String get choose_your_region => 'Vyberte svůj region';

  @override
  String get choose_your_region_description => 'To pomůže Spotube ukázat vám správný obsah\npro vaši lokalitu.';

  @override
  String get choose_your_language => 'Vyberte svůj jazyk';

  @override
  String get help_project_grow => 'Pomozte tomuto projektu růst';

  @override
  String get help_project_grow_description => 'Spotube je open-source projekt. Můžete pomoci tomuto projektu růst tím, že přispějete do projektu, nahlásíte chyby nebo navrhnete nové funkce.';

  @override
  String get contribute_on_github => 'Přispějte na GitHub';

  @override
  String get donate_on_open_collective => 'Darujte na Open Collective';

  @override
  String get browse_anonymously => 'Procházet anonymně';

  @override
  String get enable_connect => 'Povolit ovládání';

  @override
  String get enable_connect_description => 'Ovládejte Spotube z jiného zařízení';

  @override
  String get devices => 'Zařízení';

  @override
  String get select => 'Vybrat';

  @override
  String connect_client_alert(Object client) {
    return 'Zařízení je ovládáno z $client';
  }

  @override
  String get this_device => 'Toto zařízení';

  @override
  String get remote => 'Ovladač';

  @override
  String get stats => 'Statistiky';

  @override
  String and_n_more(Object count) {
    return 'a dalších $count';
  }

  @override
  String get recently_played => 'Nedávno přehráno';

  @override
  String get browse_more => 'Procházet více';

  @override
  String get no_title => 'Bez názvu';

  @override
  String get not_playing => 'Nepřehrává se';

  @override
  String get epic_failure => 'Epické selhání!';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return 'Přidáno $tracks_length skladeb do fronty';
  }

  @override
  String get spotube_has_an_update => 'Spotube má aktualizaci';

  @override
  String get download_now => 'Stáhnout nyní';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Byla vydána noční verze Spotube $nightlyBuildNum';
  }

  @override
  String release_version(Object version) {
    return 'Byla vydána verze Spotube v$version';
  }

  @override
  String get read_the_latest => 'Přečtěte si nejnovější ';

  @override
  String get release_notes => 'poznámky k vydání';

  @override
  String get pick_color_scheme => 'Vyberte barevné schéma';

  @override
  String get save => 'Uložit';

  @override
  String get choose_the_device => 'Vyberte zařízení:';

  @override
  String get multiple_device_connected => 'Je připojeno více zařízení.\nVyberte zařízení, na kterém chcete provést tuto akci';

  @override
  String get nothing_found => 'Nic nenalezeno';

  @override
  String get the_box_is_empty => 'Krabice je prázdná';

  @override
  String get top_artists => 'Nejlepší umělci';

  @override
  String get top_albums => 'Nejlepší alba';

  @override
  String get this_week => 'Tento týden';

  @override
  String get this_month => 'Tento měsíc';

  @override
  String get last_6_months => 'Posledních 6 měsíců';

  @override
  String get this_year => 'Tento rok';

  @override
  String get last_2_years => 'Poslední 2 roky';

  @override
  String get all_time => 'Všechny časy';

  @override
  String powered_by_provider(Object providerName) {
    return 'Pohání $providerName';
  }

  @override
  String get email => 'Email';

  @override
  String get profile_followers => 'Sledující';

  @override
  String get birthday => 'Narozeniny';

  @override
  String get subscription => 'Předplatné';

  @override
  String get not_born => 'Nenarozen';

  @override
  String get hacker => 'Hacker';

  @override
  String get profile => 'Profil';

  @override
  String get no_name => 'Bez jména';

  @override
  String get edit => 'Upravit';

  @override
  String get user_profile => 'Uživatelský profil';

  @override
  String count_plays(Object count) {
    return '$count přehrání';
  }

  @override
  String get streaming_fees_hypothetical => 'Poplatky za streamování (hypotetické)';

  @override
  String get minutes_listened => 'Poslouchané minuty';

  @override
  String get streamed_songs => 'Streamované skladby';

  @override
  String count_streams(Object count) {
    return '$count streamů';
  }

  @override
  String get owned_by_you => 'Vlastněno vámi';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return 'Zkopírováno $shareUrl do schránky';
  }

  @override
  String get spotify_hipotetical_calculation => '*Toto je vypočítáno na základě výplaty\nza stream Spotify od \$0.003 do \$0.005.\nToto je hypotetický výpočet,\nabyste měli představu o tom, kolik\nbyste zaplatili umělcům,\npokud byste poslouchali jejich píseň na Spotify.';

  @override
  String count_mins(Object minutes) {
    return '$minutes minut';
  }

  @override
  String get summary_minutes => 'minuty';

  @override
  String get summary_listened_to_music => 'Poslouchal(a) hudbu';

  @override
  String get summary_songs => 'písně';

  @override
  String get summary_streamed_overall => 'Streamováno celkově';

  @override
  String get summary_owed_to_artists => 'Dluženo umělcům\nTento měsíc';

  @override
  String get summary_artists => 'umělců';

  @override
  String get summary_music_reached_you => 'Hudba vás oslovila';

  @override
  String get summary_full_albums => 'plná alba';

  @override
  String get summary_got_your_love => 'Získal vaši lásku';

  @override
  String get summary_playlists => 'playlisty';

  @override
  String get summary_were_on_repeat => 'Byly na opakování';

  @override
  String total_money(Object money) {
    return 'Celkem $money';
  }

  @override
  String get webview_not_found => 'Webview nebyl nalezen';

  @override
  String get webview_not_found_description => 'Na vašem zařízení není nainstalováno žádné runtime prostředí Webview.\nPokud je nainstalováno, ujistěte se, že je v environment PATH\n\nPo instalaci restartujte aplikaci';

  @override
  String get unsupported_platform => 'Nepodporovaná platforma';

  @override
  String get cache_music => 'Hudba v mezipaměti';

  @override
  String get open => 'Otevřít';

  @override
  String get cache_folder => 'Složka mezipaměti';

  @override
  String get export => 'Exportovat';

  @override
  String get clear_cache => 'Vymazat mezipaměť';

  @override
  String get clear_cache_confirmation => 'Opravdu chcete vymazat mezipaměť?';

  @override
  String get export_cache_files => 'Exportovat soubory z mezipaměti';

  @override
  String found_n_files(Object count) {
    return 'Nalezeno $count souborů';
  }

  @override
  String get export_cache_confirmation => 'Chcete exportovat tyto soubory do';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return 'Exportováno $filesExported z $files souborů';
  }

  @override
  String get undo => 'Zpět';

  @override
  String get download_all => 'Stáhnout vše';

  @override
  String get add_all_to_playlist => 'Přidat vše do seznamu skladeb';

  @override
  String get add_all_to_queue => 'Přidat vše do fronty';

  @override
  String get play_all_next => 'Přehrát vše následně';

  @override
  String get pause => 'Pauza';

  @override
  String get view_all => 'Zobrazit vše';

  @override
  String get no_tracks_added_yet => 'Zdá se, že jste ještě nepřidali žádné skladby';

  @override
  String get no_tracks => 'Zdá se, že zde nejsou žádné skladby';

  @override
  String get no_tracks_listened_yet => 'Zdá se, že jste ještě nic neposlouchali';

  @override
  String get not_following_artists => 'Nezajímáte se o žádné umělce';

  @override
  String get no_favorite_albums_yet => 'Zdá se, že jste ještě nepřidali žádné alba mezi oblíbené';

  @override
  String get no_logs_found => 'Žádné záznamy nenalezeny';

  @override
  String get youtube_engine => 'YouTube Engine';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engine není nainstalován';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engine není nainstalován ve vašem systému.';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return 'Ujistěte se, že je k dispozici v proměnné PATH nebo\nnastavte absolutní cestu k $engine spustitelnému souboru níže';
  }

  @override
  String get youtube_engine_unix_issue_message => 'V macOS/Linux/Unixových systémech nebude fungovat nastavení cesty v .zshrc/.bashrc/.bash_profile atd.\nMusíte nastavit cestu v konfiguračním souboru shellu';

  @override
  String get download => 'Stáhnout';

  @override
  String get file_not_found => 'Soubor nenalezen';

  @override
  String get custom => 'Vlastní';

  @override
  String get add_custom_url => 'Přidat vlastní URL';
}
