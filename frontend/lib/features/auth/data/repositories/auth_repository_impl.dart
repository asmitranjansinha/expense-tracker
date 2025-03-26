import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/features/auth/data/datasources/auth_remote_datasource.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../../../../core/errors/exceptions.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
  });

  @override
  Future<User> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      await _persistUserData(user);
      return user;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<User> register(String name, String email, String password) async {
    try {
      final user = await remoteDataSource.register(name, email, password);
      await _persistUserData(user);
      return user;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final token = await secureStorage.read(key: 'auth_token');
      return token != null && token.isNotEmpty;
    } catch (e) {
      throw CacheException(message: 'Could not verify authentication status');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await Future.wait([
        secureStorage.delete(key: 'auth_token'),
        secureStorage.delete(key: 'user_id'),
        secureStorage.delete(key: 'user_email'),
        secureStorage.delete(key: 'user_name'),
      ]);
    } catch (e) {
      throw CacheException(message: 'Could not perform logout');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final token = await secureStorage.read(key: 'auth_token');
      if (token == null) return null;

      return User(
        id: await secureStorage.read(key: 'user_id') ?? '',
        name: await secureStorage.read(key: 'user_name') ?? '',
        email: await secureStorage.read(key: 'user_email') ?? '',
        token: token,
      );
    } catch (e) {
      throw CacheException(message: 'Could not retrieve user data');
    }
  }

  Future<void> _persistUserData(User user) async {
    try {
      await Future.wait([
        secureStorage.write(key: 'auth_token', value: user.token),
        secureStorage.write(key: 'user_id', value: user.id),
        secureStorage.write(key: 'user_email', value: user.email),
        secureStorage.write(key: 'user_name', value: user.name),
      ]);
    } catch (e) {
      throw CacheException(message: 'Could not persist user data');
    }
  }
}
