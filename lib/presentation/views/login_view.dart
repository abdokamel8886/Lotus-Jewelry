import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/firebase_auth_manager.dart';
import '../providers/app_providers.dart';
import '../viewmodels/login_viewmodel.dart';

/// Login - premium auth layout
class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Center(
                child: Image.asset(
                  AppConstants.logoAsset,
                  height: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.diamond,
                    size: 56,
                    color: AppTheme.gold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Sign in to continue',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              TextFormField(
                initialValue: state.email,
                onChanged: viewModel.setEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: state.emailError,
                  prefixIcon: Icon(Icons.email_outlined, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: state.password,
                onChanged: viewModel.setPassword,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: state.passwordError,
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: state.isLoading ? null : () => _handleEmailLogin(context, ref, state, viewModel),
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
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'or continue with',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: state.isLoading ? null : () => _handleGoogleLogin(context, ref, viewModel),
                  icon: const Icon(Icons.g_mobiledata, size: 24),
                  label: const Text('Google'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: state.isLoading ? null : () => _handleFacebookLogin(context, ref, viewModel),
                  icon: const Icon(Icons.facebook, color: Colors.blue),
                  label: const Text('Facebook'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushReplacementNamed(AppConstants.routeRegister),
                    child: const Text('Create one'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleEmailLogin(
    BuildContext context,
    WidgetRef ref,
    dynamic state,
    dynamic viewModel,
  ) async {
    if (!viewModel.validateForm()) return;
    viewModel.setLoading(true);
    final authManager = ref.read(firebaseAuthManagerProvider);
    final result = await authManager.signInWithEmailAndPassword(
      email: state.email,
      password: state.password,
    );
    if (context.mounted) viewModel.setLoading(false);
    if (context.mounted) {
      switch (result) {
        case AuthSuccess():
          Navigator.of(context).pushReplacementNamed(AppConstants.routeHome);
        case AuthFailure(:final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
          );
      }
    }
  }

  Future<void> _handleGoogleLogin(
    BuildContext context,
    WidgetRef ref,
    dynamic viewModel,
  ) async {
    viewModel.setLoading(true);
    final authManager = ref.read(firebaseAuthManagerProvider);
    final result = await authManager.signInWithGoogle();
    if (context.mounted) viewModel.setLoading(false);
    if (context.mounted) {
      switch (result) {
        case AuthSuccess():
          Navigator.of(context).pushReplacementNamed(AppConstants.routeHome);
        case AuthFailure(:final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
          );
      }
    }
  }

  Future<void> _handleFacebookLogin(
    BuildContext context,
    WidgetRef ref,
    dynamic viewModel,
  ) async {
    viewModel.setLoading(true);
    final authManager = ref.read(firebaseAuthManagerProvider);
    final result = await authManager.signInWithFacebook();
    if (context.mounted) viewModel.setLoading(false);
    if (context.mounted) {
      switch (result) {
        case AuthSuccess():
          Navigator.of(context).pushReplacementNamed(AppConstants.routeHome);
        case AuthFailure(:final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
          );
      }
    }
  }
}
