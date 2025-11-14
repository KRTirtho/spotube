// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get guest => 'Guest';

  @override
  String get browse => 'Browse';

  @override
  String get search => 'Search';

  @override
  String get library => 'Library';

  @override
  String get lyrics => 'Lyrics';

  @override
  String get settings => 'Settings';

  @override
  String get genre_categories_filter => 'Filter categories or genres...';

  @override
  String get genre => 'Genre';

  @override
  String get personalized => 'Personalized';

  @override
  String get featured => 'Featured';

  @override
  String get new_releases => 'New Releases';

  @override
  String get songs => 'Songs';

  @override
  String playing_track(Object track) {
    return 'Playing $track';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return 'This will clear the current queue. $track_length tracks will be removed\nDo you want to continue?';
  }

  @override
  String get load_more => 'Load more';

  @override
  String get playlists => 'Playlists';

  @override
  String get artists => 'Artists';

  @override
  String get albums => 'Albums';

  @override
  String get tracks => 'Tracks';

  @override
  String get downloads => 'Downloads';

  @override
  String get filter_playlists => 'Filter your playlists...';

  @override
  String get liked_tracks => 'Liked Tracks';

  @override
  String get liked_tracks_description => 'All your liked tracks';

  @override
  String get playlist => 'Playlist';

  @override
  String get create_a_playlist => 'Create a playlist';

  @override
  String get update_playlist => 'Update playlist';

  @override
  String get create => 'Create';

  @override
  String get cancel => 'Cancel';

  @override
  String get update => 'Update';

  @override
  String get playlist_name => 'Playlist Name';

  @override
  String get name_of_playlist => 'Name of the playlist';

  @override
  String get description => 'Description';

  @override
  String get public => 'Public';

  @override
  String get collaborative => 'Collaborative';

  @override
  String get search_local_tracks => 'Search local tracks...';

  @override
  String get play => 'Play';

  @override
  String get delete => 'Delete';

  @override
  String get none => 'None';

  @override
  String get sort_a_z => 'Sort by A-Z';

  @override
  String get sort_z_a => 'Sort by Z-A';

  @override
  String get sort_artist => 'Sort by Artist';

  @override
  String get sort_album => 'Sort by Album';

  @override
  String get sort_duration => 'Sort by Duration';

  @override
  String get sort_tracks => 'Sort Tracks';

  @override
  String currently_downloading(Object tracks_length) {
    return 'Currently Downloading ($tracks_length)';
  }

  @override
  String get cancel_all => 'Cancel All';

  @override
  String get filter_artist => 'Filter artists...';

  @override
  String followers(Object followers) {
    return '$followers Followers';
  }

  @override
  String get add_artist_to_blacklist => 'Add artist to blacklist';

  @override
  String get top_tracks => 'Top Tracks';

  @override
  String get fans_also_like => 'Fans also like';

  @override
  String get loading => 'Loading...';

  @override
  String get artist => 'Artist';

  @override
  String get blacklisted => 'Blacklisted';

  @override
  String get following => 'Following';

  @override
  String get follow => 'Follow';

  @override
  String get artist_url_copied => 'Artist URL copied to clipboard';

  @override
  String added_to_queue(Object tracks) {
    return 'Added $tracks tracks to queue';
  }

  @override
  String get filter_albums => 'Filter albums...';

  @override
  String get synced => 'Synced';

  @override
  String get plain => 'Plain';

  @override
  String get shuffle => 'Shuffle';

  @override
  String get search_tracks => 'Search tracks...';

  @override
  String get released => 'Released';

  @override
  String error(Object error) {
    return 'Error $error';
  }

  @override
  String get title => 'Title';

  @override
  String get time => 'Time';

  @override
  String get more_actions => 'More actions';

  @override
  String download_count(Object count) {
    return 'Download ($count)';
  }

  @override
  String add_count_to_playlist(Object count) {
    return 'Add ($count) to Playlist';
  }

  @override
  String add_count_to_queue(Object count) {
    return 'Add ($count) to Queue';
  }

  @override
  String play_count_next(Object count) {
    return 'Play ($count) next';
  }

  @override
  String get album => 'Album';

  @override
  String copied_to_clipboard(Object data) {
    return 'Copied $data to clipboard';
  }

  @override
  String add_to_following_playlists(Object track) {
    return 'Add $track to following Playlists';
  }

  @override
  String get add => 'Add';

  @override
  String added_track_to_queue(Object track) {
    return 'Added $track to queue';
  }

  @override
  String get add_to_queue => 'Add to queue';

  @override
  String track_will_play_next(Object track) {
    return '$track will play next';
  }

  @override
  String get play_next => 'Play next';

  @override
  String removed_track_from_queue(Object track) {
    return 'Removed $track from queue';
  }

  @override
  String get remove_from_queue => 'Remove from queue';

  @override
  String get remove_from_favorites => 'Remove from favorites';

  @override
  String get save_as_favorite => 'Save as favorite';

  @override
  String get add_to_playlist => 'Add to playlist';

  @override
  String get remove_from_playlist => 'Remove from playlist';

  @override
  String get add_to_blacklist => 'Add to blacklist';

  @override
  String get remove_from_blacklist => 'Remove from blacklist';

  @override
  String get share => 'Share';

  @override
  String get mini_player => 'Mini Player';

  @override
  String get slide_to_seek => 'Slide to seek forward or backward';

  @override
  String get shuffle_playlist => 'Shuffle playlist';

  @override
  String get unshuffle_playlist => 'Unshuffle playlist';

  @override
  String get previous_track => 'Previous track';

  @override
  String get next_track => 'Next track';

  @override
  String get pause_playback => 'Pause Playback';

  @override
  String get resume_playback => 'Resume Playback';

  @override
  String get loop_track => 'Loop track';

  @override
  String get no_loop => 'No loop';

  @override
  String get repeat_playlist => 'Repeat playlist';

  @override
  String get queue => 'Queue';

  @override
  String get alternative_track_sources => 'Alternative track sources';

  @override
  String get download_track => 'Download track';

  @override
  String tracks_in_queue(Object tracks) {
    return '$tracks tracks in queue';
  }

  @override
  String get clear_all => 'Clear all';

  @override
  String get show_hide_ui_on_hover => 'Show/Hide UI on hover';

  @override
  String get always_on_top => 'Always on top';

  @override
  String get exit_mini_player => 'Exit Mini player';

  @override
  String get download_location => 'Download location';

  @override
  String get local_library => 'Local library';

  @override
  String get add_library_location => 'Add to library';

  @override
  String get remove_library_location => 'Remove from library';

  @override
  String get account => 'Account';

  @override
  String get logout => 'Logout';

  @override
  String get logout_of_this_account => 'Logout of this account';

  @override
  String get language_region => 'Language & Region';

  @override
  String get language => 'Language';

  @override
  String get system_default => 'System Default';

  @override
  String get market_place_region => 'Marketplace Region';

  @override
  String get recommendation_country => 'Recommendation Country';

  @override
  String get appearance => 'Appearance';

  @override
  String get layout_mode => 'Layout Mode';

  @override
  String get override_layout_settings =>
      'Override responsive layout mode settings';

  @override
  String get adaptive => 'Adaptive';

  @override
  String get compact => 'Compact';

  @override
  String get extended => 'Extended';

  @override
  String get theme => 'Theme';

  @override
  String get dark => 'Dark';

  @override
  String get light => 'Light';

  @override
  String get system => 'System';

  @override
  String get accent_color => 'Accent Color';

  @override
  String get sync_album_color => 'Sync album color';

  @override
  String get sync_album_color_description =>
      'Uses the dominant color of the album art as the accent color';

  @override
  String get playback => 'Playback';

  @override
  String get audio_quality => 'Audio Quality';

  @override
  String get high => 'High';

  @override
  String get low => 'Low';

  @override
  String get pre_download_play => 'Pre-download and play';

  @override
  String get pre_download_play_description =>
      'Instead of streaming audio, download bytes and play instead (Recommended for higher bandwidth users)';

  @override
  String get skip_non_music => 'Skip non-music segments (SponsorBlock)';

  @override
  String get blacklist_description => 'Blacklisted tracks and artists';

  @override
  String get wait_for_download_to_finish =>
      'Please wait for the current download to finish';

  @override
  String get desktop => 'Desktop';

  @override
  String get close_behavior => 'Close Behavior';

  @override
  String get close => 'Close';

  @override
  String get minimize_to_tray => 'Minimize to tray';

  @override
  String get show_tray_icon => 'Show System tray icon';

  @override
  String get about => 'About';

  @override
  String get u_love_spotube => 'We know you love Spotube';

  @override
  String get check_for_updates => 'Check for updates';

  @override
  String get about_spotube => 'About Spotube';

  @override
  String get blacklist => 'Blacklist';

  @override
  String get please_sponsor => 'Please Sponsor/Donate';

  @override
  String get spotube_description =>
      'Open source extensible music streaming platform and app, based on BYOMM (Bring your own music metadata) concept';

  @override
  String get version => 'Version';

  @override
  String get build_number => 'Build Number';

  @override
  String get founder => 'Founder';

  @override
  String get repository => 'Repository';

  @override
  String get bug_issues => 'Bug+Issues';

  @override
  String get made_with => 'Made with ❤️ in Bangladesh🇧🇩';

  @override
  String get kingkor_roy_tirtho => 'Kingkor Roy Tirtho';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year Kingkor Roy Tirtho';
  }

  @override
  String get license => 'License';

  @override
  String get credentials_will_not_be_shared_disclaimer =>
      'Don\'t worry, any of your credentials won\'t be collected or shared with anyone';

  @override
  String get know_how_to_login => 'Don\'t know how to do this?';

  @override
  String get follow_step_by_step_guide => 'Follow along the Step by Step guide';

  @override
  String cookie_name_cookie(Object name) {
    return '$name Cookie';
  }

  @override
  String get fill_in_all_fields => 'Please fill in all the fields';

  @override
  String get submit => 'Submit';

  @override
  String get exit => 'Exit';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get step_1 => 'Step 1';

  @override
  String get first_go_to => 'First, Go to';

  @override
  String get something_went_wrong => 'Something went wrong';

  @override
  String get piped_instance => 'Piped Server Instance';

  @override
  String get piped_description =>
      'The Piped server instance to use for track matching';

  @override
  String get piped_warning =>
      'Some of them might not work well. So use at your own risk';

  @override
  String get invidious_instance => 'Invidious Server Instance';

  @override
  String get invidious_description =>
      'The Invidious server instance to use for track matching';

  @override
  String get invidious_warning =>
      'Some of them might not work well. So use at your own risk';

  @override
  String get generate => 'Generate';

  @override
  String track_exists(Object track) {
    return 'Track $track already exists';
  }

  @override
  String get replace_downloaded_tracks => 'Replace all downloaded tracks';

  @override
  String get skip_download_tracks => 'Skip downloading all downloaded tracks';

  @override
  String get do_you_want_to_replace =>
      'Do you want to replace the existing track??';

  @override
  String get replace => 'Replace';

  @override
  String get skip => 'Skip';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return 'Select up to $count $type';
  }

  @override
  String get select_genres => 'Select Genres';

  @override
  String get add_genres => 'Add Genres';

  @override
  String get country => 'Country';

  @override
  String get number_of_tracks_generate => 'Number of tracks to generate';

  @override
  String get acousticness => 'Acousticness';

  @override
  String get danceability => 'Danceability';

  @override
  String get energy => 'Energy';

  @override
  String get instrumentalness => 'Instrumentalness';

  @override
  String get liveness => 'Liveness';

  @override
  String get loudness => 'Loudness';

  @override
  String get speechiness => 'Speechiness';

  @override
  String get valence => 'Valence';

  @override
  String get popularity => 'Popularity';

  @override
  String get key => 'Key';

  @override
  String get duration => 'Duration (s)';

  @override
  String get tempo => 'Tempo (BPM)';

  @override
  String get mode => 'Mode';

  @override
  String get time_signature => 'Time Signature';

  @override
  String get short => 'Short';

  @override
  String get medium => 'Medium';

  @override
  String get long => 'Long';

  @override
  String get min => 'Min';

  @override
  String get max => 'Max';

  @override
  String get target => 'Target';

  @override
  String get moderate => 'Moderate';

  @override
  String get deselect_all => 'Deselect All';

  @override
  String get select_all => 'Select All';

  @override
  String get are_you_sure => 'Are you sure?';

  @override
  String get generating_playlist => 'Generating your custom playlist...';

  @override
  String selected_count_tracks(Object count) {
    return 'Selected $count tracks';
  }

  @override
  String get download_warning =>
      'If you download all Tracks at bulk you\'re clearly pirating Music & causing damage to the creative society of Music. I hope you are aware of this. Always, try respecting & supporting Artist\'s hard work';

  @override
  String get download_ip_ban_warning =>
      'BTW, your IP can get blocked on YouTube due excessive download requests than usual. IP block means you can\'t use YouTube (even if you\'re logged in) for at least 2-3 months from that IP device. And Spotube doesn\'t hold any responsibility if this ever happens';

  @override
  String get by_clicking_accept_terms =>
      'By clicking \'accept\' you agree to following terms:';

  @override
  String get download_agreement_1 => 'I know I\'m pirating Music. I\'m bad';

  @override
  String get download_agreement_2 =>
      'I\'ll support the Artist wherever I can and I\'m only doing this because I don\'t have money to buy their art';

  @override
  String get download_agreement_3 =>
      'I\'m completely aware that my IP can get blocked on YouTube & I don\'t hold Spotube or his owners/contributors responsible for any accidents caused by my current action';

  @override
  String get decline => 'Decline';

  @override
  String get accept => 'Accept';

  @override
  String get details => 'Details';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => 'Channel';

  @override
  String get likes => 'Likes';

  @override
  String get dislikes => 'Dislikes';

  @override
  String get views => 'Views';

  @override
  String get streamUrl => 'Stream URL';

  @override
  String get stop => 'Stop';

  @override
  String get sort_newest => 'Sort by newest added';

  @override
  String get sort_oldest => 'Sort by oldest added';

  @override
  String get sleep_timer => 'Sleep Timer';

  @override
  String mins(Object minutes) {
    return '$minutes Minutes';
  }

  @override
  String hours(Object hours) {
    return '$hours Hours';
  }

  @override
  String hour(Object hours) {
    return '$hours Hour';
  }

  @override
  String get custom_hours => 'Custom Hours';

  @override
  String get logs => 'Logs';

  @override
  String get developers => 'Developers';

  @override
  String get not_logged_in => 'You\'re not logged in';

  @override
  String get search_mode => 'Search Mode';

  @override
  String get audio_source => 'Audio Source';

  @override
  String get ok => 'Ok';

  @override
  String get failed_to_encrypt => 'Failed to encrypt';

  @override
  String get encryption_failed_warning =>
      'Spotube uses encryption to securely store your data. But failed to do so. So it\'ll fallback to insecure storage\nIf you\'re using linux, please make sure you\'ve any secret-service (gnome-keyring, kde-wallet, keepassxc etc) installed';

  @override
  String get querying_info => 'Querying info...';

  @override
  String get piped_api_down => 'Piped API is down';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return 'The Piped instance $pipedInstance is currently down\n\nEither change the instance or change the \'API type\' to official YouTube API\n\nMake sure to restart the app after change';
  }

  @override
  String get you_are_offline => 'You are currently offline';

  @override
  String get connection_restored => 'Your internet connection was restored';

  @override
  String get use_system_title_bar => 'Use system title bar';

  @override
  String get crunching_results => 'Crunching results...';

  @override
  String get search_to_get_results => 'Search to get results';

  @override
  String get use_amoled_mode => 'Pitch black dark theme';

  @override
  String get pitch_dark_theme => 'AMOLED Mode';

  @override
  String get normalize_audio => 'Normalize audio';

  @override
  String get change_cover => 'Change cover';

  @override
  String get add_cover => 'Add cover';

  @override
  String get restore_defaults => 'Restore defaults';

  @override
  String get download_music_format => 'Download music format';

  @override
  String get streaming_music_format => 'Streaming music format';

  @override
  String get download_music_quality => 'Download music quality';

  @override
  String get streaming_music_quality => 'Streaming music quality';

  @override
  String get login_with_lastfm => 'Login with Last.fm';

  @override
  String get connect => 'Connect';

  @override
  String get disconnect_lastfm => 'Disconnect Last.fm';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get login_with_your_lastfm => 'Login with your Last.fm account';

  @override
  String get scrobble_to_lastfm => 'Scrobble to Last.fm';

  @override
  String get go_to_album => 'Go to Album';

  @override
  String get discord_rich_presence => 'Discord Rich Presence';

  @override
  String get browse_all => 'Browse All';

  @override
  String get genres => 'Genres';

  @override
  String get explore_genres => 'Explore Genres';

  @override
  String get friends => 'Friends';

  @override
  String get no_lyrics_available => 'Sorry, unable find lyrics for this track';

  @override
  String get start_a_radio => 'Start a Radio';

  @override
  String get how_to_start_radio => 'How do you want to start the radio?';

  @override
  String get replace_queue_question =>
      'Do you want to replace the current queue or append to it?';

  @override
  String get endless_playback => 'Endless Playback';

  @override
  String get delete_playlist => 'Delete Playlist';

  @override
  String get delete_playlist_confirmation =>
      'Are you sure you want to delete this playlist?';

  @override
  String get local_tracks => 'Local Tracks';

  @override
  String get local_tab => 'Local';

  @override
  String get song_link => 'Song Link';

  @override
  String get skip_this_nonsense => 'Skip this nonsense';

  @override
  String get freedom_of_music => '“Freedom of Music”';

  @override
  String get freedom_of_music_palm =>
      '“Freedom of Music in the palm of your hand”';

  @override
  String get get_started => 'Let\'s get started';

  @override
  String get youtube_source_description => 'Recommended and works best.';

  @override
  String get piped_source_description =>
      'Feeling free? Same as YouTube but a lot free.';

  @override
  String get jiosaavn_source_description => 'Best for South Asian region.';

  @override
  String get invidious_source_description =>
      'Similar to Piped but with higher availability.';

  @override
  String highest_quality(Object quality) {
    return 'Highest Quality: $quality';
  }

  @override
  String get select_audio_source => 'Select Audio Source';

  @override
  String get endless_playback_description =>
      'Automatically append new songs\nto the end of the queue';

  @override
  String get choose_your_region => 'Choose your region';

  @override
  String get choose_your_region_description =>
      'This will help Spotube show you the right content\nfor your location.';

  @override
  String get choose_your_language => 'Choose your language';

  @override
  String get help_project_grow => 'Help this project grow';

  @override
  String get help_project_grow_description =>
      'Spotube is an open-source project. You can help this project grow by contributing to the project, reporting bugs, or suggesting new features.';

  @override
  String get contribute_on_github => 'Contribute on GitHub';

  @override
  String get donate_on_open_collective => 'Donate on Open Collective';

  @override
  String get browse_anonymously => 'Browse Anonymously';

  @override
  String get enable_connect => 'Enable Connect';

  @override
  String get enable_connect_description => 'Control Spotube from other devices';

  @override
  String get devices => 'Devices';

  @override
  String get select => 'Select';

  @override
  String connect_client_alert(Object client) {
    return 'You\'re being controlled by $client';
  }

  @override
  String get this_device => 'This Device';

  @override
  String get remote => 'Remote';

  @override
  String get stats => 'Stats';

  @override
  String and_n_more(Object count) {
    return 'and $count more';
  }

  @override
  String get recently_played => 'Recently Played';

  @override
  String get browse_more => 'Browse More';

  @override
  String get no_title => 'No Title';

  @override
  String get not_playing => 'Not playing';

  @override
  String get epic_failure => 'Epic failure!';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return 'Added $tracks_length tracks to queue';
  }

  @override
  String get spotube_has_an_update => 'Spotube has an update';

  @override
  String get download_now => 'Download Now';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Spotube Nightly $nightlyBuildNum has been released';
  }

  @override
  String release_version(Object version) {
    return 'Spotube v$version has been released';
  }

  @override
  String get read_the_latest => 'Read the latest ';

  @override
  String get release_notes => 'release notes';

  @override
  String get pick_color_scheme => 'Pick color scheme';

  @override
  String get save => 'Save';

  @override
  String get choose_the_device => 'Choose the device:';

  @override
  String get multiple_device_connected =>
      'There are multiple device connected.\nChoose the device you want this action to take place';

  @override
  String get nothing_found => 'Nothing found';

  @override
  String get the_box_is_empty => 'The box is empty';

  @override
  String get top_artists => 'Top Artists';

  @override
  String get top_albums => 'Top Albums';

  @override
  String get this_week => 'This week';

  @override
  String get this_month => 'This month';

  @override
  String get last_6_months => 'Last 6 months';

  @override
  String get this_year => 'This year';

  @override
  String get last_2_years => 'Last 2 years';

  @override
  String get all_time => 'All time';

  @override
  String powered_by_provider(Object providerName) {
    return 'Powered by $providerName';
  }

  @override
  String get email => 'Email';

  @override
  String get profile_followers => 'Followers';

  @override
  String get birthday => 'Birthday';

  @override
  String get subscription => 'Subscription';

  @override
  String get not_born => 'Not born';

  @override
  String get hacker => 'Hacker';

  @override
  String get profile => 'Profile';

  @override
  String get no_name => 'No Name';

  @override
  String get edit => 'Edit';

  @override
  String get user_profile => 'User Profile';

  @override
  String count_plays(Object count) {
    return '$count plays';
  }

  @override
  String get streaming_fees_hypothetical => 'Streaming fees (hypothetical)';

  @override
  String get minutes_listened => 'Minutes listened';

  @override
  String get streamed_songs => 'Streamed songs';

  @override
  String count_streams(Object count) {
    return '$count streams';
  }

  @override
  String get owned_by_you => 'Owned by you';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return 'Copied $shareUrl to clipboard';
  }

  @override
  String get hipotetical_calculation =>
      '*This is calculated based on average online music streaming platform\'s per stream\npayout of \$0.003 to \$0.005. This is a hypothetical\ncalculation to give user insight about how much they\nwould have paid to the artists if they were to listen\ntheir song in different music streaming platform.';

  @override
  String count_mins(Object minutes) {
    return '$minutes mins';
  }

  @override
  String get summary_minutes => 'minutes';

  @override
  String get summary_listened_to_music => 'Listened to music';

  @override
  String get summary_songs => 'songs';

  @override
  String get summary_streamed_overall => 'Streamed overall';

  @override
  String get summary_owed_to_artists => 'Owed to artists\nthis month';

  @override
  String get summary_artists => 'artist\'s';

  @override
  String get summary_music_reached_you => 'Music reached you';

  @override
  String get summary_full_albums => 'full albums';

  @override
  String get summary_got_your_love => 'Got your love';

  @override
  String get summary_playlists => 'playlists';

  @override
  String get summary_were_on_repeat => 'Were on repeat';

  @override
  String total_money(Object money) {
    return 'Total $money';
  }

  @override
  String get webview_not_found => 'Webview not found';

  @override
  String get webview_not_found_description =>
      'No webview runtime is installed in your device.\nIf it\'s installed make sure it\'s in the Environment PATH\n\nAfter installing, restart the app';

  @override
  String get unsupported_platform => 'Unsupported platform';

  @override
  String get cache_music => 'Cache music';

  @override
  String get open => 'Open';

  @override
  String get cache_folder => 'Cache folder';

  @override
  String get export => 'Export';

  @override
  String get clear_cache => 'Clear cache';

  @override
  String get clear_cache_confirmation => 'Do you want to clear the cache?';

  @override
  String get export_cache_files => 'Export Cached Files';

  @override
  String found_n_files(Object count) {
    return 'Found $count files';
  }

  @override
  String get export_cache_confirmation =>
      'Do you want to export these files to';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return 'Exported $filesExported out of $files files';
  }

  @override
  String get undo => 'Undo';

  @override
  String get download_all => 'Download all';

  @override
  String get add_all_to_playlist => 'Add all to playlist';

  @override
  String get add_all_to_queue => 'Add all to queue';

  @override
  String get play_all_next => 'Play all next';

  @override
  String get pause => 'Pause';

  @override
  String get view_all => 'View all';

  @override
  String get no_tracks_added_yet =>
      'Looks like you haven\'t added any tracks yet';

  @override
  String get no_tracks => 'Looks like there are no tracks here';

  @override
  String get no_tracks_listened_yet =>
      'Looks like you haven\'t listened to anything yet';

  @override
  String get not_following_artists => 'You\'re not following any artists';

  @override
  String get no_favorite_albums_yet =>
      'Looks like you haven\'t added any albums to your favorites yet';

  @override
  String get no_logs_found => 'No logs found';

  @override
  String get youtube_engine => 'YouTube Engine';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engine is not installed';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engine is not installed in your system.';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return 'Make sure it\'s available in the PATH variable or\nset the absolute path to the $engine executable below';
  }

  @override
  String get youtube_engine_unix_issue_message =>
      'In macOS/Linux/unix like OS\'s, setting path on .zshrc/.bashrc/.bash_profile etc. won\'t work.\nYou need to set the path in the shell configuration file';

  @override
  String get download => 'Download';

  @override
  String get file_not_found => 'File not found';

  @override
  String get custom => 'Custom';

  @override
  String get add_custom_url => 'Add custom URL';

  @override
  String get edit_port => 'Edit port';

  @override
  String get port_helper_msg =>
      'Default is -1 which indicates random number. If you\'ve firewall configured, setting this is recommended.';

  @override
  String connect_request(Object client) {
    return 'Allow $client to connect?';
  }

  @override
  String get connection_request_denied =>
      'Connection denied. User denied access.';

  @override
  String get an_error_occurred => 'An error occurred';

  @override
  String get copy_to_clipboard => 'Copy to clipboard';

  @override
  String get view_logs => 'View logs';

  @override
  String get retry => 'Retry';

  @override
  String get no_default_metadata_provider_selected =>
      'You\'ve no default metadata provider set';

  @override
  String get manage_metadata_providers => 'Manage metadata providers';

  @override
  String get open_link_in_browser => 'Open Link in Browser?';

  @override
  String get do_you_want_to_open_the_following_link =>
      'Do you want to open the following link';

  @override
  String get unsafe_url_warning =>
      'It can be unsafe to open links from untrusted sources. Be cautious!\nYou can also copy the link to your clipboard.';

  @override
  String get copy_link => 'Copy Link';

  @override
  String get building_your_timeline =>
      'Building your timeline based on your listenings...';

  @override
  String get official => 'Official';

  @override
  String author_name(Object author) {
    return 'Author: $author';
  }

  @override
  String get third_party => 'Third-party';

  @override
  String get plugin_requires_authentication => 'Plugin requires authentication';

  @override
  String get update_available => 'Update available';

  @override
  String get supports_scrobbling => 'Supports scrobbling';

  @override
  String get plugin_scrobbling_info =>
      'This plugin scrobbles your music to generate your listening history.';

  @override
  String get default_metadata_source => 'Default metadata source';

  @override
  String get set_default_metadata_source => 'Set default metadata source';

  @override
  String get default_audio_source => 'Default audio source';

  @override
  String get set_default_audio_source => 'Set default audio source';

  @override
  String get set_default => 'Set default';

  @override
  String get support => 'Support';

  @override
  String get support_plugin_development => 'Support plugin development';

  @override
  String can_access_name_api(Object name) {
    return '- Can access **$name** API';
  }

  @override
  String get do_you_want_to_install_this_plugin =>
      'Do you want to install this plugin?';

  @override
  String get third_party_plugin_warning =>
      'This plugin is from a third-party repository. Please ensure you trust the source before installing.';

  @override
  String get author => 'Author';

  @override
  String get this_plugin_can_do_following => 'This plugin can do following';

  @override
  String get install => 'Install';

  @override
  String get install_a_metadata_provider => 'Install a Metadata Provider';

  @override
  String get no_tracks_playing => 'No Track being played currently';

  @override
  String get synced_lyrics_not_available =>
      'Synced lyrics are not available for this song. Please use the';

  @override
  String get plain_lyrics => 'Plain Lyrics';

  @override
  String get tab_instead => 'tab instead.';

  @override
  String get disclaimer => 'Disclaimer';

  @override
  String get third_party_plugin_dmca_notice =>
      'The Spotube team does not hold any responsibility (including legal) for any \"Third-party\" plugins.\nPlease use them at your own risk. For any bugs/issues, please report them to the plugin repository.\n\nIf any \"Third-party\" plugin is breaking ToS/DMCA of any service/legal entity, please ask the \"Third-party\" plugin author or the hosting platform .e.g GitHub/Codeberg to take action. Above listed (\"Third-party\" labelled) are all public/community maintained plugins. We\'re not curating them, so we cannot take any action on them.\n\n';

  @override
  String get input_does_not_match_format =>
      'Input doesn\'t match the required format';

  @override
  String get plugins => 'Plugins';

  @override
  String get paste_plugin_download_url =>
      'Paste download url or GitHub/Codeberg repo url or direct link to .smplug file';

  @override
  String get download_and_install_plugin_from_url =>
      'Download and install plugin from url';

  @override
  String failed_to_add_plugin_error(Object error) {
    return 'Failed to add plugin: $error';
  }

  @override
  String get upload_plugin_from_file => 'Upload plugin from file';

  @override
  String get installed => 'Installed';

  @override
  String get available_plugins => 'Available plugins';

  @override
  String get configure_plugins =>
      'Configure your own metadata provider and audio source plugins';

  @override
  String get audio_scrobblers => 'Audio Scrobblers';

  @override
  String get scrobbling => 'Scrobbling';

  @override
  String get source => 'Source: ';

  @override
  String get uncompressed => 'Uncompressed';

  @override
  String get dab_music_source_description =>
      'For audiophiles. Provides high-quality/lossless audio streams. Accurate ISRC based track matching.';
}
