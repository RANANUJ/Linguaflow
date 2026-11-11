import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/api_auth_repository.dart';
import '../../data/repositories/auth_repository.dart';

// Provides the API authentication repository throughout the application.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return ApiAuthRepository();
});