import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/product.dart';
import '../bloc/product_bloc.dart';
import 'barcode_scanner_page.dart';
import 'product_detail_page.dart';
import 'product_form_page.dart';

class ProductListPage extends StatefulWidget {
  final bool showAppBar;

  const ProductListPage({super.key, this.showAppBar = true});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const ProductEvent.loadAll());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('Products'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Logout',
                  onPressed: () async {
                    final shouldLogout = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    );

                    if (shouldLogout == true && context.mounted) {
                      context.read<AuthBloc>().add(const AuthEvent.logout());
                    }
                  },
                ),
              ],
            )
          : null,
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          state.whenOrNull(
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: Colors.red,
                ),
              );
            },
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: Text('No products loaded')),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (products) => _buildProductList(products),
            productFound: (product) => _buildProductList([product]),
            operationSuccess: (message, product) {
              // Reload products after create/update
              context.read<ProductBloc>().add(const ProductEvent.loadAll());
              return const Center(child: CircularProgressIndicator());
            },
            deleteSuccess: (_) {
              // Reload products after delete
              context.read<ProductBloc>().add(const ProductEvent.loadAll());
              return const Center(child: CircularProgressIndicator());
            },
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<ProductBloc>()
                          .add(const ProductEvent.loadAll());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add_product',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ProductBloc>(),
                    child: const ProductFormPage(),
                  ),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            heroTag: 'scan_barcode',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ProductBloc>(),
                    child: const BarcodeScannerPage(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('Scan'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(List<Product> products) {
    if (products.isEmpty) {
      return const Center(
        child: Text('No products found'),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductBloc>().add(const ProductEvent.loadAll());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  product.code == null || product.code!.isEmpty
                      ? '?'
                      : product.code!.length >= 2
                          ? product.code!.substring(0, 2)
                          : product.code!,
                ),
              ),
              title: Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Code: ${product.code ?? 'N/A'}'),
                  Text('Price: ${_currencyFormat.format(product.priceSale)}'),
                  Text('Stock: ${product.stock} ${product.unit}'),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailPage(product: product),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
