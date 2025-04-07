import 'package:italist_mobile_assignment/data/models/product_filter/product_filter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_filter_provider.g.dart';

// Filter provider
@Riverpod(keepAlive: true)
class ProductFilterNotifier extends _$ProductFilterNotifier {
  @override
  ProductFilter build() {
    return const ProductFilter();
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateBrand(String? brand) {
    state = state.copyWith(brand: brand);
  }

  void updateCategory(String? category) {
    state = state.copyWith(category: category);
  }

  void updateGender(String? gender) {
    state = state.copyWith(gender: gender);
  }

  void updatePriceRange(double? minPrice, double? maxPrice) {
    state = state.copyWith(minPrice: minPrice, maxPrice: maxPrice);
  }

  void clearFilters() {
    state = const ProductFilter();
  }
} 