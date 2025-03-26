import 'package:frontend/core/network/api_service.dart';
import 'package:frontend/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';

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
