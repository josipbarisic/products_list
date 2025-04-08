import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_list/data/models/product/product_model.dart';
import 'package:product_list/presentation/home/providers/paginated_products_provider.dart';
import 'package:product_list/presentation/home/providers/product_filter_provider.dart';
import 'package:product_list/presentation/home/widgets/filter_bottom_sheet.dart';
import 'package:product_list/presentation/home/widgets/filter_chips.dart';
import 'package:product_list/presentation/home/widgets/product_grid_item.dart';
import 'package:product_list/presentation/home/widgets/product_grid_loading_item.dart';

/// The main page displaying the list of products with search and filter capabilities.
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  /// Padding around the grid.
  static const double _gridPadding = 8.0;

  /// Spacing between grid items.
  static const double _gridSpacing = 8.0;

  /// Number of columns in the grid.
  static const int _crossAxisCount = 2;

  /// Aspect ratio for grid items (width / height).
  static const double _childAspectRatio = 0.55;

  /// Distance from bottom that triggers loading of the next page
  static const double _scrollThreshold = 200.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- Hooks --- //
    final searchController = useTextEditingController();
    final scrollController = useScrollController();
    // Trigger rebuilds when search text changes to show/hide clear button
    final searchQuery = useState(searchController.text);

    // Track current page, products, and loading state
    final currentPage = useState(1);
    final products = useState<List<ProductModel>>([]);
    final isLoadingMore = useState(false);
    final hasMorePages = useState(true);
    final totalItemCount = useState(0);

    // --- Providers --- //
    final filterNotifier = ref.read(productFilterNotifierProvider.notifier);

    // --- Load first page --- //
    final firstPageData = ref.watch(paginatedProductsProvider(1));

    // --- Define loadNextPage function before it's used ---
    void loadNextPage() async {
      if (isLoadingMore.value || !hasMorePages.value) return;

      isLoadingMore.value = true;
      final nextPage = currentPage.value + 1;

      try {
        final nextPageData = await ref.read(paginatedProductsProvider(nextPage).future);

        // On successful load, update state
        if (nextPageData.items.isNotEmpty) {
          products.value = [...products.value, ...nextPageData.items];
          currentPage.value = nextPage;
          hasMorePages.value = nextPage < nextPageData.totalPages;
        } else {
          hasMorePages.value = false;
        }
      } catch (e) {
        log('Error loading next page: $e');
        // Show error if needed
      } finally {
        isLoadingMore.value = false;
      }
    }

    // Handle initial page data
    useEffect(() {
      void handleFirstPage() {
        firstPageData.whenData((data) {
          products.value = data.items;
          hasMorePages.value = data.currentPage < data.totalPages;
          totalItemCount.value = data.totalItems;
        });
      }

      handleFirstPage();
      return null;
    }, [firstPageData]);

    // --- Handle scroll position --- //
    useEffect(() {
      void onScroll() {
        if (scrollController.hasClients) {
          final maxScroll = scrollController.position.maxScrollExtent;
          final currentScroll = scrollController.position.pixels;

          // If we're close to the bottom and not already loading more
          if (maxScroll - currentScroll <= _scrollThreshold &&
              !isLoadingMore.value &&
              hasMorePages.value) {
            loadNextPage();
          }
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, []);

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

    // Effect to reset state when filters change
    ref.listen(productFilterNotifierProvider, (prev, next) {
      // Check if filters actually changed (excluding search, handled separately)
      final bool filtersChanged = prev?.brand != next.brand ||
          prev?.category != next.category ||
          prev?.gender != next.gender ||
          prev?.minPrice != next.minPrice ||
          prev?.maxPrice != next.maxPrice;

      if (filtersChanged) {
        // Reset pagination state
        currentPage.value = 1;
        isLoadingMore.value = false;
        hasMorePages.value = true;

        // Scroll to top if possible
        if (scrollController.hasClients) {
          scrollController.jumpTo(0);
        }
      }
    });

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
            child: firstPageData.when(
              data: (_) {
                // Handle empty state
                if (totalItemCount.value == 0) {
                  return const Center(child: Text('No products found.'));
                }

                // Calculate the itemCount based on products + loading indicator if needed
                final itemCount = products.value.length + (hasMorePages.value ? 1 : 0);

                return GridView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(_gridPadding),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _crossAxisCount,
                    crossAxisSpacing: _gridSpacing,
                    mainAxisSpacing: _gridSpacing,
                    childAspectRatio: _childAspectRatio,
                  ),
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    // If we're at the last item and there are more pages, show loader
                    if (index == products.value.length && hasMorePages.value) {
                      // We'll show a loading indicator at the bottom
                      return ProductGridLoadingItem();
                    }

                    // Regular product item
                    if (index < products.value.length) {
                      final product = products.value[index];
                      return ProductGridItem(product: product);
                    }

                    // Fallback (shouldn't be reached)
                    return const SizedBox.shrink();
                  },
                );
              },

              // Initial loading state
              loading: () => const Center(child: CircularProgressIndicator()),

              // Error state
              error: (error, stack) {
                log('Error loading products', error: error, stackTrace: stack);
                return Center(
                  child: Text('Error loading products: ${error.toString()}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
