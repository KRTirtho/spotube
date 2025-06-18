// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get guest => 'Misafir';

  @override
  String get browse => 'Göz at';

  @override
  String get search => 'Ara';

  @override
  String get library => 'Kütüphane';

  @override
  String get lyrics => 'Şarkı sözleri';

  @override
  String get settings => 'Ayarlar';

  @override
  String get genre_categories_filter => 'Kategorileri veya türleri filtreleyin...';

  @override
  String get genre => 'Tür';

  @override
  String get personalized => 'Kişiselleştirilmiş';

  @override
  String get featured => 'Öne çıkanlar';

  @override
  String get new_releases => 'Yeni çıkanlar';

  @override
  String get songs => 'Şarkılar';

  @override
  String playing_track(Object track) {
    return '$track oynatılıyor';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return 'Bu, mevcut kuyruğu temizleyecektir. $track_length parça kaldırılacak\nDevam etmek istiyor musunuz?';
  }

  @override
  String get load_more => 'Daha fazlasını yükle';

  @override
  String get playlists => 'Oynatma listeleri';

  @override
  String get artists => 'Sanatçılar';

  @override
  String get albums => 'Albümler';

  @override
  String get tracks => 'Parçalar';

  @override
  String get downloads => 'İndirilenler';

  @override
  String get filter_playlists => 'Oynatma listelerinizi filtreleyin...';

  @override
  String get liked_tracks => 'Beğenilen parçalar';

  @override
  String get liked_tracks_description => 'Beğendiğiniz tüm parçalar';

  @override
  String get playlist => 'Çalma Listesi';

  @override
  String get create_a_playlist => 'Bir oynatma listesi oluştur';

  @override
  String get update_playlist => 'Oynatma listesini güncelle';

  @override
  String get create => 'Oluştur';

  @override
  String get cancel => 'İptal';

  @override
  String get update => 'Güncelle';

  @override
  String get playlist_name => 'Oynatma listesi adı';

  @override
  String get name_of_playlist => 'Oynatma listesinin adı';

  @override
  String get description => 'Açıklama';

  @override
  String get public => 'Halka açık';

  @override
  String get collaborative => 'İşbirliği';

  @override
  String get search_local_tracks => 'Yerel parçaları ara...';

  @override
  String get play => 'Oynat';

  @override
  String get delete => 'Sil';

  @override
  String get none => 'Yok';

  @override
  String get sort_a_z => 'A - Z\'ye göre sırala';

  @override
  String get sort_z_a => 'Z - A\'ya göre sırala';

  @override
  String get sort_artist => 'Sanatçıya göre sırala';

  @override
  String get sort_album => 'Albüme göre sırala';

  @override
  String get sort_duration => 'Süreye göre sırala';

  @override
  String get sort_tracks => 'Parçaları sırala';

  @override
  String currently_downloading(Object tracks_length) {
    return 'Şu anda indirilenler ($tracks_length)';
  }

  @override
  String get cancel_all => 'Tümünü iptal et';

  @override
  String get filter_artist => 'Sanatçıları filtreleyin...';

  @override
  String followers(Object followers) {
    return '$followers Takipçiler';
  }

  @override
  String get add_artist_to_blacklist => 'Sanatçıyı kara listeye ekle';

  @override
  String get top_tracks => 'En iyi parçalar';

  @override
  String get fans_also_like => 'Hayranlar ayrıca şunları da beğendi';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get artist => 'Sanatçı';

  @override
  String get blacklisted => 'Kara listeye alındı';

  @override
  String get following => 'Takip ediliyor';

  @override
  String get follow => 'Takip et';

  @override
  String get artist_url_copied => 'Sanatçı bağlantısı panoya kopyalandı';

  @override
  String added_to_queue(Object tracks) {
    return 'Kuyruğa $tracks parçası eklendi';
  }

  @override
  String get filter_albums => 'Albümleri filtreleyin...';

  @override
  String get synced => 'Senkronize edildi';

  @override
  String get plain => 'Sade';

  @override
  String get shuffle => 'Karıştır';

  @override
  String get search_tracks => 'Parça ara...';

  @override
  String get released => 'Yayınlandı';

  @override
  String error(Object error) {
    return 'Hata $error';
  }

  @override
  String get title => 'Başlık';

  @override
  String get time => 'Zaman';

  @override
  String get more_actions => 'Daha fazla eylem';

  @override
  String download_count(Object count) {
    return 'İndir ($count)';
  }

  @override
  String add_count_to_playlist(Object count) {
    return 'Oynatma Listesine ekle ($count)';
  }

  @override
  String add_count_to_queue(Object count) {
    return 'Kuyruğa ekle ($count)';
  }

  @override
  String play_count_next(Object count) {
    return 'Sonrakini oynat ($count)';
  }

  @override
  String get album => 'Albüm';

  @override
  String copied_to_clipboard(Object data) {
    return '$data panoya kopyalandı';
  }

  @override
  String add_to_following_playlists(Object track) {
    return '$track parçasını aşağıdaki oynatma listelerine ekle';
  }

  @override
  String get add => 'Ekle';

  @override
  String added_track_to_queue(Object track) {
    return '$track kuyruğa eklendi';
  }

  @override
  String get add_to_queue => 'Kuyruğa ekle';

  @override
  String track_will_play_next(Object track) {
    return '$track bir sonraki çalacak';
  }

  @override
  String get play_next => 'Sonrakini oynat';

  @override
  String removed_track_from_queue(Object track) {
    return '$track kuyruktan kaldırıldı';
  }

  @override
  String get remove_from_queue => 'Kuyruktan kaldır';

  @override
  String get remove_from_favorites => 'Favorilerden kaldır';

  @override
  String get save_as_favorite => 'Favori olarak kaydet';

  @override
  String get add_to_playlist => 'Oynatma listesine ekle';

  @override
  String get remove_from_playlist => 'Oynatma listesinden kaldır';

  @override
  String get add_to_blacklist => 'Kara listeye ekle';

  @override
  String get remove_from_blacklist => 'Kara listeden kaldır';

  @override
  String get share => 'Paylaş';

  @override
  String get mini_player => 'Mini oynatıcı';

  @override
  String get slide_to_seek => 'İleri veya geri arama yapmak için kaydırın';

  @override
  String get shuffle_playlist => 'Oynatma listesini karıştır';

  @override
  String get unshuffle_playlist => 'Oynatma listesinin karışıklığını kaldır';

  @override
  String get previous_track => 'Önceki parça';

  @override
  String get next_track => 'Sonraki parça';

  @override
  String get pause_playback => 'Oynatmayı duraklat';

  @override
  String get resume_playback => 'Oynatmayı sürdür';

  @override
  String get loop_track => 'Döngü parçası';

  @override
  String get no_loop => 'Dönüş Yok';

  @override
  String get repeat_playlist => 'Oynatma listesini tekrarla';

  @override
  String get queue => 'Kuyruk';

  @override
  String get alternative_track_sources => 'Alternatif parça kaynakları';

  @override
  String get download_track => 'Parçayı indir';

  @override
  String tracks_in_queue(Object tracks) {
    return '$tracks parça kuyrukta';
  }

  @override
  String get clear_all => 'Tümünü temizle';

  @override
  String get show_hide_ui_on_hover => 'Fareyle üzerine gelindiğinde kullanıcı arayüzünü göster/gizle';

  @override
  String get always_on_top => 'Her zaman üstte';

  @override
  String get exit_mini_player => 'Mini oynatıcıdan çık';

  @override
  String get download_location => 'İndirme konumu';

  @override
  String get local_library => 'Yerel kütüphane';

  @override
  String get add_library_location => 'Kütüphaneye ekle';

  @override
  String get remove_library_location => 'Kütüphaneden çıkar';

  @override
  String get account => 'Hesap';

  @override
  String get login_with_spotify => 'Spotify hesabı ile giriş yap';

  @override
  String get connect_with_spotify => 'Spotify ile bağlan';

  @override
  String get logout => 'Çıkış yap';

  @override
  String get logout_of_this_account => 'Hesaptan çıkış yap';

  @override
  String get language_region => 'Dil ve bölge';

  @override
  String get language => 'Tercih edilen dil';

  @override
  String get system_default => 'Sistem varsayılanı';

  @override
  String get market_place_region => 'Tercih edilen bölge';

  @override
  String get recommendation_country => 'Tavsiye edilen ülke';

  @override
  String get appearance => 'Görünüm';

  @override
  String get layout_mode => 'Düzen modu';

  @override
  String get override_layout_settings => 'Duyarlı düzen modu ayarlarını geçersiz kıl';

  @override
  String get adaptive => 'Uyarlanabilir';

  @override
  String get compact => 'Sıkıştırılmış';

  @override
  String get extended => 'Genişletilmiş';

  @override
  String get theme => 'Tema';

  @override
  String get dark => 'Koyu';

  @override
  String get light => 'Açık';

  @override
  String get system => 'Sistem';

  @override
  String get accent_color => 'Vurgu rengi';

  @override
  String get sync_album_color => 'Albüm rengini senkronize et';

  @override
  String get sync_album_color_description => 'Vurgu rengi olarak albüm resminin baskın rengini kullanır';

  @override
  String get playback => 'Oynatma';

  @override
  String get audio_quality => 'Ses kalitesi';

  @override
  String get high => 'Yüksek';

  @override
  String get low => 'Düşük';

  @override
  String get pre_download_play => 'Önceden indir ve oynat';

  @override
  String get pre_download_play_description => 'Ses akışı yerine baytları indir ve oynat (Daha yüksek bant genişliğine sahip kullanıcılar için önerilir)';

  @override
  String get skip_non_music => 'Müzik olmayan bölümleri atlat (SponsorBlock)';

  @override
  String get blacklist_description => 'Kara listeye alınan parçalar ve sanatçılar';

  @override
  String get wait_for_download_to_finish => 'Lütfen mevcut indirme işleminin tamamlanmasını bekleyin';

  @override
  String get desktop => 'Masaüstü';

  @override
  String get close_behavior => 'Kapatma davranışı';

  @override
  String get close => 'Kapat';

  @override
  String get minimize_to_tray => 'Tepsiye küçült';

  @override
  String get show_tray_icon => 'Sistem tepsisi simgesini göster';

  @override
  String get about => 'Hakkında';

  @override
  String get u_love_spotube => 'Spotube\'u sevdiğinizi biliyoruz';

  @override
  String get check_for_updates => 'Güncellemeleri kontrol et';

  @override
  String get about_spotube => 'Spotube hakkında';

  @override
  String get blacklist => 'Kara liste';

  @override
  String get please_sponsor => 'Sponsor Ol/Bağış Yap';

  @override
  String get spotube_description => 'Spotube, hafif, platformlar arası uyumlu ve herkes için ücretsiz bir Spotify istemcisidir.';

  @override
  String get version => 'Sürüm';

  @override
  String get build_number => 'Derleme numarası';

  @override
  String get founder => 'Geliştirici';

  @override
  String get repository => 'Depo';

  @override
  String get bug_issues => 'Hata + Sorunlar';

  @override
  String get made_with => '❤️ ile Bangladeş\'te yapıldı';

  @override
  String get kingkor_roy_tirtho => 'Kingkor Roy Tirtho';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year Kingkor Roy Tirtho';
  }

  @override
  String get license => 'Lisans';

  @override
  String get add_spotify_credentials => 'Başlamak için spotify kimlik bilgilerinizi ekleyin';

  @override
  String get credentials_will_not_be_shared_disclaimer => 'Endişelenmeyin, kimlik bilgilerinizden hiçbiri toplanmayacak veya kimseyle paylaşılmayacak';

  @override
  String get know_how_to_login => 'Bunu nasıl yapacağınızı bilmiyor musunuz?';

  @override
  String get follow_step_by_step_guide => 'Adım adım kılavuzu takip edin';

  @override
  String spotify_cookie(Object name) {
    return 'Spotify $name çerezi';
  }

  @override
  String cookie_name_cookie(Object name) {
    return '$name çerezi';
  }

  @override
  String get fill_in_all_fields => 'Lütfen tüm alanları doldurun';

  @override
  String get submit => 'Başvur';

  @override
  String get exit => 'Çık';

  @override
  String get previous => 'Önceki';

  @override
  String get next => 'Sonraki';

  @override
  String get done => 'Bitti';

  @override
  String get step_1 => '1. Adım';

  @override
  String get first_go_to => 'İlk olarak şuraya gidin:';

  @override
  String get login_if_not_logged_in => 've oturum açmadıysanız Oturum açın/Kaydolun';

  @override
  String get step_2 => '2. Adım';

  @override
  String get step_2_steps => '1. Oturum açtıktan sonra, tarayıcı geliştirme araçlarını açmak için F12\'ye veya fareye sağ tıklayın > İncele\'ye basın.\n2. Daha sonra \"Uygulama\" sekmesine (Chrome, Edge, Brave vb..) veya \"Depolama\" sekmesine (Firefox, Palemoon vb..) gidin\n3. \"Çerezler\" bölümüne, ardından \"https://accounts.spotify.com\" alt bölümüne gidin';

  @override
  String get step_3 => '3. Adım';

  @override
  String get step_3_steps => '\"sp_dc\" Çerezinin değerini kopyalayın';

  @override
  String get success_emoji => 'Başarılı🥳';

  @override
  String get success_message => 'Artık Spotify hesabınızla başarıyla giriş yaptınız. Tebrik ederim!';

  @override
  String get step_4 => '4. Adım';

  @override
  String get step_4_steps => 'Kopyalanan \"sp_dc\" değerini yapıştırın';

  @override
  String get something_went_wrong => 'Bir hata oluştu';

  @override
  String get piped_instance => 'Piped sunucu örneği';

  @override
  String get piped_description => 'Parça eşleştirme için kullanılacak Piped sunucu örneği';

  @override
  String get piped_warning => 'Bazıları iyi çalışmayabilir. Yani riski size ait olmak üzere kullanın';

  @override
  String get invidious_instance => 'Invidious Sunucu Örneği';

  @override
  String get invidious_description => 'Parça eşleştirmesi için kullanılacak Invidious sunucu örneği';

  @override
  String get invidious_warning => 'Bazıları iyi çalışmayabilir. Kendi riskinizde kullanın';

  @override
  String get generate => 'Oluştur';

  @override
  String track_exists(Object track) {
    return '$track parçası zaten var';
  }

  @override
  String get replace_downloaded_tracks => 'İndirilen tüm parçaları değiştir';

  @override
  String get skip_download_tracks => 'İndirilen tüm parçaları indirmeyi atla';

  @override
  String get do_you_want_to_replace => 'Mevcut parçayı değiştirmek istiyor musunuz?';

  @override
  String get replace => 'Değiştir';

  @override
  String get skip => 'Atla';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return 'En fazla $count $type seçin';
  }

  @override
  String get select_genres => 'Türleri seç';

  @override
  String get add_genres => 'Tür ekle';

  @override
  String get country => 'Ülke';

  @override
  String get number_of_tracks_generate => 'Oluşturulacak parça sayısı';

  @override
  String get acousticness => 'Akustiklik';

  @override
  String get danceability => 'Dans Edilebilirlik';

  @override
  String get energy => 'Enerji';

  @override
  String get instrumentalness => 'Araçsallık';

  @override
  String get liveness => 'Canlılık';

  @override
  String get loudness => 'Ses yüksekliği';

  @override
  String get speechiness => 'Konuşkanlık';

  @override
  String get valence => 'Değerlik';

  @override
  String get popularity => 'Popülerlik';

  @override
  String get key => 'Anahtar';

  @override
  String get duration => 'Süre (sn)';

  @override
  String get tempo => 'Tempo (BPM)';

  @override
  String get mode => 'Mod';

  @override
  String get time_signature => 'Zaman imzası';

  @override
  String get short => 'Kısa';

  @override
  String get medium => 'Orta';

  @override
  String get long => 'Uzun';

  @override
  String get min => 'Min';

  @override
  String get max => 'Maks';

  @override
  String get target => 'Hedef';

  @override
  String get moderate => 'Orta';

  @override
  String get deselect_all => 'Tüm seçimleri kaldır';

  @override
  String get select_all => 'Tümünü seç';

  @override
  String get are_you_sure => 'Emin misiniz?';

  @override
  String get generating_playlist => 'Özel oynatma listeniz oluşturuluyor...';

  @override
  String selected_count_tracks(Object count) {
    return '$count parça seçildi';
  }

  @override
  String get download_warning => 'Tüm şarkıları toplu olarak indiriyorsanız, açıkça müzik korsanlığı yapıyorsunuz ve müzik dünyasının yaratıcı topluluğuna zarar veriyorsunuz demektir. Umuyorum bunun farkındasınızdır. Her zaman, sanatçıların emeğine saygı göstermeyi ve desteklemeyi deneyin.';

  @override
  String get download_ip_ban_warning => 'Ayrıca, normalden fazla indirme istekleri nedeniyle YouTube\'da IP\'niz engellenebilir. IP engeli, en az 2-3 ay boyunca YouTube\'u (hatta oturum açmış olsanız bile) o IP cihazından kullanamayacağınız anlamına gelir. Ve eğer böyle bir durum yaşanırsa, Spotube bundan hiçbir sorumluluk kabul etmez.';

  @override
  String get by_clicking_accept_terms => '\"Kabul et\" e tıklayarak aşağıdaki şartları kabul etmiş olursunuz:';

  @override
  String get download_agreement_1 => 'Müzik korsanlığı yaptığımı biliyorum. Ben fakir biriyim.';

  @override
  String get download_agreement_2 => 'Sanatçıyı elimden geldiğince destekleyeceğim ve bunu sadece sanatını satın alacak param olmadığı için yapıyorum';

  @override
  String get download_agreement_3 => 'YouTube\'da IP\'min engellenebileceğinin tamamen farkındayım ve mevcut eylemlerimden kaynaklanan herhangi bir kaza için Spotube\'u veya sahiplerini/katkıda bulunanları sorumlu tutmuyorum.';

  @override
  String get decline => 'Reddet';

  @override
  String get accept => 'Kabul et';

  @override
  String get details => 'Detaylar';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => 'Kanal';

  @override
  String get likes => 'Beğenenler';

  @override
  String get dislikes => 'Beğenmeyenler';

  @override
  String get views => 'İzlenmeler';

  @override
  String get streamUrl => 'Akış bağlantısı';

  @override
  String get stop => 'Durdur';

  @override
  String get sort_newest => 'En yeni eklenene göre sırala.';

  @override
  String get sort_oldest => 'En eski eklenene göre sırala';

  @override
  String get sleep_timer => 'Uyku Zamanlayıcısı';

  @override
  String mins(Object minutes) {
    return '$minutes Dakika';
  }

  @override
  String hours(Object hours) {
    return '$hours Saatler';
  }

  @override
  String hour(Object hours) {
    return '$hours Saat';
  }

  @override
  String get custom_hours => 'Özel Saatler';

  @override
  String get logs => 'Günlükler';

  @override
  String get developers => 'Geliştiriciler';

  @override
  String get not_logged_in => 'Giriş yapmadınız';

  @override
  String get search_mode => 'Arama modu';

  @override
  String get audio_source => 'Ses kaynağı';

  @override
  String get ok => 'Tamam';

  @override
  String get failed_to_encrypt => 'Şifreleme başarısız oldu';

  @override
  String get encryption_failed_warning => 'Spotube, verilerinizi güvenli bir şekilde depolamak için şifreleme kullanır. Ancak bunu başaramadı. Bu nedenle, güvensiz depolamaya geri dönecektir\nLinux kullanıyorsanız, lütfen gnome-keyring, kde-wallet, keepassxc vb. herhangi bir gizli servisin yüklü olduğundan emin olun.';

  @override
  String get querying_info => 'Bilgi sorgulanıyor...';

  @override
  String get piped_api_down => 'Piped API kapalı';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return 'Piped örneği $pipedInstance şu anda kapalı\n\nÖrneği değiştirin veya \'API türünü\' resmi YouTube API\'si olarak değiştirin\n\nDeğişiklikten sonra uygulamayı yeniden başlattığınızdan emin olun';
  }

  @override
  String get you_are_offline => 'Şu anda çevrimdışısınız';

  @override
  String get connection_restored => 'İnternet bağlantınız geri yüklendi';

  @override
  String get use_system_title_bar => 'Sistem başlık çubuğunu kullan';

  @override
  String get crunching_results => 'Sonuçlar...';

  @override
  String get search_to_get_results => 'Sonuç almak için arayın';

  @override
  String get use_amoled_mode => 'AMOLED modu kullan';

  @override
  String get pitch_dark_theme => 'Zifiri karanlık koyu tema';

  @override
  String get normalize_audio => 'Sesi normalleştir';

  @override
  String get change_cover => 'Kapağı değiştir';

  @override
  String get add_cover => 'Kapak ekle';

  @override
  String get restore_defaults => 'Varsayılanları geri yükle';

  @override
  String get download_music_codec => 'Müzik codec bileşenini indir';

  @override
  String get streaming_music_codec => 'Müzik codec\'i akışı';

  @override
  String get login_with_lastfm => 'Last.fm ile giriş yap';

  @override
  String get connect => 'Bağlan';

  @override
  String get disconnect_lastfm => 'Last.fm bağlantısını kes';

  @override
  String get disconnect => 'Bağlantıyı kes';

  @override
  String get username => 'Kullanıcı adı';

  @override
  String get password => 'Şifre';

  @override
  String get login => 'Giriş yap';

  @override
  String get login_with_your_lastfm => 'Last.fm hesabınızla giriş yapın';

  @override
  String get scrobble_to_lastfm => 'Last.fm için Scrobble';

  @override
  String get go_to_album => 'Albüme git';

  @override
  String get discord_rich_presence => 'Discord zengin varlığı';

  @override
  String get browse_all => 'Tümüne göz at';

  @override
  String get genres => 'Müzik türleri';

  @override
  String get explore_genres => 'Türleri keşfet';

  @override
  String get friends => 'Arkadaşlar';

  @override
  String get no_lyrics_available => 'Üzgünüz, bu parçanın sözleri bulunamıyor';

  @override
  String get start_a_radio => 'Radyo başlat';

  @override
  String get how_to_start_radio => 'Radyoyu nasıl başlatmak istersiniz?';

  @override
  String get replace_queue_question => 'Mevcut kuyruğu değiştirmek mi yoksa eklemek mi istersiniz?';

  @override
  String get endless_playback => 'Sonsuz olarak oynat';

  @override
  String get delete_playlist => 'Oynatma listesini sil';

  @override
  String get delete_playlist_confirmation => 'Bu oynatma listesini silmek istediğinizden emin misiniz?';

  @override
  String get local_tracks => 'Yerel parçalar';

  @override
  String get local_tab => 'Yerel';

  @override
  String get song_link => 'Şarkı bağlantısı';

  @override
  String get skip_this_nonsense => 'Bu saçmalığı atla';

  @override
  String get freedom_of_music => '“Müzik özgürlüğü”';

  @override
  String get freedom_of_music_palm => '“Müzik özgürlüğü avucunuzun içinde”';

  @override
  String get get_started => 'Haydi başlayalım';

  @override
  String get youtube_source_description => 'Tavsiye edilir ve en iyi şekilde çalışır.';

  @override
  String get piped_source_description => 'Özgür hissediyor musunuz? YouTube ile aynı, ama çok daha özgür.';

  @override
  String get jiosaavn_source_description => 'Güney Asya bölgesi için en iyisi.';

  @override
  String get invidious_source_description => 'Piped\'a benzer, ancak daha yüksek kullanılabilirliğe sahip.';

  @override
  String highest_quality(Object quality) {
    return 'En yüksek kalite: $quality';
  }

  @override
  String get select_audio_source => 'Ses kaynağını seçin';

  @override
  String get endless_playback_description => 'Yeni şarkıları otomatik olarak\nkuyruğun sonuna ekle';

  @override
  String get choose_your_region => 'Bölgenizi seçin';

  @override
  String get choose_your_region_description => 'Bu, Spotube\'un konumunuza uygun içerikleri göstermesine yardımcı olacaktır.';

  @override
  String get choose_your_language => 'Dilinizi seçin';

  @override
  String get help_project_grow => 'Bu projenin büyümesine yardımcı olun';

  @override
  String get help_project_grow_description => 'Spotube açık kaynaklı bir projedir. Projeye katkıda bulunarak, hataları bildirerek veya yeni özellikler önererek bu projenin büyümesine yardımcı olabilirsiniz.';

  @override
  String get contribute_on_github => 'GitHub\'da katkıda bulun';

  @override
  String get donate_on_open_collective => 'Open Collective\'de bağış yap';

  @override
  String get browse_anonymously => 'Anonim olarak giriş yap';

  @override
  String get enable_connect => 'Bağlanmayı etkinleştir';

  @override
  String get enable_connect_description => 'Spotube\'u diğer cihazlardan kontrol edin';

  @override
  String get devices => 'Cihazlar';

  @override
  String get select => 'Seç';

  @override
  String connect_client_alert(Object client) {
    return '$client tarafından kontrol ediliyorsun.';
  }

  @override
  String get this_device => 'Bu cihaz';

  @override
  String get remote => 'Yönet';

  @override
  String get stats => 'İstatistikler';

  @override
  String and_n_more(Object count) {
    return 've $count daha';
  }

  @override
  String get recently_played => 'Son Çalınanlar';

  @override
  String get browse_more => 'Daha Fazla Göz At';

  @override
  String get no_title => 'Başlık Yok';

  @override
  String get not_playing => 'Çalmıyor';

  @override
  String get epic_failure => 'Efsanevi başarısızlık!';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return '$tracks_length şarkı sıraya eklendi';
  }

  @override
  String get spotube_has_an_update => 'Spotube bir güncelleme aldı';

  @override
  String get download_now => 'Şimdi İndir';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Spotube Nightly $nightlyBuildNum yayımlandı';
  }

  @override
  String release_version(Object version) {
    return 'Spotube v$version yayımlandı';
  }

  @override
  String get read_the_latest => 'Son haberleri oku';

  @override
  String get release_notes => 'sürüm notları';

  @override
  String get pick_color_scheme => 'Renk şeması seç';

  @override
  String get save => 'Kaydet';

  @override
  String get choose_the_device => 'Cihazı seçin:';

  @override
  String get multiple_device_connected => 'Birden fazla cihaz bağlı.\nBu işlemi gerçekleştirmek istediğiniz cihazı seçin';

  @override
  String get nothing_found => 'Hiçbir şey bulunamadı';

  @override
  String get the_box_is_empty => 'Kutu boş';

  @override
  String get top_artists => 'En İyi Sanatçılar';

  @override
  String get top_albums => 'En İyi Albümler';

  @override
  String get this_week => 'Bu hafta';

  @override
  String get this_month => 'Bu ay';

  @override
  String get last_6_months => 'Son 6 ay';

  @override
  String get this_year => 'Bu yıl';

  @override
  String get last_2_years => 'Son 2 yıl';

  @override
  String get all_time => 'Tüm zamanlar';

  @override
  String powered_by_provider(Object providerName) {
    return '$providerName tarafından desteklenmektedir';
  }

  @override
  String get email => 'E-posta';

  @override
  String get profile_followers => 'Takipçiler';

  @override
  String get birthday => 'Doğum Günü';

  @override
  String get subscription => 'Abonelik';

  @override
  String get not_born => 'Henüz doğmadı';

  @override
  String get hacker => 'Hacker';

  @override
  String get profile => 'Profil';

  @override
  String get no_name => 'İsim Yok';

  @override
  String get edit => 'Düzenle';

  @override
  String get user_profile => 'Kullanıcı Profili';

  @override
  String count_plays(Object count) {
    return '$count çalma';
  }

  @override
  String get streaming_fees_hypothetical => '*Spotify\'ın akış başına ödeme miktarına\n\$0.003 ile \$0.005 arasında hesaplanmıştır. Bu, kullanıcıya\nSpotify\'da şarkılarını dinlerse sanatçılara ne kadar ödeme\nyapmış olabileceğini göstermek için hipotetik bir hesaplamadır.';

  @override
  String get minutes_listened => 'Dinlenilen Dakikalar';

  @override
  String get streamed_songs => 'Yayınlanan Şarkılar';

  @override
  String count_streams(Object count) {
    return '$count yayın';
  }

  @override
  String get owned_by_you => 'Sahip olduğunuz';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return '$shareUrl panoya kopyalandı';
  }

  @override
  String get spotify_hipotetical_calculation => '*Bu, Spotify\'ın her yayın başına ödemenin\n\$0.003 ile \$0.005 arasında olduğu varsayımıyla hesaplanmıştır. Bu\nhipotetik bir hesaplamadır, kullanıcıya şarkılarını Spotify\'da dinlediklerinde\nsanatçılara ne kadar ödeme yapacaklarını gösterir.';

  @override
  String count_mins(Object minutes) {
    return '$minutes dk';
  }

  @override
  String get summary_minutes => 'dakika';

  @override
  String get summary_listened_to_music => 'Dinlenen müzik';

  @override
  String get summary_songs => 'şarkılar';

  @override
  String get summary_streamed_overall => 'Genel olarak akış';

  @override
  String get summary_owed_to_artists => 'Sanatçılara borç\nbu ay';

  @override
  String get summary_artists => 'sanatçının';

  @override
  String get summary_music_reached_you => 'Müzik sana ulaştı';

  @override
  String get summary_full_albums => 'tam albümler';

  @override
  String get summary_got_your_love => 'Sevgini aldı';

  @override
  String get summary_playlists => 'çalma listeleri';

  @override
  String get summary_were_on_repeat => 'Tekrarda vardı';

  @override
  String total_money(Object money) {
    return 'Toplam $money';
  }

  @override
  String get webview_not_found => 'Webview bulunamadı';

  @override
  String get webview_not_found_description => 'Cihazınızda herhangi bir Webview çalışma zamanı yüklü değil.\nEğer kuruluysa, ortam YOLUNDA olduğundan emin olun\n\nKurulumdan sonra uygulamayı yeniden başlatın';

  @override
  String get unsupported_platform => 'Desteklenmeyen platform';

  @override
  String get cache_music => 'Müziği önbellekle';

  @override
  String get open => 'Aç';

  @override
  String get cache_folder => 'Önbellek klasörü';

  @override
  String get export => 'Dışa aktar';

  @override
  String get clear_cache => 'Önbelleği temizle';

  @override
  String get clear_cache_confirmation => 'Önbelleği temizlemek istiyor musunuz?';

  @override
  String get export_cache_files => 'Önbelleğe Alınmış Dosyaları Dışa Aktar';

  @override
  String found_n_files(Object count) {
    return '$count dosya bulundu';
  }

  @override
  String get export_cache_confirmation => 'Bu dosyaları dışa aktarmak istiyor musunuz';

  @override
  String exported_n_out_of_m_files(Object files, Object filesExported) {
    return '$filesExported / $files dosya dışa aktarıldı';
  }

  @override
  String get undo => 'Geri Al';

  @override
  String get download_all => 'Tümünü İndir';

  @override
  String get add_all_to_playlist => 'Hepsini çalma listesine ekle';

  @override
  String get add_all_to_queue => 'Hepsini kuyruğa ekle';

  @override
  String get play_all_next => 'Hepsini bir sonraki çal';

  @override
  String get pause => 'Duraklat';

  @override
  String get view_all => 'Tümünü Gör';

  @override
  String get no_tracks_added_yet => 'Henüz hiçbir şarkı eklemediniz gibi görünüyor';

  @override
  String get no_tracks => 'Burada hiç şarkı yok gibi görünüyor';

  @override
  String get no_tracks_listened_yet => 'Henüz hiçbir şey dinlemediniz gibi görünüyor';

  @override
  String get not_following_artists => 'Hiçbir sanatçıyı takip etmiyorsunuz';

  @override
  String get no_favorite_albums_yet => 'Henüz favorilerinize herhangi bir albüm eklemediniz gibi görünüyor';

  @override
  String get no_logs_found => 'Log bulunamadı';

  @override
  String get youtube_engine => 'YouTube Motoru';

  @override
  String youtube_engine_not_installed_title(Object engine) {
    return '$engine Yüklü değil';
  }

  @override
  String youtube_engine_not_installed_message(Object engine) {
    return '$engine sisteminizde yüklü değil.';
  }

  @override
  String youtube_engine_set_path(Object engine) {
    return 'PATH değişkeninde kullanılabilir olduğundan emin olun veya\n$engine çalıştırılabilir dosyasının mutlak yolunu aşağıda ayarlayın';
  }

  @override
  String get youtube_engine_unix_issue_message => 'macOS/Linux/Unix benzeri işletim sistemlerinde, .zshrc/.bashrc/.bash_profile gibi dosyalarda yol ayarlamak işe yaramaz.\nYolunuzu kabuk yapılandırma dosyasına ayarlamanız gerekir';

  @override
  String get download => 'İndir';

  @override
  String get file_not_found => 'Dosya bulunamadı';

  @override
  String get custom => 'Özel';

  @override
  String get add_custom_url => 'Özel URL ekle';

  @override
  String get edit_port => 'Portu düzenle';

  @override
  String get port_helper_msg => 'Varsayılan -1\'dir, bu da rastgele bir sayıyı gösterir. Bir güvenlik duvarınız varsa, bunu ayarlamanız önerilir.';

  @override
  String connect_request(Object client) {
    return '$client bağlantısına izin verilsin mi?';
  }

  @override
  String get connection_request_denied => 'Bağlantı reddedildi. Kullanıcı erişimi reddetti.';
}
