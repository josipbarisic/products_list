import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_list/data/models/product/product_model.dart';
import 'package:product_list/presentation/home/providers/paginated_products_provider.dart';
import 'package:product_list/presentation/home/providers/product_filter_provider.dart';
import 'package:product_list/presentation/home/providers/products_provider.dart';

// Helper function to create test products
ProductModel createTestProduct({
  required int id,
  required String title,
  required String description,
  required String brand,
  required String category,
  required String gender,
  required String salePrice,
  required String imageLink,
}) {
  return ProductModel(
    id: id,
    title: title,
    description: description,
    brand: brand,
    category: category,
    gender: gender,
    salePrice: salePrice,
    imageLink: imageLink,
    link: 'https://example.com',
    additionalImageLink: '',
    availability: 'in stock',
    listPrice: salePrice,
    gtin: '123456789',
    productType: 'Test',
    condition: 'new',
    rawColor: 'black',
    color: 'black',
    sizeFormat: 'US',
    sizingSchema: 'US',
    sizes: 'M',
    sizeType: 'regular',
    itemGroupId: 1,
    shipping: '0',
    mpn: '12345',
    material: 'Test',
    collection: 'Test',
    additionalImageLink2: '',
    additionalImageLink3: '',
    additionalImageLink4: '',
  );
}

