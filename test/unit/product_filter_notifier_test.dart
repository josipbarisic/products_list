import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:italist_mobile_assignment/presentation/home/providers/product_filter_provider.dart';

void main() {
  group('ProductFilterNotifier Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
      addTearDown(container.dispose);
    });

    test('Initial state has default values', () {
      // Act
      final provider = container.read(productFilterNotifierProvider);

      // Assert
      expect(provider.searchQuery, '');
      expect(provider.brand, null);
      expect(provider.category, null);
      expect(provider.gender, null);
      expect(provider.minPrice, null);
      expect(provider.maxPrice, null);
    });

    test('updateBrand sets brand correctly', () {
      // Act
      container
          .read(productFilterNotifierProvider.notifier)
          .updateBrand('Nike');

      // Assert
      final result = container.read(productFilterNotifierProvider);
      expect(result.brand, 'Nike');
      // Other fields should remain unchanged
      expect(result.searchQuery, '');
      expect(result.category, null);
    });

    test('updateCategory sets category correctly', () {
      // Act
      container
          .read(productFilterNotifierProvider.notifier)
          .updateCategory('Shoes');

      // Assert
      final result = container.read(productFilterNotifierProvider);
      expect(result.category, 'Shoes');
      // Other fields should remain unchanged
      expect(result.brand, null);
    });

    test('updateGender sets gender correctly', () {
      // Act
      container
          .read(productFilterNotifierProvider.notifier)
          .updateGender('Men');

      // Assert
      final result = container.read(productFilterNotifierProvider);
      expect(result.gender, 'Men');
      // Other fields should remain unchanged
      expect(result.brand, null);
    });

    test('updatePriceRange sets price range correctly', () {
      // Act
      container
          .read(productFilterNotifierProvider.notifier)
          .updatePriceRange(10.0, 100.0);

      // Assert
      final result = container.read(productFilterNotifierProvider);
      expect(result.minPrice, 10.0);
      expect(result.maxPrice, 100.0);
      // Other fields should remain unchanged
      expect(result.brand, null);
    });

    test('clearFilters resets all filters to defaults', () {
      // Arrange
      final notifier = container.read(productFilterNotifierProvider.notifier);

      // Set some filters first
      notifier.updateBrand('Nike');
      notifier.updateCategory('Shoes');
      notifier.updateGender('Men');
      notifier.updatePriceRange(10.0, 100.0);

      // Verify filters are set
      var result = container.read(productFilterNotifierProvider);
      expect(result.brand, 'Nike');
      expect(result.category, 'Shoes');
      expect(result.gender, 'Men');
      expect(result.minPrice, 10.0);
      expect(result.maxPrice, 100.0);

      // Act
      notifier.clearFilters();

      // Assert
      result = container.read(productFilterNotifierProvider);
      expect(result.searchQuery, '');
      expect(result.brand, null);
      expect(result.category, null);
      expect(result.gender, null);
      expect(result.minPrice, null);
      expect(result.maxPrice, null);
    });

    testWidgets('updateSearchQuery debounces properly', (tester) async {
      // Arrange
      final notifier = container.read(productFilterNotifierProvider.notifier);

      // Act - Update the search query
      notifier.updateSearchQuery('shirt');

      // Assert - The state should not update immediately due to debounce
      var result = container.read(productFilterNotifierProvider);
      expect(result.searchQuery, '');

      // Wait for debounce period to elapse (500ms + buffer)
      await tester.pump(const Duration(milliseconds: 600));

      // Now the state should be updated
      result = container.read(productFilterNotifierProvider);
      expect(result.searchQuery, 'shirt');
    });

    testWidgets('updateSearchQuery cancels previous debounce timer',
        (tester) async {
      // Arrange
      final notifier = container.read(productFilterNotifierProvider.notifier);

      // Act - Update the search query multiple times in quick succession
      notifier.updateSearchQuery('first');
      await tester.pump(const Duration(milliseconds: 200));
      notifier.updateSearchQuery('second');
      await tester.pump(const Duration(milliseconds: 200));
      notifier.updateSearchQuery('third');

      // Assert - The state should not update yet due to debounce
      var result = container.read(productFilterNotifierProvider);
      expect(result.searchQuery, '');

      // Wait for debounce period to elapse from the last call (500ms + buffer)
      await tester.pump(const Duration(milliseconds: 600));

      // Only the last update should be applied
      result = container.read(productFilterNotifierProvider);
      expect(result.searchQuery, 'third');
      expect(result.searchQuery, isNot('first'));
      expect(result.searchQuery, isNot('second'));
    });

    testWidgets('updateSearchQuery does nothing if query is the same',
        (tester) async {
      // Arrange
      final notifier = container.read(productFilterNotifierProvider.notifier);

      // Set initial search query with a completed debounce
      notifier.updateSearchQuery('shirt');
      await tester.pump(const Duration(milliseconds: 600));

      // Verify initial state
      var result = container.read(productFilterNotifierProvider);
      expect(result.searchQuery, 'shirt');

      // Act - Update with the same query
      notifier.updateSearchQuery('shirt');

      // Wait for potential debounce
      await tester.pump(const Duration(milliseconds: 600));

      // Assert - The state should remain the same
      result = container.read(productFilterNotifierProvider);
      expect(result.searchQuery, 'shirt');
    });
  });
}
