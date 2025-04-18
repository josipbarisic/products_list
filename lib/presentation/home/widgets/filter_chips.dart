import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:product_list/presentation/home/providers/product_filter_provider.dart';
import 'package:product_list/presentation/home/widgets/custom_filter_chip.dart';

/// A horizontal row displaying currently active filters as chips.
///
/// Shows chips for brand, category, gender, and price range if they are set.
/// Also displays a 'Clear All' button if any filters are active.
/// Returns an empty widget if no filters are active.
class FilterChips extends HookConsumerWidget {
  const FilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(productFilterNotifierProvider);
    final hasActiveFilters = filter.brand != null ||
        filter.category != null ||
        filter.gender != null ||
        filter.minPrice != null ||
        filter.maxPrice != null;

    // Return empty if no filters are active
    if (!hasActiveFilters) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            if (hasActiveFilters)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref.read(productFilterNotifierProvider.notifier).clearFilters();
                  },
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Clear All'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade100,
                    foregroundColor: Colors.red.shade900,
                  ),
                ),
              ),
            if (filter.brand != null)
              CustomFilterChip(
                label: 'Brand: ${filter.brand}',
                onRemove: () => ref.read(productFilterNotifierProvider.notifier).updateBrand(null),
              ),
            if (filter.category != null)
              CustomFilterChip(
                label: 'Category: ${filter.category}',
                onRemove: () =>
                    ref.read(productFilterNotifierProvider.notifier).updateCategory(null),
              ),
            if (filter.gender != null)
              CustomFilterChip(
                label: 'Gender: ${filter.gender}',
                onRemove: () => ref.read(productFilterNotifierProvider.notifier).updateGender(null),
              ),
            if (filter.minPrice != null || filter.maxPrice != null)
              CustomFilterChip(
                label:
                    'Price: ${filter.minPrice != null ? '\$${filter.minPrice}' : ''}${(filter.minPrice != null && filter.maxPrice != null) ? ' - ' : ''}${filter.maxPrice != null ? '\$${filter.maxPrice}' : ''}',
                onRemove: () =>
                    ref.read(productFilterNotifierProvider.notifier).updatePriceRange(null, null),
              ),
          ],
        ),
      ),
    );
  }
}
