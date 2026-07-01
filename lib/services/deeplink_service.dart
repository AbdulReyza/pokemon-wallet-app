import 'dart:async';

import 'package:app_links/app_links.dart';

class DeepLinkService {
  DeepLinkService._();

  // Singleton agar service dapat digunakan di seluruh aplikasi
  static final DeepLinkService instance = DeepLinkService._();

  // Instance AppLinks untuk menangani Deep Link
  final AppLinks _appLinks = AppLinks();

  StreamSubscription<Uri>? _subscription;

  // Stream untuk mengirim event Deep Link ke halaman yang membutuhkan
  final StreamController<Uri> _controller = StreamController<Uri>.broadcast();

  Uri? _lastUri;

  Stream<Uri> get stream => _controller.stream;

  // Menyimpan Deep Link terakhir yang diterima
  Uri? get lastUri => _lastUri;

  // Inisialisasi listener Deep Link
  Future<void> init() async {
    // Menangani Deep Link saat aplikasi pertama kali dibuka (Cold Start)
    final initial = await _appLinks.getInitialLink();

    if (initial != null) {
      _lastUri = initial;
      _controller.add(initial);
    }

    // Mendengarkan Deep Link ketika aplikasi sedang berjalan
    _subscription = _appLinks.uriLinkStream.listen((uri) {
      _lastUri = uri;
      _controller.add(uri);
    });
  }

  // Menghapus data Deep Link terakhir setelah diproses
  void clearLastUri() {
    _lastUri = null;
  }

  // Membersihkan listener dan stream saat aplikasi ditutup
  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
