import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/firebase_auth_manager.dart';
import '../providers/app_providers.dart';
import '../viewmodels/register_viewmodel.dart';

/// Register — premium auth layout matching login (card, gradient, refined inputs)
class RegisterView extends ConsumerWidget {
  const RegisterView({super.key});

  static InputDecoration _inputDecoration({
    required String label,
    String? error,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      errorText: error,
      prefixIcon: Icon(icon, size: 22, color: AppTheme.gold),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppTheme.gold, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      labelStyle: TextStyle(color: Colors.grey.shade600),
      floatingLabelStyle: const TextStyle(color: AppTheme.gold),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerViewModelProvider);
    final viewModel = ref.read(registerViewModelProvider.notifier);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.offWhite,
              Colors.white,
              AppTheme.goldLight.withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar style: back + title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.8),
                        foregroundColor: AppTheme.charcoal,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.charcoal,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                          Material(
                            elevation: 0,
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.white,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.grey.shade200),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Join us',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.charcoal,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Create an account to start shopping',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  TextFormField(
                                    initialValue: state.name,
                                    onChanged: viewModel.setName,
                                    decoration: _inputDecoration(
                                      label: 'Full Name',
                                      error: state.nameError,
                                      icon: Icons.person_outline,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    initialValue: state.email,
                                    onChanged: viewModel.setEmail,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: _inputDecoration(
                                      label: 'Email',
                                      error: state.emailError,
                                      icon: Icons.email_outlined,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    initialValue: state.password,
                                    onChanged: viewModel.setPassword,
                                    obscureText: true,
                                    decoration: _inputDecoration(
                                      label: 'Password',
                                      error: state.passwordError,
                                      icon: Icons.lock_outline,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    initialValue: state.confirmPassword,
                                    onChanged: viewModel.setConfirmPassword,
                                    obscureText: true,
                                    decoration: _inputDecoration(
                                      label: 'Confirm Password',
                                      error: state.confirmPasswordError,
                                      icon: Icons.lock_outline,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    height: 54,
                                    child: ElevatedButton(
                                      onPressed: state.isLoading
                                          ? null
                                          : () => _handleRegister(context, ref, viewModel),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.charcoal,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                      ),
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
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 15,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppTheme.gold,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                ),
                                child: const Text('Sign In'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister(
    BuildContext context,
    WidgetRef ref,
    dynamic viewModel,
  ) async {
    if (!viewModel.validateForm()) return;
    viewModel.setLoading(true);
    final authManager = ref.read(firebaseAuthManagerProvider);
    final state = ref.read(registerViewModelProvider);
    final result = await authManager.signUpWithEmailAndPassword(
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
  }
}
