import '../repositories/auth_repository.dart';
import '../entities/user.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser({required this.repository});

  Future<User> call(String name, String email, String password) async {
    // Validate input parameters
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      throw ArgumentError('All fields are required');
    }

    if (password.length < 6) {
      throw ArgumentError('Password must be at least 6 characters');
    }

    // Additional email validation can be added here
    if (!email.contains('@')) {
      throw ArgumentError('Please enter a valid email');
    }

    return await repository.register(name, email, password);
  }
}
