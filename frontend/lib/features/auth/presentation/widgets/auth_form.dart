import 'package:flutter/material.dart';

class AuthForm extends StatelessWidget {
  final TextEditingController? nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final String? error;
  final Function(String, String) onSubmit;
  final bool isLogin;

  const AuthForm({
    super.key,
    this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.error,
    required this.onSubmit,
    this.isLogin = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Column(
        children: [
          if (!isLogin)
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                if (value.length < 3) {
                  return 'Name must be at least 3 characters';
                }
                return null;
              },
            ),
          if (!isLogin) const SizedBox(height: 16),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          if (error != null) ...[
            const SizedBox(height: 16),
            Text(
              error!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      if (formKey.currentState!.validate()) {
                        onSubmit(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                      }
                    },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Text(isLogin ? 'Login' : 'Register'),
            ),
          ),
        ],
      ),
    );
  }
}
