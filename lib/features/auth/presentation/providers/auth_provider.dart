import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/mock_auth_repository.dart';

// Provides the authentication repository throughout the application.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});