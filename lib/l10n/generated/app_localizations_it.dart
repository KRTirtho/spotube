// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get guest => 'Ospite';

  @override
  String get browse => 'Sfoglia';

  @override
  String get search => 'Cerca';

  @override
  String get library => 'Libreria';

  @override
  String get lyrics => 'Testi';

  @override
  String get settings => 'Impostazioni';

  @override
  String get genre_categories_filter => 'Filtra categorie e generi...';

  @override
  String get genre => 'Genere';

  @override
  String get personalized => 'Personalizzato';

  @override
  String get featured => 'In evidenza';

  @override
  String get new_releases => 'Novità';

  @override
  String get songs => 'Canzoni';

  @override
  String playing_track(Object track) {
    return 'Riproduzione $track';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return 'Questo cancellerà la coda corrente. $track_length tracce saranno rimosse\nVuoi continuare?';
  }

  @override
  String get load_more => 'Carica altro';

  @override
  String get playlists => 'Playlist';

  @override
  String get artists => 'Artisti';

  @override
  String get albums => 'Album';

  @override
  String get tracks => 'Tracce';

  @override
  String get downloads => 'Downloads';

  @override
  String get filter_playlists => 'Filtra le tue playlist...';

  @override
  String get liked_tracks => 'Tracce piaciute';

  @override
  String get liked_tracks_description => 'Tutte le tracce piaciute';

  @override
  String get playlist => 'Playlist';

  @override
  String get create_a_playlist => 'Crea una playlist';

  @override
  String get update_playlist => 'Aggiorna playlist';

  @override
  String get create => 'Crea';

  @override
  String get cancel => 'Annulla';

  @override
  String get update => 'Aggiorna';

  @override
  String get playlist_name => 'Nome Playlist';

  @override
  String get name_of_playlist => 'Nome della playlist';

  @override
  String get description => 'Descrizione';

  @override
  String get public => 'Pubblico';

  @override
  String get collaborative => 'Collaborativo';

  @override
  String get search_local_tracks => 'Cerca tracce locali...';

  @override
  String get play => 'Riproduci';

  @override
  String get delete => 'Cancella';

  @override
  String get none => 'Nessuno';

  @override
  String get sort_a_z => 'Ordina dalla A-Z';

  @override
  String get sort_z_a => 'Ordina dalla Z-A';

  @override
  String get sort_artist => 'Ordina per Artista';

  @override
  String get sort_album => 'Ordina per Album';

  @override
  String get sort_duration => 'Ordina per Durata';

  @override
  String get sort_tracks => 'Ordina tracce';

  @override
  String currently_downloading(Object tracks_length) {
    return 'Attualmente in Download ($tracks_length)';
  }

  @override
  String get cancel_all => 'Annulla Tutto';

  @override
  String get filter_artist => 'Filtra artisti...';

  @override
  String followers(Object followers) {
    return '$followers Seguaci';
  }

  @override
  String get add_artist_to_blacklist => 'Aggiungi artista alla lista nera';

  @override
  String get top_tracks => 'Tracce Top';

  @override
  String get fans_also_like => 'Ai fan piace anche';

  @override
  String get loading => 'Caricamento...';

  @override
  String get artist => 'Artista';

  @override
  String get blacklisted => 'In lista nera';

  @override
  String get following => 'Seguendo';

  @override
  String get follow => 'Segui';

  @override
  String get artist_url_copied => 'URL artista copiato negli appunti';

  @override
  String added_to_queue(Object tracks) {
    return 'Aggiunto $tracks tracce alla coda';
  }

  @override
  String get filter_albums => 'Filtra album...';

  @override
  String get synced => 'Sincronizzato';

  @override
  String get plain => 'Semplice';

  @override
  String get shuffle => 'Casuale';

  @override
  String get search_tracks => 'Cerca tracce...';

  @override
  String get released => 'Rilasciato';

  @override
  String error(Object error) {
    return 'Errore $error';
  }

  @override
  String get title => 'Titolo';

  @override
  String get time => 'Durata';

  @override
  String get more_actions => 'Più azioni';

  @override
  String download_count(Object count) {
    return 'Scaricato ($count)';
  }

  @override
  String add_count_to_playlist(Object count) {
    return 'Aggiungi ($count) alla playlist';
  }

  @override
  String add_count_to_queue(Object count) {
    return 'Aggiungi ($count) alla Coda';
  }

  @override
  String play_count_next(Object count) {
    return 'Riproduci ($count) prossime';
  }

  @override
  String get album => 'Album';

  @override
  String copied_to_clipboard(Object data) {
    return 'Copiato $data negli appunti';
  }

  @override
  String add_to_following_playlists(Object track) {
    return 'Aggiungi $track nelle seguenti Playlist';
  }

  @override
  String get add => 'Aggiungi';

  @override
  String added_track_to_queue(Object track) {
    return 'Aggiunto $track alla coda';
  }

  @override
  String get add_to_queue => 'Aggiungi alla coda';

  @override
  String track_will_play_next(Object track) {
    return 'in seguito sarà riprodotta $track';
  }

  @override
  String get play_next => 'Riproduci prossimo';

  @override
  String removed_track_from_queue(Object track) {
    return 'Rimosso $track dalla coda';
  }

  @override
  String get remove_from_queue => 'Rimuovi dalla coda';

  @override
  String get remove_from_favorites => 'Rimuovi dai preferiti';

  @override
  String get save_as_favorite => 'Salva come preferito';

  @override
  String get add_to_playlist => 'Aggiungi alla playlist';

  @override
  String get remove_from_playlist => 'Rimuovi dalla playlist';

  @override
  String get add_to_blacklist => 'Aggiungi alla blacklist';

  @override
  String get remove_from_blacklist => 'Rimuovi dalla blacklist';

  @override
  String get share => 'Condividi';

  @override
  String get mini_player => 'Mini Riproduttore';

  @override
  String get slide_to_seek => 'Scorri per cercare avanti o indietro';

  @override
  String get shuffle_playlist => 'Playlist casuale';

  @override
  String get unshuffle_playlist => 'Ordina playlist';

  @override
  String get previous_track => 'Traccia precedente';

  @override
  String get next_track => 'Traccia successiva';

  @override
  String get pause_playback => 'Pausa Playback';

  @override
  String get resume_playback => 'Riprendi Playback';

  @override
  String get loop_track => 'Cicla traccia';

  @override
  String get no_loop => 'Nessun ciclo';

  @override
  String get repeat_playlist => 'Ripeti playlist';

  @override
  String get queue => 'Coda';

  @override
  String get alternative_track_sources => 'Sorgenti traccia alternative';

  @override
  String get download_track => 'Scarica traccia';

  @override
  String tracks_in_queue(Object tracks) {
    return '$tracks tracce in coda';
  }

  @override
  String get clear_all => 'Cancella tutto';

  @override
  String get show_hide_ui_on_hover => 'Mostra/Nascondi UI al passaggio';

  @override
  String get always_on_top => 'Sempre in cima';

  @override
  String get exit_mini_player => 'Esci da Mini player';

  @override
  String get download_location => 'Cartella di scarico';

  @override
  String get local_library => 'Biblioteca locale';

  @override
  String get add_library_location => 'Aggiungi alla biblioteca';

  @override
  String get remove_library_location => 'Rimuovi dalla biblioteca';

  @override
  String get account => 'Account';

  @override
  String get logout => 'Esci';

  @override
  String get logout_of_this_account => 'Esci da questo account';

  @override
  String get language_region => 'Lingua & Regione';

  @override
  String get language => 'Lingua';

  @override
  String get system_default => 'Default sistema';

  @override
  String get market_place_region => 'Regione del mercato';

  @override
  String get recommendation_country => 'Paese Raccomandato';

  @override
  String get appearance => 'Aspetto';

  @override
  String get layout_mode => 'Modalità Layout';

  @override
  String get override_layout_settings =>
      'Sovrascrivi le impostazioni del layout responsivo';

  @override
  String get adaptive => 'Adattiva';

  @override
  String get compact => 'Compatta';

  @override
  String get extended => 'Estesa';

  @override
  String get theme => 'Tema';

  @override
  String get dark => 'Scuro';

  @override
  String get light => 'Chiaro';

  @override
  String get system => 'Sistema';

  @override
  String get accent_color => 'Colore accento';

  @override
  String get sync_album_color => 'Syncronizza colore album';

  @override
  String get sync_album_color_description =>
      'Usa il colore dominante della copertina dell\'album come colore accento';

  @override
  String get playback => 'Riproduzione';

  @override
  String get audio_quality => 'Qualità Audio';

  @override
  String get high => 'Alta';

  @override
  String get low => 'Bassa';

  @override
  String get pre_download_play => 'Pre-scarica e riproduci';

  @override
  String get pre_download_play_description =>
      'Anzi che effettuare lo stream dell\'audio, scarica invece i byte e li riproduce (raccomandato per gli utenti con banda più alta)';

  @override
  String get skip_non_music => 'Salta i segmenti non di musica (SponsorBlock)';

  @override
  String get blacklist_description => 'Tracce e artisti in blacklist';

  @override
  String get wait_for_download_to_finish =>
      'Prego attendere che lo scaricamento corrente finisca';

  @override
  String get desktop => 'Desktop';

  @override
  String get close_behavior => 'Comportamento Chiusura';

  @override
  String get close => 'Chiudi';

  @override
  String get minimize_to_tray => 'Minimizza in tray';

  @override
  String get show_tray_icon => 'Mostra icona in tray di sistema';

  @override
  String get about => 'A proposito di';

  @override
  String get u_love_spotube => 'Sappiamo che ami Spotube';

  @override
  String get check_for_updates => 'Controlla aggiornamenti';

  @override
  String get about_spotube => 'A proposito di Spotube';

  @override
  String get blacklist => 'Blacklist';

  @override
  String get please_sponsor => 'Per favore sponsorizza/dona';

  @override
  String get spotube_description =>
      'Spotube, un client spotify gratis per tutti, multipiattaforma e leggero';

  @override
  String get version => 'Versione';

  @override
  String get build_number => 'Numero Build';

  @override
  String get founder => 'Fondatore';

  @override
  String get repository => 'Repository';

  @override
  String get bug_issues => 'Bug+Problemi';

  @override
  String get made_with => 'Fatto con ❤️ in Bangladesh🇧🇩';

  @override
  String get kingkor_roy_tirtho => 'Kingkor Roy Tirtho';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year Kingkor Roy Tirtho';
  }

  @override
  String get license => 'Licenza';

  @override
  String get credentials_will_not_be_shared_disclaimer =>
      'Non ti preoccupare, le tue credenziali non saranno inviate o condivise con nessuno';

  @override
  String get know_how_to_login => 'Non sai come farlo?';

  @override
  String get follow_step_by_step_guide => 'Segui la guida passo-passo';

  @override
  String cookie_name_cookie(Object name) {
    return 'Cookie $name';
  }

  @override
  String get fill_in_all_fields => 'Inserire tutti i campi';

  @override
  String get submit => 'Invia';

  @override
  String get exit => 'Esci';

  @override
  String get previous => 'Precedente';

  @override
  String get next => 'Prossimo';

  @override
  String get done => 'Finito';

  @override
  String get step_1 => 'Passo 1';

  @override
  String get first_go_to => 'Prim, vai a';

  @override
  String get something_went_wrong => 'Qualcosa è andato storto';

  @override
  String get piped_instance => 'Istanza Server Piped';

  @override
  String get piped_description =>
      'L\'istanza server Piped da usare per il match della tracccia';

  @override
  String get piped_warning =>
      'Alcune di queste non funzioneranno benen. Usa quindi a tuo rischio';

  @override
  String get invidious_instance => 'Istanza del server Invidious';

  @override
  String get invidious_description =>
      'L\'istanza del server Invidious da utilizzare per il matching delle tracce';

  @override
  String get invidious_warning =>
      'Alcuni potrebbero non funzionare bene. Usali a tuo rischio';

  @override
  String get generate => 'Genera';

  @override
  String track_exists(Object track) {
    return 'La traccia $track esiste già';
  }

  @override
  String get replace_downloaded_tracks =>
      'Sostituisci tutte le tracce scaricate';

  @override
  String get skip_download_tracks =>
      'Salta lo scaricamento di tutte le tracce scaricate';

  @override
  String get do_you_want_to_replace =>
      'Vuoi sovrascrivere la traccia esistente??';

  @override
  String get replace => 'Sovrascrivi';

  @override
  String get skip => 'Salta';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return 'Seleziona fino a $count $type';
  }

  @override
  String get select_genres => 'Seleziona Generi';

  @override
  String get add_genres => 'Aggiungi Generi';

  @override
  String get country => 'Paese';

  @override
  String get number_of_tracks_generate => 'Nnumero di tracce da generare';

  @override
  String get acousticness => 'Acustica';

  @override
  String get danceability => 'Ballabilità';

  @override
  String get energy => 'Energia';

  @override
  String get instrumentalness => 'Strumentalità';

  @override
  String get liveness => 'Vitalità';

  @override
  String get loudness => 'Sonorità';

  @override
  String get speechiness => 'Loquacità';

  @override
  String get valence => 'Valenza';

  @override
  String get popularity => 'Popolarità';

  @override
  String get key => 'Chiave';

  @override
  String get duration => 'Durata (s)';

  @override
  String get tempo => 'Tempo (BPM)';

  @override
  String get mode => 'Modo';

  @override
  String get time_signature => 'Indicazione di tempo';

  @override
  String get short => 'Corta';

  @override
  String get medium => 'Media';

  @override
  String get long => 'Lunga';

  @override
  String get min => 'Min';

  @override
  String get max => 'Max';

  @override
  String get target => 'Obiettivo';

  @override
  String get moderate => 'Moderato';

  @override
  String get deselect_all => 'Deseleziona Tutto';

  @override
  String get select_all => 'Seleziona Tutto';

  @override
  String get are_you_sure => 'Sei certo?';

  @override
  String get generating_playlist => 'Generazione delle tue playlist custom...';

  @override
  String selected_count_tracks(Object count) {
    return '$count tracce selezionate';
  }

  @override
  String get download_warning =>
      'Se scarichi tutte le Tracce in massa stai chiaramente piratando Musica e causando un danno alla società creativa della Musica. Spero che tu sia cosciente di questo. Cerca di rispettare e supportare sempre il duro lavoro degli Artisti';

  @override
  String get download_ip_ban_warning =>
      'A proposito, il tuo IP può essere bloccato da YouTube per il numero di richieste di download eccessive rispetto la norma. Il blocco IP significa che non puoi usare YoutTube (anche hai effettuato l\'accesso) per almeno 2-3 mesi dal dispositivo con questo IP. Spotube non ha responsabilità se questo dovesse accadere';

  @override
  String get by_clicking_accept_terms =>
      'Cliccando su \'accetta\' concordi con i seguenti termini:';

  @override
  String get download_agreement_1 =>
      'So che sto piratando Musica. Sono cattivo';

  @override
  String get download_agreement_2 =>
      'Supporterò l\'Artista come potrò e sto facendo questo solo perchè non ho denaro per acquistare il suo prodotto dell\'ingegno';

  @override
  String get download_agreement_3 =>
      'Sono completamente cosciente che il mio IP può essere bloccato da YouTube & non riterrò responsabili Spotube o i suoi autori/contributori per ogni inconveniente causato dalla mia azione corrente';

  @override
  String get decline => 'Declino';

  @override
  String get accept => 'Accetto';

  @override
  String get details => 'Dettagli';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => 'Canale';

  @override
  String get likes => 'Mi Piace';

  @override
  String get dislikes => 'Non Mi Piace';

  @override
  String get views => 'Viste';

  @override
  String get streamUrl => 'URL dello streaming';

  @override
  String get stop => 'Stop';

  @override
  String get sort_newest => 'Ordina per nuovi aggiunti';

  @override
  String get sort_oldest => 'Ordina per aggiunta più vecchia';

  @override
  String get sleep_timer => 'Timer Dormire';

  @override
  String mins(Object minutes) {
    return '$minutes Minuti';
  }

  @override
  String hours(Object hours) {
    return '$hours Ore';
  }

  @override
  String hour(Object hours) {
    return '$hours Ora';
  }

  @override
  String get custom_hours => 'Orari Personalizzati';

  @override
  String get logs => 'Log';

  @override
  String get developers => 'Sviluppatori';

  @override
  String get not_logged_in => 'Non hai effettuato l\'accesso';

  @override
  String get search_mode => 'Modalità Ricerca';

  @override
  String get audio_source => 'Fonte audio';

  @override
  String get ok => 'Ok';

  @override
  String get failed_to_encrypt => 'Criptazione fallita';

  @override
  String get encryption_failed_warning =>
      'Spotube usa la criptazione per memorizzare in modo sicuro i dati. Ma ha fallito a farlo. Passerà quindi in ripiego alla memorizzazione non siscura\nSe stai usando Linux assicurati di avere un servizio di segretezza installato (gnome-keyring, kde-wallet, keepassxc etc)';

  @override
  String get querying_info => 'Richiesta informazioni...';

  @override
  String get piped_api_down => 'Le Piped API non funzionano';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return 'L\'istanza di Piped $pipedInstance è correntemente offline\n\nCambia istanza o cambia \'Tipo API\' alle API ufficiali YouTube\n\nAssicurati di riavviare l\'app dopo il cambio';
  }

  @override
  String get you_are_offline => 'Sei correntemente offline';

  @override
  String get connection_restored => 'Connessione ad internet ripristinata';

  @override
  String get use_system_title_bar => 'Usa la barra del titolo di sistema';

  @override
  String get crunching_results => 'Elaborazione risultati...';

  @override
  String get search_to_get_results => 'Cerca per ottenere risultati';

  @override
  String get use_amoled_mode => 'Usa modalità AMOLED';

  @override
  String get pitch_dark_theme => 'Tema nero profondo';

  @override
  String get normalize_audio => 'Normalizza audio';

  @override
  String get change_cover => 'Cambia copertina';

  @override
  String get add_cover => 'Aggiungi copertina';

  @override
  String get restore_defaults => 'Ripristina default';

  @override
  String get download_music_format => 'Formato download musica';

  @override
  String get streaming_music_format => 'Formato streaming musica';

  @override
  String get download_music_quality => 'Qualità download musica';

  @override
  String get streaming_music_quality => 'Qualità streaming musica';

  @override
  String get login_with_lastfm => 'Accesso a Last.fm';

  @override
  String get connect => 'Connetti';

  @override
  String get disconnect_lastfm => 'Disconnetti Last.fm';

  @override
  String get disconnect => 'Disconnetti';

  @override
  String get username => 'Nome utente';

  @override
  String get password => 'Password';

  @override
  String get login => 'Accesso';

  @override
  String get login_with_your_lastfm => 'Accedi con il tuo account Last.fm';

  @override
  String get scrobble_to_lastfm => 'Invia a Last.fm';

  @override
  String get go_to_album => 'Vai all\'album';

  @override
  String get discord_rich_presence => 'Presenza ricca di Discord';

  @override
  String get browse_all => 'Esplora tutto';

  @override
  String get genres => 'Generi';

  @override
  String get explore_genres => 'Esplora generi';

  @override
  String get friends => 'Amici';

  @override
  String get no_lyrics_available =>
      'Spiacente, impossibile trovare il testo di questa traccia';

  @override
  String get start_a_radio => 'Avvia una Radio';

  @override
  String get how_to_start_radio => 'Come vuoi avviare la radio?';

  @override
  String get replace_queue_question =>
      'Vuoi sostituire la coda attuale o aggiungerla?';

  @override
  String get endless_playback => 'Riproduzione Infinita';

  @override
  String get delete_playlist => 'Elimina Playlist';

  @override
  String get delete_playlist_confirmation =>
      'Sei sicuro di voler eliminare questa playlist?';

  @override
  String get local_tracks => 'Tracce Locali';

  @override
  String get local_tab => 'Locale';

  @override
  String get song_link => 'Link della Canzone';

  @override
  String get skip_this_nonsense => 'Salta questa sciocchezza';

  @override
  String get freedom_of_music => '“Libertà della Musica”';

  @override
  String get freedom_of_music_palm =>
      '“Libertà della Musica nel palmo della tua mano”';

  @override
  String get get_started => 'Cominciamo';

  @override
  String get youtube_source_description => 'Consigliato e funziona meglio.';

  @override
  String get piped_source_description =>
      'Ti senti libero? Come YouTube ma molto più gratuito.';

  @override
  String get jiosaavn_source_description =>
      'Il migliore per la regione dell\'Asia meridionale.';

  @override
  String get invidious_source_description =>
      'Simile a Piped ma con maggiore disponibilità.';

  @override
  String highest_quality(Object quality) {
    return 'Massima Qualità: $quality';
  }

  @override
  String get select_audio_source => 'Seleziona Sorgente Audio';

  @override
  String get endless_playback_description =>
      'Aggiungi automaticamente nuove canzoni alla fine della coda';

  @override
  String get choose_your_region => 'Scegli la tua regione';

  @override
  String get choose_your_region_description =>
      'Questo aiuterà Spotube a mostrarti il contenuto giusto per la tua posizione.';

  @override
  String get choose_your_language => 'Scegli la tua lingua';

  @override
  String get help_project_grow => 'Aiuta questo progetto a crescere';

  @override
  String get help_project_grow_description =>
      'Spotube è un progetto open-source. Puoi aiutare questo progetto a crescere contribuendo al progetto, segnalando bug o suggerendo nuove funzionalità.';

  @override
  String get contribute_on_github => 'Contribuisci su GitHub';

  @override
  String get donate_on_open_collective => 'Dona su Open Collective';

  @override
  String get browse_anonymously => 'Naviga in modo anonimo';

  @override
  String get enable_connect => 'Abilita connessione';

  @override
  String get enable_connect_description =>
      'Controlla Spotube da altri dispositivi';

  @override
  String get devices => 'Dispositivi';

  @override
  String get select => 'Seleziona';

  @override
  String connect_client_alert(Object client) {
    return 'Stai venendo controllato da $client';
  }

  @override
  String get this_device => 'Questo dispositivo';

  @override
  String get remote => 'Remoto';

  @override
  String get stats => 'Statistiche';

  @override
  String and_n_more(Object count) {
    return 'e $count in più';
  }

  @override
  String get recently_played => 'Riprodotti di recente';

  @override
  String get browse_more => 'Esplora di più';

  @override
  String get no_title => 'Nessun titolo';

  @override
  String get not_playing => 'Non in riproduzione';

  @override
  String get epic_failure => 'Fallimento epico!';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return 'Aggiunti $tracks_length brani alla coda';
  }

  @override
  String get spotube_has_an_update => 'Spotube ha un aggiornamento';

  @override
  String get download_now => 'Scarica ora';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Spotube Nightly $nightlyBuildNum è stato rilasciato';
  }

  @override
  String release_version(Object version) {
    return 'Spotube v$version è stato rilasciato';
  }

  @override
  String get read_the_latest => 'Leggi l\'ultimo ';

  @override
  String get release_notes => 'note di rilascio';

  @override
  String get pick_color_scheme => 'Scegli uno schema di colori';

  @override
  String get save => 'Salva';

  @override
  String get choose_the_device => 'Scegli il dispositivo:';

  @override
  String get multiple_device_connected =>
      'Sono collegati più dispositivi.\nScegli il dispositivo su cui vuoi che venga eseguita questa azione';

  @override
  String get nothing_found => 'Nessun risultato';

  @override
  String get the_box_is_empty => 'La scatola è vuota';

  @override
  String get top_artists => 'Artisti Top';

  @override
  String get top_albums => 'Album Top';

  @override
  String get this_week => 'Questa settimana';

  @override
  String get this_month => 'Questo mese';

  @override
  String get last_6_months => 'Ultimi 6 mesi';

  @override
  String get this_year => 'Quest\'anno';

  @override
  String get last_2_years => 'Ultimi 2 anni';

  @override
  String get all_time => 'Di tutti i tempi';

  @override
  String powered_by_provider(Object providerName) {
    return 'Sostenuto da $providerName';
  }

  @override
  String get email => 'Email';

  @override
  String get profile_followers => 'Follower';

  @override
  String get birthday => 'Compleanno';

  @override
  String get subscription => 'Abbonamento';

  @override
  String get not_born => 'Non nato';

  @override
  String get hacker => 'Hacker';

  @override
  String get profile => 'Profilo';

  @override
  String get no_name => 'Nessun nome';

  @override
  String get edit => 'Modifica';

  @override
  String get user_profile => 'Profilo utente';

  @override
  String count_plays(Object count) {
    return '$count riproduzioni';
  }

  @override
  String get streaming_fees_hypothetical => 'Spese di streaming (ipotetico)';

  @override
  String get minutes_listened => 'Minuti ascoltati';

  @override
  String get streamed_songs => 'Brani in streaming';

  @override
  String count_streams(Object count) {
    return '$count streaming';
  }

  @override
  String get owned_by_you => 'Di tua proprietà';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return 'Copiato $shareUrl negli appunti';
  }

  @override
  String get hipotetical_calculation =>
      '*Questo è calcolato in base al pagamento medio per stream delle piattaforme di streaming musicale online, che va da \$0.003 a \$0.005. Si tratta di un calcolo ipotetico per dare all\'utente un\'idea di quanto avrebbe pagato agli artisti se avesse ascoltato la loro canzone su diverse piattaforme di streaming musicale.';

  @override
  String count_mins(Object minutes) {
    return '$minutes min';
  }

  @override
  String get summary_minutes => 'minuti';

  @override
  String get summary_listened_to_music => 'Musica ascoltata';

  @override
  String get summary_songs => 'brani';

  @override
  String get summary_streamed_overall => 'Streaming complessivo';

  @override
  String get summary_owed_to_artists => 'Dovuto agli artisti\nquesto mese';

  @override
  String get summary_artists => 'dell\'artista';

  @override
  String get summary_music_reached_you => 'La musica ti ha raggiunto';

  @override
  String get summary_full_albums => 'album completi';

  @override
  String get summary_got_your_love => 'Ha ricevuto il tuo amore';

  @override
  String get summary_playlists => 'playlist';

  @override
  String get summary_were_on_repeat => 'Erano in ripetizione';

  @override
  String total_money(Object money) {
    return 'Totale $money';
  }

  @override
  String get webview_not_found => 'Webview non trovato';

  @override
  String get webview_not_found_description =>
      'Nessun runtime Webview installato nel tuo dispositivo.\nSe è installato, assicurati che sia nel environment PATH\n\nDopo l\'installazione, riavvia l\'app';

  @override
  String get unsupported_platform => 'Piattaforma non supportata';

  @override
  String get cache_music => 'Cache musica';

  @override
  String get open => 'Apri';

  @override
  String get cache_folder => 'Cartella cache';

  @override
  String get export => 'Esporta';

  @override
  String get clear_cache => 'Cancella cache';

  @override
  String get clear_cache_confirmation => 'Vuoi cancellare la cache?';

  @override
  String get export_cache_files => 'Esporta file nella cache';

  @override
  String found_n_files(Object count) {
    return 'Trovati $count file';
  }

  @override
  String get export_cache_confirmation => 'Vuoi esportare questi file su';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return 'Esportati $filesExported su $files file';
  }

  @override
  String get undo => 'Annulla';

  @override
  String get download_all => 'Scarica tutto';

  @override
  String get add_all_to_playlist => 'Aggiungi tutto alla playlist';

  @override
  String get add_all_to_queue => 'Aggiungi tutto alla coda';

  @override
  String get play_all_next => 'Riproduci tutto dopo';

  @override
  String get pause => 'Pausa';

  @override
  String get view_all => 'Vedi tutto';

  @override
  String get no_tracks_added_yet =>
      'Sembra che non hai ancora aggiunto nessun brano';

  @override
  String get no_tracks => 'Sembra che non ci siano brani qui';

  @override
  String get no_tracks_listened_yet =>
      'Sembra che non hai ascoltato nulla ancora';

  @override
  String get not_following_artists => 'Non stai seguendo alcun artista';

  @override
  String get no_favorite_albums_yet =>
      'Sembra che non hai ancora aggiunto album ai tuoi preferiti';

  @override
  String get no_logs_found => 'Nessun registro trovato';

  @override
  String get youtube_engine => 'Motore YouTube';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engine non è installato';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engine non è installato nel tuo sistema.';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return 'Assicurati che sia disponibile nella variabile PATH o\nimposta il percorso assoluto all\'eseguibile $engine qui sotto';
  }

  @override
  String get youtube_engine_unix_issue_message =>
      'In macOS/Linux/os simili a unix, impostare il percorso su .zshrc/.bashrc/.bash_profile ecc. non funzionerà.\nDevi impostare il percorso nel file di configurazione della shell';

  @override
  String get download => 'Scarica';

  @override
  String get file_not_found => 'File non trovato';

  @override
  String get custom => 'Personalizzato';

  @override
  String get add_custom_url => 'Aggiungi URL personalizzato';

  @override
  String get edit_port => 'Modifica porta';

  @override
  String get port_helper_msg =>
      'Il valore predefinito è -1, che indica un numero casuale. Se hai configurato un firewall, si consiglia di impostarlo.';

  @override
  String connect_request(Object client) {
    return 'Consentire a $client di connettersi?';
  }

  @override
  String get connection_request_denied =>
      'Connessione negata. L\'utente ha negato l\'accesso.';

  @override
  String get an_error_occurred => 'Si è verificato un errore';

  @override
  String get copy_to_clipboard => 'Copia negli appunti';

  @override
  String get view_logs => 'Visualizza log';

  @override
  String get retry => 'Riprova';

  @override
  String get no_default_metadata_provider_selected =>
      'Non hai impostato alcun provider di metadati predefinito';

  @override
  String get manage_metadata_providers => 'Gestisci provider di metadati';

  @override
  String get open_link_in_browser => 'Aprire il link nel browser?';

  @override
  String get do_you_want_to_open_the_following_link =>
      'Vuoi aprire il seguente link';

  @override
  String get unsafe_url_warning =>
      'Potrebbe essere pericoloso aprire link da fonti non attendibili. Sii cauto!\nPuoi anche copiare il link negli appunti.';

  @override
  String get copy_link => 'Copia link';

  @override
  String get building_your_timeline =>
      'Creazione della tua cronologia in base ai tuoi ascolti...';

  @override
  String get official => 'Ufficiale';

  @override
  String author_name(Object author) {
    return 'Autore: $author';
  }

  @override
  String get third_party => 'Terze parti';

  @override
  String get plugin_requires_authentication =>
      'Il plugin richiede l\'autenticazione';

  @override
  String get update_available => 'Aggiornamento disponibile';

  @override
  String get supports_scrobbling => 'Supporta lo scrobbling';

  @override
  String get plugin_scrobbling_info =>
      'Questo plugin scrobbla la tua musica per generare la tua cronologia di ascolti.';

  @override
  String get default_metadata_source => 'Fonte metadati predefinita';

  @override
  String get set_default_metadata_source =>
      'Imposta fonte metadati predefinita';

  @override
  String get default_audio_source => 'Fonte audio predefinita';

  @override
  String get set_default_audio_source => 'Imposta fonte audio predefinita';

  @override
  String get set_default => 'Imposta come predefinito';

  @override
  String get support => 'Supporto';

  @override
  String get support_plugin_development => 'Sostieni lo sviluppo del plugin';

  @override
  String can_access_name_api(Object name) {
    return '- Può accedere all\'API **$name**';
  }

  @override
  String get do_you_want_to_install_this_plugin =>
      'Vuoi installare questo plugin?';

  @override
  String get third_party_plugin_warning =>
      'Questo plugin proviene da un repository di terze parti. Assicurati di fidarti della fonte prima di installarlo.';

  @override
  String get author => 'Autore';

  @override
  String get this_plugin_can_do_following =>
      'Questo plugin può fare quanto segue';

  @override
  String get install => 'Installa';

  @override
  String get install_a_metadata_provider => 'Installa un provider di metadati';

  @override
  String get no_tracks_playing => 'Nessun brano in riproduzione al momento';

  @override
  String get synced_lyrics_not_available =>
      'Testi sincronizzati non disponibili per questa canzone. Si prega di utilizzare la scheda';

  @override
  String get plain_lyrics => 'Testi semplici';

  @override
  String get tab_instead => 'invece.';

  @override
  String get disclaimer => 'Disclaimer';

  @override
  String get third_party_plugin_dmca_notice =>
      'Il team di Spotube non si assume alcuna responsabilità (anche legale) per i plugin di \"terze parti\".\nUsali a tuo rischio e pericolo. Per eventuali bug/problemi, segnalali al repository del plugin.\n\nSe un plugin di \"terze parti\" sta violando i ToS/DMCA di un servizio/entità legale, per favore chiedi all\'autore del plugin \"terzo\" o alla piattaforma di hosting, ad esempio GitHub/Codeberg, di agire. Quelli elencati sopra (etichettati come \"terze parti\") sono tutti plugin pubblici/mantenuti dalla comunità. Non li curiamo, quindi non possiamo intraprendere alcuna azione su di essi.\n\n';

  @override
  String get input_does_not_match_format =>
      'L\'input non corrisponde al formato richiesto';

  @override
  String get plugins => 'Plugin';

  @override
  String get paste_plugin_download_url =>
      'Incolla l\'URL di download o l\'URL del repository GitHub/Codeberg o il link diretto al file .smplug';

  @override
  String get download_and_install_plugin_from_url =>
      'Scarica e installa il plugin da URL';

  @override
  String failed_to_add_plugin_error(Object error) {
    return 'Impossibile aggiungere il plugin: $error';
  }

  @override
  String get upload_plugin_from_file => 'Carica plugin da file';

  @override
  String get installed => 'Installato';

  @override
  String get available_plugins => 'Plugin disponibili';

  @override
  String get configure_plugins =>
      'Configura i tuoi plugin per fornitore metadati e fonte audio';

  @override
  String get audio_scrobblers => 'Scrobbler audio';

  @override
  String get scrobbling => 'Scrobbling';

  @override
  String get source => 'Fonte: ';

  @override
  String get uncompressed => 'Non compresso';

  @override
  String get dab_music_source_description =>
      'Per audiophile. Fornisce flussi audio di alta qualità/senza perdita. Abbinamento traccia accurato basato su ISRC.';
}
