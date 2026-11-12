
import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    // Flutter Web running in Chrome.
    if (kIsWeb) {
      return 'http://localhost:3000';
    }

    // Flutter running on a physical Android phone.
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.125.91.249:3000';
    }

    // Other platforms.
    return 'http://localhost:3000';
  }
}
