import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class EditAttractionScreen extends StatefulWidget {
  final Map<String, dynamic> attraction;

  const EditAttractionScreen({super.key, required this.attraction});

  @override
  State<EditAttractionScreen> createState() => _EditAttractionScreenState();
}

class _EditAttractionScreenState extends State<EditAttractionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;
  final _picker = ImagePicker();

  dynamic _imageFile;
  Uint8List? _imageBytes;
  bool _isLoading = false;
  bool _isFeatured = false;

  // Controllers
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _priceController;
  late final TextEditingController _categoryController;
  late final TextEditingController _hoursController;
  late final TextEditingController _websiteController;
  late final TextEditingController _phoneController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _isFeatured = widget.attraction['is_featured'] ?? false;
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.attraction['name']);
    _descriptionController =
        TextEditingController(text: widget.attraction['description']);
    _locationController =
        TextEditingController(text: widget.attraction['location']);
    _priceController =
        TextEditingController(text: widget.attraction['price']?.toString());
    _categoryController =
        TextEditingController(text: widget.attraction['category']);
    _hoursController =
        TextEditingController(text: widget.attraction['opening_hours']);
    _websiteController =
        TextEditingController(text: widget.attraction['website']);
    _phoneController = TextEditingController(text: widget.attraction['phone']);
    _latitudeController =
        TextEditingController(text: widget.attraction['latitude']);
    _longitudeController =
        TextEditingController(text: widget.attraction['longitude']);
  }

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
      if (mounted) {
        _showError('Failed to pick image: ${e.toString()}');
      }
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
      throw Exception('Failed to upload image: ${e.toString()}');
    }
  }

  Future<void> _updateAttraction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImage();
      }

      final attractionData = {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'location': _locationController.text.trim(),
        'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
        'category': _categoryController.text.trim(),
        'opening_hours': _hoursController.text.trim(),
        'website': _websiteController.text.trim(),
        'phone': _phoneController.text.trim(),
        'is_featured': _isFeatured,
        'latitude': _latitudeController.text.trim(),
        'longitude': _longitudeController.text.trim(),
        'updated_at': DateTime.now().toIso8601String(),
        if (imageUrl != null) 'image_url': imageUrl,
      };

      await _supabase
          .from('attractions')
          .update(attractionData)
          .eq('id', widget.attraction['id']);

      if (mounted) {
        _showSuccess('Attraction updated successfully!');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        _showError('Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 236, 30, 30),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 19, 207, 116),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
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
        title: const Text('Edit Attraction'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: _isLoading
                ? const CircularProgressIndicator()
                : Icon(Icons.save_rounded, color: Colors.white),
            onPressed: _isLoading ? null : _updateAttraction,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Picker Section
              _buildImagePicker(),
              const SizedBox(height: 24),

              // Featured Toggle
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: colorScheme.outline.withAlpha(100),
                    width: 1,
                  ),
                ),
                child: SwitchListTile(
                  title: Text(
                    'Featured Attraction',
                    style: theme.textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    'Show this attraction in featured section',
                    style: theme.textTheme.bodySmall,
                  ),
                  value: _isFeatured,
                  onChanged: (value) => setState(() => _isFeatured = value),
                ),
              ),
              const SizedBox(height: 24),

              // Section Header
              Text(
                'Basic Information',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),

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
              Text(
                'Location & Details',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),

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
              Text(
                'Contact Information',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),

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

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateAttraction,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'UPDATE ATTRACTION',
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
        Text(
          'Attraction Image',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: colorScheme.surfaceContainerHighest,
              border: Border.all(
                color: colorScheme.outline.withAlpha(100),
                width: 1,
              ),
            ),
            child: _imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: kIsWeb
                        ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                        : Image.file(_imageFile!, fit: BoxFit.cover),
                  )
                : widget.attraction['image_url'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: widget.attraction['image_url'],
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: colorScheme.surfaceContainerLow,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: colorScheme.surfaceContainerLow,
                            child: Center(
                              child: Icon(
                                Icons.broken_image_rounded,
                                size: 48,
                                color: colorScheme.error,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_rounded,
                            size: 48,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap to change image',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
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
        prefixIcon: Icon(
          icon,
          color: colorScheme.onSurface.withAlpha(180),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withAlpha(120),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outline.withAlpha(120),
          ),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
      ),
      style: theme.textTheme.bodyMedium,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
    );
  }
}
