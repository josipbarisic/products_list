import 'dart:async';

import 'package:italist_mobile_assignment/data/models/product_filter/product_filter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_filter_provider.g.dart';

/// Provides the current filter state ([ProductFilter]) for products.
///
/// This notifier holds the user-selected filters (search query, brand, etc.)
/// and includes debouncing logic for the search query.
@Riverpod(keepAlive: true)
class ProductFilterNotifier extends _$ProductFilterNotifier {
  Timer? _debounceTimer;

  @override
  ProductFilter build() {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });
    // Initialize with default (empty) filters.
    return const ProductFilter();
  }

  /// Updates the search query with debouncing.
  /// 
  /// Waits for 500ms after the last call before updating the state.
  void updateSearchQuery(String query) {
    /// If the query is the same as the current state, return.
    if (query == state.searchQuery) return;

    // Cancel the previous timer if it exists
    _debounceTimer?.cancel();
    // Start a new timer
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      state = state.copyWithSearchQuery(query);
    });
  }

  /// Updates the brand filter.
  void updateBrand(String? brand) {
    state = state.copyWithBrand(brand);
  }

  /// Updates the category filter.
  void updateCategory(String? category) {
    state = state.copyWithCategory(category);
  }

  /// Updates the gender filter.
  void updateGender(String? gender) {
    state = state.copyWithGender(gender);
  }

  /// Updates the price range filter.
  void updatePriceRange(double? minPrice, double? maxPrice) {
    state = state.copyWithPriceRange(minPrice: minPrice, maxPrice: maxPrice);
  }

  /// Resets all filters to their default values.
  void clearFilters() {
    state = const ProductFilter();
  }
}
