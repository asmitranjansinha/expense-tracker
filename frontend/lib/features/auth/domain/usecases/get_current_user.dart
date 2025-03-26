import '../repositories/auth_repository.dart';
import '../entities/user.dart';

class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser({required this.repository});

  Future<User?> call() async {
    return await repository.getCurrentUser();
  }
}
