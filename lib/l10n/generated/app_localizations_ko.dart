// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get guest => '게스트';

  @override
  String get browse => '찾아보기';

  @override
  String get search => '검색';

  @override
  String get library => '라이브러리';

  @override
  String get lyrics => '가사';

  @override
  String get settings => '설정';

  @override
  String get genre_categories_filter => '카테고리 혹은 장르별로 불러오기';

  @override
  String get genre => '장르';

  @override
  String get personalized => '맞춤 추천';

  @override
  String get featured => '인기';

  @override
  String get new_releases => '신곡';

  @override
  String get songs => '노래';

  @override
  String playing_track(Object track) {
    return '$track 을 재생';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return '현재 재생 대기열을 없앱니다。$track_length 곡이 제거됩니다。\n계속 진행할까요？';
  }

  @override
  String get load_more => '더 불러오기';

  @override
  String get playlists => '플레이리스트';

  @override
  String get artists => '아티스트';

  @override
  String get albums => '앨범';

  @override
  String get tracks => '곡';

  @override
  String get downloads => '다운로드한 곡';

  @override
  String get filter_playlists => '플레이리스트를 필터링';

  @override
  String get liked_tracks => '좋아하는 곡';

  @override
  String get liked_tracks_description => '좋아요를 남긴 곡들';

  @override
  String get playlist => '재생 목록';

  @override
  String get create_a_playlist => '플레이리스트를 생성';

  @override
  String get update_playlist => '플레이리스트를 업데이트';

  @override
  String get create => '생성';

  @override
  String get cancel => '취소';

  @override
  String get update => '업데이트';

  @override
  String get playlist_name => '플레이리스트명';

  @override
  String get name_of_playlist => '플레이리스트의 이름';

  @override
  String get description => '설명';

  @override
  String get public => '공개';

  @override
  String get collaborative => '공유 플레이리스트';

  @override
  String get search_local_tracks => '기기에 저장된 곡을 검색하기';

  @override
  String get play => '재생';

  @override
  String get delete => '삭제';

  @override
  String get none => '없음';

  @override
  String get sort_a_z => 'A-Z 순으로 정렬';

  @override
  String get sort_z_a => 'Z-A 순으로 정렬';

  @override
  String get sort_artist => '아티스트 순으로 정렬';

  @override
  String get sort_album => '앨범 순으로 정렬';

  @override
  String get sort_duration => '시간순 정렬';

  @override
  String get sort_tracks => '곡명 순으로 정렬';

  @override
  String currently_downloading(Object tracks_length) {
    return '현재 ($tracks_length) 곡 다운로드 중';
  }

  @override
  String get cancel_all => '모두 취소';

  @override
  String get filter_artist => '아티스트 필터링';

  @override
  String followers(Object followers) {
    return '$followers 팔로워';
  }

  @override
  String get add_artist_to_blacklist => '이 아티스트를 블랙리스트에 추가';

  @override
  String get top_tracks => '인기곡';

  @override
  String get fans_also_like => '애청자들이 좋아하는 곡';

  @override
  String get loading => '불러오는 중...';

  @override
  String get artist => '아티스트';

  @override
  String get blacklisted => '블랙리스트';

  @override
  String get following => '팔로우 중';

  @override
  String get follow => '팔로우하기';

  @override
  String get artist_url_copied => '아티스트의 URL 주소를 클립보드에 복사함';

  @override
  String added_to_queue(Object tracks) {
    return '$tracks 곡을 대기열에 추가함';
  }

  @override
  String get filter_albums => '앨범 필터링';

  @override
  String get synced => '동기화됨';

  @override
  String get plain => '그대로';

  @override
  String get shuffle => '셔플';

  @override
  String get search_tracks => '곡 검색하기';

  @override
  String get released => '공개일';

  @override
  String error(Object error) {
    return '에러';
  }

  @override
  String get title => '타이틀';

  @override
  String get time => '길이';

  @override
  String get more_actions => '다른 작업';

  @override
  String download_count(Object count) {
    return '($count) 곡 다운로드';
  }

  @override
  String add_count_to_playlist(Object count) {
    return '플레이리스트에 ($count) 곡을 추가';
  }

  @override
  String add_count_to_queue(Object count) {
    return '대기열에 ($count) 곡을 추가';
  }

  @override
  String play_count_next(Object count) {
    return '이 다음에 ($count) 곡을 재생';
  }

  @override
  String get album => '앨범';

  @override
  String copied_to_clipboard(Object data) {
    return '$data 를 클립보드에 복사함';
  }

  @override
  String add_to_following_playlists(Object track) {
    return '$track 을 이 플레이리스트에 추가';
  }

  @override
  String get add => '추가';

  @override
  String added_track_to_queue(Object track) {
    return '대기열에 $track 을 추가함';
  }

  @override
  String get add_to_queue => '대기열에 추가';

  @override
  String track_will_play_next(Object track) {
    return '$track 을 이 다음에 재생';
  }

  @override
  String get play_next => '이 다음에 재생';

  @override
  String removed_track_from_queue(Object track) {
    return '대기열에서 $track 를 제거함';
  }

  @override
  String get remove_from_queue => '대기열에서 제거';

  @override
  String get remove_from_favorites => '즐겨찾기에서 제거';

  @override
  String get save_as_favorite => '즐겨찾기에 추가';

  @override
  String get add_to_playlist => '플레이리스트에 추가';

  @override
  String get remove_from_playlist => '플레이리스트에서 제거';

  @override
  String get add_to_blacklist => '블랙리스트에 추가';

  @override
  String get remove_from_blacklist => '블랙리스트에서 제거';

  @override
  String get share => '공유';

  @override
  String get mini_player => '미니 플레이어';

  @override
  String get slide_to_seek => '앞뒤로 슬라이드하여 탐색';

  @override
  String get shuffle_playlist => '플레이리스트를 섞기';

  @override
  String get unshuffle_playlist => '플레이리스트를 섞지 않기';

  @override
  String get previous_track => '이전 곡';

  @override
  String get next_track => '다음 곡';

  @override
  String get pause_playback => '일시정지';

  @override
  String get resume_playback => '재개';

  @override
  String get loop_track => '반복 재생';

  @override
  String get no_loop => '반복 없음';

  @override
  String get repeat_playlist => '플레이리스트 반복';

  @override
  String get queue => '재생 대기열';

  @override
  String get alternative_track_sources => '대체가능한 음악 서버';

  @override
  String get download_track => '곡 다운로드';

  @override
  String tracks_in_queue(Object tracks) {
    return '대기열에 $tracks 곡이 있음';
  }

  @override
  String get clear_all => '모두 제거';

  @override
  String get show_hide_ui_on_hover => '마우스를 올리면 UI를 표시/숨김';

  @override
  String get always_on_top => '항상 위에 표시';

  @override
  String get exit_mini_player => '미니 플레이어 닫기';

  @override
  String get download_location => '다운로드 경로';

  @override
  String get local_library => '로컬 도서관';

  @override
  String get add_library_location => '도서관에 추가';

  @override
  String get remove_library_location => '도서관에서 제거';

  @override
  String get account => '계정';

  @override
  String get login_with_spotify => 'Spotify 계정으로 로그인';

  @override
  String get connect_with_spotify => 'Spotify에 연결';

  @override
  String get logout => '로그아웃';

  @override
  String get logout_of_this_account => '이 계정에서 로그아웃';

  @override
  String get language_region => '언어 & 지역';

  @override
  String get language => '언어';

  @override
  String get system_default => '시스템 기본설정';

  @override
  String get market_place_region => '마켓플레이스 지역';

  @override
  String get recommendation_country => '추천 국가';

  @override
  String get appearance => '디자인';

  @override
  String get layout_mode => '레이아웃 모드';

  @override
  String get override_layout_settings => '반응형 레이아웃 모드 설정 덮어씌우기';

  @override
  String get adaptive => '적응형';

  @override
  String get compact => '컴팩트';

  @override
  String get extended => '확장';

  @override
  String get theme => '테마';

  @override
  String get dark => '다크';

  @override
  String get light => '라이트';

  @override
  String get system => '시스템과 동일';

  @override
  String get accent_color => '보조색';

  @override
  String get sync_album_color => '앨범 색상';

  @override
  String get sync_album_color_description => '앨범아트의 주요 색상을 보조색으로 사용';

  @override
  String get playback => '재생';

  @override
  String get audio_quality => '음질';

  @override
  String get high => '높음';

  @override
  String get low => '낮음';

  @override
  String get pre_download_play => '재생할 곡을 미리 다운로드';

  @override
  String get pre_download_play_description => '스트리밍 방식을 쓰는 대신 파일 단위로 다운로드 받고 재생 (인터넷 대역폭이 높은 환경에서 추천)';

  @override
  String get skip_non_music => '음악이 아닌 부분을 스킵 (SponsorBlock)';

  @override
  String get blacklist_description => '블랙리스트에 추가된 곡과 아티스트';

  @override
  String get wait_for_download_to_finish => '현재 진행중인 다운로드가 끝날 때까지 기다려주세요';

  @override
  String get desktop => '데스크톱';

  @override
  String get close_behavior => '닫을 때의 동작';

  @override
  String get close => '닫기';

  @override
  String get minimize_to_tray => '트레이로 최소화';

  @override
  String get show_tray_icon => '시스템 트레이 아이콘 표시';

  @override
  String get about => '앱 정보';

  @override
  String get u_love_spotube => 'Spotube... 사랑하시죠?';

  @override
  String get check_for_updates => '업데이트 확인';

  @override
  String get about_spotube => 'Spotube에 관해';

  @override
  String get blacklist => '블랙리스트';

  @override
  String get please_sponsor => '후원해주시면 감사하겠습니다.';

  @override
  String get spotube_description => 'Spotube는, 경량에 크로스플랫폼인데다 무료이기까지한 스포티파이 클라이언트입니다';

  @override
  String get version => '버전';

  @override
  String get build_number => '빌드 번호';

  @override
  String get founder => '창시자';

  @override
  String get repository => '리포지토리';

  @override
  String get bug_issues => '버그 및 이슈';

  @override
  String get made_with => '❤️을 담아 방글라데시에서 만듦';

  @override
  String get kingkor_roy_tirtho => 'Kingkor Roy Tirtho';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year Kingkor Roy Tirtho';
  }

  @override
  String get license => '라이선스';

  @override
  String get add_spotify_credentials => '먼저 Spotify의 로그인정보를 추가하기';

  @override
  String get credentials_will_not_be_shared_disclaimer => '걱정마세요. 개인정보를 수집하거나 공유하지 않습니다.';

  @override
  String get know_how_to_login => '어떻게 하는건지 모르겠나요?';

  @override
  String get follow_step_by_step_guide => '사용법 확인하기';

  @override
  String spotify_cookie(Object name) {
    return 'Spotify $name Cookies';
  }

  @override
  String cookie_name_cookie(Object name) {
    return '$name Cookies';
  }

  @override
  String get fill_in_all_fields => '모든 필드에 정보를 입력해주세요';

  @override
  String get submit => '제출';

  @override
  String get exit => '종료';

  @override
  String get previous => '이전으로';

  @override
  String get next => '다음으로';

  @override
  String get done => '완료';

  @override
  String get step_1 => '1단계';

  @override
  String get first_go_to => '가장 먼저 먼저 들어갈 곳은 ';

  @override
  String get login_if_not_logged_in => '그리고 로그인을 하지 않았다면 로그인해주세요';

  @override
  String get step_2 => '2단계';

  @override
  String get step_2_steps => '1. 로그인에 성공하면、F12나 마우스 우클릭 ＞ 검사(Inspect)을 눌러 브라우저의 개발자 도구(devtools)를 열어주세요.\n2. 애플리케이션 (Application) 탭 (Chrome, Edge, Brave 등) 또는 스토리지 탭 (Firefox, Palemoon 등)을 열어주세요.\n3. 쿠키 (Cookies) 섹션으로 들어가서, https://accounts.spotify.com 서브섹션으로 들어가주세요.';

  @override
  String get step_3 => '3단계';

  @override
  String get step_3_steps => '\"sp_dc\" 쿠키의 값을 복사';

  @override
  String get success_emoji => '성공🥳';

  @override
  String get success_message => '성공적으로 스포티파이 게정으로 로그인했습니다. 잘했어요!';

  @override
  String get step_4 => '4단계';

  @override
  String get step_4_steps => '복사한 \"sp_dc\"값을 붙여넣기';

  @override
  String get something_went_wrong => '알 수 없는 이유로 동작에 실패했습니다.';

  @override
  String get piped_instance => 'Piped 서버의 인스턴스';

  @override
  String get piped_description => '곡 탐색에 사용할 Piped 서버 인스턴스';

  @override
  String get piped_warning => '몇몇 서버는 제대로 동작하지 않을 수 있습니다. 본인 책임 하에 이용해주세요.';

  @override
  String get invidious_instance => 'Invidious 서버 인스턴스';

  @override
  String get invidious_description => '트랙 매칭에 사용할 Invidious 서버 인스턴스';

  @override
  String get invidious_warning => '일부는 제대로 작동하지 않을 수 있습니다. 자신의 책임 하에 사용하세요';

  @override
  String get generate => '생성';

  @override
  String track_exists(Object track) {
    return '곡 $track 은 이미 리스트에 있습니다';
  }

  @override
  String get replace_downloaded_tracks => '다운로드한 모든 곡을 교체';

  @override
  String get skip_download_tracks => '다운로드가 끝난 곡을 모두 건너뛰기';

  @override
  String get do_you_want_to_replace => '현재 곡을 교체하시겠습니까?';

  @override
  String get replace => '교체';

  @override
  String get skip => '건너뛰기';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return '$type을 $count개까지 선택';
  }

  @override
  String get select_genres => '장르 선택';

  @override
  String get add_genres => '장르 추가';

  @override
  String get country => '국가';

  @override
  String get number_of_tracks_generate => '생성할 곡 수';

  @override
  String get acousticness => '반주 구간 (Acousticness)';

  @override
  String get danceability => '흥겨운 정도 (Danceability)';

  @override
  String get energy => '에너지 (Energy)';

  @override
  String get instrumentalness => '기악성 (Instrumentalness)';

  @override
  String get liveness => '생동감 (Liveness)';

  @override
  String get loudness => '라우드니스 (Loudness)';

  @override
  String get speechiness => '회화성 (Speechniss)';

  @override
  String get valence => '감정가 (Valence)';

  @override
  String get popularity => '인기도 (Popularity)';

  @override
  String get key => '조성 (키)';

  @override
  String get duration => '길이 (초)';

  @override
  String get tempo => '템포 (BPM)';

  @override
  String get mode => '장조';

  @override
  String get time_signature => '박자';

  @override
  String get short => '짧음';

  @override
  String get medium => '중간';

  @override
  String get long => '긺';

  @override
  String get min => '최소';

  @override
  String get max => '최대';

  @override
  String get target => '목표';

  @override
  String get moderate => '보통';

  @override
  String get deselect_all => '모두 선택해제';

  @override
  String get select_all => '모두 선택';

  @override
  String get are_you_sure => '괜찮겠습니까?';

  @override
  String get generating_playlist => '커스텀 플레이리스트를 생성하는 중...';

  @override
  String selected_count_tracks(Object count) {
    return '$count 곡이 선택되었습니다.';
  }

  @override
  String get download_warning => '모든 트랙을 대량으로 다운로드하는 것은 명백한 불법 복제이며 음악 창작 사회에 피해를 입히는 행위입니다. 이 점을 알아주셨으면 합니다. 항상 아티스트의 노력을 존중하고 응원해 주세요.';

  @override
  String get download_ip_ban_warning => '참고로, 평소보다 과도한 다운로드 요청으로 인해 YouTube에서 IP가 차단될 수 있습니다. IP 차단은 해당 IP 기기에서 최소 2~3개월 동안 (로그인한 상태에서도) YouTube를 사용할 수 없음을 의미합니다. 그리고 이런 일이 발생하더라도 스포튜브는 어떠한 책임도 지지 않습니다.';

  @override
  String get by_clicking_accept_terms => '\'동의\'를 클릭하면 다음 약관에 동의하는 것입니다:';

  @override
  String get download_agreement_1 => '알고 있습니다. 전 나쁜 사람입니다.';

  @override
  String get download_agreement_2 => '제가 할 수 있는 모든 곳에서 아티스트를 지원할 것이며, 저는 그들의 작품을 살 돈이 없기 때문에 이렇게 하는 것뿐입니다.';

  @override
  String get download_agreement_3 => '본인은 YouTube에서 내 IP가 차단될 수 있음을 완전히 알고 있으며, 현재 내 행동으로 인해 발생하는 사고에 대해 Spotube 또는 그 소유자/기여자에게 책임을 묻지 않습니다.';

  @override
  String get decline => '거절';

  @override
  String get accept => '동의';

  @override
  String get details => '상세';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => '채널';

  @override
  String get likes => '좋아요';

  @override
  String get dislikes => '싫어요';

  @override
  String get views => '조회수';

  @override
  String get streamUrl => '스트림 URL';

  @override
  String get stop => '중지';

  @override
  String get sort_newest => '최근에 추가된 순으로 정렬';

  @override
  String get sort_oldest => '예전에 추가된 순으로 정렬';

  @override
  String get sleep_timer => '취침 타이머';

  @override
  String mins(Object minutes) {
    return '$minutes 분';
  }

  @override
  String hours(Object hours) {
    return '$hours 시간';
  }

  @override
  String hour(Object hours) {
    return '$hours 시간';
  }

  @override
  String get custom_hours => '시간 설정';

  @override
  String get logs => '로그';

  @override
  String get developers => '개발';

  @override
  String get not_logged_in => '로그인하지 않았습니다';

  @override
  String get search_mode => '검색 모드';

  @override
  String get audio_source => '오디오 출처';

  @override
  String get ok => '알겠습니다';

  @override
  String get failed_to_encrypt => '암호화에 실패했습니다';

  @override
  String get encryption_failed_warning => 'Spotube는 암호화를 사용하여 데이터를 안전하게 저장합니다. 하지만 그렇게 하지 못했습니다. 따라서 안전하지 않은 저장소로 대체됩니다.\n리눅스를 사용하는 경우, 비밀 서비스(gnome-keyring, kde-wallet, keepassxc 등)가 설치되어 있는지 확인하세요.';

  @override
  String get querying_info => '정보를 얻는 중...';

  @override
  String get piped_api_down => 'Piped API가 응답하지 않습니다';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return 'Piped 인스턴스 $pipedInstance가 현재 다운되었습니다.\n\n인스턴스를 변경하거나 \'API 유형\'을 공식 YouTube API로 변경하세요.\n\n변경 후 앱을 다시 시작해야 합니다.';
  }

  @override
  String get you_are_offline => '현재 오프라인입니다';

  @override
  String get connection_restored => '인터넷에 다시 연결되었습니다';

  @override
  String get use_system_title_bar => '시스템 타이틀바를 사용';

  @override
  String get crunching_results => '결과를 처리하는 중...';

  @override
  String get search_to_get_results => '결과를 얻으려면 검색해주세요';

  @override
  String get use_amoled_mode => 'AMOLED모드를 사용';

  @override
  String get pitch_dark_theme => '검정색 기반의 어두운 테마';

  @override
  String get normalize_audio => '오디오 노멀라이즈';

  @override
  String get change_cover => '커버 변경';

  @override
  String get add_cover => '커버 추가';

  @override
  String get restore_defaults => '기본값으로 복원';

  @override
  String get download_music_codec => '다운로드 음악 코덱';

  @override
  String get streaming_music_codec => '스트리밍 음악 코덱';

  @override
  String get login_with_lastfm => 'Last.fm에 로그인';

  @override
  String get connect => '연결';

  @override
  String get disconnect_lastfm => 'Last.fm에서 연결 해제';

  @override
  String get disconnect => '연결 해제';

  @override
  String get username => '사용자명';

  @override
  String get password => '비밀번호';

  @override
  String get login => '로그인';

  @override
  String get login_with_your_lastfm => '내 Last.fm 계정으로로그인';

  @override
  String get scrobble_to_lastfm => 'Scrobble to Last.fm';

  @override
  String get go_to_album => '앨범으로 이동';

  @override
  String get discord_rich_presence => 'Discord Rich Presence';

  @override
  String get browse_all => '모두 탐색';

  @override
  String get genres => '장르';

  @override
  String get explore_genres => '장르 탐색';

  @override
  String get friends => '친구';

  @override
  String get no_lyrics_available => '죄송하지만 이 곡의 가사를 찾지 못했습니다';

  @override
  String get start_a_radio => '라디오 시작';

  @override
  String get how_to_start_radio => '라디오를 어떻게 시작하시겠습니까?';

  @override
  String get replace_queue_question => '현재 큐를 대체하시겠습니까 아니면 추가하시겠습니까?';

  @override
  String get endless_playback => '끝없는 재생';

  @override
  String get delete_playlist => '재생 목록 삭제';

  @override
  String get delete_playlist_confirmation => '이 재생 목록을 삭제하시겠습니까?';

  @override
  String get local_tracks => '로컬 트랙';

  @override
  String get local_tab => '로컬';

  @override
  String get song_link => '곡 링크';

  @override
  String get skip_this_nonsense => '이 허튼소리 건너뛰기';

  @override
  String get freedom_of_music => '“음악의 자유”';

  @override
  String get freedom_of_music_palm => '“손바닥 안의 음악의 자유”';

  @override
  String get get_started => '시작합시다';

  @override
  String get youtube_source_description => '추천되며 가장 잘 작동합니다.';

  @override
  String get piped_source_description => '자유로운 기분이 듭니까? YouTube와 같지만 훨씬 더 무료합니다.';

  @override
  String get jiosaavn_source_description => '남아시아 지역에 최적입니다.';

  @override
  String get invidious_source_description => 'Piped와 비슷하지만 가용성이 높습니다.';

  @override
  String highest_quality(Object quality) {
    return '최고 품질: $quality';
  }

  @override
  String get select_audio_source => '오디오 소스 선택';

  @override
  String get endless_playback_description => '자동으로 새로운 노래를 대기열의 끝에 추가';

  @override
  String get choose_your_region => '지역 선택';

  @override
  String get choose_your_region_description => '이것은 Spotube가 위치에 맞는 콘텐츠를 표시하는 데 도움이 됩니다.';

  @override
  String get choose_your_language => '언어 선택';

  @override
  String get help_project_grow => '이 프로젝트 성장에 도움을 주세요';

  @override
  String get help_project_grow_description => 'Spotube는 오픈 소스 프로젝트입니다. 프로젝트에 기여하거나 버그를 보고하거나 새로운 기능을 제안하여이 프로젝트의 성장에 도움을 줄 수 있습니다.';

  @override
  String get contribute_on_github => 'GitHub에서 기여하기';

  @override
  String get donate_on_open_collective => 'Open Collective에 기부하기';

  @override
  String get browse_anonymously => '익명으로 둘러보기';

  @override
  String get enable_connect => '연결 활성화';

  @override
  String get enable_connect_description => '다른 장치에서 Spotube 제어';

  @override
  String get devices => '장치';

  @override
  String get select => '선택';

  @override
  String connect_client_alert(Object client) {
    return '$client님에 의해 제어되고 있습니다';
  }

  @override
  String get this_device => '이 장치';

  @override
  String get remote => '원격';

  @override
  String get stats => '통계';

  @override
  String and_n_more(Object count) {
    return '그리고 $count개 더';
  }

  @override
  String get recently_played => '최근 재생';

  @override
  String get browse_more => '더 보기';

  @override
  String get no_title => '제목 없음';

  @override
  String get not_playing => '재생 중이 아님';

  @override
  String get epic_failure => '서사적 실패!';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return '$tracks_length 곡을 대기열에 추가했습니다';
  }

  @override
  String get spotube_has_an_update => 'Spotube에 업데이트가 있습니다';

  @override
  String get download_now => '지금 다운로드';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Spotube Nightly $nightlyBuildNum이 출시되었습니다';
  }

  @override
  String release_version(Object version) {
    return 'Spotube v$version이 출시되었습니다';
  }

  @override
  String get read_the_latest => '최신 ';

  @override
  String get release_notes => '릴리스 노트';

  @override
  String get pick_color_scheme => '색상 테마 선택';

  @override
  String get save => '저장';

  @override
  String get choose_the_device => '디바이스 선택:';

  @override
  String get multiple_device_connected => '여러 디바이스가 연결되어 있습니다.\n이 작업을 실행할 디바이스를 선택하세요';

  @override
  String get nothing_found => '찾을 수 없음';

  @override
  String get the_box_is_empty => '상자가 비어 있습니다';

  @override
  String get top_artists => '톱 아티스트';

  @override
  String get top_albums => '톱 앨범';

  @override
  String get this_week => '이번 주';

  @override
  String get this_month => '이번 달';

  @override
  String get last_6_months => '지난 6개월';

  @override
  String get this_year => '올해';

  @override
  String get last_2_years => '지난 2년';

  @override
  String get all_time => '모든 시간';

  @override
  String powered_by_provider(Object providerName) {
    return '$providerName 제공';
  }

  @override
  String get email => '이메일';

  @override
  String get profile_followers => '팔로워';

  @override
  String get birthday => '생일';

  @override
  String get subscription => '구독';

  @override
  String get not_born => '태어나지 않음';

  @override
  String get hacker => '해커';

  @override
  String get profile => '프로필';

  @override
  String get no_name => '이름 없음';

  @override
  String get edit => '편집';

  @override
  String get user_profile => '사용자 프로필';

  @override
  String count_plays(Object count) {
    return '$count 재생';
  }

  @override
  String get streaming_fees_hypothetical => '*이것은 Spotify의 스트림당 지급액\n\$0.003에서 \$0.005를 기준으로 계산된 것입니다.\n이것은 사용자가 Spotify에서 곡을 들었을 때\n아티스트에게 지불했을 금액에 대한 통찰을 제공하기 위한\n가상의 계산입니다.';

  @override
  String get minutes_listened => '청취한 시간';

  @override
  String get streamed_songs => '스트리밍된 곡';

  @override
  String count_streams(Object count) {
    return '$count 스트림';
  }

  @override
  String get owned_by_you => '당신이 소유';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return '$shareUrl를 클립보드에 복사했습니다';
  }

  @override
  String get spotify_hipotetical_calculation => '*Spotify의 스트림당 지불금 \$0.003에서 \$0.005까지의\n기준으로 계산되었습니다. 이는 사용자가 Spotify에서\n곡을 들을 때 아티스트에게 얼마를 지불했을지를\n알려주기 위한 가상의 계산입니다.';

  @override
  String count_mins(Object minutes) {
    return '$minutes 분';
  }

  @override
  String get summary_minutes => '분';

  @override
  String get summary_listened_to_music => '듣는 음악';

  @override
  String get summary_songs => '곡';

  @override
  String get summary_streamed_overall => '전체 스트리밍';

  @override
  String get summary_owed_to_artists => '이번 달 아티스트에게 지급해야 할 금액';

  @override
  String get summary_artists => '아티스트의';

  @override
  String get summary_music_reached_you => '음악이 도달함';

  @override
  String get summary_full_albums => '전체 앨범';

  @override
  String get summary_got_your_love => '당신의 사랑을 받음';

  @override
  String get summary_playlists => '플레이리스트';

  @override
  String get summary_were_on_repeat => '반복 재생됨';

  @override
  String total_money(Object money) {
    return '총 $money';
  }

  @override
  String get webview_not_found => '웹뷰를 찾을 수 없음';

  @override
  String get webview_not_found_description => '기기에 웹뷰 런타임이 설치되지 않았습니다.\n설치되어 있으면 environment PATH에 있는지 확인하십시오\n\n설치 후 앱을 다시 시작하세요';

  @override
  String get unsupported_platform => '지원되지 않는 플랫폼';

  @override
  String get cache_music => '음악 캐시';

  @override
  String get open => '열기';

  @override
  String get cache_folder => '캐시 폴더';

  @override
  String get export => '내보내기';

  @override
  String get clear_cache => '캐시 지우기';

  @override
  String get clear_cache_confirmation => '캐시를 지우시겠습니까?';

  @override
  String get export_cache_files => '캐시된 파일 내보내기';

  @override
  String found_n_files(Object count) {
    return '$count개의 파일을 찾았습니다';
  }

  @override
  String get export_cache_confirmation => '이 파일들을 내보내시겠습니까';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return '$files개 중 $filesExported개 파일을 내보냈습니다';
  }

  @override
  String get undo => '실행 취소';

  @override
  String get download_all => '모두 다운로드';

  @override
  String get add_all_to_playlist => '모두 재생 목록에 추가';

  @override
  String get add_all_to_queue => '모두 큐에 추가';

  @override
  String get play_all_next => '모두 다음에 재생';

  @override
  String get pause => '일시 정지';

  @override
  String get view_all => '모두 보기';

  @override
  String get no_tracks_added_yet => '아직 트랙을 추가하지 않은 것 같습니다';

  @override
  String get no_tracks => '여기에 트랙이 없는 것 같습니다';

  @override
  String get no_tracks_listened_yet => '아직 아무 것도 듣지 않은 것 같습니다';

  @override
  String get not_following_artists => '아티스트를 팔로우하지 않고 있습니다';

  @override
  String get no_favorite_albums_yet => '아직 즐겨찾기 앨범을 추가하지 않은 것 같습니다';

  @override
  String get no_logs_found => '로그를 찾을 수 없습니다';

  @override
  String get youtube_engine => 'YouTube 엔진';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engine가 설치되지 않았습니다';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engine가 시스템에 설치되지 않았습니다.';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return 'PATH 변수에서 사용할 수 있는지 확인하거나\n아래에 $engine 실행 파일의 절대 경로를 설정하세요';
  }

  @override
  String get youtube_engine_unix_issue_message => 'macOS/Linux/unix와 같은 운영 체제에서는 .zshrc/.bashrc/.bash_profile 등에 경로 설정이 작동하지 않습니다.\n셸 구성 파일에 경로를 설정해야 합니다';

  @override
  String get download => '다운로드';

  @override
  String get file_not_found => '파일을 찾을 수 없습니다';

  @override
  String get custom => '사용자 정의';

  @override
  String get add_custom_url => '사용자 정의 URL 추가';

  @override
  String get edit_port => 'Edit port';

  @override
  String get port_helper_msg => 'Default is -1 which indicates random number. If you\'ve firewall configured, setting this is recommended.';
}
