// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtered_products_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredProductsHash() => r'fe5e6d8ce23bb282fb17a6839d1b6782a2f38cbf';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [filteredProducts].
@ProviderFor(filteredProducts)
const filteredProductsProvider = FilteredProductsFamily();

/// See also [filteredProducts].
class FilteredProductsFamily extends Family<AsyncValue<List<ProductModel>>> {
  /// See also [filteredProducts].
  const FilteredProductsFamily();

  /// See also [filteredProducts].
  FilteredProductsProvider call(
    int pageKey,
  ) {
    return FilteredProductsProvider(
      pageKey,
    );
  }

  @override
  FilteredProductsProvider getProviderOverride(
    covariant FilteredProductsProvider provider,
  ) {
    return call(
      provider.pageKey,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'filteredProductsProvider';
}

/// See also [filteredProducts].
class FilteredProductsProvider
    extends AutoDisposeFutureProvider<List<ProductModel>> {
  /// See also [filteredProducts].
  FilteredProductsProvider(
    int pageKey,
  ) : this._internal(
          (ref) => filteredProducts(
            ref as FilteredProductsRef,
            pageKey,
          ),
          from: filteredProductsProvider,
          name: r'filteredProductsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredProductsHash,
          dependencies: FilteredProductsFamily._dependencies,
          allTransitiveDependencies:
              FilteredProductsFamily._allTransitiveDependencies,
          pageKey: pageKey,
        );

  FilteredProductsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pageKey,
  }) : super.internal();

  final int pageKey;

  @override
  Override overrideWith(
    FutureOr<List<ProductModel>> Function(FilteredProductsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredProductsProvider._internal(
        (ref) => create(ref as FilteredProductsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pageKey: pageKey,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ProductModel>> createElement() {
    return _FilteredProductsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredProductsProvider && other.pageKey == pageKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pageKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FilteredProductsRef on AutoDisposeFutureProviderRef<List<ProductModel>> {
  /// The parameter `pageKey` of this provider.
  int get pageKey;
}

class _FilteredProductsProviderElement
    extends AutoDisposeFutureProviderElement<List<ProductModel>>
    with FilteredProductsRef {
  _FilteredProductsProviderElement(super.provider);

  @override
  int get pageKey => (origin as FilteredProductsProvider).pageKey;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
