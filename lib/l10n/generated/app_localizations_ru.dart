// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get guest => 'Гость';

  @override
  String get browse => 'Обзор';

  @override
  String get search => 'Поиск';

  @override
  String get library => 'Библиотека';

  @override
  String get lyrics => 'Текст';

  @override
  String get settings => 'Настройки';

  @override
  String get genre_categories_filter => 'Фильтр по категориям или жанрам...';

  @override
  String get genre => 'Жанр';

  @override
  String get personalized => 'Персонализированный';

  @override
  String get featured => 'Популярное';

  @override
  String get new_releases => 'Новое';

  @override
  String get songs => 'Треки';

  @override
  String playing_track(Object track) {
    return 'Играет $track';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return 'Это удалит текущую очередь. $track_length треков будет удалено. Вы хотите продолжить?';
  }

  @override
  String get load_more => 'Загрузить больше';

  @override
  String get playlists => 'Плейлисты';

  @override
  String get artists => 'Исполнители';

  @override
  String get albums => 'Альбомы';

  @override
  String get tracks => 'Треки';

  @override
  String get downloads => 'Загрузки';

  @override
  String get filter_playlists => 'Применить фильтры к вашим плейлистам...';

  @override
  String get liked_tracks => 'Понравившиеся треки';

  @override
  String get liked_tracks_description => 'Все понравившиеся треки';

  @override
  String get playlist => 'Плейлист';

  @override
  String get create_a_playlist => 'Создать плейлист';

  @override
  String get update_playlist => 'Обновить плейлист';

  @override
  String get create => 'Создать';

  @override
  String get cancel => 'Отмена';

  @override
  String get update => 'Обновить';

  @override
  String get playlist_name => 'Назвать плейлист';

  @override
  String get name_of_playlist => 'Название плейлиста';

  @override
  String get description => 'Описание';

  @override
  String get public => 'Публичный';

  @override
  String get collaborative => 'Совместный';

  @override
  String get search_local_tracks => 'Поиск песен на вашем устройстве...';

  @override
  String get play => 'Играть';

  @override
  String get delete => 'Удалить';

  @override
  String get none => 'Пусто';

  @override
  String get sort_a_z => 'Сортировка по алфавиту';

  @override
  String get sort_z_a => 'Сортировка по алфавиту в обратную сторону';

  @override
  String get sort_artist => 'Сортировать по исполнителю';

  @override
  String get sort_album => 'Сортировать по альбомам';

  @override
  String get sort_duration => 'Сортировать по длительности';

  @override
  String get sort_tracks => 'Сортировать треки';

  @override
  String currently_downloading(Object tracks_length) {
    return 'Загружается ($tracks_length)';
  }

  @override
  String get cancel_all => 'Отменить все';

  @override
  String get filter_artist => 'Фильтровать по исполнителю...';

  @override
  String followers(Object followers) {
    return '$followers Подписчики';
  }

  @override
  String get add_artist_to_blacklist => 'Добавить исполнителя в черный список';

  @override
  String get top_tracks => 'Чарт';

  @override
  String get fans_also_like => 'Поклонникам также нравится';

  @override
  String get loading => 'Загрузка...';

  @override
  String get artist => 'Исполнитель';

  @override
  String get blacklisted => 'Внесен в черный список';

  @override
  String get following => 'Подписаны';

  @override
  String get follow => 'Подписаться';

  @override
  String get artist_url_copied =>
      'URL-адрес исполнителя скопирован в буфер обмена';

  @override
  String added_to_queue(Object tracks) {
    return 'Добавлено $tracks треков в очередь';
  }

  @override
  String get filter_albums => 'Фильтровать альбомы...';

  @override
  String get synced => 'Синхронизировано';

  @override
  String get plain => 'Обычный';

  @override
  String get shuffle => 'Перемешать';

  @override
  String get search_tracks => 'Поиск треков...';

  @override
  String get released => 'Дата выхода';

  @override
  String error(Object error) {
    return 'Ошибка $error';
  }

  @override
  String get title => 'Заголовок';

  @override
  String get time => 'Время';

  @override
  String get more_actions => 'Больше действий';

  @override
  String download_count(Object count) {
    return 'Скачать ($count)';
  }

  @override
  String add_count_to_playlist(Object count) {
    return 'Добавить ($count) в плейлист';
  }

  @override
  String add_count_to_queue(Object count) {
    return 'Добавить ($count) в очередь';
  }

  @override
  String play_count_next(Object count) {
    return 'Воспроизвести ($count) следующий';
  }

  @override
  String get album => 'Альбом';

  @override
  String copied_to_clipboard(Object data) {
    return 'Скопировано $data в буфер обмена';
  }

  @override
  String add_to_following_playlists(Object track) {
    return 'Добавить $track в этот плейлист';
  }

  @override
  String get add => 'Добавить';

  @override
  String added_track_to_queue(Object track) {
    return 'Добавлен $track в очередь';
  }

  @override
  String get add_to_queue => 'Добавить в очередь';

  @override
  String track_will_play_next(Object track) {
    return '$track будет воспроизведен следующим';
  }

  @override
  String get play_next => 'Воспроизвести следующий';

  @override
  String removed_track_from_queue(Object track) {
    return '$track удален из очереди';
  }

  @override
  String get remove_from_queue => 'Удалить из очереди';

  @override
  String get remove_from_favorites => 'Удалить из избранного';

  @override
  String get save_as_favorite => 'Сохранить в избранное';

  @override
  String get add_to_playlist => 'Добавить в плейлист';

  @override
  String get remove_from_playlist => 'Удалить из плейлиста';

  @override
  String get add_to_blacklist => 'Добавить в черный список';

  @override
  String get remove_from_blacklist => 'Удалить из черного списка';

  @override
  String get share => 'Поделиться';

  @override
  String get mini_player => 'Мини-плеер';

  @override
  String get slide_to_seek => 'Потяните для перемотки вперед или назад';

  @override
  String get shuffle_playlist => 'Перемешать плейлист';

  @override
  String get unshuffle_playlist => 'Снять перемешивание плейлиста';

  @override
  String get previous_track => 'Предыдущий трек';

  @override
  String get next_track => 'Следующий трек';

  @override
  String get pause_playback => 'Пауза воспроизведения';

  @override
  String get resume_playback => 'Возобновить воспроизведение';

  @override
  String get loop_track => 'Циклический трек';

  @override
  String get no_loop => 'Без повтора';

  @override
  String get repeat_playlist => 'Повторите плейлист';

  @override
  String get queue => 'Очередь';

  @override
  String get alternative_track_sources => 'Альтернативные источники треков';

  @override
  String get download_track => 'Скачать трек';

  @override
  String tracks_in_queue(Object tracks) {
    return '$tracks треков в очереди';
  }

  @override
  String get clear_all => 'Очистить все';

  @override
  String get show_hide_ui_on_hover => 'Показать/Скрыть интерфейс при наведении';

  @override
  String get always_on_top => 'Всегда сверху';

  @override
  String get exit_mini_player => 'Выйти из мини-плеера';

  @override
  String get download_location => 'Место загрузки';

  @override
  String get local_library => 'Локальная библиотека';

  @override
  String get add_library_location => 'Добавить в библиотеку';

  @override
  String get remove_library_location => 'Удалить из библиотеки';

  @override
  String get account => 'Аккаунт';

  @override
  String get logout => 'Выйти';

  @override
  String get logout_of_this_account => 'Выйдите из этого аккаунта';

  @override
  String get language_region => 'Язык и регион';

  @override
  String get language => 'Язык';

  @override
  String get system_default => 'Системное значение по умолчанию';

  @override
  String get market_place_region => 'Региональное пространство';

  @override
  String get recommendation_country => 'Страна рекомендаций';

  @override
  String get appearance => 'Внешний вид';

  @override
  String get layout_mode => 'Режим компоновки';

  @override
  String get override_layout_settings =>
      'Изменить настройки режима адаптивной компоновки';

  @override
  String get adaptive => 'Адаптивный';

  @override
  String get compact => 'Компактный';

  @override
  String get extended => 'Расширенный';

  @override
  String get theme => 'Тема';

  @override
  String get dark => 'Тёмная';

  @override
  String get light => 'Светлая';

  @override
  String get system => 'Системная';

  @override
  String get accent_color => 'Акцентный цвет';

  @override
  String get sync_album_color => 'Синхронизировать цвет альбома';

  @override
  String get sync_album_color_description =>
      'Использует основной цвет обложки альбома как цвет акцента';

  @override
  String get playback => 'Воспроизведение';

  @override
  String get audio_quality => 'Качество звука';

  @override
  String get high => 'Высокое';

  @override
  String get low => 'Низкое';

  @override
  String get pre_download_play => 'Предварительная загрузка и воспроизведение';

  @override
  String get pre_download_play_description =>
      'Вместо потоковой передачи аудио используйте загруженные байты и воспроизводьте их (рекомендуется для пользователей с высокой пропускной способностью)';

  @override
  String get skip_non_music =>
      'Пропускать немузыкальные сегменты (SponsorBlock)';

  @override
  String get blacklist_description => 'Черный список треков и артистов';

  @override
  String get wait_for_download_to_finish =>
      'Пожалуйста, дождитесь завершения текущей загрузки';

  @override
  String get desktop => 'Компьютер';

  @override
  String get close_behavior => 'Поведение при закрытии';

  @override
  String get close => 'Закрыть';

  @override
  String get minimize_to_tray => 'Свернуть';

  @override
  String get show_tray_icon => 'Показать значок на панели задач';

  @override
  String get about => 'О нас';

  @override
  String get u_love_spotube => 'Мы знаем что вам нравится Spotube';

  @override
  String get check_for_updates => 'Проверьте наличие обновлений';

  @override
  String get about_spotube => 'О Spotube';

  @override
  String get blacklist => 'Чёрный список';

  @override
  String get please_sponsor => 'Стать спосором/поддержать';

  @override
  String get spotube_description =>
      'Spotube – это легкий, кросс-платформенный клиент Spotify, предоставляющий бесплатный доступ для всех пользователей';

  @override
  String get version => 'Версия';

  @override
  String get build_number => 'Номер сборки';

  @override
  String get founder => 'Создатель';

  @override
  String get repository => 'Репозиторий';

  @override
  String get bug_issues => 'Ошибки и проблемы';

  @override
  String get made_with => 'Сделано Bangladesh🇧🇩 с ❤️';

  @override
  String get kingkor_roy_tirtho => 'Kingkor Roy Tirtho';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year Kingkor Roy Tirtho';
  }

  @override
  String get license => 'Лицензия';

  @override
  String get credentials_will_not_be_shared_disclaimer =>
      'Не беспокойся, никакая личная информация не собирается и не передается';

  @override
  String get know_how_to_login => 'Не знаете, как это сделать?';

  @override
  String get follow_step_by_step_guide => 'Следуйте пошаговому руководству';

  @override
  String cookie_name_cookie(Object name) {
    return '$name Cookie';
  }

  @override
  String get fill_in_all_fields => 'Пожалуйста, заполните все поля';

  @override
  String get submit => 'Отправить';

  @override
  String get exit => 'Выйти';

  @override
  String get previous => 'Предыдущий';

  @override
  String get next => 'Следующий';

  @override
  String get done => 'Готово';

  @override
  String get step_1 => 'Шаг 1';

  @override
  String get first_go_to => 'Сначала перейдите в';

  @override
  String get something_went_wrong => 'Что-то пошло не так';

  @override
  String get piped_instance => 'Экземпляр сервера Piped';

  @override
  String get piped_description =>
      'Серверный экземпляр Piped для сопоставления треков';

  @override
  String get piped_warning =>
      'Некоторые из них могут работать неправильно, поэтому используйте на свой страх и риск';

  @override
  String get invidious_instance => 'Экземпляр сервера Invidious';

  @override
  String get invidious_description =>
      'Экземпляр сервера Invidious для сопоставления треков';

  @override
  String get invidious_warning =>
      'Некоторые могут работать не очень хорошо. Используйте на свой страх и риск';

  @override
  String get generate => 'Генерировать';

  @override
  String track_exists(Object track) {
    return 'Трек $track уже существует';
  }

  @override
  String get replace_downloaded_tracks => 'Заменить все ранее скачанные треки';

  @override
  String get skip_download_tracks =>
      'Пропустить загрузку всех ранее скачанных треков';

  @override
  String get do_you_want_to_replace => 'Хотите заменить существующий трек??';

  @override
  String get replace => 'Заменить';

  @override
  String get skip => 'Пропустить';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return 'Выберите до $count $type';
  }

  @override
  String get select_genres => 'Выберите жанр';

  @override
  String get add_genres => 'Добавить жанр';

  @override
  String get country => 'Страна';

  @override
  String get number_of_tracks_generate => 'Количество треков для создания';

  @override
  String get acousticness => 'Акустичность';

  @override
  String get danceability => 'Ритмичность';

  @override
  String get energy => 'Энергичность';

  @override
  String get instrumentalness => 'Инструментальность';

  @override
  String get liveness => 'Живость';

  @override
  String get loudness => 'Громкость';

  @override
  String get speechiness => 'Речевой характер';

  @override
  String get valence => 'Значимость';

  @override
  String get popularity => 'Популярность';

  @override
  String get key => 'Ключ';

  @override
  String get duration => 'Продолжительность (с)';

  @override
  String get tempo => 'Темп (BPM)';

  @override
  String get mode => 'Режим';

  @override
  String get time_signature => 'Тактовый размер';

  @override
  String get short => 'Короткий';

  @override
  String get medium => 'Средний';

  @override
  String get long => 'Длинный';

  @override
  String get min => 'Минимум';

  @override
  String get max => 'Максимум';

  @override
  String get target => 'Цель';

  @override
  String get moderate => 'Отобрать';

  @override
  String get deselect_all => 'Убрать выделение со всех';

  @override
  String get select_all => 'Выделить все';

  @override
  String get are_you_sure => 'Вы уверены?';

  @override
  String get generating_playlist => 'Создание собственного плейлиста...';

  @override
  String selected_count_tracks(Object count) {
    return 'Выбрано $count треков';
  }

  @override
  String get download_warning =>
      'При скачивании всех треков пакетом вы фактически занимаетесь пиратством и наносите ущерб творческому обществу музыки. Надеюсь, что вы осознаете это. Всегда старайтесь уважать и поддерживать усилия исполнителей, вложенные в их творчество';

  @override
  String get download_ip_ban_warning =>
      'Кроме того, стоит учитывать, что из-за чрезмерного количества запросов на скачивание ваш IP-адрес может быть заблокирован на YouTube. Блокировка IP означает, что вы не сможете использовать YouTube (даже если вы вошли в свою учетную запись) в течение, как минимум, 2-3 месяцев с того устройства, с которого были сделаны эти запросы. Важно заметить, что Spotube не несет ответственности за такие события';

  @override
  String get by_clicking_accept_terms =>
      'Нажимая \'принять\', вы соглашаетесь с следующими условиями:';

  @override
  String get download_agreement_1 =>
      'Я осознаю, что я использую музыку незаконно. Это плохо.';

  @override
  String get download_agreement_2 =>
      'Я бы поддержал исполнителей, где только смог, и делаю это, так как не имею средств на приобретение их творчества';

  @override
  String get download_agreement_3 =>
      'Я полностью осознаю, что мой IP-адрес может быть заблокирован на YouTube, и я не считаю Spotube или его владельцев/соавторов ответственными за какие-либо неприятности, вызванные моими текущими действиями';

  @override
  String get decline => 'Отклонить';

  @override
  String get accept => 'Принять';

  @override
  String get details => 'Детали';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => 'Канал';

  @override
  String get likes => 'Нравится';

  @override
  String get dislikes => 'Не нравится';

  @override
  String get views => 'Просмотров';

  @override
  String get streamUrl => 'URL-адрес потока';

  @override
  String get stop => 'Остановить';

  @override
  String get sort_newest => 'Сортировать по самым новым добавленным';

  @override
  String get sort_oldest => 'Сортировать по самым старым добавленным';

  @override
  String get sleep_timer => 'Таймер сна';

  @override
  String mins(Object minutes) {
    return '$minutes Минут';
  }

  @override
  String hours(Object hours) {
    return '$hours Часы';
  }

  @override
  String hour(Object hours) {
    return '$hours Час';
  }

  @override
  String get custom_hours => 'Пользовательские часы';

  @override
  String get logs => 'Журналы';

  @override
  String get developers => 'Разработчики';

  @override
  String get not_logged_in => 'Вы не выполнили вход';

  @override
  String get search_mode => 'Режим поиска';

  @override
  String get audio_source => 'Источник аудио';

  @override
  String get ok => 'Ок';

  @override
  String get failed_to_encrypt => 'Не удалось зашифровать';

  @override
  String get encryption_failed_warning =>
      'Spotube использует шифрование для безопасного хранения ваших данных. Однако в этом случае произошла ошибка. Поэтому будет использовано небезопасное хранилище.\nЕсли вы используете Linux, убедитесь, что у вас установлен какой-либо инструмент для работы с секретами (gnome-keyring, kde-wallet, keepassxc и т.д.)';

  @override
  String get querying_info => 'Запрос информации...';

  @override
  String get piped_api_down => 'Piped API не отвечает';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return 'Экземпляр Piped $pipedInstance в данный момент недоступен.\n\nВы можете либо изменить экземпляр, либо переключиться на использование официального API YouTube.\n\nНе забудьте перезапустить приложение после внесенных изменений';
  }

  @override
  String get you_are_offline => 'Нет доступа к сети';

  @override
  String get connection_restored => 'Ваше интернет-соединение восстановлено';

  @override
  String get use_system_title_bar => 'Использовать системную панель заголовка';

  @override
  String get crunching_results => 'Обработка результатов...';

  @override
  String get search_to_get_results => 'Поиск для получения результатов';

  @override
  String get use_amoled_mode => 'Режим AMOLED';

  @override
  String get pitch_dark_theme => 'Темная тема';

  @override
  String get normalize_audio => 'Нормализовать звук';

  @override
  String get change_cover => 'Изменить обложку';

  @override
  String get add_cover => 'Добавить обложку';

  @override
  String get restore_defaults => 'Восстановить настройки по умолчанию';

  @override
  String get download_music_codec => 'Загрузить кодек для музыки';

  @override
  String get streaming_music_codec => 'Кодек потоковой передачи музыки';

  @override
  String get login_with_lastfm => 'Войти с помощью Last.fm';

  @override
  String get connect => 'Подключить';

  @override
  String get disconnect_lastfm => 'Отключиться от Last.fm';

  @override
  String get disconnect => 'Отключить';

  @override
  String get username => 'Имя пользователя';

  @override
  String get password => 'Пароль';

  @override
  String get login => 'Войти';

  @override
  String get login_with_your_lastfm => 'Войти в свою учетную запись Last.fm';

  @override
  String get scrobble_to_lastfm => 'Скробблинг на Last.fm';

  @override
  String get go_to_album => 'Перейти к альбому';

  @override
  String get discord_rich_presence => 'Богатое присутствие в Discord';

  @override
  String get browse_all => 'Просмотреть все';

  @override
  String get genres => 'Жанры';

  @override
  String get explore_genres => 'Исследовать жанры';

  @override
  String get friends => 'Друзья';

  @override
  String get no_lyrics_available =>
      'Извините, не удается найти текст для этого трека';

  @override
  String get start_a_radio => 'Запустить радио';

  @override
  String get how_to_start_radio => 'Как вы хотите запустить радио?';

  @override
  String get replace_queue_question =>
      'Хотите заменить текущую очередь или добавить к ней?';

  @override
  String get endless_playback => 'Бесконечное воспроизведение';

  @override
  String get delete_playlist => 'Удалить плейлист';

  @override
  String get delete_playlist_confirmation =>
      'Вы уверены, что хотите удалить этот плейлист?';

  @override
  String get local_tracks => 'Локальные треки';

  @override
  String get local_tab => 'Локальное';

  @override
  String get song_link => 'Ссылка на песню';

  @override
  String get skip_this_nonsense => 'Пропустить этот бред';

  @override
  String get freedom_of_music => '“Свобода музыки”';

  @override
  String get freedom_of_music_palm => '“Свобода музыки в вашей ладони”';

  @override
  String get get_started => 'Начнем';

  @override
  String get youtube_source_description =>
      'Рекомендуется и лучше всего работает.';

  @override
  String get piped_source_description =>
      'Чувствуете себя свободно? То же самое, что и YouTube, но намного бесплатно.';

  @override
  String get jiosaavn_source_description =>
      'Лучший для Южно-Азиатского региона.';

  @override
  String get invidious_source_description =>
      'Похож на Piped, но с более высокой доступностью.';

  @override
  String highest_quality(Object quality) {
    return 'Наивысшее качество: $quality';
  }

  @override
  String get select_audio_source => 'Выберите аудиоисточник';

  @override
  String get endless_playback_description =>
      'Автоматически добавляйте новые песни\nв конец очереди';

  @override
  String get choose_your_region => 'Выберите ваш регион';

  @override
  String get choose_your_region_description =>
      'Это поможет Spotube показать вам правильный контент\nдля вашего местоположения.';

  @override
  String get choose_your_language => 'Выберите ваш язык';

  @override
  String get help_project_grow => 'Помогите этому проекту расти';

  @override
  String get help_project_grow_description =>
      'Spotube - это проект с открытым исходным кодом. Вы можете помочь этому проекту развиваться, внося вклад в проект, сообщая ошибках или предлагая новые функции.';

  @override
  String get contribute_on_github => 'Внести вклад на GitHub';

  @override
  String get donate_on_open_collective => 'Пожертвовать на Open Collective';

  @override
  String get browse_anonymously => 'Анонимно просматривать';

  @override
  String get enable_connect => 'Включить подключение';

  @override
  String get enable_connect_description =>
      'Управление Spotube с других устройств';

  @override
  String get devices => 'Устройства';

  @override
  String get select => 'Выбрать';

  @override
  String connect_client_alert(Object client) {
    return 'Вас контролирует $client';
  }

  @override
  String get this_device => 'Это устройство';

  @override
  String get remote => 'Дистанционное управление';

  @override
  String get stats => 'Статистика';

  @override
  String and_n_more(Object count) {
    return 'и $count еще';
  }

  @override
  String get recently_played => 'Недавно воспроизведено';

  @override
  String get browse_more => 'Посмотреть больше';

  @override
  String get no_title => 'Без названия';

  @override
  String get not_playing => 'Не воспроизводится';

  @override
  String get epic_failure => 'Эпическое фиаско!';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return 'Добавлено $tracks_length треков в очередь';
  }

  @override
  String get spotube_has_an_update => 'В Spotube доступно обновление';

  @override
  String get download_now => 'Скачать сейчас';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Spotube Nightly $nightlyBuildNum выпущен';
  }

  @override
  String release_version(Object version) {
    return 'Spotube v$version выпущен';
  }

  @override
  String get read_the_latest => 'Читать последние ';

  @override
  String get release_notes => 'заметки о версии';

  @override
  String get pick_color_scheme => 'Выберите цветовую схему';

  @override
  String get save => 'Сохранить';

  @override
  String get choose_the_device => 'Выберите устройство:';

  @override
  String get multiple_device_connected =>
      'Подключено несколько устройств.\nВыберите устройство, на котором вы хотите выполнить это действие';

  @override
  String get nothing_found => 'Ничего не найдено';

  @override
  String get the_box_is_empty => 'Коробка пуста';

  @override
  String get top_artists => 'Лучшие артисты';

  @override
  String get top_albums => 'Лучшие альбомы';

  @override
  String get this_week => 'На этой неделе';

  @override
  String get this_month => 'В этом месяце';

  @override
  String get last_6_months => 'Последние 6 месяцев';

  @override
  String get this_year => 'В этом году';

  @override
  String get last_2_years => 'Последние 2 года';

  @override
  String get all_time => 'Все время';

  @override
  String powered_by_provider(Object providerName) {
    return 'При поддержке $providerName';
  }

  @override
  String get email => 'Электронная почта';

  @override
  String get profile_followers => 'Подписчики';

  @override
  String get birthday => 'День рождения';

  @override
  String get subscription => 'Подписка';

  @override
  String get not_born => 'Не рожден';

  @override
  String get hacker => 'Хакер';

  @override
  String get profile => 'Профиль';

  @override
  String get no_name => 'Без имени';

  @override
  String get edit => 'Редактировать';

  @override
  String get user_profile => 'Профиль пользователя';

  @override
  String count_plays(Object count) {
    return '$count воспроизведений';
  }

  @override
  String get streaming_fees_hypothetical =>
      '*Рассчитано на основе выплат Spotify за стрим\nот \$0.003 до \$0.005. Это гипотетический\nрасчет, чтобы показать пользователю, сколько бы он\nзаплатил артистам, если бы слушал их песни на Spotify.';

  @override
  String get minutes_listened => 'Минут прослушивания';

  @override
  String get streamed_songs => 'Стримленные песни';

  @override
  String count_streams(Object count) {
    return '$count стримов';
  }

  @override
  String get owned_by_you => 'Ваша собственность';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return '$shareUrl скопировано в буфер обмена';
  }

  @override
  String get hipotetical_calculation =>
      '*Это рассчитано на основе средней выплаты за прослушивание на онлайн-платформах для потоковой передачи музыки в размере от 0,003 до 0,005 долларов США. Это гипотетический расчет, чтобы дать пользователю представление о том, сколько бы они заплатили артистам, если бы слушали их песни на разных музыкальных стриминговых платформах.';

  @override
  String count_mins(Object minutes) {
    return '$minutes мин';
  }

  @override
  String get summary_minutes => 'минуты';

  @override
  String get summary_listened_to_music => 'Слушанная музыка';

  @override
  String get summary_songs => 'песни';

  @override
  String get summary_streamed_overall => 'Всего стримов';

  @override
  String get summary_owed_to_artists => 'К выплате артистам\nв этом месяце';

  @override
  String get summary_artists => 'артиста';

  @override
  String get summary_music_reached_you => 'Музыка дошла до вас';

  @override
  String get summary_full_albums => 'полные альбомы';

  @override
  String get summary_got_your_love => 'Получил вашу любовь';

  @override
  String get summary_playlists => 'плейлисты';

  @override
  String get summary_were_on_repeat => 'Были на повторе';

  @override
  String total_money(Object money) {
    return 'Всего $money';
  }

  @override
  String get webview_not_found => 'Webview не найден';

  @override
  String get webview_not_found_description =>
      'На вашем устройстве не установлена среда выполнения Webview.\nЕсли он установлен, убедитесь, что он находится в environment PATH\n\nПосле установки перезапустите приложение';

  @override
  String get unsupported_platform => 'Платформа не поддерживается';

  @override
  String get cache_music => 'Кэшировать музыку';

  @override
  String get open => 'Открыть';

  @override
  String get cache_folder => 'Папка кэша';

  @override
  String get export => 'Экспорт';

  @override
  String get clear_cache => 'Очистить кэш';

  @override
  String get clear_cache_confirmation => 'Вы хотите очистить кэш?';

  @override
  String get export_cache_files => 'Экспортировать кэшированные файлы';

  @override
  String found_n_files(Object count) {
    return 'Найдено $count файлов';
  }

  @override
  String get export_cache_confirmation =>
      'Вы хотите экспортировать эти файлы в';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return 'Экспортировано $filesExported из $files файлов';
  }

  @override
  String get undo => 'Отменить';

  @override
  String get download_all => 'Скачать все';

  @override
  String get add_all_to_playlist => 'Добавить все в плейлист';

  @override
  String get add_all_to_queue => 'Добавить все в очередь';

  @override
  String get play_all_next => 'Воспроизвести все следующее';

  @override
  String get pause => 'Пауза';

  @override
  String get view_all => 'Просмотреть все';

  @override
  String get no_tracks_added_yet =>
      'Похоже, вы ещё не добавили ни одного трека';

  @override
  String get no_tracks => 'Похоже, здесь нет треков';

  @override
  String get no_tracks_listened_yet => 'Похоже, вы ещё ничего не слушали';

  @override
  String get not_following_artists => 'Вы не подписаны на художников';

  @override
  String get no_favorite_albums_yet =>
      'Похоже, вы ещё не добавили ни одного альбома в избранное';

  @override
  String get no_logs_found => 'Логи не найдены';

  @override
  String get youtube_engine => 'YouTube Движок';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engine не установлен';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engine не установлен в вашей системе.';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return 'Убедитесь, что он доступен в переменной PATH или\nустановите абсолютный путь к исполнимому файлу $engine ниже';
  }

  @override
  String get youtube_engine_unix_issue_message =>
      'В macOS/Linux/Unix-подобных ОС, установка пути в .zshrc/.bashrc/.bash_profile и т.д. не будет работать.\nВы должны установить путь в файле конфигурации оболочки';

  @override
  String get download => 'Скачать';

  @override
  String get file_not_found => 'Файл не найден';

  @override
  String get custom => 'Пользовательский';

  @override
  String get add_custom_url => 'Добавить пользовательский URL';

  @override
  String get edit_port => 'Редактировать порт';

  @override
  String get port_helper_msg =>
      'По умолчанию -1, что означает случайное число. Если у вас настроен брандмауэр, рекомендуется установить это.';

  @override
  String connect_request(Object client) {
    return 'Разрешить $client подключение?';
  }

  @override
  String get connection_request_denied =>
      'Подключение отклонено. Пользователь отказал в доступе.';

  @override
  String get an_error_occurred => 'Произошла ошибка';

  @override
  String get copy_to_clipboard => 'Скопировать в буфер обмена';

  @override
  String get view_logs => 'Просмотреть журналы';

  @override
  String get retry => 'Повторить';

  @override
  String get no_default_metadata_provider_selected =>
      'Вы не выбрали поставщика метаданных по умолчанию';

  @override
  String get manage_metadata_providers => 'Управление поставщиками метаданных';

  @override
  String get open_link_in_browser => 'Открыть ссылку в браузере?';

  @override
  String get do_you_want_to_open_the_following_link =>
      'Вы хотите открыть следующую ссылку';

  @override
  String get unsafe_url_warning =>
      'Открытие ссылок из ненадежных источников может быть небезопасным. Будьте осторожны!\nВы также можете скопировать ссылку в буфер обмена.';

  @override
  String get copy_link => 'Копировать ссылку';

  @override
  String get building_your_timeline =>
      'Создание вашей временной шкалы на основе ваших прослушиваний...';

  @override
  String get official => 'Официальный';

  @override
  String author_name(Object author) {
    return 'Автор: $author';
  }

  @override
  String get third_party => 'Сторонний';

  @override
  String get plugin_requires_authentication => 'Плагин требует аутентификации';

  @override
  String get update_available => 'Доступно обновление';

  @override
  String get supports_scrobbling => 'Поддерживает скробблинг';

  @override
  String get plugin_scrobbling_info =>
      'Этот плагин скробблит вашу музыку для создания вашей истории прослушиваний.';

  @override
  String get default_plugin => 'По умолчанию';

  @override
  String get set_default => 'Установить по умолчанию';

  @override
  String get support => 'Поддержка';

  @override
  String get support_plugin_development => 'Поддержать разработку плагина';

  @override
  String can_access_name_api(Object name) {
    return '- Может получить доступ к API **$name**';
  }

  @override
  String get do_you_want_to_install_this_plugin =>
      'Вы хотите установить этот плагин?';

  @override
  String get third_party_plugin_warning =>
      'Этот плагин из стороннего репозитория. Пожалуйста, убедитесь, что вы доверяете источнику перед установкой.';

  @override
  String get author => 'Автор';

  @override
  String get this_plugin_can_do_following =>
      'Этот плагин может выполнять следующее';

  @override
  String get install => 'Установить';

  @override
  String get install_a_metadata_provider => 'Установить поставщика метаданных';

  @override
  String get no_tracks_playing =>
      'В настоящее время не воспроизводится ни один трек';

  @override
  String get synced_lyrics_not_available =>
      'Синхронизированные тексты недоступны для этой песни. Пожалуйста, используйте вкладку';

  @override
  String get plain_lyrics => 'Простые тексты';

  @override
  String get tab_instead => 'вместо этого.';

  @override
  String get disclaimer => 'Отказ от ответственности';

  @override
  String get third_party_plugin_dmca_notice =>
      'Команда Spotube не несет никакой ответственности (в том числе юридической) за какие-либо \"сторонние\" плагины.\nПожалуйста, используйте их на свой страх и риск. О любых ошибках/проблемах сообщайте в репозиторий плагина.\n\nЕсли какой-либо \"сторонний\" плагин нарушает ToS/DMCA какого-либо сервиса/юридического лица, пожалуйста, попросите автора плагина \"стороннего\" или хостинговую платформу, например, GitHub/Codeberg, принять меры. Перечисленные выше (помеченные как \"сторонние\") являются общедоступными/поддерживаемыми сообществом плагинами. Мы не курируем их, поэтому не можем принимать по ним никаких мер.\n\n';

  @override
  String get input_does_not_match_format =>
      'Введенные данные не соответствуют требуемому формату';

  @override
  String get plugins => 'Plugins';

  @override
  String get paste_plugin_download_url =>
      'Вставьте URL-адрес для загрузки или URL-адрес репозитория GitHub/Codeberg или прямую ссылку на файл .smplug';

  @override
  String get download_and_install_plugin_from_url =>
      'Загрузить и установить плагин по URL-адресу';

  @override
  String failed_to_add_plugin_error(Object error) {
    return 'Не удалось добавить плагин: $error';
  }

  @override
  String get upload_plugin_from_file => 'Загрузить плагин из файла';

  @override
  String get installed => 'Установлено';

  @override
  String get available_plugins => 'Доступные плагины';

  @override
  String get configure_plugins =>
      'Configure your own metadata provider and audio source plugins';

  @override
  String get audio_scrobblers => 'Аудио скробблеры';

  @override
  String get scrobbling => 'Скробблинг';

  @override
  String get source => 'Source: ';

  @override
  String get uncompressed => 'Uncompressed';

  @override
  String get dab_music_source_description =>
      'For audiophiles. Provides high-quality/lossless audio streams. Accurate ISRC based track matching.';
}
