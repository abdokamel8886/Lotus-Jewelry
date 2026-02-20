import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../data/services/firebase_auth_manager.dart';
import '../providers/app_providers.dart';
import '../viewmodels/login_viewmodel.dart';

/// Login Page - Email/Password + Social Sign-In buttons
class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              // Logo / Title
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Email field
              TextFormField(
                initialValue: state.email,
                onChanged: viewModel.setEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: state.emailError,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),

              // Password field
              TextFormField(
                initialValue: state.password,
                onChanged: viewModel.setPassword,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: state.passwordError,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 24),

              // Login button
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () async {
                          if (!viewModel.validateForm()) return;
                          viewModel.setLoading(true);
                          final authManager = ref.read(firebaseAuthManagerProvider);
                          final result = await authManager.signInWithEmailAndPassword(
                            email: state.email,
                            password: state.password,
                          );
                          viewModel.setLoading(false);
                          if (context.mounted) {
                            switch (result) {
                              case AuthSuccess():
                                Navigator.of(context)
                                    .pushReplacementNamed(AppConstants.routeHome);
                              case AuthFailure(:final message):
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(message)),
                                );
                            }
                          }
                        },
                  child: state.isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Sign In'),
                ),
              ),
              const SizedBox(height: 24),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade400)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade400)),
                ],
              ),
              const SizedBox(height: 24),

              // Google Sign-In
              OutlinedButton.icon(
                onPressed: state.isLoading
                    ? null
                    : () async {
                        viewModel.setLoading(true);
                        final authManager = ref.read(firebaseAuthManagerProvider);
                        final result = await authManager.signInWithGoogle();
                        if (context.mounted) viewModel.setLoading(false);
                        if (context.mounted) {
                          switch (result) {
                            case AuthSuccess():
                              Navigator.of(context)
                                  .pushReplacementNamed(AppConstants.routeHome);
                            case AuthFailure(:final message):
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(message)),
                              );
                          }
                        }
                      },
                icon: const Icon(Icons.g_mobiledata, size: 28),
                label: const Text('Continue with Google'),
              ),
              const SizedBox(height: 12),

              // Facebook Sign-In
              OutlinedButton.icon(
                onPressed: state.isLoading
                    ? null
                    : () async {
                        viewModel.setLoading(true);
                        final authManager = ref.read(firebaseAuthManagerProvider);
                        final result = await authManager.signInWithFacebook();
                        if (context.mounted) viewModel.setLoading(false);
                        if (context.mounted) {
                          switch (result) {
                            case AuthSuccess():
                              Navigator.of(context)
                                  .pushReplacementNamed(AppConstants.routeHome);
                            case AuthFailure(:final message):
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(message)),
                              );
                          }
                        }
                      },
                icon: const Icon(Icons.facebook),
                label: const Text('Continue with Facebook'),
              ),
              const SizedBox(height: 32),

              // Register link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(AppConstants.routeRegister);
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
