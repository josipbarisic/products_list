import 'package:flutter/material.dart';
import 'package:product_list/core/constants/colors.dart';
import 'package:product_list/data/models/product/product_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

/// A widget that displays a single product in a grid layout.
///
/// Shows the product image, brand, title, and price.
/// Tapping the item attempts to launch the product's URL.
class ProductGridItem extends StatelessWidget {
  /// The product data to display.
  final ProductModel product;

  const ProductGridItem({
    super.key,
    required this.product,
  });

  /// Formats a price string (e.g., "150.00 USD") into a displayable currency format (e.g., "$150.00").
  ///
  /// Returns the original string if parsing fails.
  String _formatPrice(String priceString) {
    // Remove non-numeric characters except the decimal point.
    final cleanedPrice = priceString.replaceAll(RegExp(r'[^\d.]'), '');
    final priceValue = double.tryParse(cleanedPrice);
    return priceValue != null
        ? '\$${priceValue.toStringAsFixed(2)}'
        : priceString; // Format to 2 decimal places, Return original string as fallback
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(product.link)).catchError((e, st) {
          // Handle URL launch error
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to open the product link. Please try again.'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
          return false;
        }),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            AspectRatio(
              aspectRatio: 1 / 1.2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  color: Colors.white, // Placeholder color
                ),
                child: Image.network(
                  product.imageLink,
                  fit: BoxFit.scaleDown,
                  loadingBuilder: (context, child, loadingProgress) => loadingProgress == null
                      ? child
                      : Shimmer.fromColors(
                          baseColor: placeholderColor,
                          highlightColor: Colors.white,
                          child: Container(
                            color: placeholderColor,
                            child: Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        ),
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: placeholderColor,
                    child: Icon(Icons.broken_image, color: Colors.grey[400]),
                  ),
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
