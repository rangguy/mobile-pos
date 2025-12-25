import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../domain/entities/product.dart';
import '../bloc/product_bloc.dart';

class ProductFormPage extends StatefulWidget {
  final Product? product; // null for create, non-null for edit
  final String? scannedCode; // Pre-filled code from barcode scanner

  const ProductFormPage({
    super.key,
    this.product,
    this.scannedCode,
  });

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _priceBuyController;
  late final TextEditingController _priceSaleController;
  late final TextEditingController _stockController;
  late final TextEditingController _unitController;

  bool get isEditMode => widget.product != null;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data or scanned code
    _codeController = TextEditingController(
      text: widget.product?.code ?? widget.scannedCode ?? '',
    );
    _nameController = TextEditingController(
      text: widget.product?.name ?? '',
    );
    _priceBuyController = TextEditingController(
      text: widget.product?.priceBuy.toString() ?? '',
    );
    _priceSaleController = TextEditingController(
      text: widget.product?.priceSale.toString() ?? '',
    );
    _stockController = TextEditingController(
      text: widget.product?.stock.toString() ?? '',
    );
    _unitController = TextEditingController(
      text: widget.product?.unit ?? '',
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _priceBuyController.dispose();
    _priceSaleController.dispose();
    _stockController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final code = _codeController.text.trim();
      final name = _nameController.text.trim();
      final priceBuy = int.parse(_priceBuyController.text.trim());
      final priceSale = int.parse(_priceSaleController.text.trim());
      final stock = int.parse(_stockController.text.trim());
      final unit = _unitController.text.trim();

      if (isEditMode) {
        // Show confirmation dialog for update
        _showUpdateConfirmation(
          code: code.isEmpty ? null : code,
          name: name,
          priceBuy: priceBuy,
          priceSale: priceSale,
          stock: stock,
          unit: unit,
        );
      } else {
        // Create new product directly
        context.read<ProductBloc>().add(
              ProductEvent.create(
                code: code.isEmpty ? null : code,
                name: name,
                priceBuy: priceBuy,
                priceSale: priceSale,
                stock: stock,
                unit: unit,
              ),
            );
      }
    }
  }

  void _showUpdateConfirmation({
    required String? code,
    required String name,
    required int priceBuy,
    required int priceSale,
    required int stock,
    required String unit,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Update Product'),
        content: Text('Are you sure you want to update "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // Update existing product
              context.read<ProductBloc>().add(
                    ProductEvent.update(
                      uuid: widget.product!.uuid,
                      code: code,
                      name: name,
                      priceBuy: priceBuy,
                      priceSale: priceSale,
                      stock: stock,
                      unit: unit,
                    ),
                  );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _scanBarcode() async {
    // Import mobile_scanner at the top of the file
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => _BarcodeScannerDialog(),
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _codeController.text = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Product' : 'Add Product'),
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          state.whenOrNull(
            operationSuccess: (message, product) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: Colors.green,
                ),
              );
              // Navigate back to product list
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
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
          final isLoading = state is ProductStateLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.scannedCode != null)
                    Card(
                      color: Colors.blue.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(Icons.qr_code, color: Colors.blue.shade700),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Scanned code: ${widget.scannedCode}',
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (widget.scannedCode != null) const SizedBox(height: 16),
                  TextFormField(
                    controller: _codeController,
                    decoration: InputDecoration(
                      labelText: 'Product Code (Optional)',
                      hintText: 'Enter product code or scan barcode',
                      prefixIcon: const Icon(Icons.qr_code),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.qr_code_scanner),
                        onPressed: isLoading ? null : _scanBarcode,
                        tooltip: 'Scan Barcode',
                      ),
                    ),
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name *',
                      hintText: 'Enter product name',
                      prefixIcon: Icon(Icons.inventory_2),
                    ),
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter product name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _priceBuyController,
                    decoration: const InputDecoration(
                      labelText: 'Purchase Price *',
                      hintText: 'Enter purchase price',
                      prefixIcon: Icon(Icons.attach_money),
                      prefixText: 'Rp ',
                    ),
                    keyboardType: TextInputType.number,
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter purchase price';
                      }
                      final price = int.tryParse(value.trim());
                      if (price == null || price < 0) {
                        return 'Please enter a valid price (whole number)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _priceSaleController,
                    decoration: const InputDecoration(
                      labelText: 'Sale Price *',
                      hintText: 'Enter sale price',
                      prefixIcon: Icon(Icons.sell),
                      prefixText: 'Rp ',
                    ),
                    keyboardType: TextInputType.number,
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter sale price';
                      }
                      final price = int.tryParse(value.trim());
                      if (price == null || price < 0) {
                        return 'Please enter a valid price (whole number)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _stockController,
                    decoration: const InputDecoration(
                      labelText: 'Stock *',
                      hintText: 'Enter stock quantity',
                      prefixIcon: Icon(Icons.inventory),
                    ),
                    keyboardType: TextInputType.number,
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter stock quantity';
                      }
                      final stock = int.tryParse(value.trim());
                      if (stock == null || stock < 0) {
                        return 'Please enter a valid stock quantity';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _unitController,
                    decoration: const InputDecoration(
                      labelText: 'Unit *',
                      hintText: 'e.g., pcs, kg, box',
                      prefixIcon: Icon(Icons.scale),
                    ),
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter unit';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: isLoading ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            isEditMode ? 'Update Product' : 'Create Product'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Simple barcode scanner dialog for scanning product codes
class _BarcodeScannerDialog extends StatefulWidget {
  @override
  State<_BarcodeScannerDialog> createState() => _BarcodeScannerDialogState();
}

class _BarcodeScannerDialogState extends State<_BarcodeScannerDialog> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code != null && code.isNotEmpty) {
      Navigator.of(context).pop(code); // Return the scanned code
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Product Code'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onBarcodeDetected,
          ),
          // Scanning overlay
          CustomPaint(
            painter: _ScannerOverlayPainter(),
            child: Container(),
          ),
          // Instructions
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black54,
              child: const Column(
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 48,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Position barcode within the frame',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for scanner overlay
class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double scanAreaSize = size.width * 0.7;
    final double left = (size.width - scanAreaSize) / 2;
    final double top = (size.height - scanAreaSize) / 2;

    // Draw semi-transparent overlay
    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    canvas.drawPath(
      Path()
        ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
        ..addRect(Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize))
        ..fillType = PathFillType.evenOdd,
      backgroundPaint,
    );

    // Draw corner borders
    final borderPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    const cornerLength = 30.0;

    // Top-left corner
    canvas.drawLine(
      Offset(left, top),
      Offset(left + cornerLength, top),
      borderPaint,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left, top + cornerLength),
      borderPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(left + scanAreaSize, top),
      Offset(left + scanAreaSize - cornerLength, top),
      borderPaint,
    );
    canvas.drawLine(
      Offset(left + scanAreaSize, top),
      Offset(left + scanAreaSize, top + cornerLength),
      borderPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(left, top + scanAreaSize),
      Offset(left + cornerLength, top + scanAreaSize),
      borderPaint,
    );
    canvas.drawLine(
      Offset(left, top + scanAreaSize),
      Offset(left, top + scanAreaSize - cornerLength),
      borderPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(left + scanAreaSize, top + scanAreaSize),
      Offset(left + scanAreaSize - cornerLength, top + scanAreaSize),
      borderPaint,
    );
    canvas.drawLine(
      Offset(left + scanAreaSize, top + scanAreaSize),
      Offset(left + scanAreaSize, top + scanAreaSize - cornerLength),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
