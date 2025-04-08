// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productFilterNotifierHash() =>
    r'56a9cac8f4065b1b599399bcc15415f1a3092b80';

/// Provides the current filter state ([ProductFilter]) for products.
///
/// This notifier holds the user-selected filters (search query, brand, etc.)
/// and includes debouncing logic for the search query.
///
/// Copied from [ProductFilterNotifier].
@ProviderFor(ProductFilterNotifier)
final productFilterNotifierProvider =
    NotifierProvider<ProductFilterNotifier, ProductFilter>.internal(
  ProductFilterNotifier.new,
  name: r'productFilterNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productFilterNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProductFilterNotifier = Notifier<ProductFilter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
