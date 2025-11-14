// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get guest => 'Tamu';

  @override
  String get browse => 'Jelajahi';

  @override
  String get search => 'Cari';

  @override
  String get library => 'Pustaka';

  @override
  String get lyrics => 'Lirik';

  @override
  String get settings => 'Pengaturan';

  @override
  String get genre_categories_filter => 'Urutkan kategori atau genre...';

  @override
  String get genre => 'Genre';

  @override
  String get personalized => 'Dipersonalisasi';

  @override
  String get featured => 'Unggulan';

  @override
  String get new_releases => 'Rilis Terbaru';

  @override
  String get songs => 'Lagu';

  @override
  String playing_track(Object track) {
    return 'Memutar $track';
  }

  @override
  String queue_clear_alert(Object track_length) {
    return 'Ini akan menghapus antrian saat ini This will clear the current queue. $track_length trek akan dihapus\nAnda ingin melanjutkan?';
  }

  @override
  String get load_more => 'Lebih Banyak';

  @override
  String get playlists => 'Daftar Putar';

  @override
  String get artists => 'Artis';

  @override
  String get albums => 'Album';

  @override
  String get tracks => 'Trek';

  @override
  String get downloads => 'Unduhan';

  @override
  String get filter_playlists => 'Urutkan daftar putar Anda...';

  @override
  String get liked_tracks => 'Lagu Yang Disukai';

  @override
  String get liked_tracks_description => 'Semua lagu yang Anda sukai';

  @override
  String get playlist => 'Playlist';

  @override
  String get create_a_playlist => 'Buat daftar putar';

  @override
  String get update_playlist => 'Ubah daftar putar';

  @override
  String get create => 'Buat';

  @override
  String get cancel => 'Batal';

  @override
  String get update => 'Ubah';

  @override
  String get playlist_name => 'Nama Daftar Putar';

  @override
  String get name_of_playlist => 'Nama daftar putar';

  @override
  String get description => 'Deskripsi';

  @override
  String get public => 'Publik';

  @override
  String get collaborative => 'Kolaboratif';

  @override
  String get search_local_tracks => 'Cari trek lokal...';

  @override
  String get play => 'Putar';

  @override
  String get delete => 'Hapus';

  @override
  String get none => 'Tidak Ada';

  @override
  String get sort_a_z => 'Urutkan berdasarkan A-Z';

  @override
  String get sort_z_a => 'Urutkan berdasarkan Z-A';

  @override
  String get sort_artist => 'Urutkan berdasarkan Artis';

  @override
  String get sort_album => 'Urutkan berdasarkan Album';

  @override
  String get sort_duration => 'Urutkan berdasarkan Durasi';

  @override
  String get sort_tracks => 'Urutkan trek';

  @override
  String currently_downloading(Object tracks_length) {
    return 'Sedang Mengunduh ($tracks_length)';
  }

  @override
  String get cancel_all => 'Batalkan Semua';

  @override
  String get filter_artist => 'Urutkan artis...';

  @override
  String followers(Object followers) {
    return '$followers Pengikut';
  }

  @override
  String get add_artist_to_blacklist => 'Tambah artis ke daftar hitam';

  @override
  String get top_tracks => 'Lagu Teratas';

  @override
  String get fans_also_like => 'Penggemar juga menyukainya';

  @override
  String get loading => 'Memuat...';

  @override
  String get artist => 'Artis';

  @override
  String get blacklisted => 'Masuk Daftar Hitam';

  @override
  String get following => 'Mengikuti';

  @override
  String get follow => 'Ikuti';

  @override
  String get artist_url_copied => 'URL artis telah disalin';

  @override
  String added_to_queue(Object tracks) {
    return 'Menambah trek $tracks ke antrean';
  }

  @override
  String get filter_albums => 'Urutkan album...';

  @override
  String get synced => 'Disinkronkan';

  @override
  String get plain => 'Normal';

  @override
  String get shuffle => 'Acak';

  @override
  String get search_tracks => 'Cari trek...';

  @override
  String get released => 'Dirilis';

  @override
  String error(Object error) {
    return 'Kesalahan $error';
  }

  @override
  String get title => 'Judul';

  @override
  String get time => 'Waktu';

  @override
  String get more_actions => 'Tindakan Lainnya';

  @override
  String download_count(Object count) {
    return 'Unduhan ($count)';
  }

  @override
  String add_count_to_playlist(Object count) {
    return 'Menambah ($count) ke Daftar Putar';
  }

  @override
  String add_count_to_queue(Object count) {
    return 'Menambah ($count) ke Antrian';
  }

  @override
  String play_count_next(Object count) {
    return 'Mainkan ($count) selanjutnya';
  }

  @override
  String get album => 'Album';

  @override
  String copied_to_clipboard(Object data) {
    return '$data telah disalin';
  }

  @override
  String add_to_following_playlists(Object track) {
    return 'Menambah $track ke Daftar Putar berikut';
  }

  @override
  String get add => 'Tambah';

  @override
  String added_track_to_queue(Object track) {
    return 'Menambah $track ke antrian';
  }

  @override
  String get add_to_queue => 'Tambah ke antrian';

  @override
  String track_will_play_next(Object track) {
    return '$track akan diputar berikutnya';
  }

  @override
  String get play_next => 'Mainkan selanjutnya';

  @override
  String removed_track_from_queue(Object track) {
    return 'Menghapus $track dari antrian';
  }

  @override
  String get remove_from_queue => 'Hapus dari antrian';

  @override
  String get remove_from_favorites => 'Hapus dari favorit';

  @override
  String get save_as_favorite => 'Simpan sebagai favorit';

  @override
  String get add_to_playlist => 'Tambah ke daftar putar';

  @override
  String get remove_from_playlist => 'Hapus dari daftar putar';

  @override
  String get add_to_blacklist => 'Tambah ke daftar hitam';

  @override
  String get remove_from_blacklist => 'Hapus dari daftar hitam';

  @override
  String get share => 'Bagikan';

  @override
  String get mini_player => 'Pemutar Mini';

  @override
  String get slide_to_seek => 'Geser untuk maju atau mundur';

  @override
  String get shuffle_playlist => 'Acak daftar putar';

  @override
  String get unshuffle_playlist => 'Batalkan pengacakan daftar putar';

  @override
  String get previous_track => 'Lagu sebelumnya';

  @override
  String get next_track => 'Lagu berikutnya';

  @override
  String get pause_playback => 'Jeda Pemutaran';

  @override
  String get resume_playback => 'Lanjutkan Pemutaran';

  @override
  String get loop_track => 'Ulangi Pemutaran';

  @override
  String get no_loop => 'No loop';

  @override
  String get repeat_playlist => 'Ulangi daftar putar';

  @override
  String get queue => 'Antrian';

  @override
  String get alternative_track_sources => 'Sumber trek alternatif';

  @override
  String get download_track => 'Unduh lagu';

  @override
  String tracks_in_queue(Object tracks) {
    return '$tracks trek dalam antrian';
  }

  @override
  String get clear_all => 'Bersihkan semua';

  @override
  String get show_hide_ui_on_hover =>
      'Tampil/Sembunyikan UI saat mengarahkan kursor';

  @override
  String get always_on_top => 'Selalu di atas';

  @override
  String get exit_mini_player => 'Keluar Pemutar Mini';

  @override
  String get download_location => 'Lokasi unduhan';

  @override
  String get local_library => 'Perpustakaan lokal';

  @override
  String get add_library_location => 'Tambahkan ke perpustakaan';

  @override
  String get remove_library_location => 'Hapus dari perpustakaan';

  @override
  String get account => 'Akun';

  @override
  String get logout => 'Keluar';

  @override
  String get logout_of_this_account => 'Keluar dari akun';

  @override
  String get language_region => 'Bahasa & Wilayah';

  @override
  String get language => 'Bahasa';

  @override
  String get system_default => 'Bawaan Sistem';

  @override
  String get market_place_region => 'Wilayah Pasar';

  @override
  String get recommendation_country => 'Negara Rekomendasi';

  @override
  String get appearance => 'Tampilan';

  @override
  String get layout_mode => 'Mode Tata Letak';

  @override
  String get override_layout_settings =>
      'Ganti pengaturan mode tata letak responsif';

  @override
  String get adaptive => 'Adaptif';

  @override
  String get compact => 'Ringkas';

  @override
  String get extended => 'Diperluas';

  @override
  String get theme => 'Tema';

  @override
  String get dark => 'Gelap';

  @override
  String get light => 'Terang';

  @override
  String get system => 'Sistem';

  @override
  String get accent_color => 'Warna Aksen';

  @override
  String get sync_album_color => 'Sinkronkan warna album';

  @override
  String get sync_album_color_description =>
      'Menggunakan warna dominan sampul album sebagai warna aksen';

  @override
  String get playback => 'Pemutaran';

  @override
  String get audio_quality => 'Kualitas Suara';

  @override
  String get high => 'Tinggi';

  @override
  String get low => 'Rendah';

  @override
  String get pre_download_play => 'Unduh dan putar';

  @override
  String get pre_download_play_description =>
      'Daripada streaming audio, unduh byte dan mainkan (Direkomendasikan untuk pengguna bandwidth yang lebih tinggi)';

  @override
  String get skip_non_music => 'Lewati segmen non-musik (SponsorBlock)';

  @override
  String get blacklist_description => 'Lagu dan artis di daftar hitam';

  @override
  String get wait_for_download_to_finish =>
      'Tunggu hingga unduhan saat ini selesai';

  @override
  String get desktop => 'Desktop';

  @override
  String get close_behavior => 'Tutup Perilaku';

  @override
  String get close => 'Tutup';

  @override
  String get minimize_to_tray => 'Perkecil ke tray';

  @override
  String get show_tray_icon => 'Tampilkan tray ikon sistem';

  @override
  String get about => 'Tentang';

  @override
  String get u_love_spotube => 'Kami tahu Anda menyukai Spotube';

  @override
  String get check_for_updates => 'Periksa pembaruan';

  @override
  String get about_spotube => 'Tentang Spotube';

  @override
  String get blacklist => 'Daftar Hitam';

  @override
  String get please_sponsor => 'Silakan Sponsor/Menyumbang';

  @override
  String get spotube_description =>
      'Spotube, klien Spotify yang ringan, lintas platform, dan gratis untuk semua';

  @override
  String get version => 'Versi';

  @override
  String get build_number => 'Nomor Pembuatan';

  @override
  String get founder => 'Pendiri';

  @override
  String get repository => 'Repositori';

  @override
  String get bug_issues => 'Bug+Masalah';

  @override
  String get made_with => 'Dibuat dengan ❤️ di Bangladesh🇧🇩';

  @override
  String get kingkor_roy_tirtho => 'Kingkor Roy Tirtho';

  @override
  String copyright(Object current_year) {
    return '© 2021-$current_year Kingkor Roy Tirtho';
  }

  @override
  String get license => 'Lisensi';

  @override
  String get credentials_will_not_be_shared_disclaimer =>
      'Jangan khawatir, kredensial Anda tidak akan dikumpulkan atau dibagikan kepada siapa pun';

  @override
  String get know_how_to_login => 'Tidak tahu bagaimana melakukan ini?';

  @override
  String get follow_step_by_step_guide => 'Ikuti panduan Langkah demi Langkah';

  @override
  String cookie_name_cookie(Object name) {
    return '$name Cookie';
  }

  @override
  String get fill_in_all_fields => 'Silakan isi semua kolom';

  @override
  String get submit => 'Kirim';

  @override
  String get exit => 'Keluar';

  @override
  String get previous => 'Sebelumnya';

  @override
  String get next => 'Berikutnya';

  @override
  String get done => 'Selesai';

  @override
  String get step_1 => 'Langkah 1';

  @override
  String get first_go_to => 'Pertama, Pergi ke';

  @override
  String get something_went_wrong => 'Terjadi kesalahan';

  @override
  String get piped_instance => 'Piped Server Instance';

  @override
  String get piped_description =>
      'The Piped server instance untuk digunakan sebagai pencocokan trek';

  @override
  String get piped_warning =>
      'Beberapa di antaranya mungkin tidak berfungsi dengan baik. Jadi gunakan dengan risiko Anda sendiri';

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
    return 'Lagu $track sudah ada';
  }

  @override
  String get replace_downloaded_tracks => 'Ganti semua trek yang diunduh';

  @override
  String get skip_download_tracks =>
      'Lewati pengunduhan semua trek yang diunduh';

  @override
  String get do_you_want_to_replace =>
      'Apakah Anda ingin mengganti track yang ada?';

  @override
  String get replace => 'Ganti';

  @override
  String get skip => 'Lewati';

  @override
  String select_up_to_count_type(Object count, Object type) {
    return 'Pilih hingga $count $type';
  }

  @override
  String get select_genres => 'Pilih Genre';

  @override
  String get add_genres => 'Tambah Genre';

  @override
  String get country => 'Negara';

  @override
  String get number_of_tracks_generate => 'Jumlah trek yang akan dihasilkan';

  @override
  String get acousticness => 'Akustik';

  @override
  String get danceability => 'Menari';

  @override
  String get energy => 'Energi';

  @override
  String get instrumentalness => 'Instrumentalitas';

  @override
  String get liveness => 'Kehidupan';

  @override
  String get loudness => 'Kekerasan';

  @override
  String get speechiness => 'Berbicara';

  @override
  String get valence => 'Valensi';

  @override
  String get popularity => 'Popularitas';

  @override
  String get key => 'Kunci';

  @override
  String get duration => 'Durasi (s)';

  @override
  String get tempo => 'Tempo (BPM)';

  @override
  String get mode => 'Mode';

  @override
  String get time_signature => 'Tanda Tangan Waktu';

  @override
  String get short => 'Pendek';

  @override
  String get medium => 'Sedang';

  @override
  String get long => 'Panjang';

  @override
  String get min => 'Minimal';

  @override
  String get max => 'Maksimal';

  @override
  String get target => 'Target';

  @override
  String get moderate => 'Sedang';

  @override
  String get deselect_all => 'Batalkan Semua';

  @override
  String get select_all => 'Pilih Semua';

  @override
  String get are_you_sure => 'Anda yakin?';

  @override
  String get generating_playlist => 'Menghasilkan daftar putar khusus Anda...';

  @override
  String selected_count_tracks(Object count) {
    return '$count lagu yang dipilih';
  }

  @override
  String get download_warning =>
      'Jika Anda mengunduh semua Lagu secara massal, Anda jelas membajak Musik & menyebabkan kerusakan pada masyarakat kreatif Musik. Saya harap Anda menyadari hal ini. Selalu berusaha menghormati & mendukung kerja keras Artis';

  @override
  String get download_ip_ban_warning =>
      'BTW, IP Anda bisa diblokir di YouTube karena permintaan unduhan yang berlebihan dari biasanya. Blokir IP berarti Anda tidak dapat menggunakan YouTube (meskipun Anda masuk) setidaknya selama 2-3 bulan dari perangkat IP tersebut. Dan Spotube tidak bertanggung jawab jika hal ini terjadi';

  @override
  String get by_clicking_accept_terms =>
      'Dengan mengklik \'terima\' Anda menyetujui ketentuan berikut:';

  @override
  String get download_agreement_1 =>
      'Saya tahu saya membajak Musik. Saya buruk';

  @override
  String get download_agreement_2 =>
      'Saya akan mendukung Artis di mana pun saya bisa dan saya melakukan ini hanya karena saya tidak punya uang untuk membeli karya seni mereka';

  @override
  String get download_agreement_3 =>
      'Saya sepenuhnya menyadari bahwa IP saya dapat diblokir di YouTube & saya tidak menganggap Spotube atau pemilik/kontributornya bertanggung jawab atas kecelakaan apa pun yang disebabkan oleh tindakan saya saat ini';

  @override
  String get decline => 'Menolak';

  @override
  String get accept => 'Setuju';

  @override
  String get details => 'Detail';

  @override
  String get youtube => 'YouTube';

  @override
  String get channel => 'Channel';

  @override
  String get likes => 'Suka';

  @override
  String get dislikes => 'Tidak Suka';

  @override
  String get views => 'Dilihat';

  @override
  String get streamUrl => 'URL Stream';

  @override
  String get stop => 'Berhenti';

  @override
  String get sort_newest => 'Urutkan yang baru ditambah';

  @override
  String get sort_oldest => 'Urutkan yang paling lama ditambah';

  @override
  String get sleep_timer => 'Pengatur Waktu Tidur';

  @override
  String mins(Object minutes) {
    return '$minutes Menit';
  }

  @override
  String hours(Object hours) {
    return '$hours Jam';
  }

  @override
  String hour(Object hours) {
    return '$hours Jam';
  }

  @override
  String get custom_hours => 'Jam Kostum';

  @override
  String get logs => 'Log';

  @override
  String get developers => 'Pengembang';

  @override
  String get not_logged_in => 'Anda belum masuk';

  @override
  String get search_mode => 'Mode Pencarian';

  @override
  String get audio_source => 'Sumber Suara';

  @override
  String get ok => 'OK';

  @override
  String get failed_to_encrypt => 'Gagal mengenkripsi';

  @override
  String get encryption_failed_warning =>
      'Spotube menggunakan enkripsi untuk menyimpan data Anda dengan aman. Namun gagal melakukannya. Jadi itu akan kembali ke penyimpanan yang tidak aman\nJika Anda menggunakan linux, pastikan Anda telah menginstal layanan rahasia (gnome-keyring, kde-wallet, keepassxc, dll)';

  @override
  String get querying_info => 'Mencari informasi...';

  @override
  String get piped_api_down => 'Piped API tidak aktif';

  @override
  String piped_down_error_instructions(Object pipedInstance) {
    return 'Piped Instance $pipedInstance saat ini tidak aktif\n\nUbah instance atau ubah \'jenis API\' menjadi API YouTube resmi\n\nPastikan untuk memulai ulang aplikasi setelah perubahan';
  }

  @override
  String get you_are_offline => 'Anda sedang offline';

  @override
  String get connection_restored => 'Koneksi internet Anda telah pulih';

  @override
  String get use_system_title_bar => 'Gunakan bilah judul sistem';

  @override
  String get crunching_results => 'Mengolah hasil...';

  @override
  String get search_to_get_results => 'Cari untuk mendapatkan hasil';

  @override
  String get use_amoled_mode => 'Tema gelap gulita';

  @override
  String get pitch_dark_theme => 'Mode AMOLED';

  @override
  String get normalize_audio => 'Normalisasi audio';

  @override
  String get change_cover => 'Ganti sampul';

  @override
  String get add_cover => 'Tambah sampul';

  @override
  String get restore_defaults => 'Kembalikan semula';

  @override
  String get download_music_format => 'Format unduh musik';

  @override
  String get streaming_music_format => 'Format streaming musik';

  @override
  String get download_music_quality => 'Kualitas unduh musik';

  @override
  String get streaming_music_quality => 'Kualitas streaming musik';

  @override
  String get login_with_lastfm => 'Masuk dengan Last.fm';

  @override
  String get connect => 'Hubungkan';

  @override
  String get disconnect_lastfm => 'Memutuskan Last.fm';

  @override
  String get disconnect => 'Memutuskan';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get login => 'Masuk';

  @override
  String get login_with_your_lastfm => 'Masuk dengan Last.fm Anda';

  @override
  String get scrobble_to_lastfm => 'Scrobble ke Last.fm';

  @override
  String get go_to_album => 'Pergi ke Album';

  @override
  String get discord_rich_presence => 'Discord Rich Presence';

  @override
  String get browse_all => 'Lihat Semua';

  @override
  String get genres => 'Genre';

  @override
  String get explore_genres => 'Jelajahi Genre';

  @override
  String get friends => 'Daftar Teman';

  @override
  String get no_lyrics_available =>
      'Maaf, tidak dapat menemukan lirik untuk lagu ini';

  @override
  String get start_a_radio => 'Putar Radio';

  @override
  String get how_to_start_radio => 'Bagaimana Anda ingin memutar radio?';

  @override
  String get replace_queue_question =>
      'Apakah Anda ingin mengganti antrean saat ini atau menambahkannya?';

  @override
  String get endless_playback => 'Pemutaran Tanpa Akhir';

  @override
  String get delete_playlist => 'Hapus Daftar Putar';

  @override
  String get delete_playlist_confirmation =>
      'Anda yakin ingin menghapus daftar putar ini?';

  @override
  String get local_tracks => 'Trek Lokal';

  @override
  String get local_tab => 'Lokal';

  @override
  String get song_link => 'Tautan Lagu';

  @override
  String get skip_this_nonsense => 'Lewati omong kosong ini';

  @override
  String get freedom_of_music => '“Kebebasan Musik”';

  @override
  String get freedom_of_music_palm =>
      '“Kebebasan Musik di telapak tangan Anda”';

  @override
  String get get_started => 'Mari kita mulai';

  @override
  String get youtube_source_description =>
      'Direkomendasikan dan berfungsi paling baik.';

  @override
  String get piped_source_description =>
      'Merasa bebas? Sama seperti YouTube tetapi banyak yang gratis.';

  @override
  String get jiosaavn_source_description =>
      'Terbaik untuk wilayah Asia Selatan.';

  @override
  String get invidious_source_description =>
      'Similar to Piped but with higher availability.';

  @override
  String highest_quality(Object quality) {
    return 'Kualitas Terbaik: $quality';
  }

  @override
  String get select_audio_source => 'Pilih Sumber Suara';

  @override
  String get endless_playback_description =>
      'Tambahkan lagu baru secara otomatis\nke akhir antrean';

  @override
  String get choose_your_region => 'Pilih wilayah Anda';

  @override
  String get choose_your_region_description =>
      'Ini akan membantu Spotube menampilkan konten yang tepat\nuntuk lokasi Anda.';

  @override
  String get choose_your_language => 'Pilih bahasa Anda';

  @override
  String get help_project_grow => 'Bantu proyek ini berkembang';

  @override
  String get help_project_grow_description =>
      'Spotube adalah proyek sumber terbuka. Anda dapat membantu proyek ini berkembang dengan berkontribusi pada proyek, melaporkan bug, atau menyarankan fitur baru.';

  @override
  String get contribute_on_github => 'Berkontribusi di GitHub';

  @override
  String get donate_on_open_collective => 'Donasi di Open Collective';

  @override
  String get browse_anonymously => 'Jelajahi Secara Anonim';

  @override
  String get enable_connect => 'Aktifkan Hubungkan';

  @override
  String get enable_connect_description =>
      'Kontrol Spotube dari perangkat lain';

  @override
  String get devices => 'Perangkat';

  @override
  String get select => 'Pilih';

  @override
  String connect_client_alert(Object client) {
    return 'Anda dikendalikan oleh $client';
  }

  @override
  String get this_device => 'Perangkat Ini';

  @override
  String get remote => 'Remot';

  @override
  String get stats => 'Statistik';

  @override
  String and_n_more(Object count) {
    return 'dan $count lainnya';
  }

  @override
  String get recently_played => 'Baru saja diputar';

  @override
  String get browse_more => 'Telusuri lebih banyak';

  @override
  String get no_title => 'Tanpa judul';

  @override
  String get not_playing => 'Tidak diputar';

  @override
  String get epic_failure => 'Kegagalan epik!';

  @override
  String added_num_tracks_to_queue(Object tracks_length) {
    return 'Menambahkan $tracks_length trek ke antrean';
  }

  @override
  String get spotube_has_an_update => 'Spotube memiliki pembaruan';

  @override
  String get download_now => 'Unduh sekarang';

  @override
  String nightly_version(Object nightlyBuildNum) {
    return 'Spotube Nightly $nightlyBuildNum telah dirilis';
  }

  @override
  String release_version(Object version) {
    return 'Spotube v$version telah dirilis';
  }

  @override
  String get read_the_latest => 'Baca yang terbaru ';

  @override
  String get release_notes => 'catatan rilis';

  @override
  String get pick_color_scheme => 'Pilih skema warna';

  @override
  String get save => 'Simpan';

  @override
  String get choose_the_device => 'Pilih perangkat:';

  @override
  String get multiple_device_connected =>
      'Beberapa perangkat terhubung.\nPilih perangkat tempat Anda ingin melakukan tindakan ini';

  @override
  String get nothing_found => 'Tidak ditemukan apa pun';

  @override
  String get the_box_is_empty => 'Kotak kosong';

  @override
  String get top_artists => 'Artis Teratas';

  @override
  String get top_albums => 'Album Teratas';

  @override
  String get this_week => 'Minggu ini';

  @override
  String get this_month => 'Bulan ini';

  @override
  String get last_6_months => '6 bulan terakhir';

  @override
  String get this_year => 'Tahun ini';

  @override
  String get last_2_years => '2 tahun terakhir';

  @override
  String get all_time => 'Sepanjang waktu';

  @override
  String powered_by_provider(Object providerName) {
    return 'Didukung oleh $providerName';
  }

  @override
  String get email => 'Email';

  @override
  String get profile_followers => 'Pengikut';

  @override
  String get birthday => 'Ulang Tahun';

  @override
  String get subscription => 'Langganan';

  @override
  String get not_born => 'Belum lahir';

  @override
  String get hacker => 'Hacker';

  @override
  String get profile => 'Profil';

  @override
  String get no_name => 'Tanpa nama';

  @override
  String get edit => 'Edit';

  @override
  String get user_profile => 'Profil pengguna';

  @override
  String count_plays(Object count) {
    return '$count pemutaran';
  }

  @override
  String get streaming_fees_hypothetical => 'Biaya streaming (hipotetis)';

  @override
  String get minutes_listened => 'Menit didengarkan';

  @override
  String get streamed_songs => 'Lagu yang disiarkan';

  @override
  String count_streams(Object count) {
    return '$count streams';
  }

  @override
  String get owned_by_you => 'Dimiliki oleh Anda';

  @override
  String copied_shareurl_to_clipboard(Object shareUrl) {
    return '$shareUrl disalin ke clipboard';
  }

  @override
  String get hipotetical_calculation =>
      '*Ini dihitung berdasarkan pembayaran rata-rata per streaming dari platform streaming musik online sebesar \$0,003 hingga \$0,005. Ini adalah perhitungan hipotetis untuk memberikan wawasan kepada pengguna tentang seberapa banyak yang akan mereka bayarkan kepada artis jika mereka mendengarkan lagu mereka di platform streaming musik yang berbeda.';

  @override
  String count_mins(Object minutes) {
    return '$minutes menit';
  }

  @override
  String get summary_minutes => 'menit';

  @override
  String get summary_listened_to_music => 'Mendengarkan musik';

  @override
  String get summary_songs => 'lagu';

  @override
  String get summary_streamed_overall => 'Disiarkan secara keseluruhan';

  @override
  String get summary_owed_to_artists => 'Terhutang kepada artis\nBulan ini';

  @override
  String get summary_artists => 'artis';

  @override
  String get summary_music_reached_you => 'Musik mencapai Anda';

  @override
  String get summary_full_albums => 'album lengkap';

  @override
  String get summary_got_your_love => 'Mendapatkan cinta Anda';

  @override
  String get summary_playlists => 'daftar putar';

  @override
  String get summary_were_on_repeat => 'Sedang diulang';

  @override
  String total_money(Object money) {
    return 'Total $money';
  }

  @override
  String get webview_not_found => 'Webview tidak ditemukan';

  @override
  String get webview_not_found_description =>
      'Tidak ada runtime Webview yang diinstal di perangkat Anda.\nJika sudah diinstal, pastikan itu ada di environment PATH\n\nSetelah diinstal, restart aplikasi';

  @override
  String get unsupported_platform => 'Platform tidak didukung';

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
      'Default adalah -1 yang menunjukkan angka acak. Jika Anda telah mengonfigurasi firewall, disarankan untuk mengatur ini.';

  @override
  String connect_request(Object client) {
    return 'Izinkan $client untuk terhubung?';
  }

  @override
  String get connection_request_denied =>
      'Koneksi ditolak. Pengguna menolak akses.';

  @override
  String get an_error_occurred => 'Terjadi kesalahan';

  @override
  String get copy_to_clipboard => 'Salin ke papan klip';

  @override
  String get view_logs => 'Lihat log';

  @override
  String get retry => 'Coba lagi';

  @override
  String get no_default_metadata_provider_selected =>
      'Anda belum mengatur penyedia metadata default';

  @override
  String get manage_metadata_providers => 'Kelola penyedia metadata';

  @override
  String get open_link_in_browser => 'Buka Tautan di Peramban?';

  @override
  String get do_you_want_to_open_the_following_link =>
      'Apakah Anda ingin membuka tautan berikut';

  @override
  String get unsafe_url_warning =>
      'Tidak aman untuk membuka tautan dari sumber yang tidak tepercaya. Berhati-hatilah!\nAnda juga dapat menyalin tautan ke papan klip Anda.';

  @override
  String get copy_link => 'Salin Tautan';

  @override
  String get building_your_timeline =>
      'Membangun garis waktu Anda berdasarkan riwayat mendengarkan Anda...';

  @override
  String get official => 'Resmi';

  @override
  String author_name(Object author) {
    return 'Penulis: $author';
  }

  @override
  String get third_party => 'Pihak ketiga';

  @override
  String get plugin_requires_authentication => 'Plugin memerlukan otentikasi';

  @override
  String get update_available => 'Pembaruan tersedia';

  @override
  String get supports_scrobbling => 'Mendukung scrobbling';

  @override
  String get plugin_scrobbling_info =>
      'Plugin ini scrobble musik Anda untuk menghasilkan riwayat mendengarkan Anda.';

  @override
  String get default_metadata_source => 'Sumber metadata default';

  @override
  String get set_default_metadata_source => 'Atur sumber metadata default';

  @override
  String get default_audio_source => 'Sumber audio default';

  @override
  String get set_default_audio_source => 'Atur sumber audio default';

  @override
  String get set_default => 'Atur sebagai bawaan';

  @override
  String get support => 'Dukungan';

  @override
  String get support_plugin_development => 'Dukung pengembangan plugin';

  @override
  String can_access_name_api(Object name) {
    return '- Dapat mengakses API **$name**';
  }

  @override
  String get do_you_want_to_install_this_plugin =>
      'Apakah Anda ingin menginstal plugin ini?';

  @override
  String get third_party_plugin_warning =>
      'Plugin ini berasal dari repositori pihak ketiga. Pastikan Anda memercayai sumbernya sebelum menginstal.';

  @override
  String get author => 'Penulis';

  @override
  String get this_plugin_can_do_following =>
      'Plugin ini dapat melakukan hal berikut';

  @override
  String get install => 'Instal';

  @override
  String get install_a_metadata_provider => 'Instal Penyedia Metadata';

  @override
  String get no_tracks_playing => 'Tidak ada Lagu yang sedang diputar saat ini';

  @override
  String get synced_lyrics_not_available =>
      'Lirik tersinkronisasi tidak tersedia untuk lagu ini. Silakan gunakan tab';

  @override
  String get plain_lyrics => 'Lirik Polos';

  @override
  String get tab_instead => 'sebagai gantinya.';

  @override
  String get disclaimer => 'Penafian';

  @override
  String get third_party_plugin_dmca_notice =>
      'Tim Spotube tidak bertanggung jawab (termasuk hukum) atas plugin \"Pihak ketiga\" mana pun.\nSilakan gunakan dengan risiko Anda sendiri. Untuk bug/masalah apa pun, silakan laporkan ke repositori plugin.\n\nJika ada plugin \"Pihak ketiga\" yang melanggar ToS/DMCA dari layanan/entitas hukum mana pun, silakan minta penulis plugin \"Pihak ketiga\" atau platform hosting, mis. GitHub/Codeberg, untuk mengambil tindakan. Yang tercantum di atas (berlabel \"Pihak ketiga\") adalah semua plugin publik/yang dikelola oleh komunitas. Kami tidak mengkurasi mereka, jadi kami tidak dapat mengambil tindakan apa pun terhadap mereka.\n\n';

  @override
  String get input_does_not_match_format =>
      'Masukan tidak cocok dengan format yang diperlukan';

  @override
  String get plugins => 'Plugin';

  @override
  String get paste_plugin_download_url =>
      'Tempel url unduhan atau url repo GitHub/Codeberg atau tautan langsung ke file .smplug';

  @override
  String get download_and_install_plugin_from_url =>
      'Unduh dan instal plugin dari url';

  @override
  String failed_to_add_plugin_error(Object error) {
    return 'Gagal menambahkan plugin: $error';
  }

  @override
  String get upload_plugin_from_file => 'Unggah plugin dari file';

  @override
  String get installed => 'Terinstal';

  @override
  String get available_plugins => 'Plugin yang tersedia';

  @override
  String get configure_plugins =>
      'Konfigurasi plugin penyedia metadata dan sumber audio Anda sendiri';

  @override
  String get audio_scrobblers => 'Scrobblers Audio';

  @override
  String get scrobbling => 'Scrobbling';

  @override
  String get source => 'Sumber: ';

  @override
  String get uncompressed => 'Tidak terkompresi';

  @override
  String get dab_music_source_description =>
      'Untuk audiophile. Menyediakan aliran audio berkualitas tinggi/tanpa kehilangan. Pencocokkan trek yang akurat berdasarkan ISRC.';
}
