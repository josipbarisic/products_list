import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer

/// A placeholder widget displayed while a product list item is loading.
///
/// Shows a shimmer effect mimicking the layout of [ProductListItem].
class ProductListLoadingItem extends StatelessWidget {
  const ProductListLoadingItem({super.key});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!, // Adjust colors as needed
        highlightColor: Colors.grey[100]!,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shimmer for Image
              Container(
                width: 80,
                height: 100,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              // Shimmer for Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: double.infinity, height: 16.0, color: Colors.white),
                    // Title line
                    const SizedBox(height: 5),
                    Container(width: double.infinity, height: 14.0, color: Colors.white),
                    // Brand line
                    const SizedBox(height: 5),
                    Container(width: 100.0, height: 14.0, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
