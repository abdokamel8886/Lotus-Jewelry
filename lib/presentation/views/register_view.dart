import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/firebase_auth_manager.dart';
import '../providers/app_providers.dart';
import '../viewmodels/register_viewmodel.dart';

/// Register - premium auth layout
class RegisterView extends ConsumerWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerViewModelProvider);
    final viewModel = ref.read(registerViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.charcoal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset(
                  AppConstants.logoAsset,
                  height: 56,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.diamond,
                    size: 48,
                    color: AppTheme.gold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Join us',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create an account to start shopping',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 40),
              TextFormField(
                initialValue: state.name,
                onChanged: viewModel.setName,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  errorText: state.nameError,
                  prefixIcon: Icon(Icons.person_outline, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              TextFormField(
                initialValue: state.confirmPassword,
                onChanged: viewModel.setConfirmPassword,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  errorText: state.confirmPasswordError,
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 36),
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () async {
                          if (!viewModel.validateForm()) return;
                          viewModel.setLoading(true);
                          final authManager = ref.read(firebaseAuthManagerProvider);
                          final result =
                              await authManager.signUpWithEmailAndPassword(
                            email: state.email,
                            password: state.password,
                            displayName: state.name,
                          );
                          if (context.mounted) viewModel.setLoading(false);
                          if (context.mounted) {
                            switch (result) {
                              case AuthSuccess():
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  AppConstants.routeHome,
                                  (route) => false,
                                );
                              case AuthFailure(:final message):
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(message),
                                    behavior: SnackBarBehavior.floating,
                                  ),
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
                      : const Text('Create Account'),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Sign In'),
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
