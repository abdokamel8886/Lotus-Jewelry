import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/firebase_auth_manager.dart';
import '../providers/app_providers.dart';
import '../viewmodels/login_viewmodel.dart';
import 'auth_view.dart';

/// Login — premium auth layout with card, refined inputs, and social options
class LoginView extends ConsumerWidget {
  const LoginView({super.key});

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
    final state = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);

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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo
                    Center(
                      child: Image.asset(
                        AppConstants.logoAsset,
                        height: 72,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.diamond,
                          size: 56,
                          color: AppTheme.gold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Card
                    Material(
                      elevation: 0,
                      shadowColor: Colors.black.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
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
                              'Welcome back',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.charcoal,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Sign in to continue to your account',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 28),
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
                            const SizedBox(height: 20),
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
                            const SizedBox(height: 28),
                            SizedBox(
                              height: 54,
                              child: ElevatedButton(
                                onPressed: state.isLoading
                                    ? null
                                    : () => _handleEmailLogin(context, ref, state, viewModel),
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
                                    : const Text('Sign In'),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(child: Divider(color: Colors.grey.shade300)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    'or continue with',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Expanded(child: Divider(color: Colors.grey.shade300)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 50,
                                    child: OutlinedButton.icon(
                                      onPressed: state.isLoading
                                          ? null
                                          : () => _handleGoogleLogin(context, ref, viewModel),
                                      icon: const Icon(Icons.g_mobiledata, size: 22),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Colors.grey.shade300),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      label: const Text('Google'),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: SizedBox(
                                    height: 50,
                                    child: OutlinedButton.icon(
                                      onPressed: state.isLoading
                                          ? null
                                          : () => _handleFacebookLogin(context, ref, viewModel),
                                      icon: const Icon(Icons.facebook, color: Colors.blue, size: 22),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Colors.grey.shade300),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      label: const Text('Facebook'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const AuthView(initialIndex: 1)),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.gold,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          child: const Text('Create one'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
        case AuthSuccess(:final user):
          if (user?.email?.trim().toLowerCase() == AppConstants.adminEmail.toLowerCase()) {
            AppNavigator.replaceWithAdmin(context);
          } else {
            AppNavigator.replaceWithHome(context);
          }
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
        case AuthSuccess(:final user):
          if (user?.email?.trim().toLowerCase() == AppConstants.adminEmail.toLowerCase()) {
            AppNavigator.replaceWithAdmin(context);
          } else {
            AppNavigator.replaceWithHome(context);
          }
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
        case AuthSuccess(:final user):
          if (user?.email?.trim().toLowerCase() == AppConstants.adminEmail.toLowerCase()) {
            AppNavigator.replaceWithAdmin(context);
          } else {
            AppNavigator.replaceWithHome(context);
          }
        case AuthFailure(:final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
          );
      }
    }
  }
}
