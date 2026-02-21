import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/app_providers.dart';
import '../../presentation/views/auth_view.dart';
import '../../presentation/views/main_shell_view.dart';
import 'app_navigator.dart';

/// Root widget: single Navigator with no named routes so browser path stays hidden.
/// Initial page is chosen by auth state: Auth | Home. Admin uses upload icon in header.
class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Navigator(
      key: appNavigatorKey,
      onGenerateInitialRoutes: (NavigatorState navigator, String initialRoute) {
        return [
          MaterialPageRoute<void>(
            builder: (_) => Consumer(
              builder: (_, ref, __) {
                final authAsync = ref.watch(authStateProvider);
                return authAsync.when(
                  data: (user) {
                    if (user == null) return const AuthView();
                    return const MainShellView();
                  },
                  loading: () => const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => const AuthView(),
                );
              },
            ),
          ),
        ];
      },
    );
  }
}
