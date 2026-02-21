import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../providers/app_providers.dart';
import 'home_tab_content.dart';
import 'categories_tab_content.dart';
import 'orders_tab_content.dart';

/// Main shell: header (logo, tabs Home/Categories/Orders, search/cart/profile) + body
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

    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.charcoal,
        elevation: 0,
        title: Text(
          'Jewellery',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppTheme.charcoal,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppTheme.charcoal),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Search coming soon'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
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
          IconButton(
            icon: Icon(Icons.person_outline, color: AppTheme.charcoal),
            onPressed: () {
              final user = ref.read(firebaseAuthManagerProvider).currentUser;
              Navigator.of(context).pushNamed(
                user != null ? AppConstants.routeProfile : AppConstants.routeLogin,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Row(
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
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppTheme.charcoal : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
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
