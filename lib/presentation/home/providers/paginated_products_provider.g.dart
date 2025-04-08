// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_products_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$paginatedProductsHash() => r'a31367ab9ad0b8268f7d74d017b61f2758f9d9d5';

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

/// See also [paginatedProducts].
@ProviderFor(paginatedProducts)
const paginatedProductsProvider = PaginatedProductsFamily();

/// See also [paginatedProducts].
class PaginatedProductsFamily
    extends Family<AsyncValue<PaginatedResponse<ProductModel>>> {
  /// See also [paginatedProducts].
  const PaginatedProductsFamily();

  /// See also [paginatedProducts].
  PaginatedProductsProvider call(
    int page,
  ) {
    return PaginatedProductsProvider(
      page,
    );
  }

  @override
  PaginatedProductsProvider getProviderOverride(
    covariant PaginatedProductsProvider provider,
  ) {
    return call(
      provider.page,
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
  String? get name => r'paginatedProductsProvider';
}

/// See also [paginatedProducts].
class PaginatedProductsProvider
    extends AutoDisposeFutureProvider<PaginatedResponse<ProductModel>> {
  /// See also [paginatedProducts].
  PaginatedProductsProvider(
    int page,
  ) : this._internal(
          (ref) => paginatedProducts(
            ref as PaginatedProductsRef,
            page,
          ),
          from: paginatedProductsProvider,
          name: r'paginatedProductsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$paginatedProductsHash,
          dependencies: PaginatedProductsFamily._dependencies,
          allTransitiveDependencies:
              PaginatedProductsFamily._allTransitiveDependencies,
          page: page,
        );

  PaginatedProductsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
  }) : super.internal();

  final int page;

  @override
  Override overrideWith(
    FutureOr<PaginatedResponse<ProductModel>> Function(
            PaginatedProductsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PaginatedProductsProvider._internal(
        (ref) => create(ref as PaginatedProductsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PaginatedResponse<ProductModel>>
      createElement() {
    return _PaginatedProductsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PaginatedProductsProvider && other.page == page;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PaginatedProductsRef
    on AutoDisposeFutureProviderRef<PaginatedResponse<ProductModel>> {
  /// The parameter `page` of this provider.
  int get page;
}

class _PaginatedProductsProviderElement
    extends AutoDisposeFutureProviderElement<PaginatedResponse<ProductModel>>
    with PaginatedProductsRef {
  _PaginatedProductsProviderElement(super.provider);

  @override
  int get page => (origin as PaginatedProductsProvider).page;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
