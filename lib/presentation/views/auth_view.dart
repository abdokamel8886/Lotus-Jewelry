import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/theme/app_theme.dart';
import '../../data/services/firebase_auth_manager.dart';
import '../providers/app_providers.dart';
import '../viewmodels/login_viewmodel.dart';
import '../viewmodels/register_viewmodel.dart';
import '../widgets/app_footer.dart';
import 'main_shell_view.dart';

/// Full-screen auth: same header & footer as home, white card with Login/Register swiper (ref: BOB'S style).
class AuthView extends ConsumerStatefulWidget {
  /// Optional initial tab: 0 = Login, 1 = Register (e.g. from routeRegister)
  final int initialIndex;

  const AuthView({super.key, this.initialIndex = 0});

  @override
  ConsumerState<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends ConsumerState<AuthView> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, 1);
  }

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
      labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15),
      floatingLabelStyle: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w600),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartRepo = ref.watch(cartRepositoryProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.charcoal,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              AppConstants.logoAsset,
              height: 80,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
            const SizedBox(width: 8),
            const Text(
              AppConstants.appName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppTheme.charcoal,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_bag_outlined, color: AppTheme.charcoal),
                onPressed: () => AppNavigator.goCart(context),
              ),
              if (cartRepo.itemCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text(
                      '${cartRepo.itemCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.login, color: AppTheme.charcoal, size: 22),
                  const SizedBox(width: 6),
                  Text(
                    'Login',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.charcoal),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _AuthTabChip(
                  icon: Icons.home_outlined,
                  label: 'Home',
                  onTap: () {
                    ref.read(mainShellTabIndexProvider.notifier).state = 0;
                    AppNavigator.goHome(context);
                  },
                ),
                _AuthTabChip(
                  icon: Icons.category_outlined,
                  label: 'Categories',
                  onTap: () {
                    ref.read(mainShellTabIndexProvider.notifier).state = 1;
                    AppNavigator.goHome(context);
                  },
                ),
                _AuthTabChip(
                  icon: Icons.receipt_long_outlined,
                  label: 'Orders',
                  onTap: () {
                    ref.read(mainShellTabIndexProvider.notifier).state = 2;
                    AppNavigator.goHome(context);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(0, 64, 0, 0),
              child: Column(
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _SwiperBar(
                              selectedIndex: _selectedIndex,
                              onSelect: (i) => setState(() => _selectedIndex = i),
                            ),
                            const SizedBox(height: 28),
                            _selectedIndex == 0
                                ? _LoginForm(
                                    inputDecoration: _inputDecoration,
                                    onSuccess: () => AppNavigator.goHome(context),
                                  )
                                : _RegisterForm(
                                    inputDecoration: _inputDecoration,
                                    onSuccess: () => AppNavigator.goHome(context),
                                  ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _selectedIndex == 0 ? "Don't have an account? " : 'Already have an account? ',
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                                ),
                                TextButton(
                                  onPressed: () => setState(() => _selectedIndex = 1 - _selectedIndex),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppTheme.gold,
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                  ),
                                  child: Text(
                                    _selectedIndex == 0 ? 'Create one' : 'Sign In',
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  const AppFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthTabChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AuthTabChip({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
          /*  Icon(icon, size: 20, color: Colors.grey.shade600),
            const SizedBox(width: 8),*/
            Text(
              label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

/// Swiper: Login | Sign Up — connected, rounded pill style
class _SwiperBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _SwiperBar({required this.selectedIndex, required this.onSelect});

  static const _radius = 20.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(_radius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            child: _SwiperTab(
              label: 'Login',
              isSelected: selectedIndex == 0,
              isLeft: true,
              radius: _radius,
              onTap: () => onSelect(0),
            ),
          ),
          Expanded(
            child: _SwiperTab(
              label: 'Sign Up',
              isSelected: selectedIndex == 1,
              isLeft: false,
              radius: _radius,
              onTap: () => onSelect(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwiperTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isLeft;
  final double radius;
  final VoidCallback onTap;

  const _SwiperTab({
    required this.label,
    required this.isSelected,
    required this.isLeft,
    required this.radius,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = isLeft
        ? BorderRadius.only(topLeft: Radius.circular(radius), bottomLeft: Radius.circular(radius))
        : BorderRadius.only(topRight: Radius.circular(radius), bottomRight: Radius.circular(radius));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: isSelected ? AppTheme.charcoal : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppTheme.gold : AppTheme.charcoal,
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends ConsumerWidget {
  final InputDecoration Function({
    required String label,
    String? error,
    required IconData icon,
  }) inputDecoration;
  final VoidCallback onSuccess;

  const _LoginForm({
    required this.inputDecoration,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);
    final authManager = ref.read(firebaseAuthManagerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Welcome back',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.charcoal,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to continue',
          style: TextStyle(
            color: AppTheme.charcoal.withOpacity(0.6),
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 24),
        TextFormField(
          initialValue: state.email,
          onChanged: viewModel.setEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: inputDecoration(
            label: 'Email Address',
            error: state.emailError,
            icon: Icons.email_outlined,
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          initialValue: state.password,
          onChanged: viewModel.setPassword,
          obscureText: true,
          decoration: inputDecoration(
            label: 'Password',
            error: state.passwordError,
            icon: Icons.lock_outline,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 54,
          child: ElevatedButton(
            onPressed: state.isLoading
                ? null
                : () async {
                    if (!viewModel.validateForm()) return;
                    viewModel.setLoading(true);
                    final result = await authManager.signInWithEmailAndPassword(
                      email: state.email,
                      password: state.password,
                    );
                    if (context.mounted) viewModel.setLoading(false);
                    if (context.mounted) {
                      switch (result) {
                        case AuthSuccess():
                          onSuccess();
                        case AuthFailure(:final message):
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
                          );
                      }
                    }
                  },
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
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Login'),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password reset coming soon'), behavior: SnackBarBehavior.floating),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue.shade700,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Forgot Your Password?'),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade400)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Login with',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey.shade400)),
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
                      : () async {
                          viewModel.setLoading(true);
                          final result = await authManager.signInWithGoogle();
                          if (context.mounted) viewModel.setLoading(false);
                          if (context.mounted) {
                            switch (result) {
                              case AuthSuccess():
                                onSuccess();
                              case AuthFailure(:final message):
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
                                );
                            }
                          }
                        },
                  icon: const Icon(Icons.g_mobiledata, size: 22),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.gold.withOpacity(0.5)),
                    foregroundColor: AppTheme.charcoal,
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
                      : () async {
                          viewModel.setLoading(true);
                          final result = await authManager.signInWithFacebook();
                          if (context.mounted) viewModel.setLoading(false);
                          if (context.mounted) {
                            switch (result) {
                              case AuthSuccess():
                                onSuccess();
                              case AuthFailure(:final message):
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
                                );
                            }
                          }
                        },
                  icon: const Icon(Icons.facebook, color: Colors.blue, size: 22),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.gold.withOpacity(0.5)),
                    foregroundColor: AppTheme.charcoal,
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
    );
  }
}

class _RegisterForm extends ConsumerWidget {
  final InputDecoration Function({
    required String label,
    String? error,
    required IconData icon,
  }) inputDecoration;
  final VoidCallback onSuccess;

  const _RegisterForm({
    required this.inputDecoration,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerViewModelProvider);
    final viewModel = ref.read(registerViewModelProvider.notifier);
    final authManager = ref.read(firebaseAuthManagerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Join us',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.charcoal,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create an account to start shopping',
          style: TextStyle(
            color: AppTheme.charcoal.withOpacity(0.6),
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 24),
        TextFormField(
          initialValue: state.name,
          onChanged: viewModel.setName,
          decoration: inputDecoration(
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
          decoration: inputDecoration(
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
          decoration: inputDecoration(
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
          decoration: inputDecoration(
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
                : () async {
                    if (!viewModel.validateForm()) return;
                    viewModel.setLoading(true);
                    final result = await authManager.signUpWithEmailAndPassword(
                      email: state.email,
                      password: state.password,
                      displayName: state.name,
                    );
                    if (context.mounted) viewModel.setLoading(false);
                    if (context.mounted) {
                      switch (result) {
                        case AuthSuccess():
                          onSuccess();
                        case AuthFailure(:final message):
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
                          );
                      }
                    }
                  },
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
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Create Account'),
          ),
        ),
      ],
    );
  }
}
