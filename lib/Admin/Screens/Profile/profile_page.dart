import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../theme/theme.dart';
import '../../theme/theme_provider.dart';
import 'services/preferences_service.dart';
import 'services/validation_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  bool _isLoading = false;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Validation error states
  Map<String, String?> _validationErrors = {};

  // Profile data controllers
  final TextEditingController nameController = TextEditingController(
    text: 'Sarah Johnson',
  );
  final TextEditingController usernameController = TextEditingController(
    text: 'sarahj',
  );
  final TextEditingController phoneController = TextEditingController(
    text: '+1 (555) 123-4567',
  );
  final TextEditingController emailController = TextEditingController(
    text: 'sarah.johnson@example.com',
  );
  final TextEditingController dobController = TextEditingController(
    text: 'June 15, 1995',
  );
  String selectedGender = 'Female';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    dobController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    try {
      final profileData = await PreferencesService.getProfileData();
      if (profileData != null) {
        setState(() {
          nameController.text = profileData['name'] ?? 'Sarah Johnson';
          usernameController.text = profileData['username'] ?? 'sarahj';
          phoneController.text = profileData['phone'] ?? '+1 (555) 123-4567';
          emailController.text =
              profileData['email'] ?? 'sarah.johnson@example.com';
          dobController.text = profileData['dateOfBirth'] ?? 'June 15, 1995';
          selectedGender = profileData['gender'] ?? 'Female';
        });
      }
    } catch (e) {
      debugPrint('Failed to load profile data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.backgroundColor,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: const Color(0xFFB19CD9),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'My Profile',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 40),
                  _buildPersonalInfoSection(),
                  const SizedBox(height: 150),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AdminTheme.primaryPurple,
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 57,
                    backgroundColor: AdminTheme.primaryPurple,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _showImagePickerDialog,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: themeProvider.surfaceColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AdminTheme.primaryPurple,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Text(
              nameController.text,
              style: TextStyle(
                color: themeProvider.textColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              emailController.text,
              style: TextStyle(
                color: themeProvider.subtitleColor,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 32),

            if (isEditing)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: themeProvider.subtitleColor,
                        width: 1,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: _discardChanges,
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: themeProvider.subtitleColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 120,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AdminTheme.primaryPurple,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: _isLoading ? null : _saveChanges,
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.save,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Save',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              Container(
                width: 160,
                height: 48,
                decoration: BoxDecoration(
                  color: AdminTheme.primaryPurple,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildPersonalInfoSection() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Information',
                style: TextStyle(
                  color: themeProvider.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              Container(
                decoration: BoxDecoration(
                  color: themeProvider.surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: themeProvider.borderColor,
                    width: 1,
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildInfoField('Full Name', nameController, 'name'),
                        _buildDivider(),
                        _buildInfoField(
                          'Username',
                          usernameController,
                          'username',
                        ),
                        _buildDivider(),
                        _buildInfoField(
                          'Phone Number',
                          phoneController,
                          'phone',
                        ),
                        _buildDivider(),
                        _buildInfoField('Email', emailController, 'email'),
                        _buildDivider(),
                        _buildDateInfoField(
                          'Date of Birth',
                          dobController.text,
                        ),
                        _buildDivider(),
                        _buildGenderField('Gender', selectedGender),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoField(
    String label,
    TextEditingController controller,
    String fieldKey,
  ) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: themeProvider.subtitleColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              if (isEditing)
                TextFormField(
                  controller: controller,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                    color: themeProvider.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: themeProvider.subtitleColor.withValues(
                          alpha: 0.3,
                        ),
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: themeProvider.subtitleColor.withValues(
                          alpha: 0.3,
                        ),
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AdminTheme.primaryPurple,
                        width: 2,
                      ),
                    ),
                    errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedErrorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    errorText: _validationErrors[fieldKey],
                    errorStyle: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                  validator: (value) => _getValidator(fieldKey)(value),
                  onChanged: (newValue) {
                    if (_validationErrors[fieldKey] != null) {
                      setState(() {
                        _validationErrors[fieldKey] = null;
                      });
                    }
                  },
                )
              else
                Text(
                  controller.text,
                  style: TextStyle(
                    color: themeProvider.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateInfoField(String label, String value) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: themeProvider.subtitleColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              if (isEditing)
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: themeProvider.subtitleColor.withOpacity(0.3),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dobController.text,
                          style: TextStyle(
                            color: themeProvider.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.calendar_today,
                          color: themeProvider.subtitleColor,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                )
              else
                Text(
                  value,
                  style: TextStyle(
                    color: themeProvider.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGenderField(String label, String value) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: themeProvider.subtitleColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              if (isEditing)
                GestureDetector(
                  onTap: _showGenderDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: themeProvider.subtitleColor.withOpacity(0.3),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedGender,
                          style: TextStyle(
                            color: themeProvider.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: themeProvider.subtitleColor,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                )
              else
                Text(
                  value,
                  style: TextStyle(
                    color: themeProvider.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDivider() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          height: 1,
          color: themeProvider.subtitleColor.withOpacity(0.2),
        );
      },
    );
  }

  // Validation helper methods
  String? Function(String?) _getValidator(String fieldKey) {
    switch (fieldKey) {
      case 'name':
        return ValidationService.validateName;
      case 'username':
        return ValidationService.validateUsername;
      case 'email':
        return ValidationService.validateEmail;
      case 'phone':
        return ValidationService.validatePhone;
      default:
        return (value) => null;
    }
  }

  Future<bool> _validateForm() async {
    final validationResults = ValidationService.validateProfileForm(
      name: nameController.text,
      username: usernameController.text,
      email: emailController.text,
      phone: phoneController.text,
      dateOfBirth: dobController.text,
    );

    setState(() {
      _validationErrors = validationResults;
    });

    return !ValidationService.hasErrors(validationResults);
  }

  Future<void> _saveChanges() async {
    if (!await _validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ValidationService.getFirstError(_validationErrors) ??
                'Please fix the errors',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final profileData = {
        'name': nameController.text,
        'username': usernameController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'dateOfBirth': dobController.text,
        'gender': selectedGender,
      };

      await PreferencesService.saveProfileData(profileData);

      setState(() {
        isEditing = false;
        _isLoading = false;
        _validationErrors.clear();
      });

      FocusScope.of(context).unfocus();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: AdminTheme.primaryPurple,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _discardChanges() {
    setState(() {
      isEditing = false;
      _validationErrors.clear();
    });

    _loadProfileData(); // Reload original data

    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Changes discarded'),
        backgroundColor: Colors.grey,
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995, 6, 15),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child2) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.dark(
                  primary: AdminTheme.primaryPurple,
                  onPrimary: Colors.white,
                  surface: themeProvider.surfaceColor,
                  onSurface: themeProvider.textColor,
                ),
              ),
              child: child!,
            );
          },
        );
      },
    );
    if (picked != null) {
      setState(() {
        const months = [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        ];
        dobController.text =
            '${months[picked.month - 1]} ${picked.day}, ${picked.year}';
      });
    }
  }

  void _showGenderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return AlertDialog(
              backgroundColor: themeProvider.surfaceColor,
              title: Text(
                'Select Gender',
                style: TextStyle(color: themeProvider.textColor),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: ['Male', 'Female', 'Other'].map((gender) {
                  return ListTile(
                    title: Text(
                      gender,
                      style: TextStyle(color: themeProvider.textColor),
                    ),
                    leading: Radio<String>(
                      value: gender,
                      groupValue: selectedGender,
                      onChanged: (String? value) {
                        setState(() {
                          selectedGender = value!;
                        });
                        Navigator.of(context).pop();
                      },
                      activeColor: AdminTheme.primaryPurple,
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return AlertDialog(
              backgroundColor: themeProvider.surfaceColor,
              title: Text(
                'Select Profile Picture',
                style: TextStyle(color: themeProvider.textColor),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.camera_alt,
                      color: AdminTheme.primaryPurple,
                    ),
                    title: Text(
                      'Take Photo',
                      style: TextStyle(color: themeProvider.textColor),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.photo_library,
                      color: AdminTheme.primaryPurple,
                    ),
                    title: Text(
                      'Choose from Gallery',
                      style: TextStyle(color: themeProvider.textColor),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                  if (_profileImage != null)
                    ListTile(
                      leading: const Icon(Icons.delete, color: Colors.red),
                      title: Text(
                        'Remove Photo',
                        style: TextStyle(color: themeProvider.textColor),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _profileImage = null;
                        });
                      },
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated'),
            backgroundColor: AdminTheme.primaryPurple,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
