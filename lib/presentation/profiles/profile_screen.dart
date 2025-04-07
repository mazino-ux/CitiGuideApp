import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _supabase = Supabase.instance.client;
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  
  dynamic _imageFile;
  Uint8List? _imageBytes;
  bool _isLoading = false;
  bool _isEditing = false;
  
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _bioController = TextEditingController();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Immediately check auth status without loading indicator
    if (_supabase.auth.currentUser == null) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/login');
        });
      }
      return;
    }
    
    // Only load profile if user is authenticated
    await _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (!mounted) return;
    
    setState(() => _isLoading = true);
    
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
        return;
      }
      
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      
      if (response != null) {
        _usernameController.text = response['username'] ?? '';
        _bioController.text = response['bio'] ?? '';
        _avatarUrl = response['avatar_url'];
      }
    } catch (e) {
      if (mounted) {
        if (e is PostgrestException && e.code == '403') {
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          _showError('Error loading profile: ${e.toString()}');
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
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

    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
      return null;
    }

    final fileExtension = kIsWeb ? '.jpg' : '.${_imageFile.path.split('.').last}';
    final fileName = 'avatars/$userId$fileExtension';

    try {
      // First try to remove existing avatar if it exists
      try {
        await _supabase.storage.from('avatars').remove([fileName]);
      } catch (e) {
        if (!e.toString().contains('not found')) {
          debugPrint('Error removing old avatar: $e');
        }
      }

      // Upload the new file with overwrite option
      if (kIsWeb) {
        await _supabase.storage
            .from('avatars')
            .uploadBinary(fileName, _imageBytes!, fileOptions: FileOptions(
              upsert: true,
            ));
      } else {
        await _supabase.storage
            .from('avatars')
            .upload(fileName, _imageFile, fileOptions: FileOptions(
              upsert: true,
            ));
      }
      
      // Get public URL with cache-busting timestamp
      final url = _supabase.storage.from('avatars').getPublicUrl(fileName);
      return '$url?t=${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      if (e is PostgrestException && e.code == '403' && mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        _showError('Failed to upload image: ${e.toString()}');
      }
      return null;
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
        return;
      }

      String? newAvatarUrl;
      if (_imageFile != null) {
        newAvatarUrl = await _uploadImage();
        if (newAvatarUrl == null) return; // Upload failed or unauthorized
      }

      final response = await _supabase.from('profiles').upsert({
        'id': userId,
        'username': _usernameController.text.trim(),
        'bio': _bioController.text.trim(),
        if (newAvatarUrl != null) 'avatar_url': newAvatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'id').select().single();

      if (mounted) {
        _showSuccess('Profile updated successfully!');
        setState(() {
          _isEditing = false;
          _avatarUrl = response['avatar_url'] ?? _avatarUrl;
        });
      }
    } catch (e) {
      if (e is PostgrestException && e.code == '403' && mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        _showError('Error saving profile: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
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

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.greenAccent,
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
        title: const Text('My Profile'),
        centerTitle: true,
        actions: [
          if (_isEditing)
            IconButton(
              icon: _isLoading
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.save_rounded),
              onPressed: _isLoading ? null : _saveProfile,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Profile Picture Section
                    _buildAvatarSection(colorScheme),
                    const SizedBox(height: 32),

                    // Profile Info
                    _buildProfileInfoSection(theme, colorScheme),
                    const SizedBox(height: 24),

                    // Edit/Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_isEditing) {
                            _saveProfile();
                          } else {
                            setState(() => _isEditing = true);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: _isEditing 
                              ? colorScheme.primary 
                              : colorScheme.surfaceContainerHighest,
                          foregroundColor: _isEditing 
                              ? colorScheme.onPrimary 
                              : colorScheme.onSurfaceVariant,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : Text(
                                _isEditing ? 'SAVE PROFILE' : 'EDIT PROFILE',
                                style: const TextStyle(
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

  Widget _buildAvatarSection(ColorScheme colorScheme) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.outline.withAlpha(80),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: _buildAvatarImage(),
              ),
            ),
            if (_isEditing)
              FloatingActionButton.small(
                onPressed: _pickImage,
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
                child: const Icon(Icons.edit_rounded),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          '@${_usernameController.text}',
          style: TextStyle(
            fontSize: 18,
            color: colorScheme.onSurface.withAlpha(200),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarImage() {
    if (_imageFile != null) {
      return kIsWeb
          ? Image.memory(_imageBytes!, fit: BoxFit.cover)
          : Image.file(_imageFile!, fit: BoxFit.cover);
    }
    if (_avatarUrl != null) {
      return CachedNetworkImage(
        imageUrl: _avatarUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        errorWidget: (context, url, error) => _buildDefaultAvatar(),
      );
    }
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Icon(
      Icons.person_rounded,
      size: 60,
      color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
    );
  }

  Widget _buildProfileInfoSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Information',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        
        // Username Field
        TextFormField(
          controller: _usernameController,
          enabled: _isEditing,
          decoration: InputDecoration(
            labelText: 'Username',
            prefixIcon: Icon(
              Icons.alternate_email_rounded,
              color: colorScheme.onSurface.withAlpha(180),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: _isEditing 
                ? colorScheme.surfaceContainerLow
                : colorScheme.surfaceContainerHigh,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a username';
            }
            if (value.length < 3) {
              return 'Username must be at least 3 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Bio Field
        TextFormField(
          controller: _bioController,
          enabled: _isEditing,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Bio',
            alignLabelWithHint: true,
            prefixIcon: Icon(
              Icons.info_outline_rounded,
              color: colorScheme.onSurface.withAlpha(180),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: _isEditing 
                ? colorScheme.surfaceContainerLow
                : colorScheme.surfaceContainerHigh,
            hintText: 'Tell us about yourself...',
          ),
        ),
      ],
    );
  }
}