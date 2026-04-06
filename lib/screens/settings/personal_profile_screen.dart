import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/base.helper.controller.dart';
import '../../controllers/image_upload_controller.dart';
import '../../core/helper.constants/color.dart';
import '../../core/helper.constants/font_sized.dart';
import '../../core/helper.constants/textStyle.dart';
import '../../core/helper.constants/validators.dart';
import '../../core/helper.widgets/back_button.dart';
import '../../core/helper.widgets/custom_button.dart';
import '../../core/helper.widgets/custom_network_image.dart';
import '../../core/helper.widgets/custom_textfield.dart';
import '../../core/helper.widgets/custom_toaster.dart';
import '../../core/helper.widgets/space_helper.dart';

class PersonalProfileScreen extends StatefulWidget {
  static const route = '/personal-profile';
  const PersonalProfileScreen({super.key});

  @override
  State<PersonalProfileScreen> createState() => _PersonalProfileScreenState();
}

class _PersonalProfileScreenState extends State<PersonalProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.find<AuthController>();
  final ImageUploadController imageUploadController =
      Get.find<ImageUploadController>();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImageFile;
  String? _existingProfileImageUrl;
  String? _originalProfileImagePath;
  bool _isImageDeleted = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = BaseHelper.currentUser.value;
    authController.firstNameController.text = user.firstName ?? '';
    authController.surNameController.text = user.surName ?? '';
    authController.emailController.text = user.email ?? '';
    authController.phoneController.text = user.phone ?? '';

    // Load profile image URL for display
    _existingProfileImageUrl =
        user.profileImagePresignedUrl ?? user.profileImage;
    _originalProfileImagePath = user.profileImage;
    _selectedImageFile = null;
    _isImageDeleted = false;
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (image != null) {
        final file = File(image.path);
        setState(() {
          _selectedImageFile = file;
          _existingProfileImageUrl =
              null; // Clear existing URL when new image is selected
          _isImageDeleted =
              false; // Reset delete flag when new image is selected
        });

        // Upload image and get URL
        final imageUrl = await imageUploadController.uploadImage(file);
        if (imageUrl != null && mounted) {
          // Store new image URL in controller (this will be sent as profileImage)
          authController.profileImagePath = imageUrl;
        }
      }
    } catch (e) {
      if (mounted) {
        customToaster('Failed to pick image: $e', color: Colors.red);
      }
    }
  }

  void _removePhoto() {
    setState(() {
      _selectedImageFile = null;
      _existingProfileImageUrl = null;
      _isImageDeleted = true; // Mark that user wants to delete image
    });
    // Clear in controller - empty string will be sent to API to delete image
    authController.profileImagePath = '';
  }

  void _handleSaveChanges() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Determine profileImage value:
      // - If image deleted: send empty string
      // - If new image uploaded: send new image path (already set in _pickImage)
      // - If no change: send original path (or empty string if no original)
      if (_isImageDeleted) {
        // User wants to delete image - send empty string
        authController.profileImagePath = '';
      } else if (authController.profileImagePath == null ||
          authController.profileImagePath!.isEmpty) {
        // No new image uploaded and not deleted - keep original if exists
        authController.profileImagePath = _originalProfileImagePath ?? '';
      }
      // If profileImagePath already has a value (new image), use it as-is

      await authController.updateUser();

      // Reload user data to sync local state after successful update
      if (mounted) {
        _loadUserData();
      }
    }
  }

  void _clearFields() {
    authController.firstNameController.clear();
    authController.surNameController.clear();
    authController.emailController.clear();
    authController.phoneController.clear();
    // Reset image-related state
    _selectedImageFile = null;
    _existingProfileImageUrl = null;
    _originalProfileImagePath = null;
    _isImageDeleted = false;
    authController.profileImagePath = null;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,

      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _clearFields();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.white,
          surfaceTintColor: AppColor.white,
          elevation: 1,
          shadowColor: Colors.grey,
          centerTitle: false,
          leading: backButton(onTap: () => Get.back()),
          titleSpacing: 0,
          title: Text(
            'Personal Profile',
            style: poppinFonts(fontSize: lg, fontWeight: FontWeight.w500),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
            child: Obx(() {
              final user = BaseHelper.currentUser.value;
              // Use selected image file if available, otherwise use existing URL, otherwise use user's current image
              final displayImageUrl = _selectedImageFile != null
                  ? null // Will show file image
                  : (_existingProfileImageUrl ??
                        user.profileImagePresignedUrl ??
                        user.profileImage);
              final firstName = user.firstName ?? '';
              final surName = user.surName ?? '';
              final fullName = '$firstName $surName'.trim();
              final initials = fullName.isNotEmpty
                  ? fullName.substring(0, 1).toUpperCase()
                  : 'U';

              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Profile picture
                    Card(
                      color: Colors.white,
                      elevation: 2,
                      shadowColor: AppColor.cardShadowColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 82.w,
                                  height: 82.w,

                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        (_selectedImageFile != null ||
                                            (displayImageUrl != null &&
                                                displayImageUrl.isNotEmpty))
                                        ? Colors.transparent
                                        : AppColor.darkPrimary,
                                  ),
                                  child: _selectedImageFile != null
                                      ? ClipOval(
                                          child: Image.file(
                                            _selectedImageFile!,
                                            width: 82.w,
                                            height: 82.w,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : displayImageUrl != null &&
                                            displayImageUrl.isNotEmpty
                                      ? ClipOval(
                                          child: CustomNetworkImageWidget(
                                            imageUrl: displayImageUrl,
                                            width: 82.w,
                                            height: 82.w,
                                            borderRadius: 42.r,
                                            fit: BoxFit.cover,
                                            errorWidget: Container(
                                              width: 82.w,
                                              height: 82.w,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColor.darkPrimary,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  initials,
                                                  style: poppinFonts(
                                                    color: Colors.white,
                                                    fontSize: lg,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            initials,
                                            style: poppinFonts(
                                              color: Colors.white,
                                              fontSize: lg,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                ),
                                if (imageUploadController.isUploading.value)
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            // show name ,email and phone number here
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 6.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      fullName,
                                      style: poppinFonts(
                                        fontSize: base,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SpaceHelper(h: 4.h),
                                    Text(
                                      user.email ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: poppinFonts(
                                        fontSize: sm,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SpaceHelper(h: 4.h),
                                    Text(
                                      user.phone ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: poppinFonts(
                                        fontSize: sm,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if ((_selectedImageFile != null ||
                                    (displayImageUrl != null &&
                                        displayImageUrl.isNotEmpty)))
                                  GestureDetector(
                                    onTap:
                                        imageUploadController.isUploading.value
                                        ? null
                                        : _removePhoto,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 8.w),
                                      child: Icon(
                                        Icons.delete_outline,
                                        size: 20.w,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                GestureDetector(
                                  onTap: imageUploadController.isUploading.value
                                      ? null
                                      : _pickImage,
                                  child: SvgPicture.asset(
                                    'assets/images/svg/edit_icon.svg',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SpaceHelper(h: 16.h),
                    // First Name
                    CustomTextField(
                      controller: authController.firstNameController,
                      label: "First Name",
                      hintText: "Enter First Name",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'First name is required';
                        }
                        return null;
                      },
                    ),
                    SpaceHelper(h: 12.h),
                    // Last Name (using surNameController)
                    CustomTextField(
                      controller: authController.surNameController,
                      label: "Last Name",
                      hintText: "Enter Last Name",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Last name is required';
                        }
                        return null;
                      },
                    ),
                    SpaceHelper(h: 12.h),
                    // Email
                    CustomTextField(
                      controller: authController.emailController,
                      label: "Email",
                      hintText: "Enter Email",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SpaceHelper(h: 12.h),
                    // Phone
                    CustomTextField(
                      controller: authController.phoneController,
                      label: "Phone",
                      hintText: "e.g. 0821234567",
                      isNumericKeyboard: true,
                      keyboardType: TextInputType.phone,
                      maxLength: Validators.southAfricaPhoneMaxLength,
                      validator: Validators.validateSouthAfricaPhone,
                    ),
                    SpaceHelper(h: 16.h),
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              width: double.infinity,
                              height: 36.h,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColor.secondary),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  "Cancel",
                                  style: poppinFonts(
                                    fontSize: base,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SpaceHelper(w: 12.w),
                        Expanded(
                          child: Obx(
                            () => CustomButton(
                              height: 36.h,
                              radius: 8,
                              title: "Save Changes",
                              isDisabled:
                                  authController.isLoading.value ||
                                  imageUploadController.isUploading.value,
                              isLoading: authController.isLoading.value,
                              onPressed: _handleSaveChanges,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
