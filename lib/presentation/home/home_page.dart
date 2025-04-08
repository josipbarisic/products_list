import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:italist_mobile_assignment/presentation/home/providers/paginated_products_provider.dart';
import 'package:italist_mobile_assignment/presentation/home/providers/product_filter_provider.dart';
import 'package:italist_mobile_assignment/presentation/home/widgets/filter_bottom_sheet.dart';
import 'package:italist_mobile_assignment/presentation/home/widgets/filter_chips.dart';
import 'package:italist_mobile_assignment/presentation/home/widgets/product_list_item.dart';
import 'package:italist_mobile_assignment/presentation/home/widgets/product_list_loading_item.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  static const _pageSize = 20;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final firstPageAsyncValue = ref.watch(paginatedProductsProvider(1));

    // Listen to filter changes to reset scroll position (optional but good UX)
    final scrollController = useScrollController();
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
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    ref.read(productFilterNotifierProvider.notifier).updateSearchQuery('');
                  },
                ),
              ),
            ),
          ),
          const FilterChips(),
          Expanded(
            // Use ListView.builder based on total pages from first page response
            child: firstPageAsyncValue.when(
              data: (firstPageData) {
                // Calculate total items based on total pages
                final totalItems = firstPageData.totalItems;
                final totalPages = firstPageData.totalPages;
                // Check if there are actually more pages to load
                final bool hasMorePages = totalItems > 0 && firstPageData.currentPage < totalPages;
                // Add 1 for the bottom loading indicator only if there are more pages
                final itemCount = totalItems + (hasMorePages ? 1 : 0);

                if (totalItems == 0) {
                  return const Center(child: Text('No products found.'));
                }

                return ListView.builder(
                  controller: scrollController,
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    // Check if this is the slot for the loading indicator
                    if (hasMorePages && index == totalItems) {
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
                        final product = pageData.items[indexInPage];
                        return ProductListItem(product: product);
                      },
                      // Show placeholder for items in loading pages
                      loading: () => const ProductListLoadingItem(),
                      error: (err, stack) => ListTile(
                        title: Text('Error loading item...',
                            style: TextStyle(color: Theme.of(context).colorScheme.error)),
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
