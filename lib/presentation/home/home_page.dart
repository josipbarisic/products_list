import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:italist_mobile_assignment/presentation/home/providers/paginated_products_provider.dart';
import 'package:italist_mobile_assignment/presentation/home/providers/product_filter_provider.dart';
import 'package:italist_mobile_assignment/presentation/home/widgets/filter_bottom_sheet.dart';
import 'package:italist_mobile_assignment/presentation/home/widgets/filter_chips.dart';
import 'package:italist_mobile_assignment/presentation/home/widgets/product_grid_item.dart';
import 'package:italist_mobile_assignment/presentation/home/widgets/product_grid_loading_item.dart';

/// The main page displaying the list of products with search and filter capabilities.
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  /// Number of items to fetch per page.
  static const _pageSize = 20;

  /// Padding around the grid.
  static const double _gridPadding = 8.0;

  /// Spacing between grid items.
  static const double _gridSpacing = 8.0;

  /// Number of columns in the grid.
  static const int _crossAxisCount = 2;

  /// Aspect ratio for grid items (width / height).
  static const double _childAspectRatio = 0.55;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- Hooks --- //
    final searchController = useTextEditingController();
    final scrollController = useScrollController();
    // Trigger rebuilds when search text changes to show/hide clear button
    final searchQuery = useState(searchController.text);

    // --- Providers --- //
    final filterNotifier = ref.read(productFilterNotifierProvider.notifier);
    final pageTracker = useState(1); // Start with the first page

    // --- Effects --- //
    // Effect to update search query in the provider when text changes (debounced internally)
    useEffect(() {
      void listener() {
        searchQuery.value = searchController.text; // Update local state for UI
        filterNotifier.updateSearchQuery(searchController.text);
      }

      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [searchController, filterNotifier]); // Dependencies

    // Effect to scroll to top when filters change
    ref.listen(productFilterNotifierProvider, (prev, next) {
      // Check if filters actually changed (excluding search, handled separately)
      final bool filtersChanged = prev?.brand != next.brand ||
          prev?.category != next.category ||
          prev?.gender != next.gender ||
          prev?.minPrice != next.minPrice ||
          prev?.maxPrice != next.maxPrice;

      if (filtersChanged && scrollController.hasClients) {
        scrollController.jumpTo(0);
      }
    });

    void updatePageTracker() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pageTracker.value++;
      });
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter products', // Add tooltip
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              // Allows sheet to take more height
              shape: const RoundedRectangleBorder(
                // Consistent shape
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              // Clip content
              builder: (_) => const FilterBottomSheet(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // --- Search Bar ---
          Padding(
            padding: const EdgeInsets.all(_gridPadding),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: theme.colorScheme.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  // Define enabled state border
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.5)),
                ),
                // Show clear button only when text is not empty
                suffixIcon: searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        tooltip: 'Clear search',
                        onPressed: () {
                          searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
          ),
          // --- Filter Chips ---
          const FilterChips(), // Displays active filters
          // Add padding if FilterChips is showing something
          Consumer(
            // Only add space if FilterChips renders something
            builder: (context, ref, child) {
              final filter = ref.watch(productFilterNotifierProvider);
              final hasActiveFilters = filter.brand != null ||
                  filter.category != null ||
                  filter.gender != null ||
                  filter.minPrice != null ||
                  filter.maxPrice != null;
              return hasActiveFilters
                  ? const SizedBox(height: _gridPadding / 2)
                  : const SizedBox.shrink();
            },
          ),

          // --- Product Grid ---
          Expanded(
            child: ref.watch(paginatedProductsProvider(pageTracker.value)).when(
                  data: (firstPageData) {
                    final loadedItems = firstPageData.loadedItems;
                    final totalItems = firstPageData.totalItems;
                    final totalPages = firstPageData.totalPages;
                    final currentPage = firstPageData.currentPage;
                    log('Total items: $totalItems, Total pages: $totalPages, Current page: $currentPage vs pageTracker: ${pageTracker.value}');

                    // Handle empty state
                    if (totalItems == 0) {
                      return const Center(child: Text('No products found.'));
                    }
                    final bool hasMorePages = totalItems > 0 && currentPage < totalPages;

                    return GridView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(_gridPadding),
                      cacheExtent: loadedItems.toDouble(),
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _crossAxisCount,
                        crossAxisSpacing: _gridSpacing,
                        mainAxisSpacing: _gridSpacing,
                        childAspectRatio: _childAspectRatio,
                      ),
                      itemBuilder: (context, index) {
                        // --- Loading Indicator Logic ---
                        // If this is the last item slot and there are more pages, show loader
                        if (hasMorePages && index == loadedItems) {
                          // Trigger loading of the next page
                          // Increment page state to load more items
                          updatePageTracker();
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }

                        // --- Product Item Logic ---
                        // Calculate which page this index falls into
                        final page = index ~/ _pageSize + 1;
                        // Calculate the item's index within its specific page
                        final indexInPage = index % _pageSize;

                        // Watch the provider for the specific page needed for this item
                        return ref.watch(paginatedProductsProvider(page)).when(
                              data: (pageData) {
                                // Safety check: Ensure item exists in the loaded page data
                                if (indexInPage >= pageData.items.length) {
                                  // Return an empty placeholder if data is inconsistent
                                  return const SizedBox.shrink();
                                }
                                final product = pageData.items[indexInPage];
                                return ProductGridItem(product: product);
                              },
                              // Show loading placeholder while the specific page loads
                              loading: () => const ProductGridLoadingItem(),
                              // Show error placeholder if the specific page fails to load
                              error: (error, stack) => Card(
                                color: theme.colorScheme.errorContainer,
                                child: Center(
                                  child: Padding(
                                    // Make padding const
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Error loading item', // Generic error for item
                                      style: TextStyle(
                                        color: theme.colorScheme.onErrorContainer,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Text('Error loading products: ${error.toString()}'),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
