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

  // to JSON
  Map<String, dynamic> toJson() => {
        'searchQuery': searchQuery,
        'brand': brand,
        'category': category,
        'gender': gender,
        'minPrice': minPrice,
        'maxPrice': maxPrice,
      };

  ProductFilter copyWithSearchQuery(
    String searchQuery,
  ) =>
      ProductFilter(
        searchQuery: searchQuery,
        brand: brand,
        category: category,
        gender: gender,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );

  ProductFilter copyWithBrand(
    String? brand,
  ) =>
      ProductFilter(
        searchQuery: searchQuery,
        brand: brand,
        category: category,
        gender: gender,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );

  ProductFilter copyWithCategory(
    String? category,
  ) =>
      ProductFilter(
        searchQuery: searchQuery,
        brand: brand,
        category: category,
        gender: gender,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );

  ProductFilter copyWithGender(String? gender) => ProductFilter(
        searchQuery: searchQuery,
        brand: brand,
        category: category,
        gender: gender,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );

  ProductFilter copyWithPriceRange({
    double? minPrice,
    double? maxPrice,
  }) =>
      ProductFilter(
        searchQuery: searchQuery,
        brand: brand,
        category: category,
        gender: gender,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );

  ProductFilter copyWithPage(int page) => ProductFilter(
        searchQuery: searchQuery,
        brand: brand,
        category: category,
        gender: gender,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );

  ProductFilter copyWithLimit(int limit) => ProductFilter(
        searchQuery: searchQuery,
        brand: brand,
        category: category,
        gender: gender,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
}
