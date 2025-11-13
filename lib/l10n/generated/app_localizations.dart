import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_eu.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ka.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ne.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tl.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('ca'),
    Locale('cs'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('eu'),
    Locale('fa'),
    Locale('fi'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ka'),
    Locale('ko'),
    Locale('ne'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('ta'),
    Locale('th'),
    Locale('tl'),
    Locale('tr'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @browse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get browse;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @lyrics.
  ///
  /// In en, this message translates to:
  /// **'Lyrics'**
  String get lyrics;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @genre_categories_filter.
  ///
  /// In en, this message translates to:
  /// **'Filter categories or genres...'**
  String get genre_categories_filter;

  /// No description provided for @genre.
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get genre;

  /// No description provided for @personalized.
  ///
  /// In en, this message translates to:
  /// **'Personalized'**
  String get personalized;

  /// No description provided for @featured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featured;

  /// No description provided for @new_releases.
  ///
  /// In en, this message translates to:
  /// **'New Releases'**
  String get new_releases;

  /// No description provided for @songs.
  ///
  /// In en, this message translates to:
  /// **'Songs'**
  String get songs;

  /// No description provided for @playing_track.
  ///
  /// In en, this message translates to:
  /// **'Playing {track}'**
  String playing_track(Object track);

  /// No description provided for @queue_clear_alert.
  ///
  /// In en, this message translates to:
  /// **'This will clear the current queue. {track_length} tracks will be removed\nDo you want to continue?'**
  String queue_clear_alert(Object track_length);

  /// No description provided for @load_more.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get load_more;

  /// No description provided for @playlists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get playlists;

  /// No description provided for @artists.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get artists;

  /// No description provided for @albums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get albums;

  /// No description provided for @tracks.
  ///
  /// In en, this message translates to:
  /// **'Tracks'**
  String get tracks;

  /// No description provided for @downloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get downloads;

  /// No description provided for @filter_playlists.
  ///
  /// In en, this message translates to:
  /// **'Filter your playlists...'**
  String get filter_playlists;

  /// No description provided for @liked_tracks.
  ///
  /// In en, this message translates to:
  /// **'Liked Tracks'**
  String get liked_tracks;

  /// No description provided for @liked_tracks_description.
  ///
  /// In en, this message translates to:
  /// **'All your liked tracks'**
  String get liked_tracks_description;

  /// No description provided for @playlist.
  ///
  /// In en, this message translates to:
  /// **'Playlist'**
  String get playlist;

  /// No description provided for @create_a_playlist.
  ///
  /// In en, this message translates to:
  /// **'Create a playlist'**
  String get create_a_playlist;

  /// No description provided for @update_playlist.
  ///
  /// In en, this message translates to:
  /// **'Update playlist'**
  String get update_playlist;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @playlist_name.
  ///
  /// In en, this message translates to:
  /// **'Playlist Name'**
  String get playlist_name;

  /// No description provided for @name_of_playlist.
  ///
  /// In en, this message translates to:
  /// **'Name of the playlist'**
  String get name_of_playlist;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @public.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get public;

  /// No description provided for @collaborative.
  ///
  /// In en, this message translates to:
  /// **'Collaborative'**
  String get collaborative;

  /// No description provided for @search_local_tracks.
  ///
  /// In en, this message translates to:
  /// **'Search local tracks...'**
  String get search_local_tracks;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @sort_a_z.
  ///
  /// In en, this message translates to:
  /// **'Sort by A-Z'**
  String get sort_a_z;

  /// No description provided for @sort_z_a.
  ///
  /// In en, this message translates to:
  /// **'Sort by Z-A'**
  String get sort_z_a;

  /// No description provided for @sort_artist.
  ///
  /// In en, this message translates to:
  /// **'Sort by Artist'**
  String get sort_artist;

  /// No description provided for @sort_album.
  ///
  /// In en, this message translates to:
  /// **'Sort by Album'**
  String get sort_album;

  /// No description provided for @sort_duration.
  ///
  /// In en, this message translates to:
  /// **'Sort by Duration'**
  String get sort_duration;

  /// No description provided for @sort_tracks.
  ///
  /// In en, this message translates to:
  /// **'Sort Tracks'**
  String get sort_tracks;

  /// No description provided for @currently_downloading.
  ///
  /// In en, this message translates to:
  /// **'Currently Downloading ({tracks_length})'**
  String currently_downloading(Object tracks_length);

  /// No description provided for @cancel_all.
  ///
  /// In en, this message translates to:
  /// **'Cancel All'**
  String get cancel_all;

  /// No description provided for @filter_artist.
  ///
  /// In en, this message translates to:
  /// **'Filter artists...'**
  String get filter_artist;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'{followers} Followers'**
  String followers(Object followers);

  /// No description provided for @add_artist_to_blacklist.
  ///
  /// In en, this message translates to:
  /// **'Add artist to blacklist'**
  String get add_artist_to_blacklist;

  /// No description provided for @top_tracks.
  ///
  /// In en, this message translates to:
  /// **'Top Tracks'**
  String get top_tracks;

  /// No description provided for @fans_also_like.
  ///
  /// In en, this message translates to:
  /// **'Fans also like'**
  String get fans_also_like;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @artist.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get artist;

  /// No description provided for @blacklisted.
  ///
  /// In en, this message translates to:
  /// **'Blacklisted'**
  String get blacklisted;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @artist_url_copied.
  ///
  /// In en, this message translates to:
  /// **'Artist URL copied to clipboard'**
  String get artist_url_copied;

  /// No description provided for @added_to_queue.
  ///
  /// In en, this message translates to:
  /// **'Added {tracks} tracks to queue'**
  String added_to_queue(Object tracks);

  /// No description provided for @filter_albums.
  ///
  /// In en, this message translates to:
  /// **'Filter albums...'**
  String get filter_albums;

  /// No description provided for @synced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get synced;

  /// No description provided for @plain.
  ///
  /// In en, this message translates to:
  /// **'Plain'**
  String get plain;

  /// No description provided for @shuffle.
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get shuffle;

  /// No description provided for @search_tracks.
  ///
  /// In en, this message translates to:
  /// **'Search tracks...'**
  String get search_tracks;

  /// No description provided for @released.
  ///
  /// In en, this message translates to:
  /// **'Released'**
  String get released;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error {error}'**
  String error(Object error);

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @more_actions.
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get more_actions;

  /// No description provided for @download_count.
  ///
  /// In en, this message translates to:
  /// **'Download ({count})'**
  String download_count(Object count);

  /// No description provided for @add_count_to_playlist.
  ///
  /// In en, this message translates to:
  /// **'Add ({count}) to Playlist'**
  String add_count_to_playlist(Object count);

  /// No description provided for @add_count_to_queue.
  ///
  /// In en, this message translates to:
  /// **'Add ({count}) to Queue'**
  String add_count_to_queue(Object count);

  /// No description provided for @play_count_next.
  ///
  /// In en, this message translates to:
  /// **'Play ({count}) next'**
  String play_count_next(Object count);

  /// No description provided for @album.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get album;

  /// No description provided for @copied_to_clipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied {data} to clipboard'**
  String copied_to_clipboard(Object data);

  /// No description provided for @add_to_following_playlists.
  ///
  /// In en, this message translates to:
  /// **'Add {track} to following Playlists'**
  String add_to_following_playlists(Object track);

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @added_track_to_queue.
  ///
  /// In en, this message translates to:
  /// **'Added {track} to queue'**
  String added_track_to_queue(Object track);

  /// No description provided for @add_to_queue.
  ///
  /// In en, this message translates to:
  /// **'Add to queue'**
  String get add_to_queue;

  /// No description provided for @track_will_play_next.
  ///
  /// In en, this message translates to:
  /// **'{track} will play next'**
  String track_will_play_next(Object track);

  /// No description provided for @play_next.
  ///
  /// In en, this message translates to:
  /// **'Play next'**
  String get play_next;

  /// No description provided for @removed_track_from_queue.
  ///
  /// In en, this message translates to:
  /// **'Removed {track} from queue'**
  String removed_track_from_queue(Object track);

  /// No description provided for @remove_from_queue.
  ///
  /// In en, this message translates to:
  /// **'Remove from queue'**
  String get remove_from_queue;

  /// No description provided for @remove_from_favorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get remove_from_favorites;

  /// No description provided for @save_as_favorite.
  ///
  /// In en, this message translates to:
  /// **'Save as favorite'**
  String get save_as_favorite;

  /// No description provided for @add_to_playlist.
  ///
  /// In en, this message translates to:
  /// **'Add to playlist'**
  String get add_to_playlist;

  /// No description provided for @remove_from_playlist.
  ///
  /// In en, this message translates to:
  /// **'Remove from playlist'**
  String get remove_from_playlist;

  /// No description provided for @add_to_blacklist.
  ///
  /// In en, this message translates to:
  /// **'Add to blacklist'**
  String get add_to_blacklist;

  /// No description provided for @remove_from_blacklist.
  ///
  /// In en, this message translates to:
  /// **'Remove from blacklist'**
  String get remove_from_blacklist;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @mini_player.
  ///
  /// In en, this message translates to:
  /// **'Mini Player'**
  String get mini_player;

  /// No description provided for @slide_to_seek.
  ///
  /// In en, this message translates to:
  /// **'Slide to seek forward or backward'**
  String get slide_to_seek;

  /// No description provided for @shuffle_playlist.
  ///
  /// In en, this message translates to:
  /// **'Shuffle playlist'**
  String get shuffle_playlist;

  /// No description provided for @unshuffle_playlist.
  ///
  /// In en, this message translates to:
  /// **'Unshuffle playlist'**
  String get unshuffle_playlist;

  /// No description provided for @previous_track.
  ///
  /// In en, this message translates to:
  /// **'Previous track'**
  String get previous_track;

  /// No description provided for @next_track.
  ///
  /// In en, this message translates to:
  /// **'Next track'**
  String get next_track;

  /// No description provided for @pause_playback.
  ///
  /// In en, this message translates to:
  /// **'Pause Playback'**
  String get pause_playback;

  /// No description provided for @resume_playback.
  ///
  /// In en, this message translates to:
  /// **'Resume Playback'**
  String get resume_playback;

  /// No description provided for @loop_track.
  ///
  /// In en, this message translates to:
  /// **'Loop track'**
  String get loop_track;

  /// No description provided for @no_loop.
  ///
  /// In en, this message translates to:
  /// **'No loop'**
  String get no_loop;

  /// No description provided for @repeat_playlist.
  ///
  /// In en, this message translates to:
  /// **'Repeat playlist'**
  String get repeat_playlist;

  /// No description provided for @queue.
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get queue;

  /// No description provided for @alternative_track_sources.
  ///
  /// In en, this message translates to:
  /// **'Alternative track sources'**
  String get alternative_track_sources;

  /// No description provided for @download_track.
  ///
  /// In en, this message translates to:
  /// **'Download track'**
  String get download_track;

  /// No description provided for @tracks_in_queue.
  ///
  /// In en, this message translates to:
  /// **'{tracks} tracks in queue'**
  String tracks_in_queue(Object tracks);

  /// No description provided for @clear_all.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clear_all;

  /// No description provided for @show_hide_ui_on_hover.
  ///
  /// In en, this message translates to:
  /// **'Show/Hide UI on hover'**
  String get show_hide_ui_on_hover;

  /// No description provided for @always_on_top.
  ///
  /// In en, this message translates to:
  /// **'Always on top'**
  String get always_on_top;

  /// No description provided for @exit_mini_player.
  ///
  /// In en, this message translates to:
  /// **'Exit Mini player'**
  String get exit_mini_player;

  /// No description provided for @download_location.
  ///
  /// In en, this message translates to:
  /// **'Download location'**
  String get download_location;

  /// No description provided for @local_library.
  ///
  /// In en, this message translates to:
  /// **'Local library'**
  String get local_library;

  /// No description provided for @add_library_location.
  ///
  /// In en, this message translates to:
  /// **'Add to library'**
  String get add_library_location;

  /// No description provided for @remove_library_location.
  ///
  /// In en, this message translates to:
  /// **'Remove from library'**
  String get remove_library_location;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logout_of_this_account.
  ///
  /// In en, this message translates to:
  /// **'Logout of this account'**
  String get logout_of_this_account;

  /// No description provided for @language_region.
  ///
  /// In en, this message translates to:
  /// **'Language & Region'**
  String get language_region;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @system_default.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get system_default;

  /// No description provided for @market_place_region.
  ///
  /// In en, this message translates to:
  /// **'Marketplace Region'**
  String get market_place_region;

  /// No description provided for @recommendation_country.
  ///
  /// In en, this message translates to:
  /// **'Recommendation Country'**
  String get recommendation_country;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @layout_mode.
  ///
  /// In en, this message translates to:
  /// **'Layout Mode'**
  String get layout_mode;

  /// No description provided for @override_layout_settings.
  ///
  /// In en, this message translates to:
  /// **'Override responsive layout mode settings'**
  String get override_layout_settings;

  /// No description provided for @adaptive.
  ///
  /// In en, this message translates to:
  /// **'Adaptive'**
  String get adaptive;

  /// No description provided for @compact.
  ///
  /// In en, this message translates to:
  /// **'Compact'**
  String get compact;

  /// No description provided for @extended.
  ///
  /// In en, this message translates to:
  /// **'Extended'**
  String get extended;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @accent_color.
  ///
  /// In en, this message translates to:
  /// **'Accent Color'**
  String get accent_color;

  /// No description provided for @sync_album_color.
  ///
  /// In en, this message translates to:
  /// **'Sync album color'**
  String get sync_album_color;

  /// No description provided for @sync_album_color_description.
  ///
  /// In en, this message translates to:
  /// **'Uses the dominant color of the album art as the accent color'**
  String get sync_album_color_description;

  /// No description provided for @playback.
  ///
  /// In en, this message translates to:
  /// **'Playback'**
  String get playback;

  /// No description provided for @audio_quality.
  ///
  /// In en, this message translates to:
  /// **'Audio Quality'**
  String get audio_quality;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @pre_download_play.
  ///
  /// In en, this message translates to:
  /// **'Pre-download and play'**
  String get pre_download_play;

  /// No description provided for @pre_download_play_description.
  ///
  /// In en, this message translates to:
  /// **'Instead of streaming audio, download bytes and play instead (Recommended for higher bandwidth users)'**
  String get pre_download_play_description;

  /// No description provided for @skip_non_music.
  ///
  /// In en, this message translates to:
  /// **'Skip non-music segments (SponsorBlock)'**
  String get skip_non_music;

  /// No description provided for @blacklist_description.
  ///
  /// In en, this message translates to:
  /// **'Blacklisted tracks and artists'**
  String get blacklist_description;

  /// No description provided for @wait_for_download_to_finish.
  ///
  /// In en, this message translates to:
  /// **'Please wait for the current download to finish'**
  String get wait_for_download_to_finish;

  /// No description provided for @desktop.
  ///
  /// In en, this message translates to:
  /// **'Desktop'**
  String get desktop;

  /// No description provided for @close_behavior.
  ///
  /// In en, this message translates to:
  /// **'Close Behavior'**
  String get close_behavior;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @minimize_to_tray.
  ///
  /// In en, this message translates to:
  /// **'Minimize to tray'**
  String get minimize_to_tray;

  /// No description provided for @show_tray_icon.
  ///
  /// In en, this message translates to:
  /// **'Show System tray icon'**
  String get show_tray_icon;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @u_love_spotube.
  ///
  /// In en, this message translates to:
  /// **'We know you love Spotube'**
  String get u_love_spotube;

  /// No description provided for @check_for_updates.
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get check_for_updates;

  /// No description provided for @about_spotube.
  ///
  /// In en, this message translates to:
  /// **'About Spotube'**
  String get about_spotube;

  /// No description provided for @blacklist.
  ///
  /// In en, this message translates to:
  /// **'Blacklist'**
  String get blacklist;

  /// No description provided for @please_sponsor.
  ///
  /// In en, this message translates to:
  /// **'Please Sponsor/Donate'**
  String get please_sponsor;

  /// No description provided for @spotube_description.
  ///
  /// In en, this message translates to:
  /// **'Open source extensible music streaming platform and app, based on BYOMM (Bring your own music metadata) concept'**
  String get spotube_description;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @build_number.
  ///
  /// In en, this message translates to:
  /// **'Build Number'**
  String get build_number;

  /// No description provided for @founder.
  ///
  /// In en, this message translates to:
  /// **'Founder'**
  String get founder;

  /// No description provided for @repository.
  ///
  /// In en, this message translates to:
  /// **'Repository'**
  String get repository;

  /// No description provided for @bug_issues.
  ///
  /// In en, this message translates to:
  /// **'Bug+Issues'**
  String get bug_issues;

  /// No description provided for @made_with.
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ in Bangladesh🇧🇩'**
  String get made_with;

  /// No description provided for @kingkor_roy_tirtho.
  ///
  /// In en, this message translates to:
  /// **'Kingkor Roy Tirtho'**
  String get kingkor_roy_tirtho;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2021-{current_year} Kingkor Roy Tirtho'**
  String copyright(Object current_year);

  /// No description provided for @license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// No description provided for @credentials_will_not_be_shared_disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry, any of your credentials won\'t be collected or shared with anyone'**
  String get credentials_will_not_be_shared_disclaimer;

  /// No description provided for @know_how_to_login.
  ///
  /// In en, this message translates to:
  /// **'Don\'t know how to do this?'**
  String get know_how_to_login;

  /// No description provided for @follow_step_by_step_guide.
  ///
  /// In en, this message translates to:
  /// **'Follow along the Step by Step guide'**
  String get follow_step_by_step_guide;

  /// No description provided for @cookie_name_cookie.
  ///
  /// In en, this message translates to:
  /// **'{name} Cookie'**
  String cookie_name_cookie(Object name);

  /// No description provided for @fill_in_all_fields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all the fields'**
  String get fill_in_all_fields;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @step_1.
  ///
  /// In en, this message translates to:
  /// **'Step 1'**
  String get step_1;

  /// No description provided for @first_go_to.
  ///
  /// In en, this message translates to:
  /// **'First, Go to'**
  String get first_go_to;

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get something_went_wrong;

  /// No description provided for @piped_instance.
  ///
  /// In en, this message translates to:
  /// **'Piped Server Instance'**
  String get piped_instance;

  /// No description provided for @piped_description.
  ///
  /// In en, this message translates to:
  /// **'The Piped server instance to use for track matching'**
  String get piped_description;

  /// No description provided for @piped_warning.
  ///
  /// In en, this message translates to:
  /// **'Some of them might not work well. So use at your own risk'**
  String get piped_warning;

  /// No description provided for @invidious_instance.
  ///
  /// In en, this message translates to:
  /// **'Invidious Server Instance'**
  String get invidious_instance;

  /// No description provided for @invidious_description.
  ///
  /// In en, this message translates to:
  /// **'The Invidious server instance to use for track matching'**
  String get invidious_description;

  /// No description provided for @invidious_warning.
  ///
  /// In en, this message translates to:
  /// **'Some of them might not work well. So use at your own risk'**
  String get invidious_warning;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @track_exists.
  ///
  /// In en, this message translates to:
  /// **'Track {track} already exists'**
  String track_exists(Object track);

  /// No description provided for @replace_downloaded_tracks.
  ///
  /// In en, this message translates to:
  /// **'Replace all downloaded tracks'**
  String get replace_downloaded_tracks;

  /// No description provided for @skip_download_tracks.
  ///
  /// In en, this message translates to:
  /// **'Skip downloading all downloaded tracks'**
  String get skip_download_tracks;

  /// No description provided for @do_you_want_to_replace.
  ///
  /// In en, this message translates to:
  /// **'Do you want to replace the existing track??'**
  String get do_you_want_to_replace;

  /// No description provided for @replace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replace;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @select_up_to_count_type.
  ///
  /// In en, this message translates to:
  /// **'Select up to {count} {type}'**
  String select_up_to_count_type(Object count, Object type);

  /// No description provided for @select_genres.
  ///
  /// In en, this message translates to:
  /// **'Select Genres'**
  String get select_genres;

  /// No description provided for @add_genres.
  ///
  /// In en, this message translates to:
  /// **'Add Genres'**
  String get add_genres;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @number_of_tracks_generate.
  ///
  /// In en, this message translates to:
  /// **'Number of tracks to generate'**
  String get number_of_tracks_generate;

  /// No description provided for @acousticness.
  ///
  /// In en, this message translates to:
  /// **'Acousticness'**
  String get acousticness;

  /// No description provided for @danceability.
  ///
  /// In en, this message translates to:
  /// **'Danceability'**
  String get danceability;

  /// No description provided for @energy.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get energy;

  /// No description provided for @instrumentalness.
  ///
  /// In en, this message translates to:
  /// **'Instrumentalness'**
  String get instrumentalness;

  /// No description provided for @liveness.
  ///
  /// In en, this message translates to:
  /// **'Liveness'**
  String get liveness;

  /// No description provided for @loudness.
  ///
  /// In en, this message translates to:
  /// **'Loudness'**
  String get loudness;

  /// No description provided for @speechiness.
  ///
  /// In en, this message translates to:
  /// **'Speechiness'**
  String get speechiness;

  /// No description provided for @valence.
  ///
  /// In en, this message translates to:
  /// **'Valence'**
  String get valence;

  /// No description provided for @popularity.
  ///
  /// In en, this message translates to:
  /// **'Popularity'**
  String get popularity;

  /// No description provided for @key.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get key;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration (s)'**
  String get duration;

  /// No description provided for @tempo.
  ///
  /// In en, this message translates to:
  /// **'Tempo (BPM)'**
  String get tempo;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// No description provided for @time_signature.
  ///
  /// In en, this message translates to:
  /// **'Time Signature'**
  String get time_signature;

  /// No description provided for @short.
  ///
  /// In en, this message translates to:
  /// **'Short'**
  String get short;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @long.
  ///
  /// In en, this message translates to:
  /// **'Long'**
  String get long;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get min;

  /// No description provided for @max.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get max;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// No description provided for @moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// No description provided for @deselect_all.
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get deselect_all;

  /// No description provided for @select_all.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get select_all;

  /// No description provided for @are_you_sure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get are_you_sure;

  /// No description provided for @generating_playlist.
  ///
  /// In en, this message translates to:
  /// **'Generating your custom playlist...'**
  String get generating_playlist;

  /// No description provided for @selected_count_tracks.
  ///
  /// In en, this message translates to:
  /// **'Selected {count} tracks'**
  String selected_count_tracks(Object count);

  /// No description provided for @download_warning.
  ///
  /// In en, this message translates to:
  /// **'If you download all Tracks at bulk you\'re clearly pirating Music & causing damage to the creative society of Music. I hope you are aware of this. Always, try respecting & supporting Artist\'s hard work'**
  String get download_warning;

  /// No description provided for @download_ip_ban_warning.
  ///
  /// In en, this message translates to:
  /// **'BTW, your IP can get blocked on YouTube due excessive download requests than usual. IP block means you can\'t use YouTube (even if you\'re logged in) for at least 2-3 months from that IP device. And Spotube doesn\'t hold any responsibility if this ever happens'**
  String get download_ip_ban_warning;

  /// No description provided for @by_clicking_accept_terms.
  ///
  /// In en, this message translates to:
  /// **'By clicking \'accept\' you agree to following terms:'**
  String get by_clicking_accept_terms;

  /// No description provided for @download_agreement_1.
  ///
  /// In en, this message translates to:
  /// **'I know I\'m pirating Music. I\'m bad'**
  String get download_agreement_1;

  /// No description provided for @download_agreement_2.
  ///
  /// In en, this message translates to:
  /// **'I\'ll support the Artist wherever I can and I\'m only doing this because I don\'t have money to buy their art'**
  String get download_agreement_2;

  /// No description provided for @download_agreement_3.
  ///
  /// In en, this message translates to:
  /// **'I\'m completely aware that my IP can get blocked on YouTube & I don\'t hold Spotube or his owners/contributors responsible for any accidents caused by my current action'**
  String get download_agreement_3;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @youtube.
  ///
  /// In en, this message translates to:
  /// **'YouTube'**
  String get youtube;

  /// No description provided for @channel.
  ///
  /// In en, this message translates to:
  /// **'Channel'**
  String get channel;

  /// No description provided for @likes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get likes;

  /// No description provided for @dislikes.
  ///
  /// In en, this message translates to:
  /// **'Dislikes'**
  String get dislikes;

  /// No description provided for @views.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get views;

  /// No description provided for @streamUrl.
  ///
  /// In en, this message translates to:
  /// **'Stream URL'**
  String get streamUrl;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @sort_newest.
  ///
  /// In en, this message translates to:
  /// **'Sort by newest added'**
  String get sort_newest;

  /// No description provided for @sort_oldest.
  ///
  /// In en, this message translates to:
  /// **'Sort by oldest added'**
  String get sort_oldest;

  /// No description provided for @sleep_timer.
  ///
  /// In en, this message translates to:
  /// **'Sleep Timer'**
  String get sleep_timer;

  /// No description provided for @mins.
  ///
  /// In en, this message translates to:
  /// **'{minutes} Minutes'**
  String mins(Object minutes);

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'{hours} Hours'**
  String hours(Object hours);

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'{hours} Hour'**
  String hour(Object hours);

  /// No description provided for @custom_hours.
  ///
  /// In en, this message translates to:
  /// **'Custom Hours'**
  String get custom_hours;

  /// No description provided for @logs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logs;

  /// No description provided for @developers.
  ///
  /// In en, this message translates to:
  /// **'Developers'**
  String get developers;

  /// No description provided for @not_logged_in.
  ///
  /// In en, this message translates to:
  /// **'You\'re not logged in'**
  String get not_logged_in;

  /// No description provided for @search_mode.
  ///
  /// In en, this message translates to:
  /// **'Search Mode'**
  String get search_mode;

  /// No description provided for @audio_source.
  ///
  /// In en, this message translates to:
  /// **'Audio Source'**
  String get audio_source;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @failed_to_encrypt.
  ///
  /// In en, this message translates to:
  /// **'Failed to encrypt'**
  String get failed_to_encrypt;

  /// No description provided for @encryption_failed_warning.
  ///
  /// In en, this message translates to:
  /// **'Spotube uses encryption to securely store your data. But failed to do so. So it\'ll fallback to insecure storage\nIf you\'re using linux, please make sure you\'ve any secret-service (gnome-keyring, kde-wallet, keepassxc etc) installed'**
  String get encryption_failed_warning;

  /// No description provided for @querying_info.
  ///
  /// In en, this message translates to:
  /// **'Querying info...'**
  String get querying_info;

  /// No description provided for @piped_api_down.
  ///
  /// In en, this message translates to:
  /// **'Piped API is down'**
  String get piped_api_down;

  /// No description provided for @piped_down_error_instructions.
  ///
  /// In en, this message translates to:
  /// **'The Piped instance {pipedInstance} is currently down\n\nEither change the instance or change the \'API type\' to official YouTube API\n\nMake sure to restart the app after change'**
  String piped_down_error_instructions(Object pipedInstance);

  /// No description provided for @you_are_offline.
  ///
  /// In en, this message translates to:
  /// **'You are currently offline'**
  String get you_are_offline;

  /// No description provided for @connection_restored.
  ///
  /// In en, this message translates to:
  /// **'Your internet connection was restored'**
  String get connection_restored;

  /// No description provided for @use_system_title_bar.
  ///
  /// In en, this message translates to:
  /// **'Use system title bar'**
  String get use_system_title_bar;

  /// No description provided for @crunching_results.
  ///
  /// In en, this message translates to:
  /// **'Crunching results...'**
  String get crunching_results;

  /// No description provided for @search_to_get_results.
  ///
  /// In en, this message translates to:
  /// **'Search to get results'**
  String get search_to_get_results;

  /// No description provided for @use_amoled_mode.
  ///
  /// In en, this message translates to:
  /// **'Pitch black dark theme'**
  String get use_amoled_mode;

  /// No description provided for @pitch_dark_theme.
  ///
  /// In en, this message translates to:
  /// **'AMOLED Mode'**
  String get pitch_dark_theme;

  /// No description provided for @normalize_audio.
  ///
  /// In en, this message translates to:
  /// **'Normalize audio'**
  String get normalize_audio;

  /// No description provided for @change_cover.
  ///
  /// In en, this message translates to:
  /// **'Change cover'**
  String get change_cover;

  /// No description provided for @add_cover.
  ///
  /// In en, this message translates to:
  /// **'Add cover'**
  String get add_cover;

  /// No description provided for @restore_defaults.
  ///
  /// In en, this message translates to:
  /// **'Restore defaults'**
  String get restore_defaults;

  /// No description provided for @download_music_format.
  ///
  /// In en, this message translates to:
  /// **'Download music format'**
  String get download_music_format;

  /// No description provided for @streaming_music_format.
  ///
  /// In en, this message translates to:
  /// **'Streaming music format'**
  String get streaming_music_format;

  /// No description provided for @download_music_quality.
  ///
  /// In en, this message translates to:
  /// **'Download music quality'**
  String get download_music_quality;

  /// No description provided for @streaming_music_quality.
  ///
  /// In en, this message translates to:
  /// **'Streaming music quality'**
  String get streaming_music_quality;

  /// No description provided for @login_with_lastfm.
  ///
  /// In en, this message translates to:
  /// **'Login with Last.fm'**
  String get login_with_lastfm;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @disconnect_lastfm.
  ///
  /// In en, this message translates to:
  /// **'Disconnect Last.fm'**
  String get disconnect_lastfm;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @login_with_your_lastfm.
  ///
  /// In en, this message translates to:
  /// **'Login with your Last.fm account'**
  String get login_with_your_lastfm;

  /// No description provided for @scrobble_to_lastfm.
  ///
  /// In en, this message translates to:
  /// **'Scrobble to Last.fm'**
  String get scrobble_to_lastfm;

  /// No description provided for @go_to_album.
  ///
  /// In en, this message translates to:
  /// **'Go to Album'**
  String get go_to_album;

  /// No description provided for @discord_rich_presence.
  ///
  /// In en, this message translates to:
  /// **'Discord Rich Presence'**
  String get discord_rich_presence;

  /// No description provided for @browse_all.
  ///
  /// In en, this message translates to:
  /// **'Browse All'**
  String get browse_all;

  /// No description provided for @genres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get genres;

  /// No description provided for @explore_genres.
  ///
  /// In en, this message translates to:
  /// **'Explore Genres'**
  String get explore_genres;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @no_lyrics_available.
  ///
  /// In en, this message translates to:
  /// **'Sorry, unable find lyrics for this track'**
  String get no_lyrics_available;

  /// No description provided for @start_a_radio.
  ///
  /// In en, this message translates to:
  /// **'Start a Radio'**
  String get start_a_radio;

  /// No description provided for @how_to_start_radio.
  ///
  /// In en, this message translates to:
  /// **'How do you want to start the radio?'**
  String get how_to_start_radio;

  /// No description provided for @replace_queue_question.
  ///
  /// In en, this message translates to:
  /// **'Do you want to replace the current queue or append to it?'**
  String get replace_queue_question;

  /// No description provided for @endless_playback.
  ///
  /// In en, this message translates to:
  /// **'Endless Playback'**
  String get endless_playback;

  /// No description provided for @delete_playlist.
  ///
  /// In en, this message translates to:
  /// **'Delete Playlist'**
  String get delete_playlist;

  /// No description provided for @delete_playlist_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this playlist?'**
  String get delete_playlist_confirmation;

  /// No description provided for @local_tracks.
  ///
  /// In en, this message translates to:
  /// **'Local Tracks'**
  String get local_tracks;

  /// No description provided for @local_tab.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get local_tab;

  /// No description provided for @song_link.
  ///
  /// In en, this message translates to:
  /// **'Song Link'**
  String get song_link;

  /// No description provided for @skip_this_nonsense.
  ///
  /// In en, this message translates to:
  /// **'Skip this nonsense'**
  String get skip_this_nonsense;

  /// No description provided for @freedom_of_music.
  ///
  /// In en, this message translates to:
  /// **'“Freedom of Music”'**
  String get freedom_of_music;

  /// No description provided for @freedom_of_music_palm.
  ///
  /// In en, this message translates to:
  /// **'“Freedom of Music in the palm of your hand”'**
  String get freedom_of_music_palm;

  /// No description provided for @get_started.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get started'**
  String get get_started;

  /// No description provided for @youtube_source_description.
  ///
  /// In en, this message translates to:
  /// **'Recommended and works best.'**
  String get youtube_source_description;

  /// No description provided for @piped_source_description.
  ///
  /// In en, this message translates to:
  /// **'Feeling free? Same as YouTube but a lot free.'**
  String get piped_source_description;

  /// No description provided for @jiosaavn_source_description.
  ///
  /// In en, this message translates to:
  /// **'Best for South Asian region.'**
  String get jiosaavn_source_description;

  /// No description provided for @invidious_source_description.
  ///
  /// In en, this message translates to:
  /// **'Similar to Piped but with higher availability.'**
  String get invidious_source_description;

  /// No description provided for @highest_quality.
  ///
  /// In en, this message translates to:
  /// **'Highest Quality: {quality}'**
  String highest_quality(Object quality);

  /// No description provided for @select_audio_source.
  ///
  /// In en, this message translates to:
  /// **'Select Audio Source'**
  String get select_audio_source;

  /// No description provided for @endless_playback_description.
  ///
  /// In en, this message translates to:
  /// **'Automatically append new songs\nto the end of the queue'**
  String get endless_playback_description;

  /// No description provided for @choose_your_region.
  ///
  /// In en, this message translates to:
  /// **'Choose your region'**
  String get choose_your_region;

  /// No description provided for @choose_your_region_description.
  ///
  /// In en, this message translates to:
  /// **'This will help Spotube show you the right content\nfor your location.'**
  String get choose_your_region_description;

  /// No description provided for @choose_your_language.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get choose_your_language;

  /// No description provided for @help_project_grow.
  ///
  /// In en, this message translates to:
  /// **'Help this project grow'**
  String get help_project_grow;

  /// No description provided for @help_project_grow_description.
  ///
  /// In en, this message translates to:
  /// **'Spotube is an open-source project. You can help this project grow by contributing to the project, reporting bugs, or suggesting new features.'**
  String get help_project_grow_description;

  /// No description provided for @contribute_on_github.
  ///
  /// In en, this message translates to:
  /// **'Contribute on GitHub'**
  String get contribute_on_github;

  /// No description provided for @donate_on_open_collective.
  ///
  /// In en, this message translates to:
  /// **'Donate on Open Collective'**
  String get donate_on_open_collective;

  /// No description provided for @browse_anonymously.
  ///
  /// In en, this message translates to:
  /// **'Browse Anonymously'**
  String get browse_anonymously;

  /// No description provided for @enable_connect.
  ///
  /// In en, this message translates to:
  /// **'Enable Connect'**
  String get enable_connect;

  /// No description provided for @enable_connect_description.
  ///
  /// In en, this message translates to:
  /// **'Control Spotube from other devices'**
  String get enable_connect_description;

  /// No description provided for @devices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devices;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @connect_client_alert.
  ///
  /// In en, this message translates to:
  /// **'You\'re being controlled by {client}'**
  String connect_client_alert(Object client);

  /// No description provided for @this_device.
  ///
  /// In en, this message translates to:
  /// **'This Device'**
  String get this_device;

  /// No description provided for @remote.
  ///
  /// In en, this message translates to:
  /// **'Remote'**
  String get remote;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @and_n_more.
  ///
  /// In en, this message translates to:
  /// **'and {count} more'**
  String and_n_more(Object count);

  /// No description provided for @recently_played.
  ///
  /// In en, this message translates to:
  /// **'Recently Played'**
  String get recently_played;

  /// No description provided for @browse_more.
  ///
  /// In en, this message translates to:
  /// **'Browse More'**
  String get browse_more;

  /// No description provided for @no_title.
  ///
  /// In en, this message translates to:
  /// **'No Title'**
  String get no_title;

  /// No description provided for @not_playing.
  ///
  /// In en, this message translates to:
  /// **'Not playing'**
  String get not_playing;

  /// No description provided for @epic_failure.
  ///
  /// In en, this message translates to:
  /// **'Epic failure!'**
  String get epic_failure;

  /// No description provided for @added_num_tracks_to_queue.
  ///
  /// In en, this message translates to:
  /// **'Added {tracks_length} tracks to queue'**
  String added_num_tracks_to_queue(Object tracks_length);

  /// No description provided for @spotube_has_an_update.
  ///
  /// In en, this message translates to:
  /// **'Spotube has an update'**
  String get spotube_has_an_update;

  /// No description provided for @download_now.
  ///
  /// In en, this message translates to:
  /// **'Download Now'**
  String get download_now;

  /// No description provided for @nightly_version.
  ///
  /// In en, this message translates to:
  /// **'Spotube Nightly {nightlyBuildNum} has been released'**
  String nightly_version(Object nightlyBuildNum);

  /// No description provided for @release_version.
  ///
  /// In en, this message translates to:
  /// **'Spotube v{version} has been released'**
  String release_version(Object version);

  /// No description provided for @read_the_latest.
  ///
  /// In en, this message translates to:
  /// **'Read the latest '**
  String get read_the_latest;

  /// No description provided for @release_notes.
  ///
  /// In en, this message translates to:
  /// **'release notes'**
  String get release_notes;

  /// No description provided for @pick_color_scheme.
  ///
  /// In en, this message translates to:
  /// **'Pick color scheme'**
  String get pick_color_scheme;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @choose_the_device.
  ///
  /// In en, this message translates to:
  /// **'Choose the device:'**
  String get choose_the_device;

  /// No description provided for @multiple_device_connected.
  ///
  /// In en, this message translates to:
  /// **'There are multiple device connected.\nChoose the device you want this action to take place'**
  String get multiple_device_connected;

  /// No description provided for @nothing_found.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get nothing_found;

  /// No description provided for @the_box_is_empty.
  ///
  /// In en, this message translates to:
  /// **'The box is empty'**
  String get the_box_is_empty;

  /// No description provided for @top_artists.
  ///
  /// In en, this message translates to:
  /// **'Top Artists'**
  String get top_artists;

  /// No description provided for @top_albums.
  ///
  /// In en, this message translates to:
  /// **'Top Albums'**
  String get top_albums;

  /// No description provided for @this_week.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get this_week;

  /// No description provided for @this_month.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get this_month;

  /// No description provided for @last_6_months.
  ///
  /// In en, this message translates to:
  /// **'Last 6 months'**
  String get last_6_months;

  /// No description provided for @this_year.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get this_year;

  /// No description provided for @last_2_years.
  ///
  /// In en, this message translates to:
  /// **'Last 2 years'**
  String get last_2_years;

  /// No description provided for @all_time.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get all_time;

  /// No description provided for @powered_by_provider.
  ///
  /// In en, this message translates to:
  /// **'Powered by {providerName}'**
  String powered_by_provider(Object providerName);

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @profile_followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get profile_followers;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthday;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @not_born.
  ///
  /// In en, this message translates to:
  /// **'Not born'**
  String get not_born;

  /// No description provided for @hacker.
  ///
  /// In en, this message translates to:
  /// **'Hacker'**
  String get hacker;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @no_name.
  ///
  /// In en, this message translates to:
  /// **'No Name'**
  String get no_name;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @user_profile.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get user_profile;

  /// No description provided for @count_plays.
  ///
  /// In en, this message translates to:
  /// **'{count} plays'**
  String count_plays(Object count);

  /// No description provided for @streaming_fees_hypothetical.
  ///
  /// In en, this message translates to:
  /// **'Streaming fees (hypothetical)'**
  String get streaming_fees_hypothetical;

  /// No description provided for @minutes_listened.
  ///
  /// In en, this message translates to:
  /// **'Minutes listened'**
  String get minutes_listened;

  /// No description provided for @streamed_songs.
  ///
  /// In en, this message translates to:
  /// **'Streamed songs'**
  String get streamed_songs;

  /// No description provided for @count_streams.
  ///
  /// In en, this message translates to:
  /// **'{count} streams'**
  String count_streams(Object count);

  /// No description provided for @owned_by_you.
  ///
  /// In en, this message translates to:
  /// **'Owned by you'**
  String get owned_by_you;

  /// No description provided for @copied_shareurl_to_clipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied {shareUrl} to clipboard'**
  String copied_shareurl_to_clipboard(Object shareUrl);

  /// No description provided for @hipotetical_calculation.
  ///
  /// In en, this message translates to:
  /// **'*This is calculated based on average online music streaming platform\'s per stream\npayout of \$0.003 to \$0.005. This is a hypothetical\ncalculation to give user insight about how much they\nwould have paid to the artists if they were to listen\ntheir song in different music streaming platform.'**
  String get hipotetical_calculation;

  /// No description provided for @count_mins.
  ///
  /// In en, this message translates to:
  /// **'{minutes} mins'**
  String count_mins(Object minutes);

  /// No description provided for @summary_minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get summary_minutes;

  /// No description provided for @summary_listened_to_music.
  ///
  /// In en, this message translates to:
  /// **'Listened to music'**
  String get summary_listened_to_music;

  /// No description provided for @summary_songs.
  ///
  /// In en, this message translates to:
  /// **'songs'**
  String get summary_songs;

  /// No description provided for @summary_streamed_overall.
  ///
  /// In en, this message translates to:
  /// **'Streamed overall'**
  String get summary_streamed_overall;

  /// No description provided for @summary_owed_to_artists.
  ///
  /// In en, this message translates to:
  /// **'Owed to artists\nthis month'**
  String get summary_owed_to_artists;

  /// No description provided for @summary_artists.
  ///
  /// In en, this message translates to:
  /// **'artist\'s'**
  String get summary_artists;

  /// No description provided for @summary_music_reached_you.
  ///
  /// In en, this message translates to:
  /// **'Music reached you'**
  String get summary_music_reached_you;

  /// No description provided for @summary_full_albums.
  ///
  /// In en, this message translates to:
  /// **'full albums'**
  String get summary_full_albums;

  /// No description provided for @summary_got_your_love.
  ///
  /// In en, this message translates to:
  /// **'Got your love'**
  String get summary_got_your_love;

  /// No description provided for @summary_playlists.
  ///
  /// In en, this message translates to:
  /// **'playlists'**
  String get summary_playlists;

  /// No description provided for @summary_were_on_repeat.
  ///
  /// In en, this message translates to:
  /// **'Were on repeat'**
  String get summary_were_on_repeat;

  /// No description provided for @total_money.
  ///
  /// In en, this message translates to:
  /// **'Total {money}'**
  String total_money(Object money);

  /// No description provided for @webview_not_found.
  ///
  /// In en, this message translates to:
  /// **'Webview not found'**
  String get webview_not_found;

  /// No description provided for @webview_not_found_description.
  ///
  /// In en, this message translates to:
  /// **'No webview runtime is installed in your device.\nIf it\'s installed make sure it\'s in the Environment PATH\n\nAfter installing, restart the app'**
  String get webview_not_found_description;

  /// No description provided for @unsupported_platform.
  ///
  /// In en, this message translates to:
  /// **'Unsupported platform'**
  String get unsupported_platform;

  /// No description provided for @cache_music.
  ///
  /// In en, this message translates to:
  /// **'Cache music'**
  String get cache_music;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @cache_folder.
  ///
  /// In en, this message translates to:
  /// **'Cache folder'**
  String get cache_folder;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @clear_cache.
  ///
  /// In en, this message translates to:
  /// **'Clear cache'**
  String get clear_cache;

  /// No description provided for @clear_cache_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to clear the cache?'**
  String get clear_cache_confirmation;

  /// No description provided for @export_cache_files.
  ///
  /// In en, this message translates to:
  /// **'Export Cached Files'**
  String get export_cache_files;

  /// No description provided for @found_n_files.
  ///
  /// In en, this message translates to:
  /// **'Found {count} files'**
  String found_n_files(Object count);

  /// No description provided for @export_cache_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to export these files to'**
  String get export_cache_confirmation;

  /// No description provided for @exported_n_out_of_m_files.
  ///
  /// In en, this message translates to:
  /// **'Exported {filesExported} out of {files} files'**
  String exported_n_out_of_m_files(Object files, Object filesExported);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @download_all.
  ///
  /// In en, this message translates to:
  /// **'Download all'**
  String get download_all;

  /// No description provided for @add_all_to_playlist.
  ///
  /// In en, this message translates to:
  /// **'Add all to playlist'**
  String get add_all_to_playlist;

  /// No description provided for @add_all_to_queue.
  ///
  /// In en, this message translates to:
  /// **'Add all to queue'**
  String get add_all_to_queue;

  /// No description provided for @play_all_next.
  ///
  /// In en, this message translates to:
  /// **'Play all next'**
  String get play_all_next;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @view_all.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get view_all;

  /// No description provided for @no_tracks_added_yet.
  ///
  /// In en, this message translates to:
  /// **'Looks like you haven\'t added any tracks yet'**
  String get no_tracks_added_yet;

  /// No description provided for @no_tracks.
  ///
  /// In en, this message translates to:
  /// **'Looks like there are no tracks here'**
  String get no_tracks;

  /// No description provided for @no_tracks_listened_yet.
  ///
  /// In en, this message translates to:
  /// **'Looks like you haven\'t listened to anything yet'**
  String get no_tracks_listened_yet;

  /// No description provided for @not_following_artists.
  ///
  /// In en, this message translates to:
  /// **'You\'re not following any artists'**
  String get not_following_artists;

  /// No description provided for @no_favorite_albums_yet.
  ///
  /// In en, this message translates to:
  /// **'Looks like you haven\'t added any albums to your favorites yet'**
  String get no_favorite_albums_yet;

  /// No description provided for @no_logs_found.
  ///
  /// In en, this message translates to:
  /// **'No logs found'**
  String get no_logs_found;

  /// No description provided for @youtube_engine.
  ///
  /// In en, this message translates to:
  /// **'YouTube Engine'**
  String get youtube_engine;

  /// No description provided for @youtube_engine_not_installed_title.
  ///
  /// In en, this message translates to:
  /// **'{engine} is not installed'**
  String youtube_engine_not_installed_title(Object engine);

  /// No description provided for @youtube_engine_not_installed_message.
  ///
  /// In en, this message translates to:
  /// **'{engine} is not installed in your system.'**
  String youtube_engine_not_installed_message(Object engine);

  /// No description provided for @youtube_engine_set_path.
  ///
  /// In en, this message translates to:
  /// **'Make sure it\'s available in the PATH variable or\nset the absolute path to the {engine} executable below'**
  String youtube_engine_set_path(Object engine);

  /// No description provided for @youtube_engine_unix_issue_message.
  ///
  /// In en, this message translates to:
  /// **'In macOS/Linux/unix like OS\'s, setting path on .zshrc/.bashrc/.bash_profile etc. won\'t work.\nYou need to set the path in the shell configuration file'**
  String get youtube_engine_unix_issue_message;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @file_not_found.
  ///
  /// In en, this message translates to:
  /// **'File not found'**
  String get file_not_found;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @add_custom_url.
  ///
  /// In en, this message translates to:
  /// **'Add custom URL'**
  String get add_custom_url;

  /// No description provided for @edit_port.
  ///
  /// In en, this message translates to:
  /// **'Edit port'**
  String get edit_port;

  /// No description provided for @port_helper_msg.
  ///
  /// In en, this message translates to:
  /// **'Default is -1 which indicates random number. If you\'ve firewall configured, setting this is recommended.'**
  String get port_helper_msg;

  /// No description provided for @connect_request.
  ///
  /// In en, this message translates to:
  /// **'Allow {client} to connect?'**
  String connect_request(Object client);

  /// No description provided for @connection_request_denied.
  ///
  /// In en, this message translates to:
  /// **'Connection denied. User denied access.'**
  String get connection_request_denied;

  /// No description provided for @an_error_occurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get an_error_occurred;

  /// No description provided for @copy_to_clipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get copy_to_clipboard;

  /// No description provided for @view_logs.
  ///
  /// In en, this message translates to:
  /// **'View logs'**
  String get view_logs;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @no_default_metadata_provider_selected.
  ///
  /// In en, this message translates to:
  /// **'You\'ve no default metadata provider set'**
  String get no_default_metadata_provider_selected;

  /// No description provided for @manage_metadata_providers.
  ///
  /// In en, this message translates to:
  /// **'Manage metadata providers'**
  String get manage_metadata_providers;

  /// No description provided for @open_link_in_browser.
  ///
  /// In en, this message translates to:
  /// **'Open Link in Browser?'**
  String get open_link_in_browser;

  /// No description provided for @do_you_want_to_open_the_following_link.
  ///
  /// In en, this message translates to:
  /// **'Do you want to open the following link'**
  String get do_you_want_to_open_the_following_link;

  /// No description provided for @unsafe_url_warning.
  ///
  /// In en, this message translates to:
  /// **'It can be unsafe to open links from untrusted sources. Be cautious!\nYou can also copy the link to your clipboard.'**
  String get unsafe_url_warning;

  /// No description provided for @copy_link.
  ///
  /// In en, this message translates to:
  /// **'Copy Link'**
  String get copy_link;

  /// No description provided for @building_your_timeline.
  ///
  /// In en, this message translates to:
  /// **'Building your timeline based on your listenings...'**
  String get building_your_timeline;

  /// No description provided for @official.
  ///
  /// In en, this message translates to:
  /// **'Official'**
  String get official;

  /// No description provided for @author_name.
  ///
  /// In en, this message translates to:
  /// **'Author: {author}'**
  String author_name(Object author);

  /// No description provided for @third_party.
  ///
  /// In en, this message translates to:
  /// **'Third-party'**
  String get third_party;

  /// No description provided for @plugin_requires_authentication.
  ///
  /// In en, this message translates to:
  /// **'Plugin requires authentication'**
  String get plugin_requires_authentication;

  /// No description provided for @update_available.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get update_available;

  /// No description provided for @supports_scrobbling.
  ///
  /// In en, this message translates to:
  /// **'Supports scrobbling'**
  String get supports_scrobbling;

  /// No description provided for @plugin_scrobbling_info.
  ///
  /// In en, this message translates to:
  /// **'This plugin scrobbles your music to generate your listening history.'**
  String get plugin_scrobbling_info;

  /// No description provided for @default_metadata_source.
  ///
  /// In en, this message translates to:
  /// **'Default metadata source'**
  String get default_metadata_source;

  /// No description provided for @set_default_metadata_source.
  ///
  /// In en, this message translates to:
  /// **'Set default metadata source'**
  String get set_default_metadata_source;

  /// No description provided for @default_audio_source.
  ///
  /// In en, this message translates to:
  /// **'Default audio source'**
  String get default_audio_source;

  /// No description provided for @set_default_audio_source.
  ///
  /// In en, this message translates to:
  /// **'Set default audio source'**
  String get set_default_audio_source;

  /// No description provided for @set_default.
  ///
  /// In en, this message translates to:
  /// **'Set default'**
  String get set_default;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @support_plugin_development.
  ///
  /// In en, this message translates to:
  /// **'Support plugin development'**
  String get support_plugin_development;

  /// No description provided for @can_access_name_api.
  ///
  /// In en, this message translates to:
  /// **'- Can access **{name}** API'**
  String can_access_name_api(Object name);

  /// No description provided for @do_you_want_to_install_this_plugin.
  ///
  /// In en, this message translates to:
  /// **'Do you want to install this plugin?'**
  String get do_you_want_to_install_this_plugin;

  /// No description provided for @third_party_plugin_warning.
  ///
  /// In en, this message translates to:
  /// **'This plugin is from a third-party repository. Please ensure you trust the source before installing.'**
  String get third_party_plugin_warning;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// No description provided for @this_plugin_can_do_following.
  ///
  /// In en, this message translates to:
  /// **'This plugin can do following'**
  String get this_plugin_can_do_following;

  /// No description provided for @install.
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get install;

  /// No description provided for @install_a_metadata_provider.
  ///
  /// In en, this message translates to:
  /// **'Install a Metadata Provider'**
  String get install_a_metadata_provider;

  /// No description provided for @no_tracks_playing.
  ///
  /// In en, this message translates to:
  /// **'No Track being played currently'**
  String get no_tracks_playing;

  /// No description provided for @synced_lyrics_not_available.
  ///
  /// In en, this message translates to:
  /// **'Synced lyrics are not available for this song. Please use the'**
  String get synced_lyrics_not_available;

  /// No description provided for @plain_lyrics.
  ///
  /// In en, this message translates to:
  /// **'Plain Lyrics'**
  String get plain_lyrics;

  /// No description provided for @tab_instead.
  ///
  /// In en, this message translates to:
  /// **'tab instead.'**
  String get tab_instead;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get disclaimer;

  /// No description provided for @third_party_plugin_dmca_notice.
  ///
  /// In en, this message translates to:
  /// **'The Spotube team does not hold any responsibility (including legal) for any \"Third-party\" plugins.\nPlease use them at your own risk. For any bugs/issues, please report them to the plugin repository.\n\nIf any \"Third-party\" plugin is breaking ToS/DMCA of any service/legal entity, please ask the \"Third-party\" plugin author or the hosting platform .e.g GitHub/Codeberg to take action. Above listed (\"Third-party\" labelled) are all public/community maintained plugins. We\'re not curating them, so we cannot take any action on them.\n\n'**
  String get third_party_plugin_dmca_notice;

  /// No description provided for @input_does_not_match_format.
  ///
  /// In en, this message translates to:
  /// **'Input doesn\'t match the required format'**
  String get input_does_not_match_format;

  /// No description provided for @plugins.
  ///
  /// In en, this message translates to:
  /// **'Plugins'**
  String get plugins;

  /// No description provided for @paste_plugin_download_url.
  ///
  /// In en, this message translates to:
  /// **'Paste download url or GitHub/Codeberg repo url or direct link to .smplug file'**
  String get paste_plugin_download_url;

  /// No description provided for @download_and_install_plugin_from_url.
  ///
  /// In en, this message translates to:
  /// **'Download and install plugin from url'**
  String get download_and_install_plugin_from_url;

  /// No description provided for @failed_to_add_plugin_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to add plugin: {error}'**
  String failed_to_add_plugin_error(Object error);

  /// No description provided for @upload_plugin_from_file.
  ///
  /// In en, this message translates to:
  /// **'Upload plugin from file'**
  String get upload_plugin_from_file;

  /// No description provided for @installed.
  ///
  /// In en, this message translates to:
  /// **'Installed'**
  String get installed;

  /// No description provided for @available_plugins.
  ///
  /// In en, this message translates to:
  /// **'Available plugins'**
  String get available_plugins;

  /// No description provided for @configure_plugins.
  ///
  /// In en, this message translates to:
  /// **'Configure your own metadata provider and audio source plugins'**
  String get configure_plugins;

  /// No description provided for @audio_scrobblers.
  ///
  /// In en, this message translates to:
  /// **'Audio Scrobblers'**
  String get audio_scrobblers;

  /// No description provided for @scrobbling.
  ///
  /// In en, this message translates to:
  /// **'Scrobbling'**
  String get scrobbling;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source: '**
  String get source;

  /// No description provided for @uncompressed.
  ///
  /// In en, this message translates to:
  /// **'Uncompressed'**
  String get uncompressed;

  /// No description provided for @dab_music_source_description.
  ///
  /// In en, this message translates to:
  /// **'For audiophiles. Provides high-quality/lossless audio streams. Accurate ISRC based track matching.'**
  String get dab_music_source_description;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'bn',
        'ca',
        'cs',
        'de',
        'en',
        'es',
        'eu',
        'fa',
        'fi',
        'fr',
        'hi',
        'id',
        'it',
        'ja',
        'ka',
        'ko',
        'ne',
        'nl',
        'pl',
        'pt',
        'ru',
        'ta',
        'th',
        'tl',
        'tr',
        'uk',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'ca':
      return AppLocalizationsCa();
    case 'cs':
      return AppLocalizationsCs();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'eu':
      return AppLocalizationsEu();
    case 'fa':
      return AppLocalizationsFa();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ka':
      return AppLocalizationsKa();
    case 'ko':
      return AppLocalizationsKo();
    case 'ne':
      return AppLocalizationsNe();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'ta':
      return AppLocalizationsTa();
    case 'th':
      return AppLocalizationsTh();
    case 'tl':
      return AppLocalizationsTl();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
