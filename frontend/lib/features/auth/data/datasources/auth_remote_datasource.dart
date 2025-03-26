import '../../../../core/network/api_service.dart';
import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(String email, String password);
  Future<User> register(String name, String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<User> login(String email, String password) async {
    final response = await apiService.post('auth/login', {
      'email': email,
      'password': password,
    });
    return User.fromJson(response);
  }

  @override
  Future<User> register(String name, String email, String password) async {
    final response = await apiService.post('auth/register', {
      'name': name,
      'email': email,
      'password': password,
    });
    return User.fromJson(response);
  }
}
