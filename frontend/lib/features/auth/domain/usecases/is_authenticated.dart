import '../repositories/auth_repository.dart';

class IsAuthenticated {
  final AuthRepository repository;

  IsAuthenticated({required this.repository});

  Future<bool> call() async {
    return await repository.isAuthenticated();
  }
}
