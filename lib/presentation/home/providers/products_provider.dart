import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:italist_mobile_assignment/data/models/product/product_model.dart';
import 'package:italist_mobile_assignment/data/repositories/products_repository/products_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'products_provider.g.dart';

/// Provides the full, unfiltered list of all products.
///
/// This provider fetches the entire product dataset from the [ProductsRepository].
/// It serves as the base data source for filtering and pagination.
@Riverpod(keepAlive: true)
Future<List<ProductModel>> products(Ref ref) async {
  // This provider fetches all products from the products repository
  final repository = ref.watch(productsRepositoryProvider);
  final allProducts = await repository.fetchProducts();
  return allProducts;
}
