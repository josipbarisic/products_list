import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_list/core/services/local_storage/local_storage_service.dart';
import 'package:product_list/data/models/product/product_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'products_repository.g.dart';

/// ------------------------ PRODUCTS REPOSITORY PROVIDER ------------------------
@Riverpod(keepAlive: true)
ProductsRepository productsRepository(Ref ref) {
  final localStorageService = ref.read(localStorageServiceProvider);
  return ProductsRepository(localStorageService: localStorageService);
}

/// ------------------------------------------------------------------------------

class ProductsRepository {
  final LocalStorageService _localStorageService;

  ProductsRepository({required LocalStorageService localStorageService})
      : _localStorageService = localStorageService;

  /// Fetches products from the network
  Future<List<ProductModel>> fetchProducts() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // First try to get data from cache
      final cachedProducts = await fetchCachedProducts();
      if (cachedProducts.isNotEmpty) {
        return cachedProducts;
      }

      // If not in cache, fetch from network (in this case, from assets)
      final response = await _mockProductsNetworkRequest();

      // Parse the response
      final List<dynamic> productsJson = jsonDecode(response);
      final products = productsJson.map((json) => ProductModel.fromJson(json)).toList();

      // Save to cache
      await _saveProductsToCache(productsJson.cast<Map<String, dynamic>>());

      return products;
    } catch (e) {
      log('Error fetching products: $e');
      rethrow;
    }
  }

  /// Fetches products from the local cache
  Future<List<ProductModel>> fetchCachedProducts() async {
    try {
      final cachedData = await _localStorageService.getProducts();

      if (cachedData == null || cachedData.isEmpty) {
        return [];
      }

      return cachedData.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      log('Error fetching cached products: $e');
      return [];
    }
  }

  /// Saves products to cache
  Future<void> _saveProductsToCache(List<Map<String, dynamic>> products) async {
    try {
      await _localStorageService.saveProducts(products);
    } catch (e) {
      log('Error saving products to cache: $e');
    }
  }

  /// Clears the product cache
  Future<void> clearCache() async {
    await _localStorageService.clearProductCache();
  }

  /// Mock network request that loads data from JSON file
  Future<String> _mockProductsNetworkRequest() async {
    try {
      final response = await rootBundle.loadString('assets/product_data.json');
      return response;
    } catch (e) {
      log('Error in mock products network request: $e');
      rethrow;
    }
  }
}
