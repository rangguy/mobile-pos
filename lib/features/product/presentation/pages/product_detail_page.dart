import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Icon(
                        Icons.inventory_2,
                        size: 80,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Product Name', product.name),
                    const Divider(),
                    _buildDetailRow('Product Code', product.code),
                    const Divider(),
                    _buildDetailRow('Unit', product.unit),
                    const Divider(),
                    _buildDetailRow(
                      'Purchase Price',
                      currencyFormat.format(product.priceBuy),
                    ),
                    const Divider(),
                    _buildDetailRow(
                      'Sale Price',
                      currencyFormat.format(product.priceSale),
                    ),
                    const Divider(),
                    _buildDetailRow(
                        'Stock', '${product.stock} ${product.unit}'),
                    const Divider(),
                    _buildDetailRow(
                      'Created At',
                      dateFormat.format(product.createdAt),
                    ),
                    const Divider(),
                    _buildDetailRow(
                      'Updated At',
                      dateFormat.format(product.updatedAt),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profit Margin',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currencyFormat
                          .format(product.priceSale - product.priceBuy),
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Text(
                      '${((product.priceSale - product.priceBuy) / product.priceBuy * 100).toStringAsFixed(1)}% margin',
                      style: Theme.of(context).textTheme.bodyMedium,
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
