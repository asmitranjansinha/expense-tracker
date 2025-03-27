import 'package:flutter/material.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ExpenseScreen extends StatelessWidget {
  static const routeName = '/expense';

  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    authProvider.getCurrentUser();
    final user = authProvider.currentUser;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('activity'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user?.name ?? 'User'}!',
              style: theme.textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Text("No expenses recorded yet, add one to get started."),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add expense functionality
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
