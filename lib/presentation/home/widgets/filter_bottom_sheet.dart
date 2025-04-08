import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:italist_mobile_assignment/presentation/home/providers/product_filter_provider.dart';
import 'package:italist_mobile_assignment/presentation/home/widgets/filter_choice.dart';

class FilterBottomSheet extends HookConsumerWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(productFilterNotifierProvider);

    // List of available brands, categories, and genders (you would typically get this from data)
    final brands = ['Lo Decor', 'Michael Kors', 'Nike', 'Adidas', 'Gucci', 'Prada', 'Calvin Klein'];
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
