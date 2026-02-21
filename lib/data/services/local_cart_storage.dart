import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/cart_item.dart';

const String _keyCart = 'cart';

/// Local storage for cart - persists to SharedPreferences
class LocalCartStorage {
  LocalCartStorage({SharedPreferences? prefs}) : _prefs = prefs;

  SharedPreferences? _prefs;
  SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError('LocalCartStorage not initialized. Call init() first.');
    }
    return _prefs!;
  }

  /// Call this before using (e.g. in main or provider)
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<List<CartItem>> loadCart() async {
    await init();
    final jsonStr = prefs.getString(_keyCart);
    if (jsonStr == null) return [];

    try {
      final list = jsonDecode(jsonStr) as List<dynamic>? ?? [];
      return list
          .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveCart(List<CartItem> items) async {
    await init();
    final jsonStr = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_keyCart, jsonStr);
  }
}
