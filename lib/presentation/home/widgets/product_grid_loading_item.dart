import 'package:flutter/material.dart';
import 'package:italist_mobile_assignment/core/constants/colors.dart';

/// A placeholder widget displayed in the product grid while product data is loading.
///
/// Shows grey boxes approximating the layout of a [ProductGridItem].
class ProductGridLoadingItem extends StatelessWidget {
  /// Creates a loading placeholder for the product grid.
  const ProductGridLoadingItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Placeholder
          const AspectRatio(
            aspectRatio: 1 / 1.2,
            child: DecoratedBox(
              // Use DecoratedBox for const background color
              decoration: BoxDecoration(
                color: placeholderColor, // Placeholder color
                // Consider matching corner radius if ProductGridItem clips image
                // borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
            ),
          ),
          // Text Placeholders
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DecoratedBox(
                  decoration: BoxDecoration(color: placeholderColor),
                  child: SizedBox(height: 10, width: 50),
                ),
                const SizedBox(height: 4),
                const DecoratedBox(
                  decoration: BoxDecoration(color: placeholderColor),
                  child: SizedBox(height: 12, width: double.infinity),
                ),
                const SizedBox(height: 2),
                const DecoratedBox(
                  decoration: BoxDecoration(color: placeholderColor),
                  child: SizedBox(height: 12, width: 100),
                ),
                const SizedBox(height: 6),
                const DecoratedBox(
                  decoration: BoxDecoration(color: placeholderColor),
                  child: SizedBox(height: 14, width: 70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
