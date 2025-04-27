// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get guest => 'Gość';

  @override
  String get browse => 'Przeglądaj';

  @override
  String get search => 'Szukaj';

  @override
  String get library => 'Biblioteka';

  @override
  String get lyrics => 'Tekst utworu';

  @override
  String get settings => 'Ustawienia';

  @override
  String get genre_categories_filter => 'Filtruj kategorie lub gatunki...';

  @override
  String get genre => 'Gatunki';

  @override
  String get personalized => 'Spersonalizowane';

  @override
  String get featured => 'Wyróżnione';

  @override
  String get new_releases => 'Nowo wydane';

  @override
  String get songs => 'Utwory';

  @override
  String playing_track(Object track) {
    return 'Odtwarzanie $track';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return 'To spowoduje wyczyszczenie całej kolejki! $track_length pozycji zostanie usuniętych.\nCzy chcesz kontynuować?';
  }

  @override
  String get load_more => 'Załaduj więcej';

  @override
  String get playlists => 'Playlisty';

  @override
  String get artists => 'Artyści';

  @override
  String get albums => 'Albumy';

  @override
  String get tracks => 'Utwory';

  @override
  String get downloads => 'Pobrane';

  @override
  String get filter_playlists => 'Filtruj swoje playlisty...';

  @override
  String get liked_tracks => 'Ulubione utwory';

  @override
  String get liked_tracks_description => 'Wszystkie twoje ulubione utwory';

  @override
  String get playlist => 'Playlista';

  @override
  String get create_a_playlist => 'Utwórz playlistę';

  @override
  String get update_playlist => 'Zaktualizuj playlistę';

  @override
  String get create => 'Utwórz';

  @override
  String get cancel => 'Anuluj';

  @override
  String get update => 'Aktualizuj';

  @override
  String get playlist_name => 'Nazwa playlisty';

  @override
  String get name_of_playlist => 'Nazwa playlisty';

  @override
  String get description => 'Opis';

  @override
  String get public => 'Publiczny';

  @override
  String get collaborative => 'Współpraca';

  @override
  String get search_local_tracks => 'Szukanie lokalnych utworów...';

  @override
  String get play => 'Odtwórz';

  @override
  String get delete => 'Usuń';

  @override
  String get none => 'Brak';

  @override
  String get sort_a_z => 'Sortuj od A do Z';

  @override
  String get sort_z_a => 'Sortuj od Z do A';

  @override
  String get sort_artist => 'Sortuj po Artyście';

  @override
  String get sort_album => 'Sortuj po Albumie';

  @override
  String get sort_duration => 'Sortuj według Czasu Trwania';

  @override
  String get sort_tracks => 'Sortuj Utwory';

  @override
  String currently_downloading(Object tracks_length) {
    return 'Obecnie pobieram $tracks_length utworów.';
  }

  @override
  String get cancel_all => 'Anuluj wszystkie';

  @override
  String get filter_artist => 'Filtruj artystów...';

  @override
  String followers(Object followers) {
    return '$followers obserwujących';
  }

  @override
  String get add_artist_to_blacklist => 'Dodaj artystę do czarnej listy';

  @override
  String get top_tracks => 'Popularne Utwory';

  @override
  String get fans_also_like => 'Fani lubią także';

  @override
  String get loading => 'Ładowanie...';

  @override
  String get artist => 'Artysta';

  @override
  String get blacklisted => 'Dodano do czarnej listy';

  @override
  String get following => 'Obserwujesz';

  @override
  String get follow => 'Zaobserwuj';

  @override
  String get artist_url_copied => 'Skopiowano URL artysty do schowka';

  @override
  String added_to_queue(Object tracks) {
    return 'Dodano $tracks utworów do kolejki';
  }

  @override
  String get filter_albums => 'Filtruj albumy...';

  @override
  String get synced => 'Zsynchronizowano';

  @override
  String get plain => 'Zwykły';

  @override
  String get shuffle => 'Losowe odtwarzanie';

  @override
  String get search_tracks => 'Szukam utworu...';

  @override
  String get released => 'Wydano';

  @override
  String error(Object error) {
    return 'Błąd $error';
  }

  @override
  String get title => 'Tytuł';

  @override
  String get time => 'Czas';

  @override
  String get more_actions => 'Więcej akcji';

  @override
  String download_count(Object count) {
    return 'Pobrane ($count)';
  }

  @override
  String add_count_to_playlist(Object count) {
    return 'Dodaj ($count) do Playlisty';
  }

  @override
  String add_count_to_queue(Object count) {
    return 'Dodaj ($count) do Kolejki';
  }

  @override
  String play_count_next(Object count) {
    return 'Odtwórz ($count) następne';
  }

  @override
  String get album => 'Album';

  @override
  String copied_to_clipboard(Object data) {
    return 'Skopiowano $data do schowka';
  }

  @override
  String add_to_following_playlists(Object track) {
    return 'Dodano $track do danych Playlist';
  }

  @override
  String get add => 'Dodaj';

  @override
  String added_track_to_queue(Object track) {
    return 'Dodano $track do kolejki';
  }

  @override
  String get add_to_queue => 'Dodano do kolejki';

  @override
  String track_will_play_next(Object track) {
    return '$track następny';
  }

  @override
  String get play_next => 'Odtwórz następny';

  @override
  String removed_track_from_queue(Object track) {
    return 'Usunięto $track z kolejki';
  }

  @override
  String get remove_from_queue => 'Usunięto z kolejki';

  @override
  String get remove_from_favorites => 'Usunięto z ulubionych';

  @override
  String get save_as_favorite => 'Zapisz do ulubionych';

  @override
  String get add_to_playlist => 'Dodaj do playlisty';

  @override
  String get remove_from_playlist => 'Usuń z playlisty';

  @override
  String get add_to_blacklist => 'Dodaj do czarnej listy';

  @override
  String get remove_from_blacklist => 'Usuń z czarnej listy';

  @override
  String get share => 'Udostępnij';

  @override
  String get mini_player => 'Mały odwarzacz';

  @override
  String get slide_to_seek => 'Przesuń, aby przewinąć do przodu lub do tyłu.';

  @override
  String get shuffle_playlist => 'Odtwarzaj losowo z playlisty';

  @override
  String get unshuffle_playlist => 'Nie odtwarzaj losowo z playlisty';

  @override
  String get previous_track => 'Poprzedni utwór';

  @override
  String get next_track => 'Następny utwór';

  @override
  String get pause_playback => 'Zatrzymaj odwarzanie';

  @override
  String get resume_playback => 'Wznów odwarzanie';

  @override
  String get loop_track => 'Zapętl utwór';

  @override
  String get no_loop => 'Brak pętli';

  @override
  String get repeat_playlist => 'Powtarzaj playlistę';

  @override
  String get queue => 'Kolejka';

  @override
  String get alternative_track_sources => 'Alternatywne źródła utworów';

  @override
  String get download_track => 'Pobierz utwór';

  @override
  String tracks_in_queue(Object tracks) {
    return '$tracks utworów w kolejce';
  }

  @override
  String get clear_all => 'Wyczyść wszystko';

  @override
  String get show_hide_ui_on_hover => 'Pokaż/Ukryj unoszący się interfejs';

  @override
  String get always_on_top => 'Zawsze na wierzchu';

  @override
  String get exit_mini_player => 'Opuść Mały odtwarzacz';

  @override
  String get download_location => 'Zmień lokalizację';

  @override
  String get local_library => 'Biblioteka lokalna';

  @override
  String get add_library_location => 'Dodaj do biblioteki';

  @override
  String get remove_library_location => 'Usuń z biblioteki';

  @override
  String get account => 'Konto';

  @override
  String get login_with_spotify => 'Zaloguj się używając konta Spotify';

  @override
  String get connect_with_spotify => 'Połącz z Spotify';

  @override
  String get logout => 'Wyloguj';

  @override
  String get logout_of_this_account => 'Wyloguj z tego konta';

  @override
  String get language_region => 'Język i Region';

  @override
  String get language => 'Język';

  @override
  String get system_default => 'Domyślny systemowy';

  @override
  String get market_place_region => 'Region Rynku';

  @override
  String get recommendation_country => 'Kraj rekomendacji';

  @override
  String get appearance => 'Wygląd';

  @override
  String get layout_mode => 'Tryb Układu';

  @override
  String get override_layout_settings => 'Nadpisz responsywne ustawienia trybu układu';

  @override
  String get adaptive => 'Adaptacyjny';

  @override
  String get compact => 'Kompaktowy';

  @override
  String get extended => 'Rozszerzony';

  @override
  String get theme => 'Motyw';

  @override
  String get dark => 'Ciemny';

  @override
  String get light => 'Jasny';

  @override
  String get system => 'Systemowy';

  @override
  String get accent_color => 'Kolor Akcentu';

  @override
  String get sync_album_color => 'Synchronizuj kolor albumu';

  @override
  String get sync_album_color_description => 'Używa dominującego koloru okładki albumu jako koloru akcentującego';

  @override
  String get playback => 'Odtwarzanie';

  @override
  String get audio_quality => 'Jakość dźwięku';

  @override
  String get high => 'Duża';

  @override
  String get low => 'Mała';

  @override
  String get pre_download_play => 'Wstępnie pobierz i odtwórz';

  @override
  String get pre_download_play_description => 'Zamiast przesyłać strumieniowo dźwięk, pobiera odpowiedni bufor i odtwarza (zalecane dla użytkowników o większej przepustowości)';

  @override
  String get skip_non_music => 'Pomiń nie-muzyczne segmenty (SponsorBlock)';

  @override
  String get blacklist_description => 'Czarna lista utworów i artystów';

  @override
  String get wait_for_download_to_finish => 'Proszę poczekać na zakończenie obecnego pobierania.';

  @override
  String get desktop => 'Pulpit';

  @override
  String get close_behavior => 'Zamknij';

  @override
  String get close => 'Zamknij';

  @override
  String get minimize_to_tray => 'Zminimalizuj do zasobnika';

  @override
  String get show_tray_icon => 'Pokazuj ikonę w zasobniku';

  @override
  String get about => 'O projekcie';

  @override
  String get u_love_spotube => 'Wiemy jak kochacie Spotube';

  @override
  String get check_for_updates => 'Sprawdź aktualizacje';

  @override
  String get about_spotube => 'O Spotube';

  @override
  String get blacklist => 'Czarna lista';

  @override
  String get please_sponsor => 'Proszę wesprzyj projekt';

  @override
  String get spotube_description => 'Spotube, lekki, wieloplatformowy, darmowy dla wszystkich klient Spotify';

  @override
  String get version => 'Wersja';

  @override
  String get build_number => 'Numer Build\'a';

  @override
  String get founder => 'Twórca Założyciel';

  @override
  String get repository => 'Repozytorium';

  @override
  String get bug_issues => 'Błędy i propozycje';

  @override
  String get made_with => 'Stworzono z ❤️ w Bangladesh\'u 🇧🇩';

  @override
  String get kingkor_roy_tirtho => 'Kingkor Roy Tirtho';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year Kingkor Roy Tirtho';
  }

  @override
  String get license => 'Licencja';

  @override
  String get add_spotify_credentials => 'Dodaj swoje dane logowania Spotify, aby zacząć';

  @override
  String get credentials_will_not_be_shared_disclaimer => 'Nie martw się, żadne dane logowania nie są zbierane ani udostępniane nikomu';

  @override
  String get know_how_to_login => 'Nie wiesz, jak się zalogować?';

  @override
  String get follow_step_by_step_guide => 'Postępuj zgodnie z poradnikiem krok po kroku';

  @override
  String spotify_cookie(Object name) {
    return 'Spotify $name Ciasteczko';
  }

  @override
  String cookie_name_cookie(Object name) {
    return '$name Ciasteczko';
  }

  @override
  String get fill_in_all_fields => 'Proszę wypełnić wszystkie pola';

  @override
  String get submit => 'Zatwierdź';

  @override
  String get exit => 'Zamknij';

  @override
  String get previous => 'Poprzedni';

  @override
  String get next => 'Następny';

  @override
  String get done => 'Gotowe 🙂';

  @override
  String get step_1 => 'Krok 1';

  @override
  String get first_go_to => 'Po pierwsze przejdź do';

  @override
  String get login_if_not_logged_in => 'i Zaloguj się/Zarejestruj jeśli nie jesteś zalogowany';

  @override
  String get step_2 => 'Krok 2';

  @override
  String get step_2_steps => '1. Jeśli jesteś zalogowany, naciśnij klawisz F12 lub Kliknij prawym przyciskiem myszy > Zbadaj, aby odtworzyć narzędzia developerskie.\n2. Następnie przejdź do zakładki \"Application\" (Chrome, Edge, Brave etc..) lub zakładki \"Storage\" (Firefox, Palemoon etc..)\n3. Przejdź do sekcji \"Cookies\" a następnie do pod-sekcji \"https://accounts.spotify.com\"';

  @override
  String get step_3 => 'Krok 3';

  @override
  String get step_3_steps => 'Skopiuj wartość ciasteczka \"sp_dc\"';

  @override
  String get success_emoji => 'Sukces!🥳';

  @override
  String get success_message => 'Udało ci się zalogować! Dobra robota, stary!';

  @override
  String get step_4 => 'Krok 4';

  @override
  String get step_4_steps => 'Wklej skopiowaną wartość \"sp_dc\"';

  @override
  String get something_went_wrong => 'Coś poszło nie tak 🙁';

  @override
  String get piped_instance => 'Instancja serwera Piped';

  @override
  String get piped_description => 'Instancja serwera Piped używana jest do dopasowania utworów.';

  @override
  String get piped_warning => 'Niektóre z nich mogą nie działać. Używasz na własną odpowiedzialność!';

  @override
  String get invidious_instance => 'Instancja serwera Invidious';

  @override
  String get invidious_description => 'Instancja serwera Invidious do dopasowywania utworów';

  @override
  String get invidious_warning => 'Niektóre z nich mogą nie działać dobrze. Używaj na własne ryzyko';

  @override
  String get generate => 'Generuj';

  @override
  String track_exists(Object track) {
    return 'Utwór $track już istnieje';
  }

  @override
  String get replace_downloaded_tracks => 'Zamień wszystkie pobrane utwory';

  @override
  String get skip_download_tracks => 'Pomiń pobieranie wszystkich pobranych utworów';

  @override
  String get do_you_want_to_replace => 'Chcesz zamienić istniejący utwór ??';

  @override
  String get replace => 'Zamień';

  @override
  String get skip => 'Pomiń';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return 'Wybierz do $count $type';
  }

  @override
  String get select_genres => 'Wybierz Gatunki';

  @override
  String get add_genres => 'Dodaj Gatunki';

  @override
  String get country => 'Kraj';

  @override
  String get number_of_tracks_generate => 'Liczba utworów do wygenerowania';

  @override
  String get acousticness => 'Akustyczna';

  @override
  String get danceability => 'Taneczna';

  @override
  String get energy => 'Energiczna';

  @override
  String get instrumentalness => 'Instrumentalna';

  @override
  String get liveness => 'Żywa';

  @override
  String get loudness => 'Głośna';

  @override
  String get speechiness => 'Wymowna';

  @override
  String get valence => 'Wartościowa';

  @override
  String get popularity => 'Popularność';

  @override
  String get key => 'Kluczowa';

  @override
  String get duration => 'Długość (s)';

  @override
  String get tempo => 'Tempo (BPM)';

  @override
  String get mode => 'Tryb';

  @override
  String get time_signature => 'Sygnatura Czasowa';

  @override
  String get short => 'Krótka';

  @override
  String get medium => 'Średnia';

  @override
  String get long => 'Długa';

  @override
  String get min => 'Minimalnie';

  @override
  String get max => 'Maksymalnie';

  @override
  String get target => 'Cel';

  @override
  String get moderate => 'Umiarkowanie';

  @override
  String get deselect_all => 'Odznacz wszystkie';

  @override
  String get select_all => 'Zaznacz wszystkie';

  @override
  String get are_you_sure => 'Jesteś pewny?';

  @override
  String get generating_playlist => 'Generowanie twojej własnej playlisty...';

  @override
  String selected_count_tracks(Object count) {
    return 'Wybrano $count utworów';
  }

  @override
  String get download_warning => 'Jeśli hurtowo pobierasz wszystkie utwory, wyraźnie piracisz muzykę i wyrządzasz szkody kreatywnej społeczności muzycznej. Mam nadzieję, że jesteś tego świadomy. Zawsze staraj się szanować i wspierać ciężką pracę Artysty';

  @override
  String get download_ip_ban_warning => 'Przy okazji, Twój adres IP może zostać zablokowany w YouTube z powodu nadmiernych żądań pobierania niż zwykle. Blokada IP oznacza, że nie możesz korzystać z YouTube (nawet jeśli jesteś zalogowany) przez co najmniej 2-3 miesiące z IP tego urządzenia. Spotube nie ponosi żadnej odpowiedzialności, jeśli tak się stanie';

  @override
  String get by_clicking_accept_terms => 'Klikając \'Akceptuj\' zgadzasz się z następującymi warunkami:';

  @override
  String get download_agreement_1 => 'Wiem, że piracę muzykę. Jestem zły.';

  @override
  String get download_agreement_2 => 'Będę wspierał artystę i robię to tylko dlatego, że nie mam pieniędzy na albumy wykonawcy. ';

  @override
  String get download_agreement_3 => 'Jestem całkowicie świadomy, że moje IP może zostać zablokowane w YouTube i nie pociągam Spotube ani jego właścicieli/współtwórców do odpowiedzialności za jakiekolwiek wypadki spowodowane moimi obecnymi działaniami';

  @override
  String get decline => 'Odrzuć';

  @override
  String get accept => 'Akceptuj';

  @override
  String get details => 'Szczegóły';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => 'Kanał';

  @override
  String get likes => 'Polubienia';

  @override
  String get dislikes => 'Nie lubi';

  @override
  String get views => 'Wyświetlenia';

  @override
  String get streamUrl => 'URL strumienia';

  @override
  String get stop => 'Stop';

  @override
  String get sort_newest => 'Sortuj według ostatnio dodanych';

  @override
  String get sort_oldest => 'Sortuj według najstarszych dodanych';

  @override
  String get sleep_timer => 'Minutnik';

  @override
  String mins(Object minutes) {
    return '$minutes Minuty';
  }

  @override
  String hours(Object hours) {
    return '$hours Godziny';
  }

  @override
  String hour(Object hours) {
    return '$hours Godzina';
  }

  @override
  String get custom_hours => 'Własne godziny';

  @override
  String get logs => 'Logi';

  @override
  String get developers => 'Developerzy';

  @override
  String get not_logged_in => 'Nie jesteś zalogowany';

  @override
  String get search_mode => 'Tryb szukania';

  @override
  String get audio_source => 'Źródło dźwięku';

  @override
  String get ok => 'Ok';

  @override
  String get failed_to_encrypt => 'Nie można zaszyfrować :(';

  @override
  String get encryption_failed_warning => 'Spotube używa szyfrowania do bezpiecznego przechowywania danych. Ale nie udało się tego zrobić. Więc powróci do niezabezpieczonego przechowywania\nJeśli używasz Linuksa, upewnij się, że masz zainstalowane jakieś usługi do szyfrowania (gnome-keyring, kde-wallet, keepassxc itp.)';

  @override
  String get querying_info => 'Szukam informacji...';

  @override
  String get piped_api_down => 'API Piped jest niedostępne';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return 'Instancja Piped $pipedInstance jest obecnie niedostępna\n\nZmień instancję lub zmień \'Rodzaj API\' na oficjalne API YouTube\n\nUpewnij się, że po zmianie zrestartujesz aplikację';
  }

  @override
  String get you_are_offline => 'Obecnie jesteś offline';

  @override
  String get connection_restored => 'Twoje połączenie z internetem zostało przywrócone';

  @override
  String get use_system_title_bar => 'Użyj paska tytułu systemu';

  @override
  String get crunching_results => 'Przetwarzanie wyników...';

  @override
  String get search_to_get_results => 'Szukaj, aby uzyskać wyniki';

  @override
  String get use_amoled_mode => 'Tryb AMOLED';

  @override
  String get pitch_dark_theme => 'Ciemny motyw';

  @override
  String get normalize_audio => 'Normalizuj dźwięk';

  @override
  String get change_cover => 'Zmień okładkę';

  @override
  String get add_cover => 'Dodaj okładkę';

  @override
  String get restore_defaults => 'Przywróć domyślne';

  @override
  String get download_music_codec => 'Pobierz kodek muzyczny';

  @override
  String get streaming_music_codec => 'Kodek strumieniowy muzyki';

  @override
  String get login_with_lastfm => 'Zaloguj się z Last.fm';

  @override
  String get connect => 'Połącz';

  @override
  String get disconnect_lastfm => 'Rozłącz z Last.fm';

  @override
  String get disconnect => 'Rozłącz';

  @override
  String get username => 'Nazwa użytkownika';

  @override
  String get password => 'Hasło';

  @override
  String get login => 'Zaloguj';

  @override
  String get login_with_your_lastfm => 'Zaloguj się na swoje konto Last.fm';

  @override
  String get scrobble_to_lastfm => 'Scrobbluj do Last.fm';

  @override
  String get go_to_album => 'Przejdź do albumu';

  @override
  String get discord_rich_presence => 'Obecność na Discordzie';

  @override
  String get browse_all => 'Przeglądaj wszystko';

  @override
  String get genres => 'Gatunki muzyczne';

  @override
  String get explore_genres => 'Eksploruj gatunki';

  @override
  String get friends => 'Przyjaciele';

  @override
  String get no_lyrics_available => 'Przepraszamy, nie można znaleźć tekstu dla tego utworu';

  @override
  String get start_a_radio => 'Uruchom radio';

  @override
  String get how_to_start_radio => 'Jak chcesz uruchomić radio?';

  @override
  String get replace_queue_question => 'Czy chcesz zastąpić bieżącą kolejkę czy dodać do niej?';

  @override
  String get endless_playback => 'Nieskończona Odtwarzanie';

  @override
  String get delete_playlist => 'Usuń Playlistę';

  @override
  String get delete_playlist_confirmation => 'Czy na pewno chcesz usunąć tę listę odtwarzania?';

  @override
  String get local_tracks => 'Lokalne Utwory';

  @override
  String get local_tab => 'Lokalny';

  @override
  String get song_link => 'Link do Utworu';

  @override
  String get skip_this_nonsense => 'Pomiń tę bzdurę';

  @override
  String get freedom_of_music => '“Wolność Muzyki”';

  @override
  String get freedom_of_music_palm => '“Wolność Muzyki w Twojej dłoni”';

  @override
  String get get_started => 'Zacznijmy';

  @override
  String get youtube_source_description => 'Polecane i działa najlepiej.';

  @override
  String get piped_source_description => 'Czujesz się wolny? To samo co YouTube, ale dużo za darmo.';

  @override
  String get jiosaavn_source_description => 'Najlepszy dla regionu Azji Południowej.';

  @override
  String get invidious_source_description => 'Podobne do Piped, ale o wyższej dostępności.';

  @override
  String highest_quality(Object quality) {
    return 'Najwyższa Jakość: $quality';
  }

  @override
  String get select_audio_source => 'Wybierz Źródło Audio';

  @override
  String get endless_playback_description => 'Automatycznie dodaj nowe utwory na koniec kolejki';

  @override
  String get choose_your_region => 'Wybierz swoją region';

  @override
  String get choose_your_region_description => 'To pomoże Spotube pokazać Ci odpowiednią treść dla Twojej lokalizacji.';

  @override
  String get choose_your_language => 'Wybierz swój język';

  @override
  String get help_project_grow => 'Pomóż temu projektowi rosnąć';

  @override
  String get help_project_grow_description => 'Spotube to projekt open-source. Możesz pomóc temu projektowi rosnąć, przyczyniając się do projektu, zgłaszając błędy lub sugerując nowe funkcje.';

  @override
  String get contribute_on_github => 'Przyczyniaj się na GitHubie';

  @override
  String get donate_on_open_collective => 'Dotuj na Open Collective';

  @override
  String get browse_anonymously => 'Przeglądaj Anonimowo';

  @override
  String get enable_connect => 'Włącz połączenie';

  @override
  String get enable_connect_description => 'Kontroluj Spotube z innych urządzeń';

  @override
  String get devices => 'Urządzenia';

  @override
  String get select => 'Wybierz';

  @override
  String connect_client_alert(Object client) {
    return 'Jesteś sterowany przez $client';
  }

  @override
  String get this_device => 'To urządzenie';

  @override
  String get remote => 'Zdalny';

  @override
  String get stats => 'Statystyki';

  @override
  String and_n_more(Object count) {
    return 'i $count więcej';
  }

  @override
  String get recently_played => 'Ostatnio odtwarzane';

  @override
  String get browse_more => 'Zobacz więcej';

  @override
  String get no_title => 'Brak tytułu';

  @override
  String get not_playing => 'Nie odtwarzane';

  @override
  String get epic_failure => 'Epicka porażka!';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return 'Dodano $tracks_length utworów do kolejki';
  }

  @override
  String get spotube_has_an_update => 'Spotube ma aktualizację';

  @override
  String get download_now => 'Pobierz teraz';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Spotube Nightly $nightlyBuildNum został wydany';
  }

  @override
  String release_version(Object version) {
    return 'Spotube v$version został wydany';
  }

  @override
  String get read_the_latest => 'Przeczytaj najnowsze ';

  @override
  String get release_notes => 'notatki o wersji';

  @override
  String get pick_color_scheme => 'Wybierz schemat kolorów';

  @override
  String get save => 'Zapisz';

  @override
  String get choose_the_device => 'Wybierz urządzenie:';

  @override
  String get multiple_device_connected => 'Jest wiele urządzeń podłączonych.\nWybierz urządzenie, na którym chcesz wykonać tę akcję';

  @override
  String get nothing_found => 'Nic nie znaleziono';

  @override
  String get the_box_is_empty => 'Pudełko jest puste';

  @override
  String get top_artists => 'Najlepsi artyści';

  @override
  String get top_albums => 'Najlepsze albumy';

  @override
  String get this_week => 'W tym tygodniu';

  @override
  String get this_month => 'W tym miesiącu';

  @override
  String get last_6_months => 'Ostatnie 6 miesięcy';

  @override
  String get this_year => 'W tym roku';

  @override
  String get last_2_years => 'Ostatnie 2 lata';

  @override
  String get all_time => 'Wszystkie czasy';

  @override
  String powered_by_provider(Object providerName) {
    return 'Napędzane przez $providerName';
  }

  @override
  String get email => 'E-mail';

  @override
  String get profile_followers => 'Obserwujący';

  @override
  String get birthday => 'Data urodzenia';

  @override
  String get subscription => 'Subskrypcja';

  @override
  String get not_born => 'Nie urodzony';

  @override
  String get hacker => 'Haker';

  @override
  String get profile => 'Profil';

  @override
  String get no_name => 'Brak nazwy';

  @override
  String get edit => 'Edytuj';

  @override
  String get user_profile => 'Profil użytkownika';

  @override
  String count_plays(Object count) {
    return '$count odtworzeń';
  }

  @override
  String get streaming_fees_hypothetical => '*Obliczone na podstawie wypłaty Spotify za stream\nod \$0.003 do \$0.005. Jest to hipotetyczne\nobliczenie, które ma na celu pokazanie, ile\nużytkownik zapłaciłby artystom, gdyby odsłuchał\ntych utworów na Spotify.';

  @override
  String get minutes_listened => 'Minuty odsłuchane';

  @override
  String get streamed_songs => 'Strumieniowane utwory';

  @override
  String count_streams(Object count) {
    return '$count strumieni';
  }

  @override
  String get owned_by_you => 'Własność Twoja';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return '$shareUrl skopiowano do schowka';
  }

  @override
  String get spotify_hipotetical_calculation => '*Obliczone na podstawie płatności Spotify za strumień\nw zakresie od \$0.003 do \$0.005. Jest to hipotetyczne\nobliczenie mające na celu pokazanie użytkownikowi, ile\nzapłaciliby artystom, gdyby słuchali ich utworów na Spotify.';

  @override
  String count_mins(Object minutes) {
    return '$minutes min';
  }

  @override
  String get summary_minutes => 'minuty';

  @override
  String get summary_listened_to_music => 'Słuchana muzyka';

  @override
  String get summary_songs => 'utwory';

  @override
  String get summary_streamed_overall => 'Ogółem streamowane';

  @override
  String get summary_owed_to_artists => 'Do zapłaty artystom\nw tym miesiącu';

  @override
  String get summary_artists => 'artystów';

  @override
  String get summary_music_reached_you => 'Muzyka dotarła do Ciebie';

  @override
  String get summary_full_albums => 'pełne albumy';

  @override
  String get summary_got_your_love => 'Otrzymał Twoją miłość';

  @override
  String get summary_playlists => 'playlisty';

  @override
  String get summary_were_on_repeat => 'Były na powtarzaniu';

  @override
  String total_money(Object money) {
    return 'Łącznie $money';
  }

  @override
  String get webview_not_found => 'Nie znaleziono Webview';

  @override
  String get webview_not_found_description => 'Na twoim urządzeniu nie zainstalowano środowiska uruchomieniowego Webview.\nJeśli jest zainstalowany, upewnij się, że jest w environment PATH\n\nPo instalacji uruchom ponownie aplikację';

  @override
  String get unsupported_platform => 'Nieobsługiwana platforma';

  @override
  String get cache_music => 'Pamięć podręczna muzyki';

  @override
  String get open => 'Otwórz';

  @override
  String get cache_folder => 'Folder pamięci podręcznej';

  @override
  String get export => 'Eksportuj';

  @override
  String get clear_cache => 'Wyczyść pamięć podręczną';

  @override
  String get clear_cache_confirmation => 'Czy chcesz wyczyścić pamięć podręczną?';

  @override
  String get export_cache_files => 'Eksportuj pliki z pamięci podręcznej';

  @override
  String found_n_files(Object count) {
    return 'Znaleziono $count plików';
  }

  @override
  String get export_cache_confirmation => 'Czy chcesz wyeksportować te pliki do';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return 'Wyeksportowano $filesExported z $files plików';
  }

  @override
  String get undo => 'Cofnij';

  @override
  String get download_all => 'Pobierz wszystko';

  @override
  String get add_all_to_playlist => 'Dodaj wszystko do playlisty';

  @override
  String get add_all_to_queue => 'Dodaj wszystko do kolejki';

  @override
  String get play_all_next => 'Odtwórz wszystko następnie';

  @override
  String get pause => 'Pauza';

  @override
  String get view_all => 'Zobacz wszystko';

  @override
  String get no_tracks_added_yet => 'Wygląda na to, że jeszcze nie dodałeś żadnych utworów';

  @override
  String get no_tracks => 'Wygląda na to, że tutaj nie ma żadnych utworów';

  @override
  String get no_tracks_listened_yet => 'Wygląda na to, że jeszcze nic nie słuchałeś';

  @override
  String get not_following_artists => 'Nie obserwujesz żadnych artystów';

  @override
  String get no_favorite_albums_yet => 'Wygląda na to, że jeszcze nie dodałeś żadnych albumów do ulubionych';

  @override
  String get no_logs_found => 'Nie znaleziono żadnych logów';

  @override
  String get youtube_engine => 'Silnik YouTube';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engine nie jest zainstalowany';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engine nie jest zainstalowany w systemie.';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return 'Upewnij się, że jest dostępny w zmiennej PATH lub\nustaw absolutną ścieżkę do pliku wykonywalnego $engine poniżej';
  }

  @override
  String get youtube_engine_unix_issue_message => 'W systemach macOS/Linux/unix, ustawianie ścieżki w .zshrc/.bashrc/.bash_profile itp. nie będzie działać.\nMusisz ustawić ścieżkę w pliku konfiguracyjnym powłoki';

  @override
  String get download => 'Pobierz';

  @override
  String get file_not_found => 'Plik nie znaleziony';

  @override
  String get custom => 'Niestandardowy';

  @override
  String get add_custom_url => 'Dodaj niestandardowy URL';

  @override
  String get edit_port => 'Edytuj port';

  @override
  String get port_helper_msg => 'Domyślna wartość to -1, co oznacza losową liczbę. Jeśli masz skonfigurowany zaporę, zaleca się jej ustawienie.';

  @override
  String connect_request(Object client) {
    return 'Zezwolić $client na połączenie?';
  }

  @override
  String get connection_request_denied => 'Połączenie odrzucone. Użytkownik odmówił dostępu.';
}
