import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:italist_mobile_assignment/data/models/product/product_model.dart';
import 'package:italist_mobile_assignment/presentation/home/providers/product_filter_provider.dart';
import 'package:italist_mobile_assignment/presentation/home/providers/products_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filtered_products_provider.g.dart';

// Filtered products provider
@riverpod
Future<List<ProductModel>> filteredProducts(Ref ref) async {
  final filter = ref.watch(productFilterNotifierProvider);
  final products = await ref.watch(productsProvider.future);

  return products.where((product) {
    // Apply search query filter
    if (filter.searchQuery.isNotEmpty) {
      final query = filter.searchQuery.toLowerCase();
      if (!product.title.toLowerCase().contains(query) &&
          !product.brand.toLowerCase().contains(query) &&
          !product.description.toLowerCase().contains(query)) {
        return false;
      }
    }

    // Apply brand filter
    if (filter.brand != null && filter.brand!.isNotEmpty) {
      if (product.brand.toLowerCase() != filter.brand!.toLowerCase()) {
        return false;
      }
    }

    // Apply category filter
    if (filter.category != null && filter.category!.isNotEmpty) {
      if (product.category.toLowerCase() != filter.category!.toLowerCase()) {
        return false;
      }
    }

    // Apply gender filter
    if (filter.gender != null && filter.gender!.isNotEmpty) {
      if (product.gender.toLowerCase() != filter.gender!.toLowerCase()) {
        return false;
      }
    }

    // Apply price range filter
    if (filter.minPrice != null || filter.maxPrice != null) {
      // Convert price string to double
      final priceString = product.salePrice.replaceAll(' USD', '');
      try {
        final price = double.parse(priceString);

        if (filter.minPrice != null && price < filter.minPrice!) {
          return false;
        }

        if (filter.maxPrice != null && price > filter.maxPrice!) {
          return false;
        }
      } catch (e) {
        log('Error parsing price: $e');
      }
    }

    return true;
  }).toList();
}
