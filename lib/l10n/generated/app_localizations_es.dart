// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get guest => 'Invitado';

  @override
  String get browse => 'Explorar';

  @override
  String get search => 'Buscar';

  @override
  String get library => 'Biblioteca';

  @override
  String get lyrics => 'Letras';

  @override
  String get settings => 'Configuración';

  @override
  String get genre_categories_filter => 'Filtrar categorías o géneros...';

  @override
  String get genre => 'Género';

  @override
  String get personalized => 'Personalizado';

  @override
  String get featured => 'Destacado';

  @override
  String get new_releases => 'Nuevos Lanzamientos';

  @override
  String get songs => 'Canciones';

  @override
  String playing_track(Object track) {
    return 'Reproduciendo $track';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return 'Esto eliminará la lista actual. Se eliminarán $track_length canciones.\n¿Deseas continuar?';
  }

  @override
  String get load_more => 'Cargar más';

  @override
  String get playlists => 'Listas de reproducción';

  @override
  String get artists => 'Artistas';

  @override
  String get albums => 'Álbumes';

  @override
  String get tracks => 'Canciones';

  @override
  String get downloads => 'Descargas';

  @override
  String get filter_playlists => 'Filtrar tus listas de reproducción...';

  @override
  String get liked_tracks => 'Canciones Favoritas';

  @override
  String get liked_tracks_description => 'Todas tus canciones favoritas';

  @override
  String get playlist => 'Lista de reproducción';

  @override
  String get create_a_playlist => 'Crear una lista de reproducción';

  @override
  String get update_playlist => 'Actualizar lista de reproducción';

  @override
  String get create => 'Crear';

  @override
  String get cancel => 'Cancelar';

  @override
  String get update => 'Actualizar';

  @override
  String get playlist_name => 'Nombre de la lista';

  @override
  String get name_of_playlist => 'Nombre de la lista';

  @override
  String get description => 'Descripción';

  @override
  String get public => 'Pública';

  @override
  String get collaborative => 'Colaborativa';

  @override
  String get search_local_tracks => 'Buscar canciones locales...';

  @override
  String get play => 'Reproducir';

  @override
  String get delete => 'Eliminar';

  @override
  String get none => 'Ninguno';

  @override
  String get sort_a_z => 'Ordenar de la A a la Z';

  @override
  String get sort_z_a => 'Ordenar de la Z a la A';

  @override
  String get sort_artist => 'Ordenar por Artista';

  @override
  String get sort_album => 'Ordenar por Álbum';

  @override
  String get sort_duration => 'Ordenar por Duración';

  @override
  String get sort_tracks => 'Ordenar Canciones';

  @override
  String currently_downloading(Object tracks_length) {
    return 'Descargando en curso ($tracks_length)';
  }

  @override
  String get cancel_all => 'Cancelar todo';

  @override
  String get filter_artist => 'Filtrar artistas...';

  @override
  String followers(Object followers) {
    return '$followers Seguidores';
  }

  @override
  String get add_artist_to_blacklist => 'Agregar artista a la lista negra';

  @override
  String get top_tracks => 'Mejores Canciones';

  @override
  String get fans_also_like => 'A los fans también les gusta';

  @override
  String get loading => 'Cargando...';

  @override
  String get artist => 'Artista';

  @override
  String get blacklisted => 'En la lista negra';

  @override
  String get following => 'Siguiendo';

  @override
  String get follow => 'Seguir';

  @override
  String get artist_url_copied => 'URL del artista copiada al portapapeles';

  @override
  String added_to_queue(Object tracks) {
    return 'Agregadas $tracks canciones a la lista';
  }

  @override
  String get filter_albums => 'Filtrar álbumes...';

  @override
  String get synced => 'Sincronizado';

  @override
  String get plain => 'Normal';

  @override
  String get shuffle => 'Aleatorio';

  @override
  String get search_tracks => 'Buscar canciones...';

  @override
  String get released => 'Lanzado';

  @override
  String error(Object error) {
    return 'Error $error';
  }

  @override
  String get title => 'Título';

  @override
  String get time => 'Duración';

  @override
  String get more_actions => 'Más acciones';

  @override
  String download_count(Object count) {
    return 'Descargas ($count)';
  }

  @override
  String add_count_to_playlist(Object count) {
    return 'Agregar ($count) a la lista';
  }

  @override
  String add_count_to_queue(Object count) {
    return 'Agregar ($count) a la lista';
  }

  @override
  String play_count_next(Object count) {
    return 'Reproducir ($count) a continuación';
  }

  @override
  String get album => 'Álbum';

  @override
  String copied_to_clipboard(Object data) {
    return '$data copiado al portapapeles';
  }

  @override
  String add_to_following_playlists(Object track) {
    return 'Agregar $track a las listas de reproducción siguientes';
  }

  @override
  String get add => 'Agregar';

  @override
  String added_track_to_queue(Object track) {
    return '$track agregada a la lista';
  }

  @override
  String get add_to_queue => 'Agregar a la lista';

  @override
  String track_will_play_next(Object track) {
    return '$track se reproducirá a continuación';
  }

  @override
  String get play_next => 'Reproducir a continuación';

  @override
  String removed_track_from_queue(Object track) {
    return '$track eliminada de la lista';
  }

  @override
  String get remove_from_queue => 'Eliminar de la lista';

  @override
  String get remove_from_favorites => 'Eliminar de favoritos';

  @override
  String get save_as_favorite => 'Guardar como favorito';

  @override
  String get add_to_playlist => 'Agregar a la lista';

  @override
  String get remove_from_playlist => 'Eliminar de la lista';

  @override
  String get add_to_blacklist => 'Agregar a la lista negra';

  @override
  String get remove_from_blacklist => 'Eliminar de la lista negra';

  @override
  String get share => 'Compartir';

  @override
  String get mini_player => 'Reproductor Mini';

  @override
  String get slide_to_seek => 'Desliza para buscar adelante o atrás';

  @override
  String get shuffle_playlist => 'Reproducir lista en orden aleatorio';

  @override
  String get unshuffle_playlist => 'Desactivar reproducción aleatoria';

  @override
  String get previous_track => 'Pista anterior';

  @override
  String get next_track => 'Pista siguiente';

  @override
  String get pause_playback => 'Pausar reproducción';

  @override
  String get resume_playback => 'Reanudar reproducción';

  @override
  String get loop_track => 'Repetir pista';

  @override
  String get no_loop => 'Sin bucle';

  @override
  String get repeat_playlist => 'Repetir lista';

  @override
  String get queue => 'Lista';

  @override
  String get alternative_track_sources => 'Fuentes alternativas de canciones';

  @override
  String get download_track => 'Descargar canción';

  @override
  String tracks_in_queue(Object tracks) {
    return '$tracks canciones en la lista';
  }

  @override
  String get clear_all => 'Limpiar todo';

  @override
  String get show_hide_ui_on_hover => 'Mostrar/Ocultar interfaz al pasar el cursor';

  @override
  String get always_on_top => 'Siempre visible';

  @override
  String get exit_mini_player => 'Salir del reproductor mini';

  @override
  String get download_location => 'Ubicación de descargas';

  @override
  String get local_library => 'Biblioteca local';

  @override
  String get add_library_location => 'Añadir a la biblioteca';

  @override
  String get remove_library_location => 'Eliminar de la biblioteca';

  @override
  String get account => 'Cuenta';

  @override
  String get login_with_spotify => 'Iniciar sesión con tu cuenta de Spotify';

  @override
  String get connect_with_spotify => 'Conectar con Spotify';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get logout_of_this_account => 'Cerrar sesión de esta cuenta';

  @override
  String get language_region => 'Idioma y Región';

  @override
  String get language => 'Idioma';

  @override
  String get system_default => 'Predeterminado del sistema';

  @override
  String get market_place_region => 'Región de la tienda';

  @override
  String get recommendation_country => 'País de recomendación';

  @override
  String get appearance => 'Apariencia';

  @override
  String get layout_mode => 'Modo de diseño';

  @override
  String get override_layout_settings => 'Anular la configuración del modo de diseño responsive';

  @override
  String get adaptive => 'Adaptable';

  @override
  String get compact => 'Compacto';

  @override
  String get extended => 'Extendido';

  @override
  String get theme => 'Tema';

  @override
  String get dark => 'Oscuro';

  @override
  String get light => 'Claro';

  @override
  String get system => 'Sistema';

  @override
  String get accent_color => 'Color de acento';

  @override
  String get sync_album_color => 'Sincronizar color del álbum';

  @override
  String get sync_album_color_description => 'Usa el color dominante del arte del álbum como color de acento';

  @override
  String get playback => 'Reproducción';

  @override
  String get audio_quality => 'Calidad de audio';

  @override
  String get high => 'Alta';

  @override
  String get low => 'Baja';

  @override
  String get pre_download_play => 'Pre-descargar y reproducir';

  @override
  String get pre_download_play_description => 'En lugar de transmitir audio, descarga bytes y reproduce en su lugar (recomendado para usuarios con mayor ancho de banda)';

  @override
  String get skip_non_music => 'Omitir segmentos que no son música (SponsorBlock)';

  @override
  String get blacklist_description => 'Canciones y artistas en la lista negra';

  @override
  String get wait_for_download_to_finish => 'Por favor, espera a que termine la descarga actual';

  @override
  String get desktop => 'Escritorio';

  @override
  String get close_behavior => 'Comportamiento al cerrar';

  @override
  String get close => 'Cerrar';

  @override
  String get minimize_to_tray => 'Minimizar en la bandeja del sistema';

  @override
  String get show_tray_icon => 'Mostrar icono en la bandeja del sistema';

  @override
  String get about => 'Acerca de';

  @override
  String get u_love_spotube => 'Sabemos que te encanta Spotube';

  @override
  String get check_for_updates => 'Buscar actualizaciones';

  @override
  String get about_spotube => 'Acerca de Spotube';

  @override
  String get blacklist => 'Lista negra';

  @override
  String get please_sponsor => 'Por favor, apoya/dona';

  @override
  String get spotube_description => 'Spotube, un cliente ligero, multiplataforma y gratuito de Spotify';

  @override
  String get version => 'Versión';

  @override
  String get build_number => 'Número de compilación';

  @override
  String get founder => 'Fundador';

  @override
  String get repository => 'Repositorio';

  @override
  String get bug_issues => 'Errores y problemas';

  @override
  String get made_with => 'Hecho con ❤️ en Bangladesh🇧🇩';

  @override
  String get kingkor_roy_tirtho => 'Kingkor Roy Tirtho';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year Kingkor Roy Tirtho';
  }

  @override
  String get license => 'Licencia';

  @override
  String get add_spotify_credentials => 'Agrega tus credenciales de Spotify para comenzar';

  @override
  String get credentials_will_not_be_shared_disclaimer => 'No te preocupes, tus credenciales no serán recopiladas ni compartidas con nadie';

  @override
  String get know_how_to_login => '¿No sabes cómo hacerlo?';

  @override
  String get follow_step_by_step_guide => 'Sigue la guía paso a paso';

  @override
  String spotify_cookie(Object name) {
    return 'Cookie de Spotify $name';
  }

  @override
  String cookie_name_cookie(Object name) {
    return 'Cookie $name';
  }

  @override
  String get fill_in_all_fields => 'Por favor, completa todos los campos';

  @override
  String get submit => 'Enviar';

  @override
  String get exit => 'Salir';

  @override
  String get previous => 'Anterior';

  @override
  String get next => 'Siguiente';

  @override
  String get done => 'Listo';

  @override
  String get step_1 => 'Paso 1';

  @override
  String get first_go_to => 'Primero, ve a';

  @override
  String get login_if_not_logged_in => 'e inicia sesión/registra tu cuenta si no lo has hecho aún';

  @override
  String get step_2 => 'Paso 2';

  @override
  String get step_2_steps => '1. Una vez que hayas iniciado sesión, presiona F12 o haz clic derecho con el ratón > Inspeccionar para abrir las herramientas de desarrollo del navegador.\n2. Luego ve a la pestaña \"Application\" (Chrome, Edge, Brave, etc.) o \"Storage\" (Firefox, Palemoon, etc.)\n3. Ve a la sección \"Cookies\" y luego la subsección \"https://accounts.spotify.com\"';

  @override
  String get step_3 => 'Paso 3';

  @override
  String get step_3_steps => 'Copia el valor de la cookie \"sp_dc\"';

  @override
  String get success_emoji => '¡Éxito! 🥳';

  @override
  String get success_message => 'Ahora has iniciado sesión con éxito en tu cuenta de Spotify. ¡Buen trabajo!';

  @override
  String get step_4 => 'Paso 4';

  @override
  String get step_4_steps => 'Pega el valor copiado de \"sp_dc\"';

  @override
  String get something_went_wrong => 'Algo salió mal';

  @override
  String get piped_instance => 'Instancia del servidor Piped';

  @override
  String get piped_description => 'La instancia del servidor Piped a utilizar para la coincidencia de pistas';

  @override
  String get piped_warning => 'Algunas pueden no funcionar bien, úsalas bajo tu propio riesgo';

  @override
  String get invidious_instance => 'Instancia del Servidor Invidious';

  @override
  String get invidious_description => 'La instancia del servidor Invidious para identificar pistas';

  @override
  String get invidious_warning => 'Algunas instancias podrían no funcionar bien. Úselas bajo su propio riesgo';

  @override
  String get generate => 'Generar';

  @override
  String track_exists(Object track) {
    return 'La canción $track ya existe';
  }

  @override
  String get replace_downloaded_tracks => 'Reemplazar todas las canciones descargadas';

  @override
  String get skip_download_tracks => 'Omitir la descarga de todas las canciones descargadas';

  @override
  String get do_you_want_to_replace => '¿Deseas reemplazar la canción existente?';

  @override
  String get replace => 'Reemplazar';

  @override
  String get skip => 'Omitir';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return 'Seleccionar hasta $count $type';
  }

  @override
  String get select_genres => 'Seleccionar Géneros';

  @override
  String get add_genres => 'Agregar Géneros';

  @override
  String get country => 'País';

  @override
  String get number_of_tracks_generate => 'Número de canciones a generar';

  @override
  String get acousticness => 'Acousticness';

  @override
  String get danceability => 'Danceability';

  @override
  String get energy => 'Energía';

  @override
  String get instrumentalness => 'Instrumentalidad';

  @override
  String get liveness => 'En vivo';

  @override
  String get loudness => 'Volumen';

  @override
  String get speechiness => 'Habla';

  @override
  String get valence => 'Valencia';

  @override
  String get popularity => 'Popularidad';

  @override
  String get key => 'Tono';

  @override
  String get duration => 'Duración (s)';

  @override
  String get tempo => 'Tempo (BPM)';

  @override
  String get mode => 'Modo';

  @override
  String get time_signature => 'Compás';

  @override
  String get short => 'Corto';

  @override
  String get medium => 'Medio';

  @override
  String get long => 'Largo';

  @override
  String get min => 'Mín.';

  @override
  String get max => 'Máx.';

  @override
  String get target => 'Objetivo';

  @override
  String get moderate => 'Moderado';

  @override
  String get deselect_all => 'Deseleccionar todo';

  @override
  String get select_all => 'Seleccionar todo';

  @override
  String get are_you_sure => '¿Estás seguro?';

  @override
  String get generating_playlist => 'Generando tu lista de reproducción personalizada...';

  @override
  String selected_count_tracks(Object count) {
    return 'Seleccionadas $count canciones';
  }

  @override
  String get download_warning => 'Si descargas todas las canciones de golpe, estás claramente pirateando música y causando daño a la sociedad creativa de la música. Espero que seas consciente de esto y siempre intentes respetar y apoyar el arduo trabajo de los artistas';

  @override
  String get download_ip_ban_warning => 'Por cierto, tu IP puede ser bloqueada en YouTube debido a solicitudes de descarga excesivas. El bloqueo de IP significa que no podrás usar YouTube (incluso si has iniciado sesión) durante al menos 2-3 meses desde esa dirección IP. Y Spotube no se hace responsable si esto ocurre alguna vez';

  @override
  String get by_clicking_accept_terms => 'Al hacer clic en \'Aceptar\', aceptas los siguientes términos:';

  @override
  String get download_agreement_1 => 'Sé que estoy pirateando música. Soy malo';

  @override
  String get download_agreement_2 => 'Apoyaré al artista donde pueda y solo lo hago porque no tengo dinero para comprar su arte';

  @override
  String get download_agreement_3 => 'Soy completamente consciente de que mi IP puede ser bloqueada en YouTube y no responsabilizo a Spotube ni a sus dueños/contribuyentes por cualquier incidente causado por mi acción actual';

  @override
  String get decline => 'Rechazar';

  @override
  String get accept => 'Aceptar';

  @override
  String get details => 'Detalles';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => 'Canal';

  @override
  String get likes => 'Me gusta';

  @override
  String get dislikes => 'No me gusta';

  @override
  String get views => 'Vistas';

  @override
  String get streamUrl => 'URL del streaming';

  @override
  String get stop => 'Detener';

  @override
  String get sort_newest => 'Ordenar por más recientes';

  @override
  String get sort_oldest => 'Ordenar por más antiguos';

  @override
  String get sleep_timer => 'Temporizador de apagado';

  @override
  String mins(Object minutes) {
    return '$minutes minutos';
  }

  @override
  String hours(Object hours) {
    return '$hours horas';
  }

  @override
  String hour(Object hours) {
    return '$hours hora';
  }

  @override
  String get custom_hours => 'Horas personalizadas';

  @override
  String get logs => 'Registros';

  @override
  String get developers => 'Desarrolladores';

  @override
  String get not_logged_in => 'No has iniciado sesión';

  @override
  String get search_mode => 'Modo de búsqueda';

  @override
  String get audio_source => 'Fuente de audio';

  @override
  String get ok => 'OK';

  @override
  String get failed_to_encrypt => 'Error al cifrar';

  @override
  String get encryption_failed_warning => 'Spotube utiliza el cifrado para almacenar sus datos de forma segura. Pero ha fallado. Por lo tanto, volverá a un almacenamiento no seguro\nSi está utilizando Linux, asegúrese de tener instalados servicios secretos como gnome-keyring, kde-wallet y keepassxc';

  @override
  String get querying_info => 'Consultando información...';

  @override
  String get piped_api_down => 'La API de Piped no está disponible';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return 'La instancia de Piped $pipedInstance no está funcionando en este momento\n\nCambie la instancia o cambie el \'Tipo de API\' a la API oficial de YouTube\n\nAsegúrese de reiniciar la aplicación después del cambio';
  }

  @override
  String get you_are_offline => 'Actualmente estás sin conexión';

  @override
  String get connection_restored => 'Se ha restablecido tu conexión a internet';

  @override
  String get use_system_title_bar => 'Usar la barra de título del sistema';

  @override
  String get crunching_results => 'Procesando resultados...';

  @override
  String get search_to_get_results => 'Buscar para obtener resultados';

  @override
  String get use_amoled_mode => 'Usar modo AMOLED';

  @override
  String get pitch_dark_theme => 'Tema oscuro de dart';

  @override
  String get normalize_audio => 'Normalizar audio';

  @override
  String get change_cover => 'Cambiar portada';

  @override
  String get add_cover => 'Agregar portada';

  @override
  String get restore_defaults => 'Restaurar valores predeterminados';

  @override
  String get download_music_codec => 'Descargar códec de música';

  @override
  String get streaming_music_codec => 'Códec de música en streaming';

  @override
  String get login_with_lastfm => 'Iniciar sesión con Last.fm';

  @override
  String get connect => 'Conectar';

  @override
  String get disconnect_lastfm => 'Desconectar de Last.fm';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get password => 'Contraseña';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get login_with_your_lastfm => 'Iniciar sesión con tu cuenta de Last.fm';

  @override
  String get scrobble_to_lastfm => 'Scrobble a Last.fm';

  @override
  String get go_to_album => 'Ir al álbum';

  @override
  String get discord_rich_presence => 'Presencia rica en Discord';

  @override
  String get browse_all => 'Explorar todo';

  @override
  String get genres => 'Géneros';

  @override
  String get explore_genres => 'Explorar géneros';

  @override
  String get friends => 'Amigos';

  @override
  String get no_lyrics_available => 'Lo siento, no se pueden encontrar las letras de esta pista';

  @override
  String get start_a_radio => 'Iniciar una Radio';

  @override
  String get how_to_start_radio => '¿Cómo quieres iniciar la radio?';

  @override
  String get replace_queue_question => '¿Quieres reemplazar la lista de reproducción actual o añadir a ella?';

  @override
  String get endless_playback => 'Reproducción Infinita';

  @override
  String get delete_playlist => 'Eliminar Lista de Reproducción';

  @override
  String get delete_playlist_confirmation => '¿Estás seguro de que quieres eliminar esta lista de reproducción?';

  @override
  String get local_tracks => 'Pistas Locales';

  @override
  String get local_tab => 'Local';

  @override
  String get song_link => 'Enlace de la Canción';

  @override
  String get skip_this_nonsense => 'Saltar esta tontería';

  @override
  String get freedom_of_music => '“Libertad de la Música”';

  @override
  String get freedom_of_music_palm => '“Libertad de la Música en la palma de tu mano”';

  @override
  String get get_started => 'Empecemos';

  @override
  String get youtube_source_description => 'Recomendado y funciona mejor.';

  @override
  String get piped_source_description => '¿Te sientes libre? Igual que YouTube pero más libre.';

  @override
  String get jiosaavn_source_description => 'Lo mejor para la región del sur de Asia.';

  @override
  String get invidious_source_description => 'Similar a Piped, pero con mayor disponibilidad';

  @override
  String highest_quality(Object quality) {
    return 'Mayor Calidad: $quality';
  }

  @override
  String get select_audio_source => 'Seleccionar Fuente de Audio';

  @override
  String get endless_playback_description => 'Añadir automáticamente nuevas canciones\nal final de la cola de reproducción';

  @override
  String get choose_your_region => 'Elige tu región';

  @override
  String get choose_your_region_description => 'Esto ayudará a Spotube a mostrarte el contenido adecuado\npara tu ubicación.';

  @override
  String get choose_your_language => 'Elige tu idioma';

  @override
  String get help_project_grow => 'Ayuda a que este proyecto crezca';

  @override
  String get help_project_grow_description => 'Spotube es un proyecto de código abierto. Puedes ayudar a que este proyecto crezca contribuyendo al proyecto, informando errores o sugiriendo nuevas funciones.';

  @override
  String get contribute_on_github => 'Contribuir en GitHub';

  @override
  String get donate_on_open_collective => 'Donar en Open Collective';

  @override
  String get browse_anonymously => 'Navegar Anónimamente';

  @override
  String get enable_connect => 'Habilitar conexión';

  @override
  String get enable_connect_description => 'Controla Spotube desde otros dispositivos';

  @override
  String get devices => 'Dispositivos';

  @override
  String get select => 'Seleccionar';

  @override
  String connect_client_alert(Object client) {
    return 'Estás siendo controlado por $client';
  }

  @override
  String get this_device => 'Este dispositivo';

  @override
  String get remote => 'Remoto';

  @override
  String get stats => 'Estadísticas';

  @override
  String and_n_more(Object count) {
    return 'y $count más';
  }

  @override
  String get recently_played => 'Recién reproducido';

  @override
  String get browse_more => 'Explorar más';

  @override
  String get no_title => 'Sin título';

  @override
  String get not_playing => 'No reproduciendo';

  @override
  String get epic_failure => '¡Fallo épico!';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return 'Se añadieron $tracks_length canciones a la cola';
  }

  @override
  String get spotube_has_an_update => 'Spotube tiene una actualización';

  @override
  String get download_now => 'Descargar ahora';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Spotube Nightly $nightlyBuildNum ha sido lanzado';
  }

  @override
  String release_version(Object version) {
    return 'Spotube v$version ha sido lanzado';
  }

  @override
  String get read_the_latest => 'Lee las últimas ';

  @override
  String get release_notes => 'notas de la versión';

  @override
  String get pick_color_scheme => 'Elige esquema de color';

  @override
  String get save => 'Guardar';

  @override
  String get choose_the_device => 'Elige el dispositivo:';

  @override
  String get multiple_device_connected => 'Hay múltiples dispositivos conectados.\nElige el dispositivo en el que deseas realizar esta acción';

  @override
  String get nothing_found => 'Nada encontrado';

  @override
  String get the_box_is_empty => 'La caja está vacía';

  @override
  String get top_artists => 'Artistas principales';

  @override
  String get top_albums => 'Álbumes principales';

  @override
  String get this_week => 'Esta semana';

  @override
  String get this_month => 'Este mes';

  @override
  String get last_6_months => 'Últimos 6 meses';

  @override
  String get this_year => 'Este año';

  @override
  String get last_2_years => 'Últimos 2 años';

  @override
  String get all_time => 'Todos los tiempos';

  @override
  String powered_by_provider(Object providerName) {
    return 'Impulsado por $providerName';
  }

  @override
  String get email => 'Correo electrónico';

  @override
  String get profile_followers => 'Seguidores';

  @override
  String get birthday => 'Cumpleaños';

  @override
  String get subscription => 'Suscripción';

  @override
  String get not_born => 'No nacido';

  @override
  String get hacker => 'Hacker';

  @override
  String get profile => 'Perfil';

  @override
  String get no_name => 'Sin nombre';

  @override
  String get edit => 'Editar';

  @override
  String get user_profile => 'Perfil de usuario';

  @override
  String count_plays(Object count) {
    return '$count reproducciones';
  }

  @override
  String get streaming_fees_hypothetical => 'Tarifas de streaming (hipotéticas)';

  @override
  String get minutes_listened => 'Minutos escuchados';

  @override
  String get streamed_songs => 'Canciones reproducidas';

  @override
  String count_streams(Object count) {
    return '$count streams';
  }

  @override
  String get owned_by_you => 'En tu posesión';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return 'Copiado $shareUrl al portapapeles';
  }

  @override
  String get spotify_hipotetical_calculation => '*Esto se calcula en base al\npago por stream de Spotify de \$0.003 a \$0.005.\nEs un cálculo hipotético para dar\nuna idea de cuánto habría\npagado a los artistas si hubieras escuchado\nsu canción en Spotify.';

  @override
  String count_mins(Object minutes) {
    return '$minutes minutos';
  }

  @override
  String get summary_minutes => 'minutos';

  @override
  String get summary_listened_to_music => 'Escuchó música';

  @override
  String get summary_songs => 'canciones';

  @override
  String get summary_streamed_overall => 'Transmitido en general';

  @override
  String get summary_owed_to_artists => 'Debido a los artistas\nEste mes';

  @override
  String get summary_artists => 'artistas';

  @override
  String get summary_music_reached_you => 'La música te alcanzó';

  @override
  String get summary_full_albums => 'álbumes completos';

  @override
  String get summary_got_your_love => 'Obtuvo tu amor';

  @override
  String get summary_playlists => 'listas de reproducción';

  @override
  String get summary_were_on_repeat => 'Estaban en repetición';

  @override
  String total_money(Object money) {
    return 'Total $money';
  }

  @override
  String get webview_not_found => 'No se encontró el Webview';

  @override
  String get webview_not_found_description => 'No hay tiempo de ejecución de Webview instalado en su dispositivo.\nSi está instalado, asegúrese de que esté en el environment PATH\n\nDespués de instalar, reinicie la aplicación';

  @override
  String get unsupported_platform => 'Plataforma no soportada';

  @override
  String get cache_music => 'Caché de música';

  @override
  String get open => 'Abrir';

  @override
  String get cache_folder => 'Carpeta de caché';

  @override
  String get export => 'Exportar';

  @override
  String get clear_cache => 'Limpiar caché';

  @override
  String get clear_cache_confirmation => '¿Desea limpiar la caché?';

  @override
  String get export_cache_files => 'Exportar archivos en caché';

  @override
  String found_n_files(Object count) {
    return 'Se encontraron $count archivos';
  }

  @override
  String get export_cache_confirmation => '¿Desea exportar estos archivos a';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return 'Se exportaron $filesExported de $files archivos';
  }

  @override
  String get undo => 'Deshacer';

  @override
  String get download_all => 'Descargar todo';

  @override
  String get add_all_to_playlist => 'Agregar todo a la lista de reproducción';

  @override
  String get add_all_to_queue => 'Agregar todo a la cola';

  @override
  String get play_all_next => 'Reproducir todo a continuación';

  @override
  String get pause => 'Pausa';

  @override
  String get view_all => 'Ver todo';

  @override
  String get no_tracks_added_yet => 'Parece que aún no has agregado ninguna canción.';

  @override
  String get no_tracks => 'Parece que no hay canciones aquí.';

  @override
  String get no_tracks_listened_yet => 'Parece que no has escuchado nada todavía.';

  @override
  String get not_following_artists => 'No sigues a ningún artista.';

  @override
  String get no_favorite_albums_yet => 'Parece que aún no has agregado ningún álbum a tus favoritos.';

  @override
  String get no_logs_found => 'No se encontraron registros';

  @override
  String get youtube_engine => 'Motor de YouTube';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engine no está instalado';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engine no está instalado en tu sistema.';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return 'Asegúrate de que esté disponible en la variable PATH o\nestablece la ruta absoluta del ejecutable de $engine a continuación.';
  }

  @override
  String get youtube_engine_unix_issue_message => 'En macOS/Linux/sistemas operativos similares a Unix, establecer la ruta en .zshrc/.bashrc/.bash_profile etc. no funcionará.\nNecesitas establecer la ruta en el archivo de configuración del shell.';

  @override
  String get download => 'Descargar';

  @override
  String get file_not_found => 'Archivo no encontrado';

  @override
  String get custom => 'Personalizado';

  @override
  String get add_custom_url => 'Agregar URL personalizada';
}
