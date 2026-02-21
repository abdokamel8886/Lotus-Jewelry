import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../providers/app_providers.dart';

/// Admin page - upload products to Firebase Realtime Database
class AdminView extends ConsumerStatefulWidget {
  const AdminView({super.key});

  @override
  ConsumerState<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends ConsumerState<AdminView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imagesController = TextEditingController(); // one URL per line
  final _colorController = TextEditingController();
  final _materialController = TextEditingController();
  final _discountController = TextEditingController(text: '0');
  final _ratingsController = TextEditingController();
  final _sizeController = TextEditingController();
  final _stockController = TextEditingController(text: '10');
  final _weightController = TextEditingController();
  final _lengthController = TextEditingController();
  final _tagsController = TextEditingController(); // comma separated
  final _badgeController = TextEditingController();
  final _careController = TextEditingController();
  final _brandController = TextEditingController();
  final _deliveryController = TextEditingController();

  bool _inStock = true;
  bool _isUploading = false;
  String _category = 'rings';

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imagesController.dispose();
    _colorController.dispose();
    _materialController.dispose();
    _discountController.dispose();
    _ratingsController.dispose();
    _sizeController.dispose();
    _stockController.dispose();
    _weightController.dispose();
    _lengthController.dispose();
    _tagsController.dispose();
    _badgeController.dispose();
    _careController.dispose();
    _brandController.dispose();
    _deliveryController.dispose();
    super.dispose();
  }

  Future<void> _uploadProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUploading = true);

    try {
      final imagesStr = _imagesController.text.trim();
      final images = imagesStr.isEmpty
          ? <String>[]
          : imagesStr.split(RegExp(r'[\n,]+')).map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

      final tagsStr = _tagsController.text.trim();
      final tags = tagsStr.isEmpty
          ? <String>[]
          : tagsStr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

      final data = <String, dynamic>{
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': double.tryParse(_priceController.text.trim()) ?? 0,
        'images': images,
        'category': _category,
        'inStock': _inStock,
        'discount': int.tryParse(_discountController.text.trim()) ?? 0,
        'stock': int.tryParse(_stockController.text.trim()) ?? 0,
      };

      if (_colorController.text.trim().isNotEmpty) data['color'] = _colorController.text.trim();
      if (_materialController.text.trim().isNotEmpty) data['material'] = _materialController.text.trim();
      if (_ratingsController.text.trim().isNotEmpty) {
        data['ratings'] = double.tryParse(_ratingsController.text.trim());
      }
      final sizeStr = _sizeController.text.trim();
      if (sizeStr.isNotEmpty) {
        final sizes = sizeStr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        data['size'] = sizes.length == 1 ? sizes.first : sizes;
      }
      if (_weightController.text.trim().isNotEmpty) {
        final w = num.tryParse(_weightController.text.trim());
        if (w != null) data['weight'] = w;
      }
      if (_lengthController.text.trim().isNotEmpty) data['length'] = _lengthController.text.trim();
      if (tags.isNotEmpty) data['tags'] = tags;
      if (_badgeController.text.trim().isNotEmpty) data['badge'] = _badgeController.text.trim();
      if (_careController.text.trim().isNotEmpty) data['care'] = _careController.text.trim();
      if (_brandController.text.trim().isNotEmpty) data['brand'] = _brandController.text.trim();
      if (_deliveryController.text.trim().isNotEmpty) data['delivery'] = _deliveryController.text.trim();

      final db = ref.read(firebaseRealtimeDbManagerProvider);
      final key = await db.addProduct(data);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product uploaded. ID: $key'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ),
        );
        _clearForm();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _imagesController.clear();
    setState(() => _category = 'rings');
    _colorController.clear();
    _materialController.clear();
    _discountController.text = '0';
    _ratingsController.clear();
    _sizeController.clear();
    _stockController.text = '10';
    _weightController.clear();
    _lengthController.clear();
    _tagsController.clear();
    _badgeController.clear();
    _careController.clear();
    _brandController.clear();
    _deliveryController.clear();
    setState(() {
      _category = 'rings';
      _inStock = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      appBar: AppBar(
        title: const Text('Admin – Add Product'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.charcoal,
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).pushReplacementNamed(AppConstants.routeHome),
            icon: const Icon(Icons.store),
            label: const Text('Shop'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product name *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Price *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        if (double.tryParse(v.trim()) == null) return 'Invalid number';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _discountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Discount %',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imagesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Image URLs (one per line or comma-separated)',
                  hintText: 'https://...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'rings', child: Text('Rings')),
                  DropdownMenuItem(value: 'necklaces', child: Text('Necklaces')),
                  DropdownMenuItem(value: 'bracelets', child: Text('Bracelets')),
                  DropdownMenuItem(value: 'earrings', child: Text('Earrings')),
                  DropdownMenuItem(value: 'watches', child: Text('Watches')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _category = v);
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _colorController,
                      decoration: const InputDecoration(
                        labelText: 'Color',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _materialController,
                      decoration: const InputDecoration(
                        labelText: 'Material',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Stock',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _ratingsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Ratings (e.g. 4.5)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _sizeController,
                      decoration: const InputDecoration(
                        labelText: 'Sizes (comma-separated: 14, 15, 16)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Weight (g)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lengthController,
                decoration: const InputDecoration(
                  labelText: 'Length (e.g. 45cm)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags (comma-separated)',
                  hintText: 'gold, ring, luxury',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _badgeController,
                decoration: const InputDecoration(
                  labelText: 'Badge (e.g. Best Seller)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _careController,
                decoration: const InputDecoration(
                  labelText: 'Care (e.g. Clean with soft cloth)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(
                  labelText: 'Brand (e.g. L\'azurde)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deliveryController,
                decoration: const InputDecoration(
                  labelText: 'Delivery (e.g. 3-5 business days)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('In stock'),
                value: _inStock,
                onChanged: (v) => setState(() => _inStock = v),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _uploadProduct,
                  child: _isUploading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Upload Product'),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _isUploading ? null : _clearForm,
                child: const Text('Clear form'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
