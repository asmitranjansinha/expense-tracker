import 'package:flutter/material.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/is_authenticated.dart';
import '../../domain/usecases/logout_user.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/entities/user.dart';

class AuthProvider with ChangeNotifier {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final IsAuthenticated isAuthenticated;
  final LogoutUser logoutUser;
  final GetCurrentUser getCurrentUser;

  AuthProvider({
    required this.loginUser,
    required this.registerUser,
    required this.isAuthenticated,
    required this.logoutUser,
    required this.getCurrentUser,
  });

  bool _isLoading = false;
  String? _error;
  User? _currentUser;

  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get currentUser => _currentUser;

  Future<bool> checkAuthentication() async {
    try {
      final authenticated = await isAuthenticated.call();
      if (authenticated) {
        // Use post-frame callback to safely update state
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          _currentUser = await getCurrentUser.call();
          _error = null;
          notifyListeners();
        });
      }
      return authenticated;
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _error = e.toString();
        notifyListeners();
      });
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await loginUser(email, password);
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await registerUser(name, email, password);
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await logoutUser();
      _currentUser = null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
