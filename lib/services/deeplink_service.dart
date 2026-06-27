import 'dart:async';

import 'package:app_links/app_links.dart';

class DeepLinkService {
  DeepLinkService._();

  static final DeepLinkService instance = DeepLinkService._();

  final AppLinks _appLinks = AppLinks();

  StreamSubscription<Uri>? _subscription;

  final StreamController<Uri> _controller = StreamController<Uri>.broadcast();

  Uri? _lastUri;

  Stream<Uri> get stream => _controller.stream;

  Uri? get lastUri => _lastUri;

  Future<void> init() async {
    // Cold Start
    final initial = await _appLinks.getInitialLink();

    if (initial != null) {
      _lastUri = initial;
      _controller.add(initial);
    }

    // App sudah hidup
    _subscription = _appLinks.uriLinkStream.listen((uri) {
      _lastUri = uri;
      _controller.add(uri);
    });
  }

  void clearLastUri() {
    _lastUri = null;
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
