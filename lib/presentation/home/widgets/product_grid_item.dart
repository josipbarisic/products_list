import 'package:flutter/material.dart';
import 'package:italist_mobile_assignment/data/models/product/product_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductGridItem extends StatelessWidget {
  final ProductModel product;

  const ProductGridItem({
    super.key,
    required this.product,
  });

  // Helper to parse price string
  String _formatPrice(String priceString) {
    // Keep only digits and the first dot, and prefix with currency if needed
    final cleaned = priceString.replaceAll(RegExp(r'[^\d.]'), '');
    // Re-add currency symbol or format as needed
    return '\$${double.tryParse(cleaned)?.toStringAsFixed(2) ?? priceString}';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias, // Clip the image to the card shape
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(product.link)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            AspectRatio(
              aspectRatio: 1 / 1.2, // Adjust aspect ratio for image display
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  color: Colors.white, // Placeholder color
                ),
                child: Image.network(
                  product.imageLink,
                  fit: BoxFit.fitHeight,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image, color: Colors.grey[400]),
                    );
                  },
                ),
              ),
            ),
            // Text Content Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand
                    Text(
                      product.brand,
                      style: textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Title
                    Text(
                      product.title,
                      style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                      maxLines: 2, // Allow two lines for title
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Prices
                    Row(
                      children: [
                        Text(
                          _formatPrice(product.salePrice),
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary, // Use primary color for sale price
                          ),
                        ),
                        if (product.salePrice !=
                            product.listPrice) // Show list price only if different
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                _formatPrice(product.listPrice),
                                style: textTheme.bodySmall?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey[500],
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
