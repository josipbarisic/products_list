import 'dart:developer';

import 'package:flutter/material.dart';

class CustomFilterChip extends StatelessWidget {
  final String label;
  final Function() onRemove;

  const CustomFilterChip({
    super.key,
    required this.label,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Chip(
          label: Text(label),
          deleteIcon: const Icon(Icons.close, size: 16),
          onDeleted: () {
            log('Removing filter: $label');
            onRemove();
          },
        ),
      );
}
