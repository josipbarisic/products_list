import 'dart:async'; // Import dart:async for Timer
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:italist_mobile_assignment/data/models/product/product_model.dart';
import 'package:italist_mobile_assignment/presentation/home/providers/filtered_products_provider.dart';
import 'package:italist_mobile_assignment/presentation/home/providers/product_filter_provider.dart';
import 'package:italist_mobile_assignment/presentation/home/widgets/filter_bottom_sheet.dart';
import 'package:italist_mobile_assignment/presentation/home/widgets/filter_chips.dart';
import 'package:italist_mobile_assignment/presentation/home/widgets/product_list_item.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final debounceTimer = useState<Timer?>(null);
    final pagingController = useMemoized(
      () => PagingController<int, ProductModel>(
        getNextPageKey: (state) {
          log('PAGING CONTROLLER: getNextPageKey called with state: ${state.keys} and hasNextPage: ${state.hasNextPage} and pageKey: ${state.keys?.last} and status: ${state.status}');
          return (state.keys?.last ?? -1) + 1;
        },
        fetchPage: (pageKey) {
          log('PAGING CONTROLLER: fetchPage called with pageKey: $pageKey');
          return ref.read(filteredProductsProvider(pageKey).future);
        },
      ),
      [],
    );

    // Effect to cancel the timer when the widget is disposed
    useEffect(() {
      return () => debounceTimer.value?.cancel();
    }, []); // Empty dependency array ensures cleanup runs only on unmount

    // Listen to search text changes and update filter ONLY
    useEffect(() {
      void updateSearch() {
        ref.read(productFilterNotifierProvider.notifier).updateSearchQuery(searchController.text);
      }

      searchController.addListener(updateSearch);
      return () => searchController.removeListener(updateSearch);
    }, [searchController]);

    // Listen to filter changes (excluding pagination) and refresh the controller with debounce
    ref.listen(productFilterNotifierProvider, (prev, next) {
      final bool filtersChanged = prev?.searchQuery != next.searchQuery ||
          prev?.brand != next.brand ||
          prev?.category != next.category ||
          prev?.gender != next.gender ||
          prev?.minPrice != next.minPrice ||
          prev?.maxPrice != next.maxPrice;

      // Refresh only if core filters changed
      if (filtersChanged) {
        log('PAGING CONTROLLER: Filters changed, debouncing refresh.');
        debounceTimer.value?.cancel();
        debounceTimer.value = Timer(const Duration(milliseconds: 1000), () {
          log('PAGING CONTROLLER: Debounce finished, refreshing.');
          pagingController.refresh();
        });
      }
    });

    // Cleanup PagingController on dispose
    useEffect(() {
        log('PAGING CONTROLLER: Setting up dispose effect.');
        return () {
             log('PAGING CONTROLLER: Disposing controller.');
             pagingController.dispose();
        };
    }, [pagingController]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context, ref);
            },
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
              ),
            ),
          ),
          const FilterChips(),
          Expanded(
            // Use PagingListener + PagedListView as per example
            child: PagingListener(
              controller: pagingController,
              builder: (context, state, fetchNextPage) => PagedListView<int, ProductModel>(
                state: state,
                fetchNextPage: fetchNextPage,
                builderDelegate: PagedChildBuilderDelegate<ProductModel>(
                  itemBuilder: (context, item, index) => ProductListItem(product: item),
                  firstPageProgressIndicatorBuilder: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  newPageProgressIndicatorBuilder: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  noItemsFoundIndicatorBuilder: (_) => const Center(
                    child: Text('No products found'),
                  ),
                  noMoreItemsIndicatorBuilder: (_) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const FilterBottomSheet(),
    );
  }
}
