import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:italist_mobile_assignment/data/models/product/product_model.dart';
import 'package:italist_mobile_assignment/presentation/home/providers/product_filter_provider.dart';
import 'package:italist_mobile_assignment/presentation/home/providers/products_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filtered_products_provider.g.dart';

// Filtered products provider
@riverpod
Future<List<ProductModel>> filteredProducts(Ref ref, int pageKey) async {
  final filter = ref.watch(productFilterNotifierProvider);
  final products = await ref.watch(productsProvider.future);

  log('Fetching filtered products for page: $pageKey because of filter: ${filter.toJson()} and products: ${products.length}');

  final filteredProducts = products.where((product) {
    bool matches = true; // Assume match initially

    // Apply search query filter
    if (filter.searchQuery.isNotEmpty) {
      final query = filter.searchQuery.trim().toLowerCase(); // Added trim()
      if (query.isNotEmpty) { // Check if query is not empty after trimming
        final titleLower = product.title.toLowerCase();
        final brandLower = product.brand.toLowerCase();
        final descriptionLower = product.description.toLowerCase();

        final titleMatch = titleLower.contains(query);
        final brandMatch = brandLower.contains(query);
        final descriptionMatch = descriptionLower.contains(query);

        // Logging for debugging search
        if (titleLower.contains('classic') || brandLower.contains('classic') || descriptionLower.contains('classic')) {
            log('Checking product ID: ${product.id}, Title: "$titleLower", Brand: "$brandLower", Desc: "$descriptionLower"');
            log('Searching for: "$query"');
            log('Matches: Title=$titleMatch, Brand=$brandMatch, Desc=$descriptionMatch');
        }

        if (!titleMatch && !brandMatch && !descriptionMatch) {
          matches = false;
        }
      }
    }

    if (!matches) return false; // Early exit if search didn't match

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
        log('Error parsing price: $e for product ID: ${product.id}');
        // Decide how to handle parse errors - currently includes the item
      }
    }

    return true; // Include if all filters passed
  }).toList();

  log('Filtered products count: ${filteredProducts.length}');

  // Calculate the start and end indices for the current page
  final startIndex = pageKey * 20;
  final endIndex = startIndex + 20;

  // If we've reached the end of the list, return an empty list
  if (startIndex >= filteredProducts.length) {
    return [];
  }

  log('Start index: $startIndex, End index: $endIndex');

  // Return the slice of products for the current page
  return filteredProducts.sublist(
    startIndex,
    endIndex > filteredProducts.length ? filteredProducts.length : endIndex,
  );
}
