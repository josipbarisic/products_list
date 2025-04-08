import 'dart:async';
import 'dart:developer';

import 'package:italist_mobile_assignment/data/models/product_filter/product_filter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_filter_provider.g.dart';

// Filter provider
@Riverpod(keepAlive: true)
class ProductFilterNotifier extends _$ProductFilterNotifier {
  Timer? _debounceTimer;

  @override
  ProductFilter build() {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });
    return const ProductFilter();
  }

  void updateSearchQuery(String query) {
    log('Debounce query update: "$query"');
    // Cancel the previous timer if it exists
    _debounceTimer?.cancel();
    // Start a new timer
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      log('Debounce triggered. Updating state with query: "$query"');
      state = state.copyWithSearchQuery(query);
      // NOTE: We no longer reset pagination here as pagination is handled by the UI/fetch provider
    });
  }

  void updateBrand(String? brand) {
    state = state.copyWithBrand(brand);
    // No resetPagination needed
  }

  void updateCategory(String? category) {
    state = state.copyWithCategory(category);
    // No resetPagination needed
  }

  void updateGender(String? gender) {
    state = state.copyWithGender(gender);
    // No resetPagination needed
  }

  void updatePriceRange(double? minPrice, double? maxPrice) {
    state = state.copyWithPriceRange(minPrice: minPrice, maxPrice: maxPrice);
    // No resetPagination needed
  }

  void clearFilters() {
    state = const ProductFilter();
    // No resetPagination needed
  }

// Removed loadMore and resetPagination methods as they are no longer relevant
// void loadMore() { ... }
// void resetPagination() { ... }
}
