import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:italist_mobile_assignment/presentation/home/providers/filtered_products_provider.dart';
import 'package:italist_mobile_assignment/presentation/home/providers/product_filter_provider.dart';
import 'package:italist_mobile_assignment/presentation/widgets/product_list_item.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();

    // Listen to search text changes and update filter
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
            child: ref.watch(filteredProductsProvider).when(
                  data: (products) => products.isEmpty
                      ? const Center(
                          child: Text('No products found'),
                        )
                      : ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) =>
                              ProductListItem(product: products[index]),
                        ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stackTrace) {
                    log('Error: $error');
                    return Center(
                      child: Text('Error: $error'),
                    );
                  },
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
              _buildFilterChip(
                context,
                'Brand: ${filter.brand}',
                () => ref.read(productFilterNotifierProvider.notifier).updateBrand(null),
              ),
            if (filter.category != null)
              _buildFilterChip(
                context,
                'Category: ${filter.category}',
                () => ref.read(productFilterNotifierProvider.notifier).updateCategory(null),
              ),
            if (filter.gender != null)
              _buildFilterChip(
                context,
                'Gender: ${filter.gender}',
                () => ref.read(productFilterNotifierProvider.notifier).updateGender(null),
              ),
            if (filter.minPrice != null || filter.maxPrice != null)
              _buildFilterChip(
                context,
                'Price: ${filter.minPrice != null ? '\$${filter.minPrice}' : ''}${(filter.minPrice != null && filter.maxPrice != null) ? ' - ' : ''}${filter.maxPrice != null ? '\$${filter.maxPrice}' : ''}',
                () => ref.read(productFilterNotifierProvider.notifier).updatePriceRange(null, null),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, VoidCallback onRemove) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(label),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onRemove,
      ),
    );
  }
}

class FilterBottomSheet extends HookConsumerWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(productFilterNotifierProvider);

    // List of available brands, categories, and genders (you would typically get this from data)
    final brands = ['Lo Decor', 'Michael Kors', 'Nike', 'Adidas', 'Gucci', 'Prada'];
    final categories = ['Home Décor', 'Accessories', 'Clothing', 'Shoes', 'Bags'];
    final genders = ['male', 'female', 'unisex'];

    final selectedBrand = useState<String?>(filter.brand);
    final selectedCategory = useState<String?>(filter.category);
    final selectedGender = useState<String?>(filter.gender);
    final priceRange = useState<RangeValues>(RangeValues(
      filter.minPrice ?? 0,
      filter.maxPrice ?? 1000,
    ));

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter Products',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    const Text('Brand', style: TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8.0,
                      children: brands
                          .map((brand) => FilterChoice(
                                label: brand,
                                isSelected: brand == selectedBrand.value,
                                onSelected: (selected) {
                                  selectedBrand.value = selected ? brand : null;
                                },
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8.0,
                      children: categories
                          .map((category) => FilterChoice(
                                label: category,
                                isSelected: category == selectedCategory.value,
                                onSelected: (selected) {
                                  selectedCategory.value = selected ? category : null;
                                },
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8.0,
                      children: genders
                          .map((gender) => FilterChoice(
                                label: gender,
                                isSelected: gender == selectedGender.value,
                                onSelected: (selected) {
                                  selectedGender.value = selected ? gender : null;
                                },
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Price Range', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$${priceRange.value.start.toInt()}'),
                        Text('\$${priceRange.value.end.toInt()}'),
                      ],
                    ),
                    RangeSlider(
                      values: priceRange.value,
                      min: 0,
                      max: 1000,
                      divisions: 100,
                      onChanged: (values) {
                        priceRange.value = values;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ref.read(productFilterNotifierProvider.notifier).clearFilters();
                        Navigator.pop(context);
                      },
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        // Apply all filters
                        ref.read(productFilterNotifierProvider.notifier)
                          ..updateBrand(selectedBrand.value)
                          ..updateCategory(selectedCategory.value)
                          ..updateGender(selectedGender.value)
                          ..updatePriceRange(
                            priceRange.value.start > 0 ? priceRange.value.start : null,
                            priceRange.value.end < 1000 ? priceRange.value.end : null,
                          );
                        Navigator.pop(context);
                      },
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class FilterChoice extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;

  const FilterChoice({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      checkmarkColor: Theme.of(context).colorScheme.primary,
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}
