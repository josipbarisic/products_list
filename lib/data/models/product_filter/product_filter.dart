// Product filter class
class ProductFilter {
  final String searchQuery;
  final String? brand;
  final String? category;
  final String? gender;
  final double? minPrice;
  final double? maxPrice;

  const ProductFilter({
    this.searchQuery = '',
    this.brand,
    this.category,
    this.gender,
    this.minPrice,
    this.maxPrice,
  });

  ProductFilter copyWith({
    String? searchQuery,
    String? brand,
    String? category,
    String? gender,
    double? minPrice,
    double? maxPrice,
  }) {
    return ProductFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      gender: gender ?? this.gender,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }
}