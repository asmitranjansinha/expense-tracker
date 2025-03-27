import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:provider/provider.dart';
import 'core/network/api_service.dart';
import 'core/routes/app_router.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/domain/usecases/register_user.dart';
import 'features/auth/domain/usecases/is_authenticated.dart';
import 'features/auth/domain/usecases/logout_user.dart';
import 'features/auth/domain/usecases/get_current_user.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Core dependencies
        Provider<ApiService>(
          create: (_) => ApiService(baseUrl: 'http://localhost:3000/api'),
        ),
        Provider<FlutterSecureStorage>(
          create: (_) => const FlutterSecureStorage(),
        ),

        // Auth feature dependencies
        Provider<AuthRemoteDataSource>(
          create: (ctx) => AuthRemoteDataSourceImpl(
            apiService: ctx.read<ApiService>(),
          ),
        ),
        Provider<AuthRepositoryImpl>(
          create: (ctx) => AuthRepositoryImpl(
            remoteDataSource: ctx.read<AuthRemoteDataSource>(),
            secureStorage: ctx.read<FlutterSecureStorage>(),
          ),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (ctx) => AuthProvider(
            loginUser: LoginUser(repository: ctx.read<AuthRepositoryImpl>()),
            registerUser:
                RegisterUser(repository: ctx.read<AuthRepositoryImpl>()),
            isAuthenticated:
                IsAuthenticated(repository: ctx.read<AuthRepositoryImpl>()),
            logoutUser: LogoutUser(repository: ctx.read<AuthRepositoryImpl>()),
            getCurrentUser:
                GetCurrentUser(repository: ctx.read<AuthRepositoryImpl>()),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracker',
        theme: ThemeData(primarySwatch: Colors.blue),
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: '/',
      ),
    );
  }
}
