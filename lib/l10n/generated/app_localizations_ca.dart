// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get guest => 'Convidat';

  @override
  String get browse => 'Explorar';

  @override
  String get search => 'Cercar';

  @override
  String get library => 'Biblioteca';

  @override
  String get lyrics => 'Lletres';

  @override
  String get settings => 'Configuració';

  @override
  String get genre_categories_filter => 'Filtrar categories o gèneres...';

  @override
  String get genre => 'Gènere';

  @override
  String get personalized => 'Personalizat';

  @override
  String get featured => 'Destacat';

  @override
  String get new_releases => 'Nous Llançaments';

  @override
  String get songs => 'Cançons';

  @override
  String playing_track(Object track) {
    return 'Reproduint $track';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return 'Això eliminarà la llista actual. S\'eliminaran $track_length cançons.\n¿Vol continuar?';
  }

  @override
  String get load_more => 'Carregar més';

  @override
  String get playlists => 'Llistes de reproducció';

  @override
  String get artists => 'Artistes';

  @override
  String get albums => 'Àlbums';

  @override
  String get tracks => 'Cançons';

  @override
  String get downloads => 'Descàrregues';

  @override
  String get filter_playlists => 'Filtrar les seves llistes de reproducció...';

  @override
  String get liked_tracks => 'Cançons Preferides';

  @override
  String get liked_tracks_description => 'Totes les seves cançons preferides';

  @override
  String get playlist => 'Llista de reproducció';

  @override
  String get create_a_playlist => 'Crear una llista de reproducció';

  @override
  String get update_playlist => 'Actualitzar la llista de reproducció';

  @override
  String get create => 'Crear';

  @override
  String get cancel => 'Cancel·lar';

  @override
  String get update => 'Actualitzar';

  @override
  String get playlist_name => 'Nom de la llista';

  @override
  String get name_of_playlist => 'Nom de la lista';

  @override
  String get description => 'Descripció';

  @override
  String get public => 'Pública';

  @override
  String get collaborative => 'Col·laborativa';

  @override
  String get search_local_tracks => 'Cercar cançons locals...';

  @override
  String get play => 'Reproduir';

  @override
  String get delete => 'Eliminar';

  @override
  String get none => 'Cap';

  @override
  String get sort_a_z => 'Ordenar de la A a la Z';

  @override
  String get sort_z_a => 'Ordenar de la Z a la A';

  @override
  String get sort_artist => 'Ordenar per Artista';

  @override
  String get sort_album => 'Ordenar per Àlbum';

  @override
  String get sort_duration => 'Ordenar per Durada';

  @override
  String get sort_tracks => 'Ordenar Cançons';

  @override
  String currently_downloading(Object tracks_length) {
    return 'Descàrrega en curs ($tracks_length)';
  }

  @override
  String get cancel_all => 'Cancel·lar todo';

  @override
  String get filter_artist => 'Filtrar artistes...';

  @override
  String followers(Object followers) {
    return '$followers Seguidors';
  }

  @override
  String get add_artist_to_blacklist => 'Afegir artista a la llista negra';

  @override
  String get top_tracks => 'Millors Cançons';

  @override
  String get fans_also_like => 'Als fans també els hi agrada';

  @override
  String get loading => 'Carregant...';

  @override
  String get artist => 'Artista';

  @override
  String get blacklisted => 'A la llista negra';

  @override
  String get following => 'Seguint';

  @override
  String get follow => 'Seguir';

  @override
  String get artist_url_copied => 'URL de l\'artista copiada al porta-retalls ';

  @override
  String added_to_queue(Object tracks) {
    return '$tracks cançons afegides a la llista';
  }

  @override
  String get filter_albums => 'Filtrar àlbums...';

  @override
  String get synced => 'Sincronitzat';

  @override
  String get plain => 'Normal';

  @override
  String get shuffle => 'Aleatori';

  @override
  String get search_tracks => 'Buscar cançons...';

  @override
  String get released => 'Publicat';

  @override
  String error(Object error) {
    return 'Error $error';
  }

  @override
  String get title => 'Títul';

  @override
  String get time => 'Duració';

  @override
  String get more_actions => 'Més accios';

  @override
  String download_count(Object count) {
    return 'Descarregar ($count)';
  }

  @override
  String add_count_to_playlist(Object count) {
    return 'Afegir ($count) a la llista de reproducció';
  }

  @override
  String add_count_to_queue(Object count) {
    return 'Agregar ($count) a la llista';
  }

  @override
  String play_count_next(Object count) {
    return 'Reproduir ($count) a continuació';
  }

  @override
  String get album => 'Àlbum';

  @override
  String copied_to_clipboard(Object data) {
    return '$data copiado al porta-retalls';
  }

  @override
  String add_to_following_playlists(Object track) {
    return 'Afegir $track a les llistes de reproducció següents';
  }

  @override
  String get add => 'Afegir';

  @override
  String added_track_to_queue(Object track) {
    return '$track afegida a la llista';
  }

  @override
  String get add_to_queue => 'Afegir a la llista';

  @override
  String track_will_play_next(Object track) {
    return '$track es reproduirà a continuació';
  }

  @override
  String get play_next => 'Reproduir a continuació';

  @override
  String removed_track_from_queue(Object track) {
    return '$track eliminada de la llista';
  }

  @override
  String get remove_from_queue => 'Eliminar de la llista';

  @override
  String get remove_from_favorites => 'Eliminar de preferits';

  @override
  String get save_as_favorite => 'Guardar a preferits';

  @override
  String get add_to_playlist => 'Afegir a la llista de reproducció';

  @override
  String get remove_from_playlist => 'Eliminar de la llista de reproducció';

  @override
  String get add_to_blacklist => 'Afegir a la llista negra';

  @override
  String get remove_from_blacklist => 'Eliminar de la llista negra';

  @override
  String get share => 'Compartir';

  @override
  String get mini_player => 'Reproductor Petit';

  @override
  String get slide_to_seek => 'Lliscar per cercar endavant o endarrere';

  @override
  String get shuffle_playlist => 'Mesclar la llista de reproducció';

  @override
  String get unshuffle_playlist => 'No mesclar la llista de reproducció';

  @override
  String get previous_track => 'Cançó anterior';

  @override
  String get next_track => 'Canço següent';

  @override
  String get pause_playback => 'Pausar reproducció';

  @override
  String get resume_playback => 'Continuar reproducció';

  @override
  String get loop_track => 'Repetir canço';

  @override
  String get no_loop => 'Sense repetició';

  @override
  String get repeat_playlist => 'Repetir la llista de reproducció';

  @override
  String get queue => 'Llista';

  @override
  String get alternative_track_sources => 'Fonts alternatives de cançons';

  @override
  String get download_track => 'Descarregar cançó';

  @override
  String tracks_in_queue(Object tracks) {
    return '$tracks cançons a la llista';
  }

  @override
  String get clear_all => 'Netejar tot';

  @override
  String get show_hide_ui_on_hover =>
      'Mostrar/Ocultar interfície al passar el cursor';

  @override
  String get always_on_top => 'Sempre visible';

  @override
  String get exit_mini_player => 'Sortir del reproductor petit';

  @override
  String get download_location => 'Ubicació de descàrregues';

  @override
  String get local_library => 'Biblioteca local';

  @override
  String get add_library_location => 'Afegeix a la biblioteca';

  @override
  String get remove_library_location => 'Elimina de la biblioteca';

  @override
  String get account => 'Compte';

  @override
  String get logout => 'Tancar sessió';

  @override
  String get logout_of_this_account => 'Tancar sessió d\'aquest compte';

  @override
  String get language_region => 'Idioma i Regió';

  @override
  String get language => 'Idioma';

  @override
  String get system_default => 'Predeterminat del sistema';

  @override
  String get market_place_region => 'Regió de la botiga';

  @override
  String get recommendation_country => 'País de recomanació';

  @override
  String get appearance => 'Apariència';

  @override
  String get layout_mode => 'Mode de disseny';

  @override
  String get override_layout_settings =>
      'Anul·leu la configuració del mode de disseny responsiu';

  @override
  String get adaptive => 'Adaptable';

  @override
  String get compact => 'Compacte';

  @override
  String get extended => 'Extès';

  @override
  String get theme => 'Tema';

  @override
  String get dark => 'Fosc';

  @override
  String get light => 'Clar';

  @override
  String get system => 'Sistema';

  @override
  String get accent_color => 'Color d\'accent';

  @override
  String get sync_album_color => 'Sincronitzar color de l\'àlbum';

  @override
  String get sync_album_color_description =>
      'Utilitza el color dominant de l\'álbum com a color d\'accent';

  @override
  String get playback => 'Reproducció';

  @override
  String get audio_quality => 'Qualitat d\'àudio';

  @override
  String get high => 'Alta';

  @override
  String get low => 'Baixa';

  @override
  String get pre_download_play => 'Descàrrega prèvia i reproduir';

  @override
  String get pre_download_play_description =>
      'En lloc de transmetre l\'àudio, descarrega bytes i ho reprodueix (recomendat per usuaris amb un bon ample de banda)';

  @override
  String get skip_non_music =>
      'Ometre segments que no son música (SponsorBlock)';

  @override
  String get blacklist_description => 'Cançons i artistes de la llista negra';

  @override
  String get wait_for_download_to_finish =>
      'Si us plau, esperi que acabi la descàrrega actual';

  @override
  String get desktop => 'Escriptori';

  @override
  String get close_behavior => 'Comportament al tancar';

  @override
  String get close => 'Tancar';

  @override
  String get minimize_to_tray => 'Minimizar a la safata del sistema';

  @override
  String get show_tray_icon => 'Mostrar icona a la safata del sistema';

  @override
  String get about => 'Sobre';

  @override
  String get u_love_spotube => 'Sabem que li encanta Spotube';

  @override
  String get check_for_updates => 'Buscar actualitzacions';

  @override
  String get about_spotube => 'Sobre Spotube';

  @override
  String get blacklist => 'Llista negra';

  @override
  String get please_sponsor => 'Si us plau, patrocina/dona';

  @override
  String get spotube_description =>
      'Spotube, un client lleuger, multiplataforma i gratuït de Spotify';

  @override
  String get version => 'Versió';

  @override
  String get build_number => 'Número de compilació';

  @override
  String get founder => 'Fundador';

  @override
  String get repository => 'Repositori';

  @override
  String get bug_issues => 'Errors i problemes';

  @override
  String get made_with => 'Fet amb ❤️ a Bangladesh🇧🇩';

  @override
  String get kingkor_roy_tirtho => 'Kingkor Roy Tirtho';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year Kingkor Roy Tirtho';
  }

  @override
  String get license => 'Llicència';

  @override
  String get credentials_will_not_be_shared_disclaimer =>
      'No es preocupi, les seves credencials no seran recollides ni compartides amb ningú';

  @override
  String get know_how_to_login => 'No sap com fer-ho?';

  @override
  String get follow_step_by_step_guide => 'Segueixi la guia pas a pas';

  @override
  String cookie_name_cookie(Object name) {
    return 'Cookie $name';
  }

  @override
  String get fill_in_all_fields => 'Si us plau, completi tots els camps';

  @override
  String get submit => 'Enviar';

  @override
  String get exit => 'Sortir';

  @override
  String get previous => 'Anterior';

  @override
  String get next => 'Següent';

  @override
  String get done => 'Fet';

  @override
  String get step_1 => 'Pas 1';

  @override
  String get first_go_to => 'Primer, vagi a';

  @override
  String get something_went_wrong => 'Quelcom ha sortit malament';

  @override
  String get piped_instance => 'Instància del servidor Piped';

  @override
  String get piped_description =>
      'La instància del servidor Piped a utilitzar per la coincidència de cançons';

  @override
  String get piped_warning =>
      'Algunes poden no funcionar bé, utilitzi-les sota el seu propi risc';

  @override
  String get invidious_instance => 'Instància del servidor Invidious';

  @override
  String get invidious_description =>
      'La instància del servidor Invidious per fer coincidir pistes';

  @override
  String get invidious_warning =>
      'Algunes instàncies podrien no funcionar bé. Feu-les servir sota la vostra responsabilitat';

  @override
  String get generate => 'Generar';

  @override
  String track_exists(Object track) {
    return 'La cançó $track ja existeix';
  }

  @override
  String get replace_downloaded_tracks =>
      'Substituir totes les cançons descarregades';

  @override
  String get skip_download_tracks =>
      'Ometre la descàrrega de totes les cançons descarregades';

  @override
  String get do_you_want_to_replace => 'Vol substituir la cançó existent?';

  @override
  String get replace => 'Substituir';

  @override
  String get skip => 'Ometre';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return 'Seleccionar fins$count $type';
  }

  @override
  String get select_genres => 'Seleccionar Gèneres';

  @override
  String get add_genres => 'Afegir Gèneres';

  @override
  String get country => 'País';

  @override
  String get number_of_tracks_generate => 'Número de cançons a generar';

  @override
  String get acousticness => 'Acústica';

  @override
  String get danceability => 'Ballabilitat';

  @override
  String get energy => 'Energia';

  @override
  String get instrumentalness => 'Instrumental';

  @override
  String get liveness => 'En viu';

  @override
  String get loudness => 'Sonoritat';

  @override
  String get speechiness => 'Parla';

  @override
  String get valence => 'Valencia';

  @override
  String get popularity => 'Popularidad';

  @override
  String get key => 'To';

  @override
  String get duration => 'Duració (s)';

  @override
  String get tempo => 'Tempo (BPM)';

  @override
  String get mode => 'Mode';

  @override
  String get time_signature => 'Signatura de temps';

  @override
  String get short => 'Curt';

  @override
  String get medium => 'Mig';

  @override
  String get long => 'Llarg';

  @override
  String get min => 'Mín.';

  @override
  String get max => 'Màx.';

  @override
  String get target => 'Objetiu';

  @override
  String get moderate => 'Moderat';

  @override
  String get deselect_all => 'Desseleccionar tot';

  @override
  String get select_all => 'Seleccionar tot';

  @override
  String get are_you_sure => 'Està segur?';

  @override
  String get generating_playlist =>
      'Generant la seva llista de reproducció personalitzada...';

  @override
  String selected_count_tracks(Object count) {
    return 'Cançons $count seleccionades';
  }

  @override
  String get download_warning =>
      'Si descarrega totes les cançons de cop, està piratejant música clarament i causant dany a la societat creativa de la música. Espero que sigui conscient d\'això i sempre intenti respectar i recolzar la forta feina dels artístes';

  @override
  String get download_ip_ban_warning =>
      'Per cert, la seva IP pot ser bloquejada a YouTube degut a solicituds de descàrrega excessives. El bloqueig d\'IP vol dir que no podrà utilitzar YouTube (fins i tot si ha iniciat sessió) durant un mínim de 2-3 meses desde esa dirección IP. I Spotube no es fa responsable si això succeeix en alguna ocasió';

  @override
  String get by_clicking_accept_terms =>
      'Al fer clic a \'Acceptar\', acepta els següents termes:';

  @override
  String get download_agreement_1 =>
      'Se que estic piratejant música. Sóc dolent';

  @override
  String get download_agreement_2 =>
      'Recolzaré l\'artista quan pugui i només ho faig perquè no tinc diners per comprar el seu art';

  @override
  String get download_agreement_3 =>
      'Sóc completament conscient que la meva IP pot ser bloqueada per YouTube i no responsabilizo a Spotube ni als seus propietaris/contribuents per qualsevol incident causat per la meva acció actual';

  @override
  String get decline => 'Rebutjar';

  @override
  String get accept => 'Acceptar';

  @override
  String get details => 'Detalls';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => 'Canal';

  @override
  String get likes => 'M\'agrada';

  @override
  String get dislikes => 'No m\'agrada';

  @override
  String get views => 'Vistes';

  @override
  String get streamUrl => 'URL del streaming';

  @override
  String get stop => 'Parar';

  @override
  String get sort_newest => 'Ordenar per més noves';

  @override
  String get sort_oldest => 'Ordenar per més antigues';

  @override
  String get sleep_timer => 'Temporitzador d\'apagat';

  @override
  String mins(Object minutes) {
    return '$minutes minuts';
  }

  @override
  String hours(Object hours) {
    return '$hours hores';
  }

  @override
  String hour(Object hours) {
    return '$hours hora';
  }

  @override
  String get custom_hours => 'Hores personalitzades';

  @override
  String get logs => 'Registres';

  @override
  String get developers => 'Desenvolupadors';

  @override
  String get not_logged_in => 'No ha iniciat sesió';

  @override
  String get search_mode => 'Mode de cerca';

  @override
  String get audio_source => 'Font d\'àudio';

  @override
  String get ok => 'OK';

  @override
  String get failed_to_encrypt => 'Error al xifrar';

  @override
  String get encryption_failed_warning =>
      'Spotube utilitza el xifrado per emmagatzemar les seves dades de forma segura. Però ha fallat. Per tant, tornarà a un emmagatzament no segur\nSi estè utilizant Linux, asseguri\'s de tenir instal·lats els serveis secrets com gnome-keyring, kde-wallet i keepassxc';

  @override
  String get querying_info => 'Consultant informació...';

  @override
  String get piped_api_down => 'La API de Piped no està operativa';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return 'La instància de Piped $pipedInstance no està operativa en aquest moment\n\nCanvieu la instància o canvieu el \'Tipus d\'API\' a l\'API oficial de YouTube\n\nAssegureu-vos de reiniciar l\'aplicació després del canvi';
  }

  @override
  String get you_are_offline => 'Actualment no teniu connexió a internet';

  @override
  String get connection_restored => 'S\'ha restablert la connexió a internet';

  @override
  String get use_system_title_bar => 'Utilitza la barra de títol del sistema';

  @override
  String get crunching_results => 'Processant resultats...';

  @override
  String get search_to_get_results => 'Cerca per obtenir resultats';

  @override
  String get use_amoled_mode => 'Utilitza el mode AMOLED';

  @override
  String get pitch_dark_theme => 'Tema de dart negre intens';

  @override
  String get normalize_audio => 'Normalitza l\'àudio';

  @override
  String get change_cover => 'Canvia la coberta';

  @override
  String get add_cover => 'Afegeix una coberta';

  @override
  String get restore_defaults => 'Restaura els valors per defecte';

  @override
  String get download_music_format => 'Format de descàrrega de música';

  @override
  String get streaming_music_format =>
      'Format de reproducció de música en temps real';

  @override
  String get download_music_quality => 'Qualitat de descàrrega de música';

  @override
  String get streaming_music_quality =>
      'Qualitat de reproducció de música en temps real';

  @override
  String get login_with_lastfm => 'Inicia la sessió amb Last.fm';

  @override
  String get connect => 'Connecta';

  @override
  String get disconnect_lastfm => 'Desconnecta de Last.fm';

  @override
  String get disconnect => 'Desconnecta';

  @override
  String get username => 'Nom d\'usuari';

  @override
  String get password => 'Contrasenya';

  @override
  String get login => 'Inicia la sessió';

  @override
  String get login_with_your_lastfm =>
      'Inicia la sessió amb el teu compte de Last.fm';

  @override
  String get scrobble_to_lastfm => 'Scrobble a Last.fm';

  @override
  String get go_to_album => 'Anar a l\'àlbum';

  @override
  String get discord_rich_presence => 'Presència rica de Discord';

  @override
  String get browse_all => 'Navega per tot';

  @override
  String get genres => 'Gèneres';

  @override
  String get explore_genres => 'Explora els gèneres';

  @override
  String get friends => 'Amics';

  @override
  String get no_lyrics_available =>
      'Ho sentim, no es poden trobar les lletres d\'aquesta pista';

  @override
  String get start_a_radio => 'Inicia una ràdio';

  @override
  String get how_to_start_radio => 'Com vols començar la ràdio?';

  @override
  String get replace_queue_question =>
      'Voleu substituir la cua actual o afegir-hi?';

  @override
  String get endless_playback => 'Reproducció infinita';

  @override
  String get delete_playlist => 'Suprimeix la llista de reproducció';

  @override
  String get delete_playlist_confirmation =>
      'Esteu segur que voleu suprimir aquesta llista de reproducció?';

  @override
  String get local_tracks => 'Pistes locals';

  @override
  String get local_tab => 'Local';

  @override
  String get song_link => 'Enllaç de la cançó';

  @override
  String get skip_this_nonsense => 'Omet aquesta tonteria';

  @override
  String get freedom_of_music => '“Llibertat de la música”';

  @override
  String get freedom_of_music_palm =>
      '“Llibertat de la música a la palma de la mà”';

  @override
  String get get_started => 'Comencem';

  @override
  String get youtube_source_description => 'Recomanat i funciona millor.';

  @override
  String get piped_source_description =>
      'Et sents lliure? El mateix que YouTube però més lliure.';

  @override
  String get jiosaavn_source_description =>
      'El millor per a la regió del sud d\'Àsia.';

  @override
  String get invidious_source_description =>
      'Similar a Piped però amb més disponibilitat';

  @override
  String highest_quality(Object quality) {
    return 'Qualitat més alta: $quality';
  }

  @override
  String get select_audio_source => 'Seleccioneu la font d\'àudio';

  @override
  String get endless_playback_description =>
      'Afegiu automàticament noves cançons\nal final de la cua';

  @override
  String get choose_your_region => 'Trieu la vostra regió';

  @override
  String get choose_your_region_description =>
      'Això ajudarà a Spotube a mostrar-vos el contingut adequat\nper a la vostra ubicació.';

  @override
  String get choose_your_language => 'Trieu el vostre idioma';

  @override
  String get help_project_grow => 'Ajuda a fer créixer aquest projecte';

  @override
  String get help_project_grow_description =>
      'Spotube és un projecte de codi obert. Podeu ajudar a fer créixer aquest projecte contribuint al projecte, informant d\'errors o suggerint noves funcionalitats.';

  @override
  String get contribute_on_github => 'Contribueix a GitHub';

  @override
  String get donate_on_open_collective => 'Fes una donació a Open Collective';

  @override
  String get browse_anonymously => 'Navega de manera anònima';

  @override
  String get enable_connect => 'Habilita la connexió';

  @override
  String get enable_connect_description =>
      'Controla Spotube des d\'altres dispositius';

  @override
  String get devices => 'Dispositius';

  @override
  String get select => 'Selecciona';

  @override
  String connect_client_alert(Object client) {
    return 'Estàs sent controlat per $client';
  }

  @override
  String get this_device => 'Aquest dispositiu';

  @override
  String get remote => 'Remot';

  @override
  String get stats => 'Estadístiques';

  @override
  String and_n_more(Object count) {
    return 'i $count més';
  }

  @override
  String get recently_played => 'Reproduït recentment';

  @override
  String get browse_more => 'Navega més';

  @override
  String get no_title => 'Sense títol';

  @override
  String get not_playing => 'No s\'està reproduint';

  @override
  String get epic_failure => 'Fracàs èpic!';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return 'Afegit $tracks_length pistes a la cua';
  }

  @override
  String get spotube_has_an_update => 'Spotube té una actualització';

  @override
  String get download_now => 'Descarregar ara';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Spotube Nightly $nightlyBuildNum ha estat publicat';
  }

  @override
  String release_version(Object version) {
    return 'Spotube v$version ha estat publicat';
  }

  @override
  String get read_the_latest => 'Llegeix el més recent';

  @override
  String get release_notes => 'notes de la versió';

  @override
  String get pick_color_scheme => 'Tria l\'esquema de colors';

  @override
  String get save => 'Desar';

  @override
  String get choose_the_device => 'Tria el dispositiu:';

  @override
  String get multiple_device_connected =>
      'Hi ha diversos dispositius connectats.\nTria el dispositiu on vols realitzar aquesta acció';

  @override
  String get nothing_found => 'No s\'ha trobat res';

  @override
  String get the_box_is_empty => 'La caixa està buida';

  @override
  String get top_artists => 'Millors artistes';

  @override
  String get top_albums => 'Millors àlbums';

  @override
  String get this_week => 'Aquesta setmana';

  @override
  String get this_month => 'Aquest mes';

  @override
  String get last_6_months => 'Últims 6 mesos';

  @override
  String get this_year => 'Aquest any';

  @override
  String get last_2_years => 'Últims 2 anys';

  @override
  String get all_time => 'Tots els temps';

  @override
  String powered_by_provider(Object providerName) {
    return 'Funciona amb $providerName';
  }

  @override
  String get email => 'Correu electrònic';

  @override
  String get profile_followers => 'Seguidors';

  @override
  String get birthday => 'Aniversari';

  @override
  String get subscription => 'Subscripció';

  @override
  String get not_born => 'No ha nascut';

  @override
  String get hacker => 'Hacker';

  @override
  String get profile => 'Perfil';

  @override
  String get no_name => 'Sense nom';

  @override
  String get edit => 'Editar';

  @override
  String get user_profile => 'Perfil d\'usuari';

  @override
  String count_plays(Object count) {
    return '$count reproduccions';
  }

  @override
  String get streaming_fees_hypothetical =>
      'Comissions de streaming (hipotètic)';

  @override
  String get minutes_listened => 'minuts escoltats';

  @override
  String get streamed_songs => 'cançons reproduïdes';

  @override
  String count_streams(Object count) {
    return '$count reproduccions';
  }

  @override
  String get owned_by_you => 'De la teva propietat';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return 'S\'ha copiat $shareUrl al porta-retalls';
  }

  @override
  String get hipotetical_calculation =>
      '*Això està calculat en funció d’un pagament mitjà per reproducció de 0,003–0,005  USD en plataformes de reproducció musical en línia. És un càlcul hipotètic per ajudar l’usuari a entendre quant hauria pagat als artistes si hagués escoltat la seva cançó en diferents plataformes.';

  @override
  String count_mins(Object minutes) {
    return '$minutes minuts';
  }

  @override
  String get summary_minutes => 'minuts';

  @override
  String get summary_listened_to_music => 'has escoltat música';

  @override
  String get summary_songs => 'cançons';

  @override
  String get summary_streamed_overall => 'reproduït en general';

  @override
  String get summary_owed_to_artists => 'degut als artistes\nAquest mes';

  @override
  String get summary_artists => 'artistes';

  @override
  String get summary_music_reached_you => 'La música t\'ha arribat';

  @override
  String get summary_full_albums => 'Àlbums complets';

  @override
  String get summary_got_your_love => 'ha aconseguit el teu amor';

  @override
  String get summary_playlists => 'llistes de reproducció';

  @override
  String get summary_were_on_repeat => 'estaven en repetició';

  @override
  String total_money(Object money) {
    return 'total $money';
  }

  @override
  String get webview_not_found => 'No s\'ha trobat el Webview';

  @override
  String get webview_not_found_description =>
      'No hi ha cap temps d\'execució de Webview instal·lat al dispositiu.\nSi està instal·lat, assegureu-vos que estigui en el environment PATH\n\nDesprés d\'instal·lar-lo, reinicieu l\'aplicació';

  @override
  String get unsupported_platform => 'Plataforma no compatible';

  @override
  String get cache_music => 'Música en caché';

  @override
  String get open => 'Obrir';

  @override
  String get cache_folder => 'Carpeta de caché';

  @override
  String get export => 'Exportar';

  @override
  String get clear_cache => 'Netejar caché';

  @override
  String get clear_cache_confirmation => 'Voleu netejar la memòria cau?';

  @override
  String get export_cache_files => 'Exportar arxius en caché';

  @override
  String found_n_files(Object count) {
    return 'S\'han trobat $count arxius';
  }

  @override
  String get export_cache_confirmation => 'Voleu exportar aquests arxius a';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return 'S\'han exportat $filesExported de $files arxius';
  }

  @override
  String get undo => 'Desfer';

  @override
  String get download_all => 'Descarregar tot';

  @override
  String get add_all_to_playlist => 'Afegir tot a la llista de reproducció';

  @override
  String get add_all_to_queue => 'Afegir tot a la cua';

  @override
  String get play_all_next => 'Reproduir tot a continuació';

  @override
  String get pause => 'Pausa';

  @override
  String get view_all => 'Veure tot';

  @override
  String get no_tracks_added_yet => 'Sembla que encara no has afegit cap pista';

  @override
  String get no_tracks => 'Sembla que no hi ha pistes aquí';

  @override
  String get no_tracks_listened_yet => 'Sembla que no has escoltat res encara';

  @override
  String get not_following_artists => 'No estàs seguint cap artista';

  @override
  String get no_favorite_albums_yet =>
      'Sembla que encara no has afegit cap àlbum als teus favorits';

  @override
  String get no_logs_found => 'No s\'han trobat registres';

  @override
  String get youtube_engine => 'Motor de YouTube';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engine no està instal·lat';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engine no està instal·lat al teu sistema.';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return 'Assegura\'t que estigui disponible a la variable PATH o\nestableix el camí absolut a l\'executable de $engine a continuació';
  }

  @override
  String get youtube_engine_unix_issue_message =>
      'En macOS/Linux/Unix com a sistemes operatius, establir el camí a .zshrc/.bashrc/.bash_profile etc. no funcionarà.\nHas de configurar el camí al fitxer de configuració de la shell';

  @override
  String get download => 'Descarregar';

  @override
  String get file_not_found => 'Fitxer no trobat';

  @override
  String get custom => 'Personalitzat';

  @override
  String get add_custom_url => 'Afegir URL personalitzada';

  @override
  String get edit_port => 'Editar port';

  @override
  String get port_helper_msg =>
      'El valor per defecte és -1, que indica un número aleatori. Si teniu un tallafoc configurat, es recomana establir-ho.';

  @override
  String connect_request(Object client) {
    return 'Permetre que $client es connecti?';
  }

  @override
  String get connection_request_denied =>
      'Connexió denegada. L\'usuari ha denegat l\'accés.';

  @override
  String get an_error_occurred => 'S’ha produït un error';

  @override
  String get copy_to_clipboard => 'Copiar al porta-retalls';

  @override
  String get view_logs => 'Veure registres';

  @override
  String get retry => 'Tornar-ho a provar';

  @override
  String get no_default_metadata_provider_selected =>
      'No has configurat cap proveïdor de metadades predeterminat';

  @override
  String get manage_metadata_providers => 'Gestionar proveïdors de metadades';

  @override
  String get open_link_in_browser => 'Obrir l’enllaç en el navegador?';

  @override
  String get do_you_want_to_open_the_following_link =>
      'Vols obrir l’enllaç següent?';

  @override
  String get unsafe_url_warning =>
      'Pot ser perillós obrir enllaços de fonts no fiables. Sigues precavís!\nTambé pots copiar l’enllaç al porta-retalls.';

  @override
  String get copy_link => 'Copiar enllaç';

  @override
  String get building_your_timeline =>
      'Construint la teva cronologia en funció de les teves escoltes...';

  @override
  String get official => 'Oficial';

  @override
  String author_name(Object author) {
    return 'Autor: $author';
  }

  @override
  String get third_party => 'Tercers';

  @override
  String get plugin_requires_authentication =>
      'El complement requereix autenticació';

  @override
  String get update_available => 'Actualització disponible';

  @override
  String get supports_scrobbling => 'Admet scrobbling';

  @override
  String get plugin_scrobbling_info =>
      'Aquest complement fa scrobbling de la teva música per generar l’historial d’escoltes.';

  @override
  String get default_metadata_source => 'Font de metadades per defecte';

  @override
  String get set_default_metadata_source =>
      'Estableix la font de metadades per defecte';

  @override
  String get default_audio_source => 'Font d\'àudio per defecte';

  @override
  String get set_default_audio_source =>
      'Estableix la font d\'àudio per defecte';

  @override
  String get set_default => 'Establir com a predeterminat';

  @override
  String get support => 'Suport';

  @override
  String get support_plugin_development =>
      'Suportar el desenvolupament del complement';

  @override
  String can_access_name_api(Object name) {
    return '- Pot accedir a l’API **$name**';
  }

  @override
  String get do_you_want_to_install_this_plugin =>
      'Vols instal·lar aquest complement?';

  @override
  String get third_party_plugin_warning =>
      'Aquest complement prové d’un repositori de tercers. Assegura’t de confiar en la font abans d’instal·lar-lo.';

  @override
  String get author => 'Autor';

  @override
  String get this_plugin_can_do_following =>
      'Aquest complement pot fer el següent';

  @override
  String get install => 'Instal·lar';

  @override
  String get install_a_metadata_provider =>
      'Instal·lar un proveïdor de metadades';

  @override
  String get no_tracks_playing => 'No s’està reproduint cap pista actualment';

  @override
  String get synced_lyrics_not_available =>
      'Les lletres sincronitzades no estan disponibles per a aquesta cançó. Si us plau, usa';

  @override
  String get plain_lyrics => 'Lletres sense format';

  @override
  String get tab_instead => 'en lloc d’això, utilitza la tecla Tab.';

  @override
  String get disclaimer => 'Avís legal';

  @override
  String get third_party_plugin_dmca_notice =>
      'L’equip de Spotube no accepta cap responsabilitat (inclosa legal) pels complements de “tercers”.\nFes-los servir sota la teva responsabilitat. Si detectes errors/problemes, informa’ls al repositori del complement.\n\nSi algun complement de “tercers” incompleix els ToS/DMCA d’un servei o entitat legal, contacta amb l’autor del complement o amb la plataforma d’allotjament (per exemple GitHub/Codeberg) per prendre mesures. Els complements etiquetats com a “tercers” són públics i gestionats per la comunitat; no els curatem, per la qual cosa no podem intervenir-hi.\n\n';

  @override
  String get input_does_not_match_format =>
      'L’entrada no coincideix amb el format requerit';

  @override
  String get plugins => 'Connectors';

  @override
  String get paste_plugin_download_url =>
      'Enllaça l’URL de descàrrega o el repositori de GitHub/Codeberg o l’enllaç directe al fitxer .smplug';

  @override
  String get download_and_install_plugin_from_url =>
      'Descarrega i instal·la el complement des d’un URL';

  @override
  String failed_to_add_plugin_error(Object error) {
    return 'Error en afegir el complement: $error';
  }

  @override
  String get upload_plugin_from_file => 'Penja el complement des d’un fitxer';

  @override
  String get installed => 'Instal·lat';

  @override
  String get available_plugins => 'Complements disponibles';

  @override
  String get configure_plugins =>
      'Configura els teus propis connectors de proveïdor de metadades i de font d\'àudio';

  @override
  String get audio_scrobblers => 'Scrobblers d’àudio';

  @override
  String get scrobbling => 'Scrobbling';

  @override
  String get source => 'Font: ';

  @override
  String get uncompressed => 'Sense comprimir';

  @override
  String get dab_music_source_description =>
      'Per als audiòfils. Ofereix fluxos d\'àudio d\'alta qualitat/sense pèrdua. Coincidència precisa de pistes basada en ISRC.';
}
