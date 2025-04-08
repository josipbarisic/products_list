import 'package:flutter/material.dart';

class ProductGridLoadingItem extends StatelessWidget {
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
          AspectRatio(
            aspectRatio: 1 / 1.2,
            child: Container(
              color: Colors.grey[300], // Placeholder color
            ),
          ),
          // Text Placeholders
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 10, width: 50, color: Colors.grey[300]),
                const SizedBox(height: 4),
                Container(height: 12, width: double.infinity, color: Colors.grey[300]),
                const SizedBox(height: 2),
                Container(height: 12, width: 100, color: Colors.grey[300]),
                const SizedBox(height: 6),
                Container(height: 14, width: 70, color: Colors.grey[300]),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 