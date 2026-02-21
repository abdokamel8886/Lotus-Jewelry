import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../providers/app_providers.dart';
import 'home_tab_content.dart';
import 'categories_tab_content.dart';
import 'orders_tab_content.dart';

/// Main shell: header (logo, tabs Home/Categories/Orders, search/cart) + auth: Login (drawer) or Welcome + Logout
class MainShellView extends ConsumerStatefulWidget {
  const MainShellView({super.key});

  @override
  ConsumerState<MainShellView> createState() => _MainShellViewState();
}

final mainShellTabIndexProvider = StateProvider<int>((ref) => 0);

class _MainShellViewState extends ConsumerState<MainShellView> {
  @override
  Widget build(BuildContext context) {
    final cartRepo = ref.watch(cartRepositoryProvider);
    final selectedIndex = ref.watch(mainShellTabIndexProvider);
    final authAsync = ref.watch(authStateProvider);
    final user = authAsync.valueOrNull;

    return Scaffold(
      backgroundColor: AppTheme.offWhite,
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
              height: 48,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                AppConstants.appName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.charcoal,
                  letterSpacing: -0.5,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
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
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppConstants.routeCart),
              ),
              if (cartRepo.itemCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cartRepo.itemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (user != null)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 130),
                    child: Text(
                      'Welcome, ${user.displayName?.isNotEmpty == true ? user.displayName : user.email?.split('@').first ?? 'User'}',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.charcoal,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.logout, color: AppTheme.charcoal, size: 22),
                    tooltip: 'Logout',
                    onPressed: () async {
                      await ref.read(firebaseAuthManagerProvider).signOut();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.charcoal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            InkWell(
              onTap: () => Navigator.of(context).pushNamed(AppConstants.routeLogin),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.login, color: AppTheme.charcoal, size: 22),
                    const SizedBox(width: 6),
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.charcoal,
                      ),
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
                _TabChip(
                  icon: Icons.home_outlined,
                  label: 'Home',
                  isSelected: selectedIndex == 0,
                  onTap: () => ref.read(mainShellTabIndexProvider.notifier).state = 0,
                ),
                _TabChip(
                  icon: Icons.category_outlined,
                  label: 'Categories',
                  isSelected: selectedIndex == 1,
                  onTap: () => ref.read(mainShellTabIndexProvider.notifier).state = 1,
                ),
                _TabChip(
                  icon: Icons.receipt_long_outlined,
                  label: 'Orders',
                  isSelected: selectedIndex == 2,
                  onTap: () => ref.read(mainShellTabIndexProvider.notifier).state = 2,
                ),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: const [
          HomeTabContent(),
          CategoriesTabContent(),
          OrdersTabContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
/*            Icon(
              icon,
              size: 20,
              color: isSelected ? AppTheme.charcoal : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),*/
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppTheme.charcoal : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
