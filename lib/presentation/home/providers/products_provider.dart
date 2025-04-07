import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:italist_mobile_assignment/data/models/product/product_model.dart';
import 'package:italist_mobile_assignment/data/repositories/products_repository/products_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'products_provider.g.dart';

// Provider that exposes the products from the repository
@riverpod
Future<List<ProductModel>> products(Ref ref) async {
  // Use the repository provider from the data layer
  final repository = ref.watch(productsRepositoryProvider);
  return repository.fetchProducts();
}
