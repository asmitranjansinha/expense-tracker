import '../repositories/auth_repository.dart';
import '../entities/user.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser({required this.repository});

  Future<User> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
