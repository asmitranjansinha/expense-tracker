import '../repositories/auth_repository.dart';

class LogoutUser {
  final AuthRepository repository;

  LogoutUser({required this.repository});

  Future<void> call() async {
    await repository.logout();
  }
}