void main() {
  group('paginatedProducts Provider Tests', () {
    // Test data
    final testProducts = [
      createTestProduct(
        id: 1,
        title: 'Nike Running Shoes',
        description: 'Comfortable running shoes',
        brand: 'Nike',
        category: 'Shoes',
        gender: 'Men',
        salePrice: '89.99 USD',
        imageLink: 'https://example.com/nike-shoes.jpg',
      ),
      createTestProduct(
        id: 2,
        title: 'Adidas T-Shirt',
        description: 'Cotton t-shirt',
        brand: 'Adidas',
        category: 'Apparel',
        gender: 'Women',
        salePrice: '29.99 USD',
        imageLink: 'https://example.com/adidas-tshirt.jpg',
      ),
      createTestProduct(
        id: 3,
        title: 'Puma Hoodie',
        description: 'Warm hoodie for winter',
        brand: 'Puma',
        category: 'Apparel',
        gender: 'Men',
        salePrice: '59.99 USD',
        imageLink: 'https://example.com/puma-hoodie.jpg',
      ),
      createTestProduct(
        id: 4,
        title: 'Under Armour Shorts',
        description: 'Sports shorts',
        brand: 'Under Armour',
        category: 'Sportswear',
        gender: 'Men',
        salePrice: '39.99 USD',
        imageLink: 'https://example.com/ua-shorts.jpg',
      ),
      createTestProduct(
        id: 5,
        title: 'New Balance Sneakers',
        description: 'Casual sneakers',
        brand: 'New Balance',
        category: 'Shoes',
        gender: 'Women',
        salePrice: '79.99 USD',
        imageLink: 'https://example.com/nb-sneakers.jpg',
      ),
    ];

    late ProviderContainer container;

    setUp(() {
      // Create a container with mocked products
      container = ProviderContainer(
        overrides: [
          // Mock the products provider to return our test data
          productsProvider.overrideWith((ref) => Future.value(testProducts)),
        ],
      );

      // Add teardown to dispose the container
      addTearDown(container.dispose);
    });

    test('Returns first page with default page size and no filters', () async {
      // Act
      final result = await container.read(paginatedProductsProvider(1).future);

      // Assert
      expect(result.items.length,
          5); // All products should be included (test data has fewer than page size)
      expect(result.totalItems, 5);
      expect(result.totalPages,
          1); // With page size 20, all test products fit on one page
      expect(result.currentPage, 1);
    });

    test('Filters products by brand correctly', () async {
      // Arrange - Set brand filter
      container
          .read(productFilterNotifierProvider.notifier)
          .updateBrand('Nike');

      // Act
      final result = await container.read(paginatedProductsProvider(1).future);

      // Assert
      expect(result.items.length, 1);
      expect(result.totalItems, 1);
      expect(result.items.first.brand, 'Nike');
    });

    test('Filters products by category correctly', () async {
      // Arrange - Set category filter
      container
          .read(productFilterNotifierProvider.notifier)
          .updateCategory('Shoes');

      // Act
      final result = await container.read(paginatedProductsProvider(1).future);

      // Assert
      expect(result.items.length, 2);
      expect(result.totalItems, 2);
      expect(
          result.items.every((product) => product.category == 'Shoes'), true);
    });

    test('Filters products by gender correctly', () async {
      // Arrange - Set gender filter
      container
          .read(productFilterNotifierProvider.notifier)
          .updateGender('Women');

      // Act
      final result = await container.read(paginatedProductsProvider(1).future);

      // Assert
      expect(result.items.length, 2);
      expect(result.totalItems, 2);
      expect(result.items.every((product) => product.gender == 'Women'), true);
    });

    test('Filters products by price range correctly', () async {
      // Arrange - Set price range filter
      container
          .read(productFilterNotifierProvider.notifier)
          .updatePriceRange(30.0, 60.0);

      // Act
      final result = await container.read(paginatedProductsProvider(1).future);

      // Assert
      expect(result.items.length, 2);
      expect(result.totalItems, 2);

      // Verify all products in the result are within the price range
      for (final product in result.items) {
        final price = double.parse(product.salePrice.replaceAll(' USD', ''));
        expect(price >= 30.0 && price <= 60.0, true);
      }
    });

    test('Filters products by search query correctly', () async {
      // Arrange - Set search query
      container
          .read(productFilterNotifierProvider.notifier)
          .updateSearchQuery('running');

      // Allow debounce to complete
      await Future.delayed(const Duration(milliseconds: 600));

      // Act
      final result = await container.read(paginatedProductsProvider(1).future);

      // Assert
      expect(result.items.length, 1);
      expect(result.totalItems, 1);
      expect(result.items.first.title, contains('Running'));
    });

    test('Combines multiple filters correctly', () async {
      // Arrange - Set multiple filters
      final notifier = container.read(productFilterNotifierProvider.notifier);
      notifier.updateCategory('Apparel');
      notifier.updateGender('Men');

      // Act
      final result = await container.read(paginatedProductsProvider(1).future);

      // Assert
      expect(result.items.length, 1);
      expect(result.totalItems, 1);
      expect(result.items.first.category, 'Apparel');
      expect(result.items.first.gender, 'Men');
      expect(result.items.first.brand, 'Puma');
    });

    test('Returns empty result when no products match filters', () async {
      // Arrange - Set filters that no product will match
      container
          .read(productFilterNotifierProvider.notifier)
          .updateBrand('Unknown Brand');

      // Act
      final result = await container.read(paginatedProductsProvider(1).future);

      // Assert
      expect(result.items.isEmpty, true);
      expect(result.totalItems, 0);
      expect(result.totalPages, 0); // No pages when no items
      expect(result.currentPage,
          1); // Current page should still be the requested page
    });

    test('Provider updates when filters change', () async {
      // Test with fresh container to avoid timer leaks
      final testContainer = ProviderContainer(
        overrides: [
          productsProvider.overrideWith((ref) => Future.value(testProducts)),
        ],
      );
      addTearDown(testContainer.dispose);

      // Initial read to get the baseline
      final initialResult =
          await testContainer.read(paginatedProductsProvider(1).future);
      expect(initialResult.totalItems, 5);

      // Change the filter
      testContainer
          .read(productFilterNotifierProvider.notifier)
          .updateBrand('Nike');

      // Read the provider again
      final updatedResult =
          await testContainer.read(paginatedProductsProvider(1).future);

      // Assert the results have changed
      expect(updatedResult.totalItems, 1);
      expect(updatedResult.items.length, 1);
      expect(updatedResult.items.first.brand, 'Nike');

      // Explicitly dispose to clean up any timers
      testContainer.dispose();
    });
  });
}
