import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:italist_mobile_assignment/presentation/home/providers/paginated_products_provider.dart';
import 'package:italist_mobile_assignment/presentation/home/providers/product_filter_provider.dart';
import 'package:italist_mobile_assignment/presentation/home/widgets/filter_bottom_sheet.dart';
import 'package:italist_mobile_assignment/presentation/home/widgets/filter_chips.dart';
import 'package:italist_mobile_assignment/presentation/home/widgets/product_grid_item.dart';
import 'package:italist_mobile_assignment/presentation/home/widgets/product_grid_loading_item.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  static const _pageSize = 20;
  static const double _gridPadding = 8.0;
  static const double _gridSpacing = 8.0;
  static const int _crossAxisCount = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final firstPageAsyncValue = ref.watch(paginatedProductsProvider(1));
    final scrollController = useScrollController();

    // Listen to filter changes to reset scroll position (optional but good UX)
    ref.listen(productFilterNotifierProvider, (prev, next) {
      final bool filtersChanged = prev?.searchQuery != next.searchQuery ||
          prev?.brand != next.brand ||
          prev?.category != next.category ||
          prev?.gender != next.gender ||
          prev?.minPrice != next.minPrice ||
          prev?.maxPrice != next.maxPrice;
      if (filtersChanged && scrollController.hasClients) {
        scrollController.jumpTo(0); // Go to top on filter change
      }
    });

    // Search listener only updates the state (debounced internally)
    useEffect(() {
      void updateSearch() {
        ref.read(productFilterNotifierProvider.notifier).updateSearchQuery(searchController.text);
      }

      searchController.addListener(updateSearch);
      return () => searchController.removeListener(updateSearch);
    }, [searchController]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => const FilterBottomSheet(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(_gridPadding),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          ref.read(productFilterNotifierProvider.notifier).updateSearchQuery('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          const FilterChips(),
          const SizedBox(height: _gridPadding / 2), // Add some space before the grid
          Expanded(
            // Use Expanded + GridView.builder
            child: firstPageAsyncValue.when(
              data: (firstPageData) {
                final totalItems = firstPageData.totalItems;
                final totalPages = firstPageData.totalPages;
                final bool hasMorePages = totalItems > 0 && firstPageData.currentPage < totalPages;
                // Add 1 item slot for the loading indicator if needed
                final itemCount = totalItems + (hasMorePages ? 1 : 0);

                if (totalItems == 0) {
                  return const Center(child: Text('No products found.'));
                }

                return GridView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(_gridPadding),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _crossAxisCount, // 2 columns
                    crossAxisSpacing: _gridSpacing, // Horizontal spacing
                    mainAxisSpacing: _gridSpacing, // Vertical spacing
                    childAspectRatio: 0.55, // Adjust aspect ratio (width / height) for desired look
                  ),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    // Check if it's the loading indicator slot
                    if (hasMorePages && index == totalItems) {
                      // For GridView, the loading indicator needs to fit in a cell
                      // or be handled outside. Here, we place it in the last cell.
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    // Calculate page and index within the page
                    final page = index ~/ _pageSize + 1;
                    final indexInPage = index % _pageSize;

                    // Watch the specific page provider
                    final pageAsyncValue = ref.watch(paginatedProductsProvider(page));

                    return pageAsyncValue.when(
                      data: (pageData) {
                        // Handle potential index out of bounds if data changes unexpectedly
                        if (indexInPage >= pageData.items.length) {
                          // Return an empty container or a placeholder
                          return const SizedBox.shrink();
                        }
                        final product = pageData.items[indexInPage];
                        // Use ProductGridItem instead of ProductListItem
                        return ProductGridItem(product: product);
                      },
                      // Show placeholder grid item for loading pages
                      loading: () => const ProductGridLoadingItem(),
                      error: (err, stack) => Card(
                        color: Theme.of(context).colorScheme.errorContainer,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Error',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onErrorContainer,
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
              error: (err, stack) => Center(child: Text('Error loading products: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
