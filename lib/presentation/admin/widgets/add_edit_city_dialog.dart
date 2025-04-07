import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:citi_guide_app/models/city.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddEditCityDialog extends StatefulWidget {
  final City? city;
  final Function(City, Uint8List) onSave;

  const AddEditCityDialog({
    super.key,
    this.city,
    required this.onSave,
  });

  @override
  State<AddEditCityDialog> createState() => _AddEditCityDialogState();
}

class _AddEditCityDialogState extends State<AddEditCityDialog> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final Uuid _uuid = const Uuid();
  // final _supabase = Supabase.instance.client;

  dynamic _imageFile;
  Uint8List? _imageBytes;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.city != null) {
      _nameController.text = widget.city!.name;
      _descriptionController.text = widget.city!.description ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (widget.city == null && _imageBytes == null) {
      _showError('Please select an image');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final city = City(
        id: widget.city?.id ?? _uuid.v4(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: widget.city?.imageUrl,
        createdAt: widget.city?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Modified error handling approach
      try {
        await widget.onSave(city, _imageBytes ?? Uint8List(0));
        if (mounted) Navigator.pop(context);
      } on PostgrestException catch (e) {
        if (e.code == '403' && mounted) {
          Navigator.pushReplacementNamed(context, '/login');
          return;
        }
        rethrow;
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      if (!(e is PostgrestException && e.code == '403')) {
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
        backgroundColor: Colors.redAccent,
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

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.city == null ? '✨ Add New City ✨' : '✏️ Edit City',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Cute Image Picker
                _buildImagePicker(),
                const SizedBox(height: 20),
                
                // City Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'City Name',
                    prefixIcon: const Icon(Icons.location_city_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerLow,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter city name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    prefixIcon: const Icon(Icons.description_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerLow,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Save City'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 180,
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
            child: _imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: kIsWeb
                        ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                        : Image.file(_imageFile!, fit: BoxFit.cover),
                  )
                : widget.city?.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          widget.city!.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                            _buildPlaceholderContent(),
                        ),
                      )
                    : _buildPlaceholderContent(),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'City Image',
          style: theme.textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurface.withAlpha(180),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderContent() {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate_rounded,
          size: 48,
          color: colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          'Tap to add image',
          style: TextStyle(
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}