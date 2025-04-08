import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddAttractionScreen extends StatefulWidget {
  final String cityId;
  const AddAttractionScreen({super.key, required this.cityId});

  @override
  State<AddAttractionScreen> createState() => _AddAttractionScreenState();
}

class _AddAttractionScreenState extends State<AddAttractionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;
  final _picker = ImagePicker();

  dynamic _imageFile;
  Uint8List? _imageBytes;
  bool _isLoading = false;
  bool _isFeatured = false;

  // Form controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _hoursController = TextEditingController();
  final _websiteController = TextEditingController();
  final _phoneController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _hoursController.dispose();
    _websiteController.dispose();
    _phoneController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageFile = pickedFile;
          _imageBytes = bytes;
        });
      } else {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showError('Failed to pick image: ${e.toString()}');
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageFile == null) return null;

    final fileExtension =
        kIsWeb ? '.jpg' : '.${_imageFile.path.split('.').last}';
    final fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExtension';
    final filePath = 'attractions/$fileName';

    try {
      if (kIsWeb) {
        await _supabase.storage
            .from('attractions')
            .uploadBinary(filePath, _imageBytes!);
      } else {
        await _supabase.storage
            .from('attractions')
            .upload(filePath, _imageFile);
      }
      return _supabase.storage.from('attractions').getPublicUrl(filePath);
    } catch (e) {
      // Handle 403 unauthorized error
      if (e is StorageException && e.statusCode == '403') {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
        return null;
      }
      throw Exception('Failed to upload image: ${e.toString()}');
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      _showError('Please select an image');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final imageUrl = await _uploadImage();
      if (imageUrl == null) return; // Upload failed and redirected

      final attractionData = {
        'city_id': widget.cityId,
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'location': _locationController.text.trim(),
        'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
        'category': _categoryController.text.trim(),
        'opening_hours': _hoursController.text.trim(),
        'website': _websiteController.text.trim(),
        'phone': _phoneController.text.trim(),
        'image_url': imageUrl,
        'created_at': DateTime.now().toIso8601String(),
        'is_featured': _isFeatured,
        'latitude': _latitudeController.text.trim(),
        'longitude': _longitudeController.text.trim(),
        'rating': 0.0,
      };

      await _supabase
          .from('attractions')
          .insert(attractionData)
          .onError((error, _) {
        // Handle 403 unauthorized error
        if (error is PostgrestException && error.code == '403') {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/login');
          }
          return;
        }
        throw error!;
      });

      _showSuccess('Attraction added successfully!');
      if (mounted) Navigator.pop(context);
    } catch (e) {
      // Only show error if not a 403 (already redirected)
      if (!(e is PostgrestException && e.code == '403') &&
          !(e is StorageException && e.statusCode == '403')) {
        _showError('Error: ${e.toString()}');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 205, 17, 17),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 8, 153, 83),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Attraction'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: _isLoading
                ? const CircularProgressIndicator()
                : const Icon(Icons.save_rounded, color: Colors.white),
            onPressed: _isLoading ? null : _submitForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cute Image Picker
              _buildImagePicker(),
              const SizedBox(height: 24),

              // Featured Toggle - Extra Cute Version
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withAlpha(60),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: _isFeatured
                          ? Colors.amber
                          : colorScheme.onSurface.withAlpha(150),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Feature this attraction',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const Spacer(),
                    Switch(
                      value: _isFeatured,
                      onChanged: (value) => setState(() => _isFeatured = value),
                      activeColor: Colors.amber,
                      activeTrackColor: Colors.amber.withAlpha(100),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Section Header
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: Text(
                  'Basic Information',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),

              // Name Field
              _buildTextField(
                controller: _nameController,
                label: 'Attraction Name',
                icon: Icons.place_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter attraction name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description Field
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                icon: Icons.description_rounded,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  if (value.length < 30) {
                    return 'Description should be at least 30 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Section Header
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: Text(
                  'Location & Details',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),

              // Location Field
              _buildTextField(
                controller: _locationController,
                label: 'Location',
                icon: Icons.location_on_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),

              // Location Field
              _buildTextField(
                controller: _latitudeController,
                label: 'Latitude',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                icon: Icons.map_sharp,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter latitude';
                  }
                  return null;
                },
              ),
              // Location Field
              _buildTextField(
                controller: _longitudeController,
                label: 'Longitude',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                icon: Icons.map_sharp,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter longitude';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Price & Category Row
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _priceController,
                      label: 'Price (\$)',
                      icon: Icons.attach_money_rounded,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _categoryController,
                      label: 'Category',
                      icon: Icons.category_rounded,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter category';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Hours Field
              _buildTextField(
                controller: _hoursController,
                label: 'Opening Hours',
                icon: Icons.access_time_rounded,
                hintText: 'e.g. 9:00 AM - 5:00 PM',
              ),
              const SizedBox(height: 24),

              // Section Header
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: Text(
                  'Contact Information',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),

              // Website Field
              _buildTextField(
                controller: _websiteController,
                label: 'Website',
                icon: Icons.public_rounded,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),

              // Phone Field
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Icons.phone_rounded,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),

              // Super Cute Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: colorScheme.primaryContainer,
                    foregroundColor: colorScheme.onPrimaryContainer,
                    elevation: 0,
                  ),
                  icon: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.rocket_launch_rounded),
                  label: _isLoading
                      ? const Text('Creating...')
                      : const Text(
                          'Launch Attraction!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            'Attraction Image',
            style: theme.textTheme.titleMedium,
          ),
        ),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: colorScheme.surfaceContainerHigh,
              border: Border.all(
                color: colorScheme.outline.withAlpha(80),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withAlpha(30),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _imageFile == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_rounded,
                        size: 48,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tap to add image',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Recommended: 16:9 ratio',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withAlpha(150),
                        ),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: kIsWeb
                        ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                        : Image.file(_imageFile!, fit: BoxFit.cover),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hintText,
    int? maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: colorScheme.outline.withAlpha(50),
                width: 1,
              ),
            ),
          ),
          child: Icon(
            icon,
            color: colorScheme.primary,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHigh,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      style: theme.textTheme.bodyLarge,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
    );
  }
}
