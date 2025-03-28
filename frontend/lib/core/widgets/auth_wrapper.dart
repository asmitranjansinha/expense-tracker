import 'package:flutter/material.dart';
import 'package:frontend/features/auth/presentation/screens/login_screen.dart';
import 'package:frontend/features/expense/presentation/providers/expense_provider.dart';
import 'package:frontend/features/expense/presentation/screens/activity_screen.dart';
import 'package:provider/provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);
    return FutureBuilder<bool>(
      future: authProvider.checkAuthentication(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final isAuthenticated = snapshot.data ?? false;
        if (isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            expenseProvider.loadExpenses();
          });
        }
        return isAuthenticated ? const ActivityScreen() : const LoginScreen();
      },
    );
  }
}
