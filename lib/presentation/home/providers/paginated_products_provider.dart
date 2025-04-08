import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:italist_mobile_assignment/data/models/paginated_response/paginated_response.dart';
import 'package:italist_mobile_assignment/data/models/product/product_model.dart';
import 'package:italist_mobile_assignment/presentation/home/providers/product_filter_provider.dart';
import 'package:italist_mobile_assignment/presentation/home/providers/products_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'paginated_products_provider.g.dart';

/// Page size used for pagination.
const int _pageSize = 20;

/// Provides a paginated list of products based on the current filters.
///
/// Takes the 1-based `page` number as an argument.
/// Watches [productFilterNotifierProvider] to get the current filter criteria.
/// Fetches the full product list from [productsProvider].
/// Applies filtering and returns a [PaginatedResponse] containing the items
/// for the requested page and pagination metadata (total items, total pages).
@riverpod
Future<PaginatedResponse<ProductModel>> paginatedProducts(Ref ref, int page) async {
  // Get the current filter state (search, brand, etc.)
  final filter = ref.watch(productFilterNotifierProvider);
  final allProducts = await ref.watch(productsProvider.future);

  // Apply filtering logic
  final filteredProducts = allProducts.where((product) {
    bool matches = true;
    // Apply search query filter
    if (filter.searchQuery.isNotEmpty) {
      final query = filter.searchQuery.trim().toLowerCase();
      if (query.isNotEmpty) {
        final titleLower = product.title.toLowerCase();
        final brandLower = product.brand.toLowerCase();
        final descriptionLower = product.description.toLowerCase();
        if (!titleLower.contains(query) &&
            !brandLower.contains(query) &&
            !descriptionLower.contains(query)) {
          matches = false;
        }
      }
    }
    if (!matches) return false;
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
      }
    }
    return true;
  }).toList();

  // Calculate pagination details
  final totalItems = filteredProducts.length;
  final totalPages = (totalItems / _pageSize).ceil();
  final startIndex = (page - 1) * _pageSize;

  // Get the items for the current page
  List<ProductModel> pageItems = [];
  if (startIndex < totalItems) {
    final endIndex = startIndex + _pageSize;
    pageItems = filteredProducts.sublist(
      startIndex,
      endIndex > totalItems ? totalItems : endIndex,
    );
  }

  final loadedItems = page == 0 ? pageItems.length : (_pageSize * page) + pageItems.length;

  // Add artificial delay for subsequent pages
  if (page > 1) {
    log('paginatedProducts: Adding artificial delay for page $page');
    await Future.delayed(const Duration(seconds: 1));
  }

  log('PAGINATED RESPONSE FOR PAGE items: ${pageItems.length} :: loadedItems: $loadedItems totalItems: $totalItems totalPages: $totalPages currentPage: $page');
  // Return the paginated response
  return PaginatedResponse(
    items: pageItems,
    loadedItems: loadedItems,
    totalItems: totalItems,
    totalPages: totalPages,
    currentPage: page,
  );
}
