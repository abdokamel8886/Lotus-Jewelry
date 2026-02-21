import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/admin_random_lists.dart';
import '../../core/theme/app_theme.dart';
import '../providers/app_providers.dart';

/// Admin – minimal form: name, desc, price, discount, category, 3 images; rest from dropdowns (edit admin_random_lists.dart).
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
  final _discountController = TextEditingController(text: '0');
  final _image1Controller = TextEditingController();
  final _image2Controller = TextEditingController();
  final _image3Controller = TextEditingController();

  String _category = AdminRandomLists.categories.first;
  String? _selectedColor;
  String? _selectedMaterial;
  String? _selectedSize;
  String? _selectedCare;
  String? _selectedBrand;
  String? _selectedDelivery;
  String? _selectedTag;
  String? _selectedBadge;
  String? _selectedOccasion;
  String? _selectedGender;
  String? _selectedStockStatus;
  String? _selectedCollection;
  bool _inStock = true;
  bool _isUploading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _image1Controller.dispose();
    _image2Controller.dispose();
    _image3Controller.dispose();
    super.dispose();
  }

  Future<void> _uploadProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUploading = true);

    try {
      final images = <String>[
        _image1Controller.text.trim(),
        _image2Controller.text.trim(),
        _image3Controller.text.trim(),
      ].where((e) => e.isNotEmpty).toList();

      final inStock = _selectedStockStatus != 'Out of Stock';
      final stock = _selectedStockStatus == 'Low Stock'
          ? 3
          : (_selectedStockStatus == 'Pre-order' ? 0 : 10);

      final data = <String, dynamic>{
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': double.tryParse(_priceController.text.trim()) ?? 0,
        'discount': int.tryParse(_discountController.text.trim()) ?? 0,
        'category': _category,
        'images': images,
        'inStock': inStock,
        'stock': stock,
      };

      if (_selectedColor != null && _selectedColor!.isNotEmpty) {
        data['color'] = _selectedColor;
      }
      if (_selectedMaterial != null && _selectedMaterial!.isNotEmpty) {
        data['material'] = _selectedMaterial;
      }
      if (_selectedSize != null && _selectedSize!.isNotEmpty) {
        final sizeOpts = AdminRandomLists.sizeOptionsForCategory(_category);
        data['size'] = sizeOpts;
      }
      if (_selectedCare != null && _selectedCare!.isNotEmpty) {
        data['care'] = _selectedCare;
      }
      if (_selectedBrand != null && _selectedBrand!.isNotEmpty) {
        data['brand'] = _selectedBrand;
      }
      if (_selectedDelivery != null && _selectedDelivery!.isNotEmpty) {
        data['delivery'] = _selectedDelivery;
      }
      if (_selectedTag != null && _selectedTag!.isNotEmpty) {
        data['tags'] = [_selectedTag!];
      }
      if (_selectedBadge != null && _selectedBadge!.isNotEmpty) {
        data['badge'] = _selectedBadge;
      }
      if (_selectedOccasion != null && _selectedOccasion!.isNotEmpty) {
        data['occasion'] = _selectedOccasion;
      }
      if (_selectedGender != null && _selectedGender!.isNotEmpty) {
        data['gender'] = _selectedGender;
      }
      if (_selectedCollection != null && _selectedCollection!.isNotEmpty) {
        data['collection'] = _selectedCollection;
      }

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
    _discountController.text = '0';
    _image1Controller.clear();
    _image2Controller.clear();
    _image3Controller.clear();
    setState(() {
      _category = AdminRandomLists.categories.first;
      _selectedColor = null;
      _selectedMaterial = null;
      _selectedSize = null;
      _selectedCare = null;
      _selectedBrand = null;
      _selectedDelivery = null;
      _selectedTag = null;
      _selectedBadge = null;
      _selectedOccasion = null;
      _selectedGender = null;
      _selectedStockStatus = null;
      _selectedCollection = null;
      _inStock = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeOptions = AdminRandomLists.sizeOptionsForCategory(_category);
    final tagOptions = AdminRandomLists.tagsForCategory(_category);

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
                  labelText: 'Name *',
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
                        if (double.tryParse(v.trim()) == null) return 'Invalid';
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
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Category *',
                  border: OutlineInputBorder(),
                ),
                items: AdminRandomLists.categories
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c[0].toUpperCase() + c.substring(1)),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() {
                      _category = v;
                      _selectedSize = null;
                      _selectedTag = null;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _image1Controller,
                decoration: const InputDecoration(
                  labelText: 'Image 1 URL',
                  hintText: 'https://...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _image2Controller,
                decoration: const InputDecoration(
                  labelText: 'Image 2 URL',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _image3Controller,
                decoration: const InputDecoration(
                  labelText: 'Image 3 URL',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Optional (from lists – edit lib/core/constants/admin_random_lists.dart)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 12),
              _dropdown('Color', _selectedColor, AdminRandomLists.colors, (v) => setState(() => _selectedColor = v)),
              const SizedBox(height: 12),
              _dropdown('Material', _selectedMaterial, AdminRandomLists.materials, (v) => setState(() => _selectedMaterial = v)),
              if (sizeOptions.isNotEmpty) ...[
                const SizedBox(height: 12),
                _dropdown('Size / Length', _selectedSize, sizeOptions, (v) => setState(() => _selectedSize = v)),
              ],
              const SizedBox(height: 12),
              _dropdown('Care', _selectedCare, AdminRandomLists.care, (v) => setState(() => _selectedCare = v)),
              const SizedBox(height: 12),
              _dropdown('Brand', _selectedBrand, AdminRandomLists.brands, (v) => setState(() => _selectedBrand = v)),
              const SizedBox(height: 12),
              _dropdown('Delivery', _selectedDelivery, AdminRandomLists.delivery, (v) => setState(() => _selectedDelivery = v)),
              const SizedBox(height: 12),
              _dropdown('Tag', _selectedTag, tagOptions, (v) => setState(() => _selectedTag = v)),
              const SizedBox(height: 12),
              _dropdown('Badge', _selectedBadge, AdminRandomLists.badges, (v) => setState(() => _selectedBadge = v)),
              const SizedBox(height: 12),
              _dropdown('Occasion', _selectedOccasion, AdminRandomLists.occasions, (v) => setState(() => _selectedOccasion = v)),
              const SizedBox(height: 12),
              _dropdown('Gender', _selectedGender, AdminRandomLists.genders, (v) => setState(() => _selectedGender = v)),
              const SizedBox(height: 12),
              _dropdown('Stock status', _selectedStockStatus, AdminRandomLists.stockStatus, (v) => setState(() => _selectedStockStatus = v)),
              const SizedBox(height: 12),
              _dropdown('Collection', _selectedCollection, AdminRandomLists.collections, (v) => setState(() => _selectedCollection = v)),
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

  Widget _dropdown(
    String label,
    String? value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value ?? (options.isNotEmpty ? null : null),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem<String>(value: null, child: Text('— None —')),
        ...options.map((o) => DropdownMenuItem(value: o, child: Text(o))),
      ],
      onChanged: onChanged,
    );
  }
}
