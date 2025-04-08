// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productsHash() => r'dc2fbed5713cd485ec99ebc1bafabf0efa50fe77';

/// Provides the full, unfiltered list of all products.
///
/// This provider fetches the entire product dataset from the [ProductsRepository].
/// It serves as the base data source for filtering and pagination.
///
/// Copied from [products].
@ProviderFor(products)
final productsProvider = FutureProvider<List<ProductModel>>.internal(
  products,
  name: r'productsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$productsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProductsRef = FutureProviderRef<List<ProductModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
