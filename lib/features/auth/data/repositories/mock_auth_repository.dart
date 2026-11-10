import '../../domain/models/user_model.dart';
import 'auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  UserModel? _currentUser;

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // Simulate a short network request.
    await Future.delayed(const Duration(seconds: 1));

    // Create a new user.
    final user = UserModel(
      name: name,
      email: email,
    );

    // Save the user temporarily in memory.
    _currentUser = user;

    return user;
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Simulate a short network request.
    await Future.delayed(const Duration(seconds: 1));

    // For temporary testing, create a user from the email.
    final user = UserModel(
      name: 'User',
      email: email,
    );

    // Save the logged-in user temporarily.
    _currentUser = user;

    return user;
  }

  @override
  Future<void> logout() async {
    // Remove the user from memory.
    _currentUser = null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return _currentUser;
  }
}