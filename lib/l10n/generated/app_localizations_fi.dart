// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get guest => 'Vieras';

  @override
  String get browse => 'Selaa';

  @override
  String get search => 'Hae';

  @override
  String get library => 'Kirjasto';

  @override
  String get lyrics => 'Lyriikat';

  @override
  String get settings => 'Asetukset';

  @override
  String get genre_categories_filter => 'Suodata kategorioita tai genrejä';

  @override
  String get genre => 'Genre';

  @override
  String get personalized => 'Personoidut';

  @override
  String get featured => 'Esittelyssä';

  @override
  String get new_releases => 'Uusi julkaisu';

  @override
  String get songs => 'Laulut';

  @override
  String playing_track(Object track) {
    return 'Soitetaan $track';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return 'Tämä tulee tyhjentämään jonon. $track_length Kappaleita poistetaan\nHaluatko jatkaa?';
  }

  @override
  String get load_more => 'Lataa lisää';

  @override
  String get playlists => 'Soittolistat';

  @override
  String get artists => 'Artistit';

  @override
  String get albums => 'Albumit';

  @override
  String get tracks => 'Kappaleet';

  @override
  String get downloads => 'Lataukset';

  @override
  String get filter_playlists => 'Suodata soittolistasi...';

  @override
  String get liked_tracks => 'Tykätyt kappaleet';

  @override
  String get liked_tracks_description => 'Kaikki tykättysi kappaleet';

  @override
  String get playlist => 'Soittolista';

  @override
  String get create_a_playlist => 'Luo soittolista';

  @override
  String get update_playlist => 'Päivitä soittolista';

  @override
  String get create => 'Luo';

  @override
  String get cancel => 'Peruuta';

  @override
  String get update => 'Päivitä';

  @override
  String get playlist_name => 'Soittolistan nimi';

  @override
  String get name_of_playlist => 'Soittolistan nimi';

  @override
  String get description => 'Kuvaus';

  @override
  String get public => 'Julkinen';

  @override
  String get collaborative => 'Collaborative';

  @override
  String get search_local_tracks => 'Hae paikallisia lauluja...';

  @override
  String get play => 'Soita';

  @override
  String get delete => 'Poista';

  @override
  String get none => 'Ei mitään';

  @override
  String get sort_a_z => 'Suodata A-Z';

  @override
  String get sort_z_a => 'Suodata Z-A';

  @override
  String get sort_artist => 'Suodata Artistilta';

  @override
  String get sort_album => 'Suodata Albumilta';

  @override
  String get sort_duration => 'Suodata Pituudelta';

  @override
  String get sort_tracks => 'Suodata Kappaleet';

  @override
  String currently_downloading(Object tracks_length) {
    return 'Ladataan ($tracks_length)';
  }

  @override
  String get cancel_all => 'Peru kaikki';

  @override
  String get filter_artist => 'Suodata artistit...';

  @override
  String followers(Object followers) {
    return '$followers Seuraajaa';
  }

  @override
  String get add_artist_to_blacklist => 'Lisää artisti mustalle listalle';

  @override
  String get top_tracks => 'Suosituimmat kappaleet';

  @override
  String get fans_also_like => 'Fanit myös tykkäsivät';

  @override
  String get loading => 'Ladataan...';

  @override
  String get artist => 'Artisti';

  @override
  String get blacklisted => 'Mustalistattu';

  @override
  String get following => 'Seurataan';

  @override
  String get follow => 'Seuraa';

  @override
  String get artist_url_copied => 'Aristin URL kopioitiin leikepöytään';

  @override
  String added_to_queue(Object tracks) {
    return 'Lisättiin $tracks kappaletta jonoon';
  }

  @override
  String get filter_albums => 'Suodata albumit...';

  @override
  String get synced => 'Synkronoitu';

  @override
  String get plain => 'Tavallinen';

  @override
  String get shuffle => 'Sekoita';

  @override
  String get search_tracks => 'Hae kappaleita...';

  @override
  String get released => 'Julkaistu';

  @override
  String error(Object error) {
    return 'Virhe $error';
  }

  @override
  String get title => 'Otsikko';

  @override
  String get time => 'Aika';

  @override
  String get more_actions => 'Lisää toimintoja';

  @override
  String download_count(Object count) {
    return 'Lataa ($count)';
  }

  @override
  String add_count_to_playlist(Object count) {
    return 'Lisää ($count) Soittolistaasi';
  }

  @override
  String add_count_to_queue(Object count) {
    return 'Lisää ($count) Jonoon';
  }

  @override
  String play_count_next(Object count) {
    return 'Soita ($count) seuraavaksi';
  }

  @override
  String get album => 'Albumi';

  @override
  String copied_to_clipboard(Object data) {
    return 'Kopioitiin $data leikepöytään';
  }

  @override
  String add_to_following_playlists(Object track) {
    return 'Lisää $track seuraaviin soittolistoihin';
  }

  @override
  String get add => 'Lisää';

  @override
  String added_track_to_queue(Object track) {
    return 'Lisättiin $track jonoon';
  }

  @override
  String get add_to_queue => 'Lisää jonoon';

  @override
  String track_will_play_next(Object track) {
    return '$track Soitetaan seuraavaksi';
  }

  @override
  String get play_next => 'Soita seuraavaksi';

  @override
  String removed_track_from_queue(Object track) {
    return 'Poistettiin $track jonosta';
  }

  @override
  String get remove_from_queue => 'Poista jonosta';

  @override
  String get remove_from_favorites => 'Poista suosikeista';

  @override
  String get save_as_favorite => 'Tallenna soittolistana';

  @override
  String get add_to_playlist => 'Lisää soittolistaan';

  @override
  String get remove_from_playlist => 'Poista soittolistasta';

  @override
  String get add_to_blacklist => 'Lisää mustalle listalle';

  @override
  String get remove_from_blacklist => 'Poista mustalistalta';

  @override
  String get share => 'Jaa';

  @override
  String get mini_player => 'Minisoitin';

  @override
  String get slide_to_seek => 'Liu\'uta mennäkseen eteenpäin tai taaksepäin';

  @override
  String get shuffle_playlist => 'Sekoita soittolista';

  @override
  String get unshuffle_playlist => 'Poista sekoitus soittolistasta';

  @override
  String get previous_track => 'Äskeinen kappale';

  @override
  String get next_track => 'Seuraava kappale';

  @override
  String get pause_playback => 'Pysäytä soittolistan toisto';

  @override
  String get resume_playback => 'Jatka soittolistan toistoa';

  @override
  String get loop_track => 'Uudelleentoista kappale';

  @override
  String get no_loop => 'Ei silmukkaa';

  @override
  String get repeat_playlist => 'Toista soittolista uudelleen';

  @override
  String get queue => 'Jono';

  @override
  String get alternative_track_sources => 'Toinen kappale lähde';

  @override
  String get download_track => 'Lataa kappale';

  @override
  String tracks_in_queue(Object tracks) {
    return '$tracks kappaletta jonossa';
  }

  @override
  String get clear_all => 'Tyhjennä kaikki';

  @override
  String get show_hide_ui_on_hover => 'Näytä/Piilota UI leijumalla';

  @override
  String get always_on_top => 'Aina päällimmäisenä';

  @override
  String get exit_mini_player => 'Lähde minisoittimesta';

  @override
  String get download_location => 'Lataus sijainti';

  @override
  String get local_library => 'Paikallinen kirjasto';

  @override
  String get add_library_location => 'Lisää kirjastoon';

  @override
  String get remove_library_location => 'Poista kirjastosta';

  @override
  String get account => 'Käyttäjä';

  @override
  String get logout => 'Kirjaudu ulos';

  @override
  String get logout_of_this_account => 'Kirjaudu ulos tältä käyttäjältä';

  @override
  String get language_region => 'Kieli ja Maa';

  @override
  String get language => 'Kieli';

  @override
  String get system_default => 'Järjestelmän oletus';

  @override
  String get market_place_region => 'Markkina-alue';

  @override
  String get recommendation_country => 'Suositeltu maa';

  @override
  String get appearance => 'Ulkomuto';

  @override
  String get layout_mode => 'Asettelutila';

  @override
  String get override_layout_settings =>
      'Jätä reagoiva asettelutila huomioimatta';

  @override
  String get adaptive => 'Mukautuva';

  @override
  String get compact => 'Kompakti';

  @override
  String get extended => 'Laajennettu';

  @override
  String get theme => 'Teema';

  @override
  String get dark => 'Tumma';

  @override
  String get light => 'Vaalea';

  @override
  String get system => 'Järjestelmä';

  @override
  String get accent_color => 'Korostusväri';

  @override
  String get sync_album_color => 'Synkronoi albumin väri';

  @override
  String get sync_album_color_description =>
      'Käyttää albumin kansitaiteen vallitsevaa väirä korostuvärinä';

  @override
  String get playback => 'Toisto';

  @override
  String get audio_quality => 'Äänenlaatu';

  @override
  String get high => 'Korkea';

  @override
  String get low => 'Matala';

  @override
  String get pre_download_play => 'Esilataa ja soita';

  @override
  String get pre_download_play_description =>
      'Audion suoratoiston sijaan, lataa tavut ja soita ne (Suositeltu korkeamman kaistanleveyden käyttäjille)';

  @override
  String get skip_non_music => 'Ohita ei-musiikki kohdat (SponsorBlock)';

  @override
  String get blacklist_description => 'Mustalistat kappaleet aja artistit';

  @override
  String get wait_for_download_to_finish =>
      'Odota nykyisen latauksen lopetteluun';

  @override
  String get desktop => 'Työpöytä';

  @override
  String get close_behavior => 'Sulkemisen käyttäytyminen';

  @override
  String get close => 'Sulje';

  @override
  String get minimize_to_tray => 'Minimisoi tehtäväpalkkiin';

  @override
  String get show_tray_icon => 'Näytä järjestelmäkuvake';

  @override
  String get about => 'Tietoa';

  @override
  String get u_love_spotube => 'Tiedämme että rakastat Spotubea';

  @override
  String get check_for_updates => 'Tarkista päivitykset';

  @override
  String get about_spotube => 'Tietoa Spotube:sta';

  @override
  String get blacklist => 'Mustalista';

  @override
  String get please_sponsor => 'Sponsoroi/Lahjoita, kiitos';

  @override
  String get spotube_description =>
      'Spotube, kevyt, cross-platform, vapaa-kaikille spotify clientti';

  @override
  String get version => 'Versio';

  @override
  String get build_number => 'Rakennusnumero';

  @override
  String get founder => 'Perustaja';

  @override
  String get repository => 'Arkisto';

  @override
  String get bug_issues => 'Bugit+Ongelmat';

  @override
  String get made_with => 'Tehty ❤️ Bangladeshista 🇧🇩';

  @override
  String get kingkor_roy_tirtho => 'Kingkor Roy Tirtho';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year Kingkor Roy Tirtho';
  }

  @override
  String get license => 'Lisenssi';

  @override
  String get credentials_will_not_be_shared_disclaimer =>
      'Älä huoli, tunnuksiasi ei talleteta tai jaeta kenenkään kanssa';

  @override
  String get know_how_to_login => 'Etkö tiedä miten tehdä tämä?';

  @override
  String get follow_step_by_step_guide => 'Seuraa askel askeleelta opasta';

  @override
  String cookie_name_cookie(Object name) {
    return '$name Keksi';
  }

  @override
  String get fill_in_all_fields => 'Täytä kaikki kentät';

  @override
  String get submit => 'Lähetä';

  @override
  String get exit => 'Poistu';

  @override
  String get previous => 'Edellinen';

  @override
  String get next => 'Seuraava';

  @override
  String get done => 'Tehty';

  @override
  String get step_1 => 'Vaihe 1';

  @override
  String get first_go_to => 'Ensiksi, mene';

  @override
  String get something_went_wrong => 'Jotain meni pieleen';

  @override
  String get piped_instance => 'Johdettu palvelinesiintymä';

  @override
  String get piped_description =>
      'Johdettu palvelinesiintymä Kappale täsmäyksiin';

  @override
  String get piped_warning =>
      'Jotkut niistä eivät toimi hyvin, käytä siis omalla vastuullasi';

  @override
  String get invidious_instance => 'Invidious-palvelinesiintymä';

  @override
  String get invidious_description =>
      'Invidious-palvelinesiintymä raitojen yhteensovittamiseen';

  @override
  String get invidious_warning =>
      'Jotkin esiintymät eivät välttämättä toimi hyvin. Käytä omalla vastuullasi';

  @override
  String get generate => 'Luo';

  @override
  String track_exists(Object track) {
    return 'Kappale $track on jo olemassa!';
  }

  @override
  String get replace_downloaded_tracks => 'Korvaa kaikki ladatut kappaleet';

  @override
  String get skip_download_tracks => 'Ohita ladattujen laulujen lataaminen';

  @override
  String get do_you_want_to_replace =>
      'Haluatko korvata olemassa olevan kappaleen??';

  @override
  String get replace => 'Korvaa';

  @override
  String get skip => 'Ohita';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return 'Valitse enintään $count $type';
  }

  @override
  String get select_genres => 'Valitse Genret';

  @override
  String get add_genres => 'Lisää Genrejä';

  @override
  String get country => 'Maa';

  @override
  String get number_of_tracks_generate => 'Numero tuotettavia kappaleita';

  @override
  String get acousticness => 'Akustisuus';

  @override
  String get danceability => 'Tanssittavuus';

  @override
  String get energy => 'Energia';

  @override
  String get instrumentalness => 'Instrumentaalisuus';

  @override
  String get liveness => 'Elävyyttä';

  @override
  String get loudness => 'Äänekkyys';

  @override
  String get speechiness => 'Puheisuus';

  @override
  String get valence => 'Valenssi';

  @override
  String get popularity => 'Suosio';

  @override
  String get key => 'Sävellaji';

  @override
  String get duration => 'Pituus (s)';

  @override
  String get tempo => 'Tempo (BPM)';

  @override
  String get mode => 'Tila';

  @override
  String get time_signature => 'Aikamerkki';

  @override
  String get short => 'Lyhyt';

  @override
  String get medium => 'Keskikokoinen';

  @override
  String get long => 'Pitkä';

  @override
  String get min => 'Minimi';

  @override
  String get max => 'Maximi';

  @override
  String get target => 'Kohde';

  @override
  String get moderate => 'Kohtalainen';

  @override
  String get deselect_all => 'Poista kaikki valinnat';

  @override
  String get select_all => 'Valitse kaikki';

  @override
  String get are_you_sure => 'Oletko varma?';

  @override
  String get generating_playlist => 'Luodaan mukautettua soittolistoa...';

  @override
  String selected_count_tracks(Object count) {
    return 'Valittu $count kappaletta';
  }

  @override
  String get download_warning =>
      'Jos lataat kaikki laulut kerrällä olet selkeästi Piratoimassa ja aiheuttamassa vahinkoa musiikin luovaan yhteiskuntaan. Toivottavasti olet tietoinen tästä. Yritä aina kunnioittaa ja tukea Artistin kovaa työtä.';

  @override
  String get download_ip_ban_warning =>
      'BTW, YouTube voi estää IP-Osoitteesi tavallista liiallisten latauspyyntöjen takia. IP-Osoitteen esto tarkoittaa sitä, ettet voi käyttää YouTubea (vaikka olisit kirjautunut) vähintään 2-3kk aikana kyseiseltä laitteelta. Spotube ei kanna yhtään vastuuta jos se tapahtuu.';

  @override
  String get by_clicking_accept_terms =>
      'Painamalla \'hyväksy\' hyväksyt seuraaviin ehtoihin:';

  @override
  String get download_agreement_1 =>
      'Tiedän että Piratoin musiikkia. Olen paha.';

  @override
  String get download_agreement_2 =>
      'Tuen Artisteja silloin kun pystyn, ja teen tämän vain koska minulla ei ole rahaa ostaa heidän taidetta';

  @override
  String get download_agreement_3 =>
      'Ymmärrän että minun YouTube voi estää IP-Osoitteeni ja en pidä Spotubea tai omistajiinsa/avustajia vastuullisena mistään omista teoistsani';

  @override
  String get decline => 'Hylkää';

  @override
  String get accept => 'Hyväksy';

  @override
  String get details => 'Yksityiskohdat';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => 'Kanava';

  @override
  String get likes => 'Tykkäykset';

  @override
  String get dislikes => 'Epä-tykkäykset';

  @override
  String get views => 'Näyttökerrat';

  @override
  String get streamUrl => 'Suoratoiston URL';

  @override
  String get stop => 'Lopeta';

  @override
  String get sort_newest => 'Suodata uusimmista';

  @override
  String get sort_oldest => 'Suodata vanhimmista';

  @override
  String get sleep_timer => 'Uniajastin';

  @override
  String mins(Object minutes) {
    return '$minutes Minuuttia';
  }

  @override
  String hours(Object hours) {
    return '$hours Tuntia';
  }

  @override
  String hour(Object hours) {
    return '$hours Tunti';
  }

  @override
  String get custom_hours => 'Mukautetut tunnit';

  @override
  String get logs => 'Lokit';

  @override
  String get developers => 'Kehittäjät';

  @override
  String get not_logged_in => 'Et ole kirjautunut sisään.';

  @override
  String get search_mode => 'Hakutila';

  @override
  String get audio_source => 'Äänilähde';

  @override
  String get ok => 'Ok';

  @override
  String get failed_to_encrypt => 'Salaaminen epäonnistui';

  @override
  String get encryption_failed_warning =>
      'Spotube käyttää salausta tallentaakseen tietosi, mutta epäonnistui, joten se palaa epäturvalliseen tallennukseen\nJos käytät Linuxia, varmista että sinulla on turvallisuuspalvelu (gnome-keyring, kde-wallet, keepassxc jne) asennettu';

  @override
  String get querying_info => 'Hankitaan tietoa...';

  @override
  String get piped_api_down => 'Johdettu palvelinesiintymä on alhaalla';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return 'Johdettu palvelinesiintymä $pipedInstance on alhaalla.\n\nVaihda joko ilmeytymä tia vahda \'API tyyppi\' YouTuben viralliseen API\n\nKäynnistä sovellus uudestaan vaihdon jälkeen';
  }

  @override
  String get you_are_offline => 'Et ole yhdistetty verkkoon';

  @override
  String get connection_restored => 'Verkkoyhteys palautettu';

  @override
  String get use_system_title_bar => 'Käytä järjestelmäpalkkia';

  @override
  String get crunching_results => 'Paloitellaan tuloksia...';

  @override
  String get search_to_get_results => 'Hae saadakseen tuloksia';

  @override
  String get use_amoled_mode => 'Pilkkopimeä tumma teema';

  @override
  String get pitch_dark_theme => 'AMOLED Tila';

  @override
  String get normalize_audio => 'Normalisoi audio';

  @override
  String get change_cover => 'Vaihda koveri';

  @override
  String get add_cover => 'Lisää koveri';

  @override
  String get restore_defaults => 'Palauta oletukset';

  @override
  String get download_music_format => 'Musiikin latausmuoto';

  @override
  String get streaming_music_format => 'Musiikin suoratoistomuoto';

  @override
  String get download_music_quality => 'Musiikin latauslaatu';

  @override
  String get streaming_music_quality => 'Musiikin suoratoistolaadun';

  @override
  String get login_with_lastfm => 'Kirjaudu sisään Last.fm:llä';

  @override
  String get connect => 'Yhdistä';

  @override
  String get disconnect_lastfm => 'Katkaise Last.fm';

  @override
  String get disconnect => 'Katkaise';

  @override
  String get username => 'Käyttäjänimi';

  @override
  String get password => 'Salasana';

  @override
  String get login => 'Kirjaudu';

  @override
  String get login_with_your_lastfm => 'Kirjaudu Last.fm käyttäjälläsi';

  @override
  String get scrobble_to_lastfm => 'Scrobble Last.fm:ään';

  @override
  String get go_to_album => 'Mene albumiin';

  @override
  String get discord_rich_presence => 'Discord Rich Presence';

  @override
  String get browse_all => 'Selaa kaikki';

  @override
  String get genres => 'Genret';

  @override
  String get explore_genres => 'Seikkaile genrejä';

  @override
  String get friends => 'Kaverit';

  @override
  String get no_lyrics_available =>
      'Anteeksi, emme löytäneet lyriikoita tälle laululle';

  @override
  String get start_a_radio => 'Aloita Radio';

  @override
  String get how_to_start_radio => 'Kuinka haluat aloittaa radion?';

  @override
  String get replace_queue_question =>
      'Haluatko korvata nykyisen jonon vai lisätä siihen?';

  @override
  String get endless_playback => 'Loputon toisto';

  @override
  String get delete_playlist => 'Poista soittolista';

  @override
  String get delete_playlist_confirmation =>
      'Oletko varma että haluat poistaa tämän soittolistan?';

  @override
  String get local_tracks => 'Paikalliset kappaleet';

  @override
  String get local_tab => 'Paikallinen';

  @override
  String get song_link => 'Laulun linkki';

  @override
  String get skip_this_nonsense => 'Ohita tämä hölynpöly';

  @override
  String get freedom_of_music => '“Musiikin vapaus”';

  @override
  String get freedom_of_music_palm => '“Musiikin vapaus käsissäsi”';

  @override
  String get get_started => 'Aloitetaan';

  @override
  String get youtube_source_description => 'Suositeltu ja toimii parhaiten.';

  @override
  String get piped_source_description =>
      'Tuntuuko vapaalta? Sama kuin YouTube mutta paljon vapautta';

  @override
  String get jiosaavn_source_description => 'Paras Etelä-Aasian alueelle.';

  @override
  String get invidious_source_description =>
      'Samankaltainen kuin Piped, mutta korkeammalla saatavuudella';

  @override
  String highest_quality(Object quality) {
    return 'Korkein laatu: $quality';
  }

  @override
  String get select_audio_source => 'Valitse äänilähde';

  @override
  String get endless_playback_description =>
      'Lisää automaattisesti uusia lauluja\njonon perään';

  @override
  String get choose_your_region => 'Valitse alueesi';

  @override
  String get choose_your_region_description =>
      'Tämä auttaa Spotube näyttämään sinulle oikeaa sisältöä\nsijaintiasi varten.';

  @override
  String get choose_your_language => 'Valitse kielesi';

  @override
  String get help_project_grow => 'Auta tätä projektia kasvamaan';

  @override
  String get help_project_grow_description =>
      'Spotube projekti minkä lähdekoodi on julkisesti saatavilla. Voit autta tätä projektia kasvamaan muutoksilla, ilmoittamalla bugeista, tai ehdottamalla uusia ominaisuuksia.';

  @override
  String get contribute_on_github => 'Auta GitHub:ssa';

  @override
  String get donate_on_open_collective => 'Lahjoita avoimessa kollektiivissa';

  @override
  String get browse_anonymously => 'Selaa anonyyminä';

  @override
  String get enable_connect => 'Ota käyttöön yhdistäminen';

  @override
  String get enable_connect_description => 'Ohjaa Spotubea toiselta laitteelta';

  @override
  String get devices => 'Laitteet';

  @override
  String get select => 'Valitse';

  @override
  String connect_client_alert(Object client) {
    return '$client ohjaa sinua';
  }

  @override
  String get this_device => 'Tämä laite';

  @override
  String get remote => 'Etä';

  @override
  String get stats => 'Tilastot';

  @override
  String and_n_more(Object count) {
    return 'ja $count lisää';
  }

  @override
  String get recently_played => 'Äskettäin soitetut';

  @override
  String get browse_more => 'Selaa lisää';

  @override
  String get no_title => 'Ei otsikkoa';

  @override
  String get not_playing => 'Ei soi';

  @override
  String get epic_failure => 'Epäonnistuminen!';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return 'Lisätty $tracks_length kappaletta jonoon';
  }

  @override
  String get spotube_has_an_update => 'Spotubella on päivitys';

  @override
  String get download_now => 'Lataa nyt';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Spotube Nightly $nightlyBuildNum on julkaistu';
  }

  @override
  String release_version(Object version) {
    return 'Spotube v$version on julkaistu';
  }

  @override
  String get read_the_latest => 'Lue viimeisimmät';

  @override
  String get release_notes => 'julkaisumuistiinpanot';

  @override
  String get pick_color_scheme => 'Valitse värimaailma';

  @override
  String get save => 'Tallenna';

  @override
  String get choose_the_device => 'Valitse laite:';

  @override
  String get multiple_device_connected =>
      'Useita laitteita on kytketty.\nValitse laite, jossa haluat toiminnon suorittaa';

  @override
  String get nothing_found => 'Ei tuloksia';

  @override
  String get the_box_is_empty => 'Laatikko on tyhjä';

  @override
  String get top_artists => 'Suosituimmat artistit';

  @override
  String get top_albums => 'Suosituimmat albumit';

  @override
  String get this_week => 'Tällä viikolla';

  @override
  String get this_month => 'Tässä kuussa';

  @override
  String get last_6_months => 'Viimeiset 6 kuukautta';

  @override
  String get this_year => 'Tänä vuonna';

  @override
  String get last_2_years => 'Viimeiset 2 vuotta';

  @override
  String get all_time => 'Kaikki ajat';

  @override
  String powered_by_provider(Object providerName) {
    return 'Tuottanut $providerName';
  }

  @override
  String get email => 'Sähköposti';

  @override
  String get profile_followers => 'Seuraajat';

  @override
  String get birthday => 'Syntymäpäivä';

  @override
  String get subscription => 'Tilaus';

  @override
  String get not_born => 'Ei syntynyt';

  @override
  String get hacker => 'Hakkeri';

  @override
  String get profile => 'Profiili';

  @override
  String get no_name => 'Ei nimeä';

  @override
  String get edit => 'Muokkaa';

  @override
  String get user_profile => 'Käyttäjäprofiili';

  @override
  String count_plays(Object count) {
    return '$count toistoa';
  }

  @override
  String get streaming_fees_hypothetical =>
      'Suoratoiston maksut (hypoteettinen)';

  @override
  String get minutes_listened => 'Kuunneltuja minuutteja';

  @override
  String get streamed_songs => 'Suoratoistettuja kappaleita';

  @override
  String count_streams(Object count) {
    return '$count suoratoistoa';
  }

  @override
  String get owned_by_you => 'Sinun omistama';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return '$shareUrl kopioitu leikepöydälle';
  }

  @override
  String get hipotetical_calculation =>
      '*Tämä on laskettu keskimääräisen musiikin suoratoistopalvelun 0,003–0,005 dollarin kappalekohtaisen maksun perusteella. Tämä on hypoteettinen laskelma, joka antaa käyttäjälle käsityksen siitä, kuinka paljon he olisivat maksaneet artisteille, jos he kuuntelisivat heidän kappaleitaan eri musiikin suoratoistopalveluissa.';

  @override
  String count_mins(Object minutes) {
    return '$minutes min';
  }

  @override
  String get summary_minutes => 'minuuttia';

  @override
  String get summary_listened_to_music => 'Kuunneltu musiikkia';

  @override
  String get summary_songs => 'kappaletta';

  @override
  String get summary_streamed_overall => 'Suoratoistettu yhteensä';

  @override
  String get summary_owed_to_artists => 'Maksettava artisteille\nTässä kuussa';

  @override
  String get summary_artists => 'artisti';

  @override
  String get summary_music_reached_you => 'Musiikki saavutti sinut';

  @override
  String get summary_full_albums => 'täydet albumit';

  @override
  String get summary_got_your_love => 'Sai rakkautesi';

  @override
  String get summary_playlists => 'soittolistat';

  @override
  String get summary_were_on_repeat => 'Olivat toistossa';

  @override
  String total_money(Object money) {
    return 'Yhteensä $money';
  }

  @override
  String get webview_not_found => 'Webview ei löydy';

  @override
  String get webview_not_found_description =>
      'Laitteellasi ei ole asennettua Webview-ajonaikaa.\nJos se on asennettu, varmista, että se on environment PATH:ssa\n\nAsennuksen jälkeen käynnistä sovellus uudelleen';

  @override
  String get unsupported_platform => 'Ei tuettu alusta';

  @override
  String get cache_music => 'Musiikki välimuistissa';

  @override
  String get open => 'Avaa';

  @override
  String get cache_folder => 'Välimuistikansio';

  @override
  String get export => 'Vie';

  @override
  String get clear_cache => 'Tyhjennä välimuisti';

  @override
  String get clear_cache_confirmation => 'Haluatko tyhjentää välimuistin?';

  @override
  String get export_cache_files => 'Vie välimuistitiedostot';

  @override
  String found_n_files(Object count) {
    return 'Löydettiin $count tiedostoa';
  }

  @override
  String get export_cache_confirmation => 'Haluatko viedä nämä tiedostot';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return 'Vietiin $filesExported/$files tiedostoa';
  }

  @override
  String get undo => 'Peruuta';

  @override
  String get download_all => 'Lataa kaikki';

  @override
  String get add_all_to_playlist => 'Lisää kaikki soittolistalle';

  @override
  String get add_all_to_queue => 'Lisää kaikki jonoon';

  @override
  String get play_all_next => 'Toista kaikki seuraavaksi';

  @override
  String get pause => 'Pysäytä';

  @override
  String get view_all => 'Näytä kaikki';

  @override
  String get no_tracks_added_yet =>
      'Näyttää siltä, että et ole lisännyt vielä mitään kappaleita.';

  @override
  String get no_tracks => 'Näyttää siltä, että täällä ei ole kappaleita.';

  @override
  String get no_tracks_listened_yet =>
      'Näyttää siltä, että et ole kuunnellut mitään vielä.';

  @override
  String get not_following_artists => 'Et seuraa yhtään artistia.';

  @override
  String get no_favorite_albums_yet =>
      'Näyttää siltä, että et ole lisännyt yhtään albumia suosikkeihisi.';

  @override
  String get no_logs_found => 'Ei lokitietoja löydetty';

  @override
  String get youtube_engine => 'YouTube-moottori';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engine ei ole asennettu';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engine ei ole asennettu järjestelmääsi.';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return 'Varmista, että se on saatavilla PATH-muuttujassa tai\nasetetaan $engine suoritettavan tiedoston absoluuttinen polku alla.';
  }

  @override
  String get youtube_engine_unix_issue_message =>
      'macOS/Linux/unix-tyyppisissä käyttöjärjestelmissä polun asettaminen .zshrc/.bashrc/.bash_profile jne. ei toimi.\nSinun täytyy asettaa polku shellin asetustiedostoon.';

  @override
  String get download => 'Lataa';

  @override
  String get file_not_found => 'Tiedostoa ei löydy';

  @override
  String get custom => 'Mukautettu';

  @override
  String get add_custom_url => 'Lisää mukautettu URL';

  @override
  String get edit_port => 'Muokkaa porttia';

  @override
  String get port_helper_msg =>
      'Oletusarvo on -1, mikä tarkoittaa satunnaista numeroa. Jos sinulla on palomuuri määritetty, tämän asettamista suositellaan.';

  @override
  String connect_request(Object client) {
    return 'Salli $client yhdistää?';
  }

  @override
  String get connection_request_denied =>
      'Yhteys evätty. Käyttäjä eväsi pääsyn.';

  @override
  String get an_error_occurred => 'Tapahtui virhe';

  @override
  String get copy_to_clipboard => 'Kopioi leikepöydälle';

  @override
  String get view_logs => 'Näytä lokit';

  @override
  String get retry => 'Yritä uudelleen';

  @override
  String get no_default_metadata_provider_selected =>
      'Et ole asettanut oletusmetatietojen tarjoajaa';

  @override
  String get manage_metadata_providers => 'Hallinnoi metatietojen tarjoajia';

  @override
  String get open_link_in_browser => 'Avaa linkki selaimessa?';

  @override
  String get do_you_want_to_open_the_following_link =>
      'Haluatko avata seuraavan linkin';

  @override
  String get unsafe_url_warning =>
      'Linkkien avaaminen epäluotettavista lähteistä voi olla vaarallista. Ole varovainen!\nVoit myös kopioida linkin leikepöydälle.';

  @override
  String get copy_link => 'Kopioi linkki';

  @override
  String get building_your_timeline =>
      'Rakennetaan aikajanaasi kuuntelujesi perusteella...';

  @override
  String get official => 'Virallinen';

  @override
  String author_name(Object author) {
    return 'Tekijä: $author';
  }

  @override
  String get third_party => 'Kolmannen osapuolen';

  @override
  String get plugin_requires_authentication => 'Lisäosa vaatii todentamisen';

  @override
  String get update_available => 'Päivitys saatavilla';

  @override
  String get supports_scrobbling => 'Tukee scrobblingia';

  @override
  String get plugin_scrobbling_info =>
      'Tämä lisäosa scrobblaa musiikkisi luodakseen kuunteluhistoriasi.';

  @override
  String get default_metadata_source => 'Oletusarvoinen metatietolähde';

  @override
  String get set_default_metadata_source => 'Aseta oletusmetatietolähde';

  @override
  String get default_audio_source => 'Oletusarvoinen äänilähde';

  @override
  String get set_default_audio_source => 'Aseta oletusäänilähde';

  @override
  String get set_default => 'Aseta oletukseksi';

  @override
  String get support => 'Tuki';

  @override
  String get support_plugin_development => 'Tue lisäosan kehitystä';

  @override
  String can_access_name_api(Object name) {
    return '- Voi käyttää **$name** APIa';
  }

  @override
  String get do_you_want_to_install_this_plugin =>
      'Haluatko asentaa tämän lisäosan?';

  @override
  String get third_party_plugin_warning =>
      'Tämä lisäosa on kolmannen osapuolen arkistosta. Varmista, että luotat lähteeseen ennen asennusta.';

  @override
  String get author => 'Tekijä';

  @override
  String get this_plugin_can_do_following => 'Tämä lisäosa voi tehdä seuraavaa';

  @override
  String get install => 'Asenna';

  @override
  String get install_a_metadata_provider => 'Asenna metatietojen tarjoaja';

  @override
  String get no_tracks_playing => 'Ei kappaletta toistossa tällä hetkellä';

  @override
  String get synced_lyrics_not_available =>
      'Synkronoidut sanoitukset eivät ole saatavilla tälle kappaleelle. Käytä sen sijaan';

  @override
  String get plain_lyrics => 'Pelkät sanoitukset';

  @override
  String get tab_instead => 'välilehteä.';

  @override
  String get disclaimer => 'Vastuuvapauslauseke';

  @override
  String get third_party_plugin_dmca_notice =>
      'Spotube-tiimi ei ota mitään vastuuta (mukaan lukien oikeudellinen) mistään \"kolmannen osapuolen\" lisäosista.\nKäytä niitä omalla vastuullasi. Ilmoita kaikista virheistä/ongelmista lisäosan arkistoon.\n\nJos jokin \"kolmannen osapuolen\" lisäosa rikkoo jonkin palvelun/oikeushenkilön käyttöehtoja/DMCA:ta, pyydä \"kolmannen osapuolen\" lisäosan tekijää tai isännöintialustaa, esim. GitHubia/Codebergiä, ryhtymään toimiin. Yllä luetellut (\"kolmannen osapuolen\" merkityt) ovat kaikki julkisia/yhteisön ylläpitämiä lisäosia. Emme kuratoi niitä, joten emme voi ryhtyä niihin toimiin.\n\n';

  @override
  String get input_does_not_match_format => 'Syöte ei vastaa vaadittua muotoa';

  @override
  String get plugins => 'Laajennukset';

  @override
  String get paste_plugin_download_url =>
      'Liitä lataus-URL-osoite tai GitHub/Codeberg-arkiston URL-osoite tai suora linkki .smplug-tiedostoon';

  @override
  String get download_and_install_plugin_from_url =>
      'Lataa ja asenna lisäosa URL-osoitteesta';

  @override
  String failed_to_add_plugin_error(Object error) {
    return 'Lisäosan lisääminen epäonnistui: $error';
  }

  @override
  String get upload_plugin_from_file => 'Lataa lisäosa tiedostosta';

  @override
  String get installed => 'Asennettu';

  @override
  String get available_plugins => 'Saatavilla olevat lisäosat';

  @override
  String get configure_plugins =>
      'Määritä omat metatietojen tarjoaja- ja äänilähdelaajennukset';

  @override
  String get audio_scrobblers => 'Äänen scrobblerit';

  @override
  String get scrobbling => 'Scrobbling';

  @override
  String get source => 'Lähde: ';

  @override
  String get uncompressed => 'Pakkaamaton';

  @override
  String get dab_music_source_description =>
      'Audiofiileille. Tarjoaa korkealaatuisia/häviöttömiä äänivirtoja. Tarkka ISRC-pohjainen kappaleiden tunnistus.';
}
