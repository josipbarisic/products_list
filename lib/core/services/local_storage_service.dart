import 'dart:convert';
import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static const String _productsBoxName = 'products_box';
  static const String _productsKey = 'products_data';
  static const String _productsCacheTimestampKey = 'products_cache_timestamp';

  // Cache duration - 24 hours
  static const Duration _cacheDuration = Duration(hours: 24);

  static LocalStorageService? _instance;
  late Box _productsBox;

  // Private constructor
  LocalStorageService._();

  // Singleton factory
  static LocalStorageService getInstance() {
    _instance ??= LocalStorageService._();
    return _instance!;
  }

  // Save products to local storage
  Future<void> saveProducts(List<Map<String, dynamic>> products) async {
    try {
      _productsBox = await Hive.openBox(_productsBoxName);

      final jsonData = jsonEncode(products);
      await _productsBox.put(_productsKey, jsonData);
      await _productsBox.put(_productsCacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
      log('Products saved to local storage');
    } catch (e) {
      log('Error saving products to local storage: $e');
      rethrow;
    }
  }

  // Retrieve products from local storage
  Future<List<Map<String, dynamic>>?> getProducts() async {
    try {
      _productsBox = await Hive.openBox(_productsBoxName);

      final jsonData = _productsBox.get(_productsKey);

      if (jsonData == null) {
        log('No products found in local storage');
        return null;
      }

      // Check cache validity
      final timestamp = _productsBox.get(_productsCacheTimestampKey);
      if (timestamp != null) {
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final now = DateTime.now();

        if (now.difference(cacheTime) > _cacheDuration) {
          log('Cache expired, returning null');
          return null;
        }
      }

      final List<dynamic> decodedData = jsonDecode(jsonData);
      return decodedData.cast<Map<String, dynamic>>();
    } catch (e) {
      log('Error retrieving products from local storage: $e');
      return null;
    }
  }

  // Clear product cache
  Future<void> clearProductCache() async {
    try {
      _productsBox = await Hive.openBox(_productsBoxName);

      await _productsBox.delete(_productsKey);
      await _productsBox.delete(_productsCacheTimestampKey);
      log('Product cache cleared');
    } catch (e) {
      log('Error clearing product cache: $e');
    }
  }

  // Close hive boxes when app is closed
  Future<void> close() async {
    await _productsBox.close();
  }
}
