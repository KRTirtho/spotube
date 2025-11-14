// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get guest => 'Гість';

  @override
  String get browse => 'Огляд';

  @override
  String get search => 'Пошук';

  @override
  String get library => 'Медіатека';

  @override
  String get lyrics => 'Тексти пісень';

  @override
  String get settings => 'Налаштування';

  @override
  String get genre_categories_filter => 'Фільтрувати категорії або жанри...';

  @override
  String get genre => 'Жанр';

  @override
  String get personalized => 'Персоналізовані';

  @override
  String get featured => 'Рекомендовані';

  @override
  String get new_releases => 'Нові релізи';

  @override
  String get songs => 'Пісні';

  @override
  String playing_track(Object track) {
    return 'Відтворюється $track';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return 'Це очистить поточну чергу. Буде видалено $track_length треків\nПродовжити?';
  }

  @override
  String get load_more => 'Завантажити більше';

  @override
  String get playlists => 'Плейлисти';

  @override
  String get artists => 'Виконавці';

  @override
  String get albums => 'Альбоми';

  @override
  String get tracks => 'Треки';

  @override
  String get downloads => 'Завантаження';

  @override
  String get filter_playlists => 'Фільтрувати плейлисти...';

  @override
  String get liked_tracks => 'Сподобалися треки';

  @override
  String get liked_tracks_description => 'Усі ваші сподобалися треки';

  @override
  String get playlist => 'Плейлист';

  @override
  String get create_a_playlist => 'Створити плейлист';

  @override
  String get update_playlist => 'Оновити плейлист';

  @override
  String get create => 'Створити';

  @override
  String get cancel => 'Скасувати';

  @override
  String get update => 'Оновити';

  @override
  String get playlist_name => 'Назва плейлиста';

  @override
  String get name_of_playlist => 'Назва плейлиста';

  @override
  String get description => 'Опис';

  @override
  String get public => 'Публічний';

  @override
  String get collaborative => 'Спільний';

  @override
  String get search_local_tracks => 'Пошук локальних треків...';

  @override
  String get play => 'Відтворити';

  @override
  String get delete => 'Видалити';

  @override
  String get none => 'Немає';

  @override
  String get sort_a_z => 'Сортувати за алфавітом A-Я';

  @override
  String get sort_z_a => 'Сортувати за алфавітом Я-А';

  @override
  String get sort_artist => 'Сортувати за виконавцем';

  @override
  String get sort_album => 'Сортувати за альбомом';

  @override
  String get sort_duration => 'Сортувати за тривалістю';

  @override
  String get sort_tracks => 'Сортувати треки';

  @override
  String currently_downloading(Object tracks_length) {
    return 'Завантажується ($tracks_length)';
  }

  @override
  String get cancel_all => 'Скасувати все';

  @override
  String get filter_artist => 'Фільтрувати виконавців...';

  @override
  String followers(Object followers) {
    return '$followers підписників';
  }

  @override
  String get add_artist_to_blacklist => 'Додати виконавця до чорного списку';

  @override
  String get top_tracks => 'Топ треки';

  @override
  String get fans_also_like => 'Шанувальникам також подобається';

  @override
  String get loading => 'Завантаження...';

  @override
  String get artist => 'Виконавець';

  @override
  String get blacklisted => 'У чорному списку';

  @override
  String get following => 'Стежу';

  @override
  String get follow => 'Стежити';

  @override
  String get artist_url_copied => 'URL виконавця скопійовано до буфера обміну';

  @override
  String added_to_queue(Object tracks) {
    return 'Додано $tracks треків до черги';
  }

  @override
  String get filter_albums => 'Фільтрувати альбоми...';

  @override
  String get synced => 'Синхронізовано';

  @override
  String get plain => 'Звичайний';

  @override
  String get shuffle => 'Випадковий порядок';

  @override
  String get search_tracks => 'Пошук треків...';

  @override
  String get released => 'Випущено';

  @override
  String error(Object error) {
    return 'Помилка $error';
  }

  @override
  String get title => 'Назва';

  @override
  String get time => 'Час';

  @override
  String get more_actions => 'Більше дій';

  @override
  String download_count(Object count) {
    return 'Завантажено ($count)';
  }

  @override
  String add_count_to_playlist(Object count) {
    return 'Додати ($count) до плейлиста';
  }

  @override
  String add_count_to_queue(Object count) {
    return 'Додати ($count) до черги';
  }

  @override
  String play_count_next(Object count) {
    return 'Відтворити ($count) наступними';
  }

  @override
  String get album => 'Альбом';

  @override
  String copied_to_clipboard(Object data) {
    return 'Скопійовано $data до буфера обміну';
  }

  @override
  String add_to_following_playlists(Object track) {
    return 'Додати $track до наступних плейлистів';
  }

  @override
  String get add => 'Додати';

  @override
  String added_track_to_queue(Object track) {
    return 'Додано $track до черги';
  }

  @override
  String get add_to_queue => 'Додати до черги';

  @override
  String track_will_play_next(Object track) {
    return '$track буде відтворено наступним';
  }

  @override
  String get play_next => 'Відтворити наступним';

  @override
  String removed_track_from_queue(Object track) {
    return 'Видалено $track з черги';
  }

  @override
  String get remove_from_queue => 'Видалити з черги';

  @override
  String get remove_from_favorites => 'Видалити з обраних';

  @override
  String get save_as_favorite => 'Зберегти як обране';

  @override
  String get add_to_playlist => 'Додати до плейлиста';

  @override
  String get remove_from_playlist => 'Видалити з плейлиста';

  @override
  String get add_to_blacklist => 'Додати до чорного списку';

  @override
  String get remove_from_blacklist => 'Видалити з чорного списку';

  @override
  String get share => 'Поділитися';

  @override
  String get mini_player => 'Міні-плеєр';

  @override
  String get slide_to_seek =>
      'Проведіть пальцем, щоб перемотати вперед або назад';

  @override
  String get shuffle_playlist => 'Випадковий порядок відтворення плейлиста';

  @override
  String get unshuffle_playlist =>
      'Відключити випадковий порядок відтворення плейлиста';

  @override
  String get previous_track => 'Попередній трек';

  @override
  String get next_track => 'Наступний трек';

  @override
  String get pause_playback => 'Призупинити відтворення';

  @override
  String get resume_playback => 'Відновити відтворення';

  @override
  String get loop_track => 'Повторювати трек';

  @override
  String get no_loop => 'Без повтору';

  @override
  String get repeat_playlist => 'Повторювати плейлист';

  @override
  String get queue => 'Черга';

  @override
  String get alternative_track_sources => 'Альтернативні джерела треків';

  @override
  String get download_track => 'Завантажити трек';

  @override
  String tracks_in_queue(Object tracks) {
    return '$tracks треків у черзі';
  }

  @override
  String get clear_all => 'Очистити все';

  @override
  String get show_hide_ui_on_hover =>
      'Показувати/приховувати інтерфейс при наведенні курсору';

  @override
  String get always_on_top => 'Завжди зверху';

  @override
  String get exit_mini_player => 'Вийти з міні-плеєра';

  @override
  String get download_location => 'Шлях завантаження';

  @override
  String get local_library => 'Місцева бібліотека';

  @override
  String get add_library_location => 'Додати до бібліотеки';

  @override
  String get remove_library_location => 'Видалити з бібліотеки';

  @override
  String get account => 'Обліковий запис';

  @override
  String get logout => 'Вийти';

  @override
  String get logout_of_this_account => 'Вийти з цього облікового запису';

  @override
  String get language_region => 'Мова та регіон';

  @override
  String get language => 'Мова';

  @override
  String get system_default => 'Системна мова';

  @override
  String get market_place_region => 'Регіон маркетплейсу';

  @override
  String get recommendation_country => 'Країна рекомендацій';

  @override
  String get appearance => 'Зовнішній вигляд';

  @override
  String get layout_mode => 'Режим макета';

  @override
  String get override_layout_settings =>
      'Перезаписати налаштування адаптивного режиму макета';

  @override
  String get adaptive => 'Адаптивний';

  @override
  String get compact => 'Компактний';

  @override
  String get extended => 'Розширений';

  @override
  String get theme => 'Тема';

  @override
  String get dark => 'Темна';

  @override
  String get light => 'Світла';

  @override
  String get system => 'Системна';

  @override
  String get accent_color => 'Колір акценту';

  @override
  String get sync_album_color => 'Синхронізувати колір альбому';

  @override
  String get sync_album_color_description =>
      'Використовує домінуючий колір обкладинки альбому як колір акценту';

  @override
  String get playback => 'Відтворення';

  @override
  String get audio_quality => 'Якість аудіо';

  @override
  String get high => 'Висока';

  @override
  String get low => 'Низька';

  @override
  String get pre_download_play => 'Попереднє завантаження та відтворення';

  @override
  String get pre_download_play_description =>
      'Замість потокового відтворення аудіо завантажте байти та відтворіть їх (рекомендовано для користувачів з високою пропускною здатністю)';

  @override
  String get skip_non_music => 'Пропустити не музичні сегменти';

  @override
  String get blacklist_description => 'Треки та виконавці в чорному списку';

  @override
  String get wait_for_download_to_finish =>
      'Зачекайте, поки завершиться поточна загрузка';

  @override
  String get desktop => 'Робочий стіл';

  @override
  String get close_behavior => 'Поведінка при закритті';

  @override
  String get close => 'Закрити';

  @override
  String get minimize_to_tray => 'Згорнути в трей';

  @override
  String get show_tray_icon => 'Показувати значок у системному треї';

  @override
  String get about => 'Про';

  @override
  String get u_love_spotube => 'Ми знаємо, що ви любите Spotube';

  @override
  String get check_for_updates => 'Перевірити наявність оновлень';

  @override
  String get about_spotube => 'Про Spotube';

  @override
  String get blacklist => 'Чорний список';

  @override
  String get please_sponsor => 'Будь ласка, станьте спонсором/зробіть пожертву';

  @override
  String get spotube_description =>
      'Spotube, легкий, кросплатформовий, безкоштовний клієнт Spotify';

  @override
  String get version => 'Версія';

  @override
  String get build_number => 'Номер збірки';

  @override
  String get founder => 'Засновник';

  @override
  String get repository => 'Репозиторій';

  @override
  String get bug_issues => 'Помилки та проблеми';

  @override
  String get made_with => 'Зроблено з ❤️ в Бангладеш 🇧🇩';

  @override
  String get kingkor_roy_tirtho => 'Kingkor Roy Tirtho';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year Kingkor Roy Tirtho';
  }

  @override
  String get license => 'Ліцензія';

  @override
  String get credentials_will_not_be_shared_disclaimer =>
      'Не хвилюйтеся, жодні ваші облікові дані не будуть зібрані або передані кому-небудь';

  @override
  String get know_how_to_login => 'Не знаєте, як це зробити?';

  @override
  String get follow_step_by_step_guide => 'Дотримуйтесь покрокової інструкції';

  @override
  String cookie_name_cookie(Object name) {
    return 'Кукі-файл $name';
  }

  @override
  String get fill_in_all_fields => 'Будь ласка, заповніть усі поля';

  @override
  String get submit => 'Надіслати';

  @override
  String get exit => 'Вийти';

  @override
  String get previous => 'Попередній';

  @override
  String get next => 'Наступний';

  @override
  String get done => 'Готово';

  @override
  String get step_1 => 'Крок 1';

  @override
  String get first_go_to => 'Спочатку перейдіть на';

  @override
  String get something_went_wrong => 'Щось пішло не так';

  @override
  String get piped_instance => 'Примірник сервера Piped';

  @override
  String get piped_description =>
      'Примірник сервера Piped, який використовуватиметься для зіставлення треків';

  @override
  String get piped_warning =>
      'Деякі з них можуть працювати неправильно. Тому використовуйте на свій страх і ризик';

  @override
  String get invidious_instance => 'Екземпляр сервера Invidious';

  @override
  String get invidious_description =>
      'Екземпляр сервера Invidious для зіставлення треків';

  @override
  String get invidious_warning =>
      'Деякі можуть працювати не дуже добре. Використовуйте на власний ризик';

  @override
  String get generate => 'Генерувати';

  @override
  String track_exists(Object track) {
    return 'Трек $track вже існує';
  }

  @override
  String get replace_downloaded_tracks => 'Замінити всі завантажені треки';

  @override
  String get skip_download_tracks =>
      'Пропустити завантаження всіх завантажених треків';

  @override
  String get do_you_want_to_replace => 'Ви хочете замінити існуючий трек?';

  @override
  String get replace => 'Замінити';

  @override
  String get skip => 'Пропустити';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return 'Виберіть до $count $type';
  }

  @override
  String get select_genres => 'Виберіть жанри';

  @override
  String get add_genres => 'Додати жанри';

  @override
  String get country => 'Країна';

  @override
  String get number_of_tracks_generate => 'Кількість треків для створення';

  @override
  String get acousticness => 'Акустичність';

  @override
  String get danceability => 'Танцювальність';

  @override
  String get energy => 'Енергія';

  @override
  String get instrumentalness => 'Інструментальність';

  @override
  String get liveness => 'Живість';

  @override
  String get loudness => 'Гучність';

  @override
  String get speechiness => 'Розмовність';

  @override
  String get valence => 'Валентність';

  @override
  String get popularity => 'Популярність';

  @override
  String get key => 'Тональність';

  @override
  String get duration => 'Тривалість (с)';

  @override
  String get tempo => 'Темп (BPM)';

  @override
  String get mode => 'Режим';

  @override
  String get time_signature => 'Розмір';

  @override
  String get short => 'Короткий';

  @override
  String get medium => 'Середній';

  @override
  String get long => 'Довгий';

  @override
  String get min => 'Мін';

  @override
  String get max => 'Макс';

  @override
  String get target => 'Цільовий';

  @override
  String get moderate => 'Помірний';

  @override
  String get deselect_all => 'Зняти вибір з усіх';

  @override
  String get select_all => 'Вибрати всі';

  @override
  String get are_you_sure => 'Ви впевнені?';

  @override
  String get generating_playlist =>
      'Створення вашого персонального плейлиста...';

  @override
  String selected_count_tracks(Object count) {
    return 'Вибрано $count треків';
  }

  @override
  String get download_warning =>
      'Якщо ви завантажуєте всі треки масово, ви явно піратствуєте і завдаєте шкоди музичному творчому співтовариству. Сподіваюся, ви усвідомлюєте це. Завжди намагайтеся поважати і підтримувати важку працю артиста';

  @override
  String get download_ip_ban_warning =>
      'До речі, ваш IP може бути заблокований на YouTube через надмірну кількість запитів на завантаження, ніж зазвичай. Блокування IP-адреси означає, що ви не зможете користуватися YouTube (навіть якщо ви увійшли в систему) протягом щонайменше 2-3 місяців з цього пристрою. І Spotube не несе жодної відповідальності, якщо це станеться';

  @override
  String get by_clicking_accept_terms =>
      'Натискаючи \'прийняти\', ви погоджуєтеся з наступними умовами:';

  @override
  String get download_agreement_1 => 'Я знаю, що краду музику. Я поганий.';

  @override
  String get download_agreement_2 =>
      'Я підтримаю автора, де тільки зможу, і роблю це лише тому, що не маю грошей, щоб купити його роботи.';

  @override
  String get download_agreement_3 =>
      'Я повністю усвідомлюю, що мій IP може бути заблокований на YouTube, і я не покладаю на Spotube або його власників/контрибуторів відповідальність за будь-які нещасні випадки, спричинені моїми діями.';

  @override
  String get decline => 'Відхилити';

  @override
  String get accept => 'Прийняти';

  @override
  String get details => 'Деталі';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => 'Канал';

  @override
  String get likes => 'Подобається';

  @override
  String get dislikes => 'Не подобається';

  @override
  String get views => 'Переглядів';

  @override
  String get streamUrl => 'Посилання на стрімінг';

  @override
  String get stop => 'Зупинити';

  @override
  String get sort_newest => 'Сортувати за датою додавання (новіші першими)';

  @override
  String get sort_oldest => 'Сортувати за датою додавання (старіші першими)';

  @override
  String get sleep_timer => 'Таймер сну';

  @override
  String mins(Object minutes) {
    return '$minutes хвилин';
  }

  @override
  String hours(Object hours) {
    return '$hours годин';
  }

  @override
  String hour(Object hours) {
    return '$hours година';
  }

  @override
  String get custom_hours => 'Кількість годин на замовлення';

  @override
  String get logs => 'Логи';

  @override
  String get developers => 'Розробники';

  @override
  String get not_logged_in => 'Ви не ввійшли в обліковий запис';

  @override
  String get search_mode => 'Режим пошуку';

  @override
  String get audio_source => 'Джерело аудіо';

  @override
  String get ok => 'Гаразд';

  @override
  String get failed_to_encrypt => 'Не вдалося зашифрувати';

  @override
  String get encryption_failed_warning =>
      'Spotube використовує шифрування для безпечного зберігання ваших даних. Але не вдалося цього зробити. Тому він перейде до небезпечного зберігання\nЯкщо ви використовуєте Linux, переконайтеся, що у вас встановлено будь-який секретний сервіс (gnome-keyring, kde-wallet, keepassxc тощо)';

  @override
  String get querying_info => 'Запит інформації...';

  @override
  String get piped_api_down => 'API Piped не працює';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return 'Поточний екземпляр Piped $pipedInstance не працює\n\nЗмініть екземпляр або змініть \'Тип API\' на офіційний YouTube API\n\nОбов\'язково перезапустіть програму після зміни';
  }

  @override
  String get you_are_offline => 'Ви зараз не в мережі';

  @override
  String get connection_restored => 'Ваше інтернет-з\'єднання відновлено';

  @override
  String get use_system_title_bar => 'Використовувати системний заголовок';

  @override
  String get crunching_results => 'Опрацювання результатів...';

  @override
  String get search_to_get_results => 'Почніть пошук, щоб отримати результати';

  @override
  String get use_amoled_mode => 'Режим AMOLED';

  @override
  String get pitch_dark_theme => 'Темна тема';

  @override
  String get normalize_audio => 'Нормалізувати звук';

  @override
  String get change_cover => 'Змінити обкладинку';

  @override
  String get add_cover => 'Додати обкладинку';

  @override
  String get restore_defaults => 'Відновити налаштування за замовчуванням';

  @override
  String get download_music_format => 'Формат завантаження музики';

  @override
  String get streaming_music_format => 'Формат потокової музики';

  @override
  String get download_music_quality => 'Якість завантаженої музики';

  @override
  String get streaming_music_quality => 'Якість потокової музики';

  @override
  String get login_with_lastfm => 'Увійти з Last.fm';

  @override
  String get connect => 'Підключити';

  @override
  String get disconnect_lastfm => 'Відключитися від Last.fm';

  @override
  String get disconnect => 'Відключити';

  @override
  String get username => 'Ім\'я користувача';

  @override
  String get password => 'Пароль';

  @override
  String get login => 'Увійти';

  @override
  String get login_with_your_lastfm => 'Увійти в свій обліковий запис Last.fm';

  @override
  String get scrobble_to_lastfm => 'Скробблінг на Last.fm';

  @override
  String get go_to_album => 'Перейти до альбому';

  @override
  String get discord_rich_presence => 'Багата присутність у Discord';

  @override
  String get browse_all => 'Переглянути все';

  @override
  String get genres => 'Жанри';

  @override
  String get explore_genres => 'Досліджувати жанри';

  @override
  String get friends => 'Друзі';

  @override
  String get no_lyrics_available =>
      'Вибачте, не вдалося знайти текст для цього треку';

  @override
  String get start_a_radio => 'Запустити радіо';

  @override
  String get how_to_start_radio => 'Як ви хочете запустити радіо?';

  @override
  String get replace_queue_question =>
      'Ви хочете замінити поточну чергу чи додати до неї?';

  @override
  String get endless_playback => 'Безкінечне відтворення';

  @override
  String get delete_playlist => 'Видалити плейлист';

  @override
  String get delete_playlist_confirmation =>
      'Ви впевнені, що хочете видалити цей плейлист?';

  @override
  String get local_tracks => 'Місцеві треки';

  @override
  String get local_tab => 'Місцевий';

  @override
  String get song_link => 'Посилання на пісню';

  @override
  String get skip_this_nonsense => 'Пропустити цей бред';

  @override
  String get freedom_of_music => '“Свобода музики”';

  @override
  String get freedom_of_music_palm => '“Свобода музики у вашій долоні”';

  @override
  String get get_started => 'Давайте почнемо';

  @override
  String get youtube_source_description =>
      'Рекомендовано та працює краще за все.';

  @override
  String get piped_source_description =>
      'Чи почуваєте себе вільно? Те саме, що і на YouTube, але набагато безкоштовно.';

  @override
  String get jiosaavn_source_description =>
      'Найкраще для регіону Південної Азії.';

  @override
  String get invidious_source_description =>
      'Подібний до Piped, але з вищою доступністю.';

  @override
  String highest_quality(Object quality) {
    return 'Найвища якість: $quality';
  }

  @override
  String get select_audio_source => 'Виберіть джерело аудіо';

  @override
  String get endless_playback_description =>
      'Автоматично додавати нові пісні\nв кінець черги';

  @override
  String get choose_your_region => 'Виберіть ваш регіон';

  @override
  String get choose_your_region_description =>
      'Це допоможе Spotube показати вам правильний контент\nдля вашого місцезнаходження.';

  @override
  String get choose_your_language => 'Виберіть свою мову';

  @override
  String get help_project_grow => 'Допоможіть цьому проекту рости';

  @override
  String get help_project_grow_description =>
      'Spotube - це проект з відкритим кодом. Ви можете допомогти цьому проекту зростати, вносячи свій внесок у проект, повідомляючи про помилки або пропонуючи нові функції.';

  @override
  String get contribute_on_github => 'Долучайтесь на GitHub';

  @override
  String get donate_on_open_collective => 'Пожертвуйте на Open Collective';

  @override
  String get browse_anonymously => 'Анонімно переглядати';

  @override
  String get enable_connect => 'Увімкнути підключення';

  @override
  String get enable_connect_description => 'Керуйте Spotube з інших пристроїв';

  @override
  String get devices => 'Пристрої';

  @override
  String get select => 'Вибрати';

  @override
  String connect_client_alert(Object client) {
    return 'Вас керує $client';
  }

  @override
  String get this_device => 'Цей пристрій';

  @override
  String get remote => 'Віддалений';

  @override
  String get stats => 'Статистика';

  @override
  String and_n_more(Object count) {
    return 'і $count більше';
  }

  @override
  String get recently_played => 'Нещодавно Відтворене';

  @override
  String get browse_more => 'Переглянути Більше';

  @override
  String get no_title => 'Без Назви';

  @override
  String get not_playing => 'Не Відтворюється';

  @override
  String get epic_failure => 'Епічний провал!';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return 'Додано $tracks_length треків до черги';
  }

  @override
  String get spotube_has_an_update => 'Spotube має оновлення';

  @override
  String get download_now => 'Завантажити Зараз';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Spotube Nightly $nightlyBuildNum було випущено';
  }

  @override
  String release_version(Object version) {
    return 'Spotube v$version було випущено';
  }

  @override
  String get read_the_latest => 'Читати останні новини';

  @override
  String get release_notes => 'ноти про випуск';

  @override
  String get pick_color_scheme => 'Оберіть кольорову схему';

  @override
  String get save => 'Зберегти';

  @override
  String get choose_the_device => 'Виберіть пристрій:';

  @override
  String get multiple_device_connected =>
      'Підключено кілька пристроїв.\nВиберіть пристрій, на якому ви хочете виконати цю дію';

  @override
  String get nothing_found => 'Нічого не знайдено';

  @override
  String get the_box_is_empty => 'Коробка порожня';

  @override
  String get top_artists => 'Топ Артисти';

  @override
  String get top_albums => 'Топ Альбоми';

  @override
  String get this_week => 'Цього тижня';

  @override
  String get this_month => 'Цього місяця';

  @override
  String get last_6_months => 'Останні 6 місяців';

  @override
  String get this_year => 'Цього року';

  @override
  String get last_2_years => 'Останні 2 роки';

  @override
  String get all_time => 'Усі часи';

  @override
  String powered_by_provider(Object providerName) {
    return 'Забезпечено $providerName';
  }

  @override
  String get email => 'Електронна пошта';

  @override
  String get profile_followers => 'Підписники';

  @override
  String get birthday => 'День народження';

  @override
  String get subscription => 'Підписка';

  @override
  String get not_born => 'Ще не народжений';

  @override
  String get hacker => 'Хакер';

  @override
  String get profile => 'Профіль';

  @override
  String get no_name => 'Без імені';

  @override
  String get edit => 'Редагувати';

  @override
  String get user_profile => 'Профіль користувача';

  @override
  String count_plays(Object count) {
    return '$count відтворень';
  }

  @override
  String get streaming_fees_hypothetical =>
      '*Розраховано на основі виплат Spotify за стримінг\nвід \$0.003 до \$0.005. Це гіпотетичний\nрозрахунок, щоб дати уявлення користувачу про те, скільки б він\nзаплатив артистам, якби слухав їхні пісні на Spotify.';

  @override
  String get minutes_listened => 'Хвилини прослуховування';

  @override
  String get streamed_songs => 'Стримлені пісні';

  @override
  String count_streams(Object count) {
    return '$count стримів';
  }

  @override
  String get owned_by_you => 'Ваша власність';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return '$shareUrl скопійовано в буфер обміну';
  }

  @override
  String get hipotetical_calculation =>
      '*Це розраховано на основі середньої виплати за стрім онлайн-платформ для потокового відтворення музики, що становить від \$0,003 до \$0,005. Це гіпотетичний розрахунок, щоб дати користувачеві уявлення про те, скільки б вони заплатили артистам, якщо б слухали їхні пісні на різних музичних стрімінгових платформах.';

  @override
  String count_mins(Object minutes) {
    return '$minutes хв';
  }

  @override
  String get summary_minutes => 'хвилини';

  @override
  String get summary_listened_to_music => 'Прослухана музика';

  @override
  String get summary_songs => 'пісні';

  @override
  String get summary_streamed_overall => 'Загалом стримів';

  @override
  String get summary_owed_to_artists => 'Заборгованість артистам\nцього місяця';

  @override
  String get summary_artists => 'артистів';

  @override
  String get summary_music_reached_you => 'Музика досягла вас';

  @override
  String get summary_full_albums => 'повні альбоми';

  @override
  String get summary_got_your_love => 'Отримав вашу любов';

  @override
  String get summary_playlists => 'плейлисти';

  @override
  String get summary_were_on_repeat => 'Були на повторі';

  @override
  String total_money(Object money) {
    return 'Загалом $money';
  }

  @override
  String get webview_not_found => 'Webview не знайдено';

  @override
  String get webview_not_found_description =>
      'На вашому пристрої не встановлено виконуване середовище Webview.\nЯкщо воно встановлено, переконайтеся, що воно знаходиться в environment PATH\n\nПісля встановлення перезапустіть програму';

  @override
  String get unsupported_platform => 'Непідтримувана платформа';

  @override
  String get cache_music => 'Кешувати музику';

  @override
  String get open => 'Відкрити';

  @override
  String get cache_folder => 'Тека кешу';

  @override
  String get export => 'Експорт';

  @override
  String get clear_cache => 'Очистити кеш';

  @override
  String get clear_cache_confirmation => 'Ви хочете очистити кеш?';

  @override
  String get export_cache_files => 'Експортувати кешовані файли';

  @override
  String found_n_files(Object count) {
    return 'Знайдено $count файлів';
  }

  @override
  String get export_cache_confirmation => 'Ви хочете експортувати ці файли до';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return 'Експортовано $filesExported з $files файлів';
  }

  @override
  String get undo => 'Скасувати';

  @override
  String get download_all => 'Завантажити все';

  @override
  String get add_all_to_playlist => 'Додати все до плейлиста';

  @override
  String get add_all_to_queue => 'Додати все в чергу';

  @override
  String get play_all_next => 'Відтворити все наступне';

  @override
  String get pause => 'Пауза';

  @override
  String get view_all => 'Переглянути все';

  @override
  String get no_tracks_added_yet => 'Здається, ви ще не додали жодної пісні';

  @override
  String get no_tracks => 'Здається, тут немає пісень';

  @override
  String get no_tracks_listened_yet => 'Здається, ви ще нічого не слухали';

  @override
  String get not_following_artists => 'Ви не підписані на жодного артиста';

  @override
  String get no_favorite_albums_yet =>
      'Здається, ви ще не додали жодного альбому в улюблені';

  @override
  String get no_logs_found => 'Жодних журналів не знайдено';

  @override
  String get youtube_engine => 'YouTube Двигун';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engine не встановлено';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engine не встановлено на вашій системі.';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return 'Переконайтесь, що він доступний у змінній PATH або\nвстановіть абсолютний шлях до виконуваного файлу $engine нижче';
  }

  @override
  String get youtube_engine_unix_issue_message =>
      'У macOS/Linux/Unix-подібних ОС, встановлення шляху в .zshrc/.bashrc/.bash_profile тощо не працює.\nВам потрібно налаштувати шлях у файлі конфігурації оболонки';

  @override
  String get download => 'Завантажити';

  @override
  String get file_not_found => 'Файл не знайдено';

  @override
  String get custom => 'Користувацький';

  @override
  String get add_custom_url => 'Додати користувацький URL';

  @override
  String get edit_port => 'Редагувати порт';

  @override
  String get port_helper_msg =>
      'За замовчуванням -1, що означає випадкове число. Якщо у вас налаштований брандмауер, рекомендується це налаштувати.';

  @override
  String connect_request(Object client) {
    return 'Дозволити $client підключення?';
  }

  @override
  String get connection_request_denied =>
      'Підключення відхилено. Користувач відмовив у доступі.';

  @override
  String get an_error_occurred => 'Сталася помилка';

  @override
  String get copy_to_clipboard => 'Копіювати в буфер обміну';

  @override
  String get view_logs => 'Переглянути логи';

  @override
  String get retry => 'Повторити';

  @override
  String get no_default_metadata_provider_selected =>
      'Ви не встановили провайдера метаданих за замовчуванням';

  @override
  String get manage_metadata_providers => 'Керувати провайдерами метаданих';

  @override
  String get open_link_in_browser => 'Відкрити посилання в браузері?';

  @override
  String get do_you_want_to_open_the_following_link =>
      'Ви хочете відкрити наступне посилання';

  @override
  String get unsafe_url_warning =>
      'Відкриття посилань з ненадійних джерел може бути небезпечним. Будьте обережні!\nВи також можете скопіювати посилання в буфер обміну.';

  @override
  String get copy_link => 'Копіювати посилання';

  @override
  String get building_your_timeline =>
      'Створення вашої часової шкали на основі ваших прослуховувань...';

  @override
  String get official => 'Офіційний';

  @override
  String author_name(Object author) {
    return 'Автор: $author';
  }

  @override
  String get third_party => 'Сторонній';

  @override
  String get plugin_requires_authentication => 'Плагін вимагає автентифікації';

  @override
  String get update_available => 'Доступне оновлення';

  @override
  String get supports_scrobbling => 'Підтримує скроблінг';

  @override
  String get plugin_scrobbling_info =>
      'Цей плагін скроббить вашу музику, щоб створити вашу історію прослуховувань.';

  @override
  String get default_metadata_source => 'Джерело метаданих за замовчуванням';

  @override
  String get set_default_metadata_source =>
      'Встановити джерело метаданих за замовчуванням';

  @override
  String get default_audio_source => 'Джерело аудіо за замовчуванням';

  @override
  String get set_default_audio_source =>
      'Встановити джерело аудіо за замовчуванням';

  @override
  String get set_default => 'Встановити за замовчуванням';

  @override
  String get support => 'Підтримка';

  @override
  String get support_plugin_development => 'Підтримати розробку плагіна';

  @override
  String can_access_name_api(Object name) {
    return '- Може отримати доступ до **$name** API';
  }

  @override
  String get do_you_want_to_install_this_plugin =>
      'Ви хочете встановити цей плагін?';

  @override
  String get third_party_plugin_warning =>
      'Цей плагін із стороннього репозиторію. Будь ласка, переконайтеся, що ви довіряєте джерелу перед встановленням.';

  @override
  String get author => 'Автор';

  @override
  String get this_plugin_can_do_following => 'Цей плагін може робити наступне';

  @override
  String get install => 'Встановити';

  @override
  String get install_a_metadata_provider => 'Встановити провайдера метаданих';

  @override
  String get no_tracks_playing => 'Наразі не відтворюється жоден трек';

  @override
  String get synced_lyrics_not_available =>
      'Синхронізовані тексти недоступні для цієї пісні. Будь ласка, використовуйте вкладку';

  @override
  String get plain_lyrics => 'Звичайні тексти';

  @override
  String get tab_instead => 'замість цього.';

  @override
  String get disclaimer => 'Відмова від відповідальності';

  @override
  String get third_party_plugin_dmca_notice =>
      'Команда Spotube не несе жодної відповідальності (включно з юридичною) за будь-які плагіни \"третіх сторін\".\nБудь ласка, використовуйте їх на свій страх і ризик. Про будь-які помилки/проблеми повідомляйте в репозиторій плагіна.\n\nЯкщо якийсь плагін \"третьої сторони\" порушує ToS/DMCA будь-якої служби/юридичної особи, будь ласка, попросіть автора плагіна \"третьої сторони\" або хостингову платформу, наприклад, GitHub/Codeberg, вжити заходів. Усі перераховані вище (позначені як \"треті сторони\") є плагінами, які підтримуються публічно/спільнотою. Ми не куруємо їх, тому не можемо вжити жодних заходів щодо них.\n\n';

  @override
  String get input_does_not_match_format =>
      'Введені дані не відповідають необхідному формату';

  @override
  String get plugins => 'Плагіни';

  @override
  String get paste_plugin_download_url =>
      'Вставте URL-адресу для завантаження або URL-адресу репозиторію GitHub/Codeberg або пряме посилання на файл .smplug';

  @override
  String get download_and_install_plugin_from_url =>
      'Завантажити та встановити плагін з URL-адреси';

  @override
  String failed_to_add_plugin_error(Object error) {
    return 'Не вдалося додати плагін: $error';
  }

  @override
  String get upload_plugin_from_file => 'Завантажити плагін з файлу';

  @override
  String get installed => 'Встановлено';

  @override
  String get available_plugins => 'Доступні плагіни';

  @override
  String get configure_plugins =>
      'Налаштуйте власні плагіни метаданих і аудіоджерела';

  @override
  String get audio_scrobblers => 'Аудіо скробблери';

  @override
  String get scrobbling => 'Скроблінг';

  @override
  String get source => 'Джерело: ';

  @override
  String get uncompressed => 'Без стиснення';

  @override
  String get dab_music_source_description =>
      'Для аудіофілів. Забезпечує високоякісні/без втрат аудіопотоки. Точна відповідність треків на основі ISRC.';
}
