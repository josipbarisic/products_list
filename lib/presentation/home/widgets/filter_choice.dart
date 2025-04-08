import 'package:flutter/material.dart';

/// A customizable choice chip used for filtering options.
///
/// Wraps Flutter's [FilterChip] widget, providing a consistent appearance
/// for filter selections.
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
  Widget build(BuildContext context) => FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: onSelected,
        checkmarkColor: Theme.of(context).colorScheme.primary,
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
      );
}
