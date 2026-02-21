import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/// Entry point - Gold Jewelry E-commerce App
/// Uses Clean Architecture + MVVM + Riverpod
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    // ProviderScope enables Riverpod state management
    const ProviderScope(
      child: GoldApp(),
    ),
  );
}

class GoldApp extends StatelessWidget {
  const GoldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      // Initial route - use routeAdmin for admin, routeHome for shop, routeLogin for auth
      initialRoute: AppConstants.routeAdmin,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}