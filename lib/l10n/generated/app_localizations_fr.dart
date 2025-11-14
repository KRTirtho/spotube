// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get guest => 'Invité';

  @override
  String get browse => 'Explorer';

  @override
  String get search => 'Rechercher';

  @override
  String get library => 'Bibliothèque';

  @override
  String get lyrics => 'Paroles';

  @override
  String get settings => 'Paramètres';

  @override
  String get genre_categories_filter =>
      'Filtrer les catégories ou les genres...';

  @override
  String get genre => 'Genre';

  @override
  String get personalized => 'Personnalisé';

  @override
  String get featured => 'En vedette';

  @override
  String get new_releases => 'Nouvelles sorties';

  @override
  String get songs => 'Chansons';

  @override
  String playing_track(Object track) {
    return 'Lecture de $track';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return 'Cela effacera la file d\'attente actuelle. $track_length pistes seront supprimées\nVoulez-vous continuer?';
  }

  @override
  String get load_more => 'Charger plus';

  @override
  String get playlists => 'Listes de lecture';

  @override
  String get artists => 'Artistes';

  @override
  String get albums => 'Albums';

  @override
  String get tracks => 'Pistes';

  @override
  String get downloads => 'Téléchargements';

  @override
  String get filter_playlists => 'Filtrer vos listes de lecture...';

  @override
  String get liked_tracks => 'Pistes aimées';

  @override
  String get liked_tracks_description => 'Toutes vos pistes aimées';

  @override
  String get playlist => 'Playlist';

  @override
  String get create_a_playlist => 'Créer une liste de lecture';

  @override
  String get update_playlist => 'Mettre à jour la playlist';

  @override
  String get create => 'Créer';

  @override
  String get cancel => 'Annuler';

  @override
  String get update => 'Mettre à jour';

  @override
  String get playlist_name => 'Nom de la liste de lecture';

  @override
  String get name_of_playlist => 'Nom de la liste de lecture';

  @override
  String get description => 'Description';

  @override
  String get public => 'Public';

  @override
  String get collaborative => 'Collaborative';

  @override
  String get search_local_tracks => 'Rechercher des pistes locales...';

  @override
  String get play => 'Lecture';

  @override
  String get delete => 'Supprimer';

  @override
  String get none => 'Aucun';

  @override
  String get sort_a_z => 'Trier par ordre alphabétique';

  @override
  String get sort_z_a => 'Trier par ordre alphabétique inverse';

  @override
  String get sort_artist => 'Trier par artiste';

  @override
  String get sort_album => 'Trier par album';

  @override
  String get sort_duration => 'Trier par durée';

  @override
  String get sort_tracks => 'Trier les pistes';

  @override
  String currently_downloading(Object tracks_length) {
    return 'Téléchargement en cours ($tracks_length)';
  }

  @override
  String get cancel_all => 'Tout annuler';

  @override
  String get filter_artist => 'Filtrer les artistes...';

  @override
  String followers(Object followers) {
    return '$followers abonnés';
  }

  @override
  String get add_artist_to_blacklist => 'Ajouter l\'artiste à la liste noire';

  @override
  String get top_tracks => 'Meilleures pistes';

  @override
  String get fans_also_like => 'Les fans aiment aussi';

  @override
  String get loading => 'Chargement...';

  @override
  String get artist => 'Artiste';

  @override
  String get blacklisted => 'Liste noire';

  @override
  String get following => 'Abonné';

  @override
  String get follow => 'S\'abonner';

  @override
  String get artist_url_copied =>
      'URL de l\'artiste copiée dans le presse-papiers';

  @override
  String added_to_queue(Object tracks) {
    return '$tracks pistes ajoutées à la file d\'attente';
  }

  @override
  String get filter_albums => 'Filtrer les albums...';

  @override
  String get synced => 'Synchronisé';

  @override
  String get plain => 'Simple';

  @override
  String get shuffle => 'Lecture aléatoire';

  @override
  String get search_tracks => 'Rechercher des pistes...';

  @override
  String get released => 'Sorti';

  @override
  String error(Object error) {
    return 'Erreur $error';
  }

  @override
  String get title => 'Titre';

  @override
  String get time => 'Durée';

  @override
  String get more_actions => 'Plus d\'actions';

  @override
  String download_count(Object count) {
    return 'Téléchargement ($count)';
  }

  @override
  String add_count_to_playlist(Object count) {
    return 'Ajouter ($count) à la liste de lecture';
  }

  @override
  String add_count_to_queue(Object count) {
    return 'Ajouter ($count) à la file d\'attente';
  }

  @override
  String play_count_next(Object count) {
    return 'Lire ($count) ensuite';
  }

  @override
  String get album => 'Album';

  @override
  String copied_to_clipboard(Object data) {
    return '$data copié dans le presse-papiers';
  }

  @override
  String add_to_following_playlists(Object track) {
    return 'Ajouter $track aux listes de lecture suivantes';
  }

  @override
  String get add => 'Ajouter';

  @override
  String added_track_to_queue(Object track) {
    return '$track ajouté à la file d\'attente';
  }

  @override
  String get add_to_queue => 'Ajouter à la file d\'attente';

  @override
  String track_will_play_next(Object track) {
    return '$track sera joué ensuite';
  }

  @override
  String get play_next => 'Lire ensuite';

  @override
  String removed_track_from_queue(Object track) {
    return '$track retiré de la file d\'attente';
  }

  @override
  String get remove_from_queue => 'Retirer de la file d\'attente';

  @override
  String get remove_from_favorites => 'Retirer des favoris';

  @override
  String get save_as_favorite => 'Enregistrer comme favori';

  @override
  String get add_to_playlist => 'Ajouter à la liste de lecture';

  @override
  String get remove_from_playlist => 'Retirer de la liste de lecture';

  @override
  String get add_to_blacklist => 'Ajouter à la liste noire';

  @override
  String get remove_from_blacklist => 'Retirer de la liste noire';

  @override
  String get share => 'Partager';

  @override
  String get mini_player => 'Lecteur mini';

  @override
  String get slide_to_seek => 'Faites glisser pour avancer ou reculer';

  @override
  String get shuffle_playlist => 'Lecture aléatoire de la liste de lecture';

  @override
  String get unshuffle_playlist =>
      'Annuler la lecture aléatoire de la liste de lecture';

  @override
  String get previous_track => 'Piste précédente';

  @override
  String get next_track => 'Piste suivante';

  @override
  String get pause_playback => 'Mettre en pause la lecture';

  @override
  String get resume_playback => 'Reprendre la lecture';

  @override
  String get loop_track => 'Lecture en boucle de la piste';

  @override
  String get no_loop => 'Pas de boucle';

  @override
  String get repeat_playlist => 'Répéter la liste de lecture';

  @override
  String get queue => 'File d\'attente';

  @override
  String get alternative_track_sources => 'Sources alternatives de pistes';

  @override
  String get download_track => 'Télécharger la piste';

  @override
  String tracks_in_queue(Object tracks) {
    return '$tracks pistes dans la file d\'attente';
  }

  @override
  String get clear_all => 'Tout effacer';

  @override
  String get show_hide_ui_on_hover =>
      'Afficher/Masquer l\'interface utilisateur au survol';

  @override
  String get always_on_top => 'Toujours au-dessus';

  @override
  String get exit_mini_player => 'Quitter le lecteur mini';

  @override
  String get download_location => 'Emplacement de téléchargement';

  @override
  String get local_library => 'Bibliothèque locale';

  @override
  String get add_library_location => 'Ajouter à la bibliothèque';

  @override
  String get remove_library_location => 'Retirer de la bibliothèque';

  @override
  String get account => 'Compte';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get logout_of_this_account => 'Se déconnecter de ce compte';

  @override
  String get language_region => 'Langue et région';

  @override
  String get language => 'Langue';

  @override
  String get system_default => 'Paramètres par défaut du système';

  @override
  String get market_place_region => 'Région du marché';

  @override
  String get recommendation_country => 'Pays de recommandation';

  @override
  String get appearance => 'Apparence';

  @override
  String get layout_mode => 'Mode de mise en page';

  @override
  String get override_layout_settings =>
      'Remplacer les paramètres de mise en page adaptative';

  @override
  String get adaptive => 'Adaptatif';

  @override
  String get compact => 'Compact';

  @override
  String get extended => 'Étendu';

  @override
  String get theme => 'Thème';

  @override
  String get dark => 'Sombre';

  @override
  String get light => 'Clair';

  @override
  String get system => 'Système';

  @override
  String get accent_color => 'Couleur d\'accentuation';

  @override
  String get sync_album_color => 'Synchroniser la couleur de l\'album';

  @override
  String get sync_album_color_description =>
      'Utilise la couleur dominante de l\'art de l\'album comme couleur d\'accentuation';

  @override
  String get playback => 'Lecture';

  @override
  String get audio_quality => 'Qualité audio';

  @override
  String get high => 'Haute';

  @override
  String get low => 'Basse';

  @override
  String get pre_download_play => 'Pré-télécharger et lire';

  @override
  String get pre_download_play_description =>
      'Au lieu de diffuser de l\'audio, téléchargez les octets et lisez-les à la place (recommandé pour les utilisateurs à bande passante élevée)';

  @override
  String get skip_non_music =>
      'Ignorer les segments non musicaux (SponsorBlock)';

  @override
  String get blacklist_description => 'Pistes et artistes en liste noire';

  @override
  String get wait_for_download_to_finish =>
      'Veuillez attendre la fin du téléchargement en cours';

  @override
  String get desktop => 'Bureau';

  @override
  String get close_behavior => 'Comportement de fermeture';

  @override
  String get close => 'Fermer';

  @override
  String get minimize_to_tray => 'Réduire dans la zone de notification';

  @override
  String get show_tray_icon => 'Afficher l\'icône de la zone de notification';

  @override
  String get about => 'À propos';

  @override
  String get u_love_spotube => 'Nous savons que vous aimez Spotube';

  @override
  String get check_for_updates => 'Vérifier les mises à jour';

  @override
  String get about_spotube => 'À propos de Spotube';

  @override
  String get blacklist => 'Liste noire';

  @override
  String get please_sponsor => 'S\'il vous plaît Sponsoriser/Donner';

  @override
  String get spotube_description =>
      'Spotube, un client Spotify léger, multiplateforme et gratuit pour tous';

  @override
  String get version => 'Version';

  @override
  String get build_number => 'Numéro de version';

  @override
  String get founder => 'Fondateur';

  @override
  String get repository => 'Dépôt';

  @override
  String get bug_issues => 'Bugs + Problèmes';

  @override
  String get made_with => 'Fabriqué avec ❤️ au Bangladesh🇧🇩';

  @override
  String get kingkor_roy_tirtho => 'Kingkor Roy Tirtho';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year Kingkor Roy Tirtho';
  }

  @override
  String get license => 'Licence';

  @override
  String get credentials_will_not_be_shared_disclaimer =>
      'Ne vous inquiétez pas, vos identifiants ne seront ni collectés ni partagés avec qui que ce soit';

  @override
  String get know_how_to_login => 'Vous ne savez pas comment faire?';

  @override
  String get follow_step_by_step_guide => 'Suivez le guide étape par étape';

  @override
  String cookie_name_cookie(Object name) {
    return 'Cookie $name';
  }

  @override
  String get fill_in_all_fields => 'Veuillez remplir tous les champs';

  @override
  String get submit => 'Soumettre';

  @override
  String get exit => 'Quitter';

  @override
  String get previous => 'Précédent';

  @override
  String get next => 'Suivant';

  @override
  String get done => 'Terminé';

  @override
  String get step_1 => 'Étape 1';

  @override
  String get first_go_to => 'Tout d\'abord, allez sur';

  @override
  String get something_went_wrong => 'Quelque chose s\'est mal passé';

  @override
  String get piped_instance => 'Instance pipée';

  @override
  String get piped_description =>
      'L\'instance de serveur Piped à utiliser pour la correspondance des pistes';

  @override
  String get piped_warning =>
      'Certaines d\'entre elles peuvent ne pas fonctionner correctement. Alors utilisez à vos risques et périls';

  @override
  String get invidious_instance => 'Instance de serveur Invidious';

  @override
  String get invidious_description =>
      'L\'instance de serveur Invidious à utiliser pour la correspondance de pistes';

  @override
  String get invidious_warning =>
      'Certaines instances pourraient ne pas bien fonctionner. À utiliser à vos risques et périls';

  @override
  String get generate => 'Générer';

  @override
  String track_exists(Object track) {
    return 'La piste $track existe déjà';
  }

  @override
  String get replace_downloaded_tracks =>
      'Remplacer toutes les pistes téléchargées';

  @override
  String get skip_download_tracks =>
      'Ignorer le téléchargement de toutes les pistes téléchargées';

  @override
  String get do_you_want_to_replace =>
      'Voulez-vous remplacer la piste existante ?';

  @override
  String get replace => 'Remplacer';

  @override
  String get skip => 'Passer';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return 'Sélectionnez jusqu\'à $count $type';
  }

  @override
  String get select_genres => 'Sélectionner les genres';

  @override
  String get add_genres => 'Ajouter des genres';

  @override
  String get country => 'Pays';

  @override
  String get number_of_tracks_generate => 'Nombre de pistes à générer';

  @override
  String get acousticness => 'Acoustique';

  @override
  String get danceability => 'Dansabilité';

  @override
  String get energy => 'Énergie';

  @override
  String get instrumentalness => 'Instrumentalité';

  @override
  String get liveness => 'Interprétation en direct';

  @override
  String get loudness => 'Sonorité';

  @override
  String get speechiness => 'Parlé';

  @override
  String get valence => 'Valeur émotionnelle';

  @override
  String get popularity => 'Popularité';

  @override
  String get key => 'Clé';

  @override
  String get duration => 'Durée (s)';

  @override
  String get tempo => 'Tempo (BPM)';

  @override
  String get mode => 'Mode';

  @override
  String get time_signature => 'Signature rythmique';

  @override
  String get short => 'Court';

  @override
  String get medium => 'Moyen';

  @override
  String get long => 'Long';

  @override
  String get min => 'Min';

  @override
  String get max => 'Max';

  @override
  String get target => 'Cible';

  @override
  String get moderate => 'Modéré';

  @override
  String get deselect_all => 'Tout désélectionner';

  @override
  String get select_all => 'Tout sélectionner';

  @override
  String get are_you_sure => 'Êtes-vous sûr(e) ?';

  @override
  String get generating_playlist =>
      'Génération de votre playlist personnalisée en cours...';

  @override
  String selected_count_tracks(Object count) {
    return '$count pistes sélectionnées';
  }

  @override
  String get download_warning =>
      'Si vous téléchargez toutes les pistes en vrac, vous violez clairement les droits d\'auteur de la musique et vous causez des dommages à la société créative de la musique. J\'espère que vous en êtes conscient. Essayez toujours de respecter et de soutenir le travail acharné des artistes.';

  @override
  String get download_ip_ban_warning =>
      'Au fait, votre adresse IP peut être bloquée sur YouTube en raison d\'une demande excessive de téléchargements par rapport à la normale. Le blocage de l\'IP signifie que vous ne pourrez pas utiliser YouTube (même si vous êtes connecté) pendant au moins 2 à 3 mois à partir de cet appareil IP. Et Spotube ne peut être tenu responsable si cela se produit.';

  @override
  String get by_clicking_accept_terms =>
      'En cliquant sur \'accepter\', vous acceptez les conditions suivantes :';

  @override
  String get download_agreement_1 =>
      'Je sais que je pirate de la musique. Je suis méchant(e).';

  @override
  String get download_agreement_2 =>
      'Je soutiendrai l\'artiste autant que possible et je ne fais cela que parce que je n\'ai pas d\'argent pour acheter leur art.';

  @override
  String get download_agreement_3 =>
      'Je suis parfaitement conscient(e) que mon adresse IP peut être bloquée sur YouTube et je ne tiens pas Spotube ni ses propriétaires/contributeurs responsables de tout accident causé par mon action actuelle.';

  @override
  String get decline => 'Refuser';

  @override
  String get accept => 'Accepter';

  @override
  String get details => 'Détails';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => 'Chaîne';

  @override
  String get likes => 'J\'aime';

  @override
  String get dislikes => 'Je n\'aime pas';

  @override
  String get views => 'Vues';

  @override
  String get streamUrl => 'URL de diffusion';

  @override
  String get stop => 'Arrêter';

  @override
  String get sort_newest => 'Trier par les plus récents';

  @override
  String get sort_oldest => 'Trier par les plus anciens';

  @override
  String get sleep_timer => 'Minuteur de veille';

  @override
  String mins(Object minutes) {
    return '$minutes minutes';
  }

  @override
  String hours(Object hours) {
    return '$hours heures';
  }

  @override
  String hour(Object hours) {
    return '$hours heure';
  }

  @override
  String get custom_hours => 'Heures personnalisées';

  @override
  String get logs => 'Journaux';

  @override
  String get developers => 'Développeurs';

  @override
  String get not_logged_in => 'Vous n\'êtes pas connecté(e)';

  @override
  String get search_mode => 'Mode de recherche';

  @override
  String get audio_source => 'Source audio';

  @override
  String get ok => 'OK';

  @override
  String get failed_to_encrypt => 'Échec de la cryptage';

  @override
  String get encryption_failed_warning =>
      'Spotube utilise le cryptage pour stocker vos données en toute sécurité. Mais cela a échoué. Il basculera donc vers un stockage non sécurisé\nSi vous utilisez Linux, assurez-vous d\'avoir installé des services secrets tels que gnome-keyring, kde-wallet et keepassxc';

  @override
  String get querying_info => 'Interrogation des info...';

  @override
  String get piped_api_down => 'L\'API Piped est hors service';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return 'L\'instance Piped $pipedInstance est actuellement indisponible\n\nChangez soit l\'instance, soit le \'Type d\'API\' pour utiliser l\'API officielle de YouTube\n\nN\'oubliez pas de redémarrer l\'application après la modification';
  }

  @override
  String get you_are_offline => 'Vous êtes actuellement hors ligne';

  @override
  String get connection_restored => 'Votre connexion internet a été rétablie';

  @override
  String get use_system_title_bar => 'Utiliser la barre de titre système';

  @override
  String get crunching_results => 'Traitement des résultats...';

  @override
  String get search_to_get_results => 'Recherche pour obtenir des résultats';

  @override
  String get use_amoled_mode => 'Utiliser le mode AMOLED';

  @override
  String get pitch_dark_theme => 'Thème Dart noir intense';

  @override
  String get normalize_audio => 'Normaliser l\'audio';

  @override
  String get change_cover => 'Changer de couverture';

  @override
  String get add_cover => 'Ajouter une couverture';

  @override
  String get restore_defaults => 'Restaurer les valeurs par défaut';

  @override
  String get download_music_format => 'Format de téléchargement de musique';

  @override
  String get streaming_music_format => 'Format de streaming de musique';

  @override
  String get download_music_quality => 'Qualité de téléchargement de musique';

  @override
  String get streaming_music_quality => 'Qualité de streaming de musique';

  @override
  String get login_with_lastfm => 'Se connecter avec Last.fm';

  @override
  String get connect => 'Connecter';

  @override
  String get disconnect_lastfm => 'Déconnecter de Last.fm';

  @override
  String get disconnect => 'Déconnecter';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get password => 'Mot de passe';

  @override
  String get login => 'Se connecter';

  @override
  String get login_with_your_lastfm => 'Se connecter avec votre compte Last.fm';

  @override
  String get scrobble_to_lastfm => 'Scrobble à Last.fm';

  @override
  String get go_to_album => 'Aller à l\'album';

  @override
  String get discord_rich_presence => 'Présence riche de Discord';

  @override
  String get browse_all => 'Parcourir tout';

  @override
  String get genres => 'Genres';

  @override
  String get explore_genres => 'Explorer les genres';

  @override
  String get friends => 'Amis';

  @override
  String get no_lyrics_available =>
      'Désolé, impossible de trouver les paroles de cette piste';

  @override
  String get start_a_radio => 'Démarrer une radio';

  @override
  String get how_to_start_radio => 'Comment voulez-vous démarrer la radio ?';

  @override
  String get replace_queue_question =>
      'Voulez-vous remplacer la file d\'attente actuelle ou y ajouter ?';

  @override
  String get endless_playback => 'Lecture sans fin';

  @override
  String get delete_playlist => 'Supprimer la playlist';

  @override
  String get delete_playlist_confirmation =>
      'Êtes-vous sûr de vouloir supprimer cette playlist ?';

  @override
  String get local_tracks => 'Titres locaux';

  @override
  String get local_tab => 'Local';

  @override
  String get song_link => 'Lien de la chanson';

  @override
  String get skip_this_nonsense => 'Passer cette absurdité';

  @override
  String get freedom_of_music => '“Liberté de la musique”';

  @override
  String get freedom_of_music_palm =>
      '“Liberté de la musique dans la paume de votre main”';

  @override
  String get get_started => 'Commençons';

  @override
  String get youtube_source_description => 'Recommandé et fonctionne mieux.';

  @override
  String get piped_source_description =>
      'Vous vous sentez libre ? Comme YouTube mais beaucoup plus gratuit.';

  @override
  String get jiosaavn_source_description =>
      'Le meilleur pour la région d\'Asie du Sud.';

  @override
  String get invidious_source_description =>
      'Similaire à Piped mais avec une meilleure disponibilité';

  @override
  String highest_quality(Object quality) {
    return 'Meilleure qualité : $quality';
  }

  @override
  String get select_audio_source => 'Sélectionner la source audio';

  @override
  String get endless_playback_description =>
      'Ajouter automatiquement de nouvelles chansons à la fin de la file d\'attente';

  @override
  String get choose_your_region => 'Choisissez votre région';

  @override
  String get choose_your_region_description =>
      'Cela aidera Spotube à vous montrer le bon contenu pour votre emplacement.';

  @override
  String get choose_your_language => 'Choisissez votre langue';

  @override
  String get help_project_grow => 'Aidez ce projet à grandir';

  @override
  String get help_project_grow_description =>
      'Spotube est un projet open-source. Vous pouvez aider ce projet à grandir en contribuant au projet, en signalant des bugs ou en suggérant de nouvelles fonctionnalités.';

  @override
  String get contribute_on_github => 'Contribuer sur GitHub';

  @override
  String get donate_on_open_collective => 'Faire un don sur Open Collective';

  @override
  String get browse_anonymously => 'Naviguer anonymement';

  @override
  String get enable_connect => 'Activer la connexion';

  @override
  String get enable_connect_description =>
      'Contrôlez Spotube depuis d\'autres appareils';

  @override
  String get devices => 'Appareils';

  @override
  String get select => 'Sélectionner';

  @override
  String connect_client_alert(Object client) {
    return 'Vous êtes contrôlé par $client';
  }

  @override
  String get this_device => 'Cet appareil';

  @override
  String get remote => 'À distance';

  @override
  String get stats => 'Statistiques';

  @override
  String and_n_more(Object count) {
    return 'et $count de plus';
  }

  @override
  String get recently_played => 'Récemment joué';

  @override
  String get browse_more => 'Parcourir plus';

  @override
  String get no_title => 'Sans titre';

  @override
  String get not_playing => 'Non joué';

  @override
  String get epic_failure => 'Échec épique!';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return '$tracks_length morceaux ajoutés à la file d\'attente';
  }

  @override
  String get spotube_has_an_update => 'Spotube a une mise à jour';

  @override
  String get download_now => 'Télécharger maintenant';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Spotube Nightly $nightlyBuildNum a été publié';
  }

  @override
  String release_version(Object version) {
    return 'Spotube v$version a été publié';
  }

  @override
  String get read_the_latest => 'Lisez les dernières ';

  @override
  String get release_notes => 'notes de version';

  @override
  String get pick_color_scheme => 'Choisissez le schéma de couleurs';

  @override
  String get save => 'Sauvegarder';

  @override
  String get choose_the_device => 'Choisissez l\'appareil:';

  @override
  String get multiple_device_connected =>
      'Plusieurs appareils sont connectés.\nChoisissez l\'appareil sur lequel vous souhaitez effectuer cette action';

  @override
  String get nothing_found => 'Rien trouvé';

  @override
  String get the_box_is_empty => 'La boîte est vide';

  @override
  String get top_artists => 'Meilleurs artistes';

  @override
  String get top_albums => 'Meilleurs albums';

  @override
  String get this_week => 'Cette semaine';

  @override
  String get this_month => 'Ce mois-ci';

  @override
  String get last_6_months => 'Les 6 derniers mois';

  @override
  String get this_year => 'Cette année';

  @override
  String get last_2_years => 'Les 2 dernières années';

  @override
  String get all_time => 'De tous les temps';

  @override
  String powered_by_provider(Object providerName) {
    return 'Propulsé par $providerName';
  }

  @override
  String get email => 'Email';

  @override
  String get profile_followers => 'Abonnés';

  @override
  String get birthday => 'Anniversaire';

  @override
  String get subscription => 'Abonnement';

  @override
  String get not_born => 'Non né';

  @override
  String get hacker => 'Hacker';

  @override
  String get profile => 'Profil';

  @override
  String get no_name => 'Sans nom';

  @override
  String get edit => 'Modifier';

  @override
  String get user_profile => 'Profil utilisateur';

  @override
  String count_plays(Object count) {
    return '$count lectures';
  }

  @override
  String get streaming_fees_hypothetical =>
      'Frais de streaming (hypothétiques)';

  @override
  String get minutes_listened => 'Minutes écoutées';

  @override
  String get streamed_songs => 'Morceaux diffusés';

  @override
  String count_streams(Object count) {
    return '$count streams';
  }

  @override
  String get owned_by_you => 'Possédé par vous';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return '$shareUrl copié dans le presse-papier';
  }

  @override
  String get hipotetical_calculation =>
      '*Ce calcul est basé sur le paiement moyen par lecture des plateformes de streaming musical en ligne, de 0,003 \$ à 0,005 \$. Il s\'agit d\'un calcul hypothétique pour donner à l\'utilisateur un aperçu de ce qu\'il aurait payé aux artistes s\'il écoutait leur chanson sur différentes plateformes de streaming musical.';

  @override
  String count_mins(Object minutes) {
    return '$minutes minutes';
  }

  @override
  String get summary_minutes => 'minutes';

  @override
  String get summary_listened_to_music => 'A écouté de la musique';

  @override
  String get summary_songs => 'morceaux';

  @override
  String get summary_streamed_overall => 'Diffusé en général';

  @override
  String get summary_owed_to_artists => 'Dû aux artistes\nCe mois-ci';

  @override
  String get summary_artists => 'artistes';

  @override
  String get summary_music_reached_you => 'La musique vous a atteint';

  @override
  String get summary_full_albums => 'albums complets';

  @override
  String get summary_got_your_love => 'A obtenu votre amour';

  @override
  String get summary_playlists => 'playlists';

  @override
  String get summary_were_on_repeat => 'Était en répétition';

  @override
  String total_money(Object money) {
    return 'Total $money';
  }

  @override
  String get webview_not_found => 'Webview non trouvé';

  @override
  String get webview_not_found_description =>
      'Aucun environnement d\'exécution Webview installé sur votre appareil.\nSi c\'est installé, assurez-vous qu\'il soit dans le environment PATH\n\nAprès l\'installation, redémarrez l\'application';

  @override
  String get unsupported_platform => 'Plateforme non prise en charge';

  @override
  String get cache_music => 'Mettre la musique en cache';

  @override
  String get open => 'Ouvrir';

  @override
  String get cache_folder => 'Dossier du cache';

  @override
  String get export => 'Exporter';

  @override
  String get clear_cache => 'Effacer le cache';

  @override
  String get clear_cache_confirmation => 'Voulez-vous effacer le cache ?';

  @override
  String get export_cache_files => 'Exporter les fichiers en cache';

  @override
  String found_n_files(Object count) {
    return '$count fichiers trouvés';
  }

  @override
  String get export_cache_confirmation =>
      'Voulez-vous exporter ces fichiers vers';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return '$filesExported fichiers exportés sur $files';
  }

  @override
  String get undo => 'Annuler';

  @override
  String get download_all => 'Télécharger tout';

  @override
  String get add_all_to_playlist => 'Ajouter tout à la playlist';

  @override
  String get add_all_to_queue => 'Ajouter tout à la file d\'attente';

  @override
  String get play_all_next => 'Lire tout suivant';

  @override
  String get pause => 'Pause';

  @override
  String get view_all => 'Voir tout';

  @override
  String get no_tracks_added_yet =>
      'Il semble que vous n\'avez encore ajouté aucun morceau.';

  @override
  String get no_tracks => 'Il semble qu\'il n\'y ait pas de morceaux ici.';

  @override
  String get no_tracks_listened_yet =>
      'Il semble que vous n\'avez encore rien écouté.';

  @override
  String get not_following_artists => 'Vous ne suivez aucun artiste.';

  @override
  String get no_favorite_albums_yet =>
      'Il semble que vous n\'ayez encore ajouté aucun album à vos favoris.';

  @override
  String get no_logs_found => 'Aucun log trouvé';

  @override
  String get youtube_engine => 'Moteur YouTube';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engine n\'est pas installé';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engine n\'est pas installé sur votre système.';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return 'Assurez-vous qu\'il est disponible dans la variable PATH ou\nfixez le chemin absolu du fichier exécutable $engine ci-dessous.';
  }

  @override
  String get youtube_engine_unix_issue_message =>
      'Dans macOS/Linux/les systèmes d\'exploitation similaires à Unix, définir le chemin dans .zshrc/.bashrc/.bash_profile etc. ne fonctionnera pas.\nVous devez définir le chemin dans le fichier de configuration du shell.';

  @override
  String get download => 'Télécharger';

  @override
  String get file_not_found => 'Fichier non trouvé';

  @override
  String get custom => 'Personnalisé';

  @override
  String get add_custom_url => 'Ajouter une URL personnalisée';

  @override
  String get edit_port => 'Modifier le port';

  @override
  String get port_helper_msg =>
      'La valeur par défaut est -1, ce qui indique un nombre aléatoire. Si vous avez configuré un pare-feu, il est recommandé de le définir.';

  @override
  String connect_request(Object client) {
    return 'Autoriser $client à se connecter ?';
  }

  @override
  String get connection_request_denied =>
      'Connexion refusée. L\'utilisateur a refusé l\'accès.';

  @override
  String get an_error_occurred => 'Une erreur est survenue';

  @override
  String get copy_to_clipboard => 'Copier dans le presse-papiers';

  @override
  String get view_logs => 'Afficher les journaux';

  @override
  String get retry => 'Réessayer';

  @override
  String get no_default_metadata_provider_selected =>
      'Vous n\'avez pas de fournisseur de métadonnées par défaut';

  @override
  String get manage_metadata_providers =>
      'Gérer les fournisseurs de métadonnées';

  @override
  String get open_link_in_browser => 'Ouvrir le lien dans le navigateur ?';

  @override
  String get do_you_want_to_open_the_following_link =>
      'Voulez-vous ouvrir le lien suivant';

  @override
  String get unsafe_url_warning =>
      'L\'ouverture de liens provenant de sources non fiables peut être dangereuse. Soyez prudent !\nVous pouvez également copier le lien dans votre presse-papiers.';

  @override
  String get copy_link => 'Copier le lien';

  @override
  String get building_your_timeline =>
      'Construction de votre chronologie en fonction de vos écoutes...';

  @override
  String get official => 'Officiel';

  @override
  String author_name(Object author) {
    return 'Auteur : $author';
  }

  @override
  String get third_party => 'Tiers';

  @override
  String get plugin_requires_authentication =>
      'Le plugin nécessite une authentification';

  @override
  String get update_available => 'Mise à jour disponible';

  @override
  String get supports_scrobbling => 'Supporte le scrobbling';

  @override
  String get plugin_scrobbling_info =>
      'Ce plugin scrobble votre musique pour générer votre historique d\'écoute.';

  @override
  String get default_metadata_source => 'Source de métadonnées par défaut';

  @override
  String get set_default_metadata_source =>
      'Définir la source de métadonnées par défaut';

  @override
  String get default_audio_source => 'Source audio par défaut';

  @override
  String get set_default_audio_source => 'Définir la source audio par défaut';

  @override
  String get set_default => 'Définir par défaut';

  @override
  String get support => 'Soutien';

  @override
  String get support_plugin_development =>
      'Soutenir le développement de plugins';

  @override
  String can_access_name_api(Object name) {
    return '- Peut accéder à l\'API **$name**';
  }

  @override
  String get do_you_want_to_install_this_plugin =>
      'Voulez-vous installer ce plugin ?';

  @override
  String get third_party_plugin_warning =>
      'Ce plugin provient d\'un dépôt tiers. Assurez-vous de faire confiance à la source avant de l\'installer.';

  @override
  String get author => 'Auteur';

  @override
  String get this_plugin_can_do_following => 'Ce plugin peut faire ce qui suit';

  @override
  String get install => 'Installer';

  @override
  String get install_a_metadata_provider =>
      'Installer un fournisseur de métadonnées';

  @override
  String get no_tracks_playing =>
      'Aucune piste n\'est en cours de lecture actuellement';

  @override
  String get synced_lyrics_not_available =>
      'Les paroles synchronisées ne sont pas disponibles pour cette chanson. Veuillez utiliser l\'onglet';

  @override
  String get plain_lyrics => 'Paroles simples';

  @override
  String get tab_instead => 'à la place.';

  @override
  String get disclaimer => 'Avertissement';

  @override
  String get third_party_plugin_dmca_notice =>
      'L\'équipe de Spotube n\'assume aucune responsabilité (y compris juridique) pour les plugins \"tiers\".\nVeuillez les utiliser à vos propres risques. Pour tout bug/problème, veuillez le signaler au dépôt du plugin.\n\nSi un plugin \"tiers\" enfreint les conditions d\'utilisation/DMCA d\'un service/entité juridique, veuillez demander à l\'auteur du plugin \"tiers\" ou à la plateforme d\'hébergement (par exemple GitHub/Codeberg) de prendre des mesures. Les plugins listés ci-dessus (étiquetés \"tiers\") sont tous des plugins publics/maintenus par la communauté. Nous ne les gérons pas, nous ne pouvons donc prendre aucune mesure à leur sujet.\n\n';

  @override
  String get input_does_not_match_format =>
      'L\'entrée ne correspond pas au format requis';

  @override
  String get plugins => 'Plugins';

  @override
  String get paste_plugin_download_url =>
      'Collez l\'URL de téléchargement ou l\'URL du dépôt GitHub/Codeberg ou un lien direct vers le fichier .smplug';

  @override
  String get download_and_install_plugin_from_url =>
      'Télécharger et installer le plugin à partir de l\'URL';

  @override
  String failed_to_add_plugin_error(Object error) {
    return 'Échec de l\'ajout du plugin : $error';
  }

  @override
  String get upload_plugin_from_file =>
      'Télécharger le plugin à partir d\'un fichier';

  @override
  String get installed => 'Installé';

  @override
  String get available_plugins => 'Plugins disponibles';

  @override
  String get configure_plugins =>
      'Configurez vos propres plugins de fournisseur de métadonnées et de source audio';

  @override
  String get audio_scrobblers => 'Scrobblers audio';

  @override
  String get scrobbling => 'Scrobbling';

  @override
  String get source => 'Source : ';

  @override
  String get uncompressed => 'Non compressé';

  @override
  String get dab_music_source_description =>
      'Pour les audiophiles. Fournit des flux audio de haute qualité/sans perte. Correspondance précise des pistes basée sur ISRC.';
}
