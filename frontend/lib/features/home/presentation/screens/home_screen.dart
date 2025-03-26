import 'package:flutter/material.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    authProvider.getCurrentUser();
    final user = authProvider.currentUser;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
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
            const SizedBox(height: 20),
            Text(
              'Email: ${user?.email ?? ''}',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 40),
            // Add your expense tracking widgets here
            const Expanded(
              child: Center(
                child: Text('Your expenses will appear here'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add expense functionality
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
