import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:scholarwheels/controllers/child_controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_textfield.dart';
import 'package:scholarwheels/core/helper.widgets/custom_network_image.dart';
import 'package:scholarwheels/core/helper.widgets/location_field.dart';
import 'package:scholarwheels/controllers/image_upload_controller.dart';
import 'package:scholarwheels/models/child_model.dart';
import 'package:scholarwheels/models/location_data_model.dart';
import 'package:scholarwheels/services/api_state.dart';

import '../../core/helper.widgets/space_helper.dart';

class EditChildScreen extends StatefulWidget {
  static const route = '/edit-children';
  const EditChildScreen({super.key});

  @override
  State<EditChildScreen> createState() => _EditChildScreenState();
}

class _EditChildScreenState extends State<EditChildScreen> {
  final ChildController childController = Get.find<ChildController>();
  final ImageUploadController imageUploadController =
      Get.find<ImageUploadController>();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String? childId;
  File? _profileImage;
  String? _existingProfileImageUrl; // For display (profileImagePresignedUrl)
  String? _originalProfileImagePath; // Original profileImage path from server
  bool _isImageDeleted = false; // Track if user wants to delete image
  String _childInitials = '';

  @override
  void initState() {
    super.initState();
    // Get child ID from arguments
    childId = Get.arguments as String?;
    // Load child data if ID is provided
    if (childId != null) {
      _loadChildData();
    }
  }

  void _loadChildData() {
    // Find the child from the list and load data
    if (childController.childrenState.value is DataState<List<ChildModel>>) {
      final state =
          childController.childrenState.value as DataState<List<ChildModel>>;
      try {
        final child = state.data.firstWhere((c) => c.id == childId);

        // Reset image-related flags
        _isImageDeleted = false;
        _profileImage = null;

        childController.nameController.text = child.name ?? '';
        childController.ageController.text = child.age?.toString() ?? '';
        childController.schoolController.text = child.schoolDescription ?? '';
        // Note: Email is not stored in the child model, keeping field empty
        childController.emailController.text = child.user?.email ?? '';
        childController.pickUpAddressController.text =
            child.pickUpAddressDescription ?? '';
        childController.dropOffAddressController.text =
            child.dropOffAddressDescription ?? '';

        // Load location data if it's LocationData model
        if (child.pickUpAddress is LocationData) {
          childController.pickUpAddressLocationData =
              child.pickUpAddress as LocationData;
        }
        if (child.dropOffAddress is LocationData) {
          childController.dropOffAddressLocationData =
              child.dropOffAddress as LocationData;
        }
        childController.primaryContactNumberController.text =
            child.primaryContactNumber ?? '';
        childController.secondaryContactNumberController.text =
            child.secondaryContactNumber ?? '';

        // Load profile image URL for display (use profileImagePresignedUrl)
        _existingProfileImageUrl = child.user?.profileImagePresignedUrl;
        // Store original profileImage path for comparison
        _originalProfileImagePath = child.user?.profileImage;

        // Get first 2 characters of name (first char of first name + first char of last name, or first 2 chars if single word)
        if (child.name != null && child.name!.isNotEmpty) {
          final nameParts = child.name!
              .trim()
              .split(' ')
              .where((part) => part.isNotEmpty)
              .toList();
          if (nameParts.length >= 2) {
            // First char of first name + first char of last name
            _childInitials =
                (nameParts[0][0] + nameParts[nameParts.length - 1][0])
                    .toUpperCase();
          } else if (nameParts.length == 1 && nameParts[0].length >= 2) {
            // First 2 characters if single word
            _childInitials = nameParts[0].substring(0, 2).toUpperCase();
          } else if (nameParts.length == 1 && nameParts[0].length == 1) {
            // Single character
            _childInitials = nameParts[0][0].toUpperCase();
          } else {
            _childInitials = 'C';
          }
        } else {
          _childInitials = 'C';
        }
      } catch (e) {
        // Child not found
      }
    }
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
          _profileImage = file;
          _existingProfileImageUrl =
              null; // Clear existing URL when new image is selected
          _isImageDeleted =
              false; // Reset delete flag when new image is selected
        });

        // Upload image and get URL
        final imageUrl = await imageUploadController.uploadImage(file);
        if (imageUrl != null && mounted) {
          // Store new image URL in controller (this will be sent as profileImage)
          childController.profileImagePath = imageUrl;
        }
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          'Failed to pick image: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> _removePhoto() async {
    setState(() {
      _profileImage = null;
      _existingProfileImageUrl = null;
      _isImageDeleted = true; // Mark that user wants to delete image
    });
    // Clear in controller - empty string will be sent to API to delete image
    childController.profileImagePath = '';
  }

  void _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (childId != null) {
        // Determine profileImage value:
        // - If image deleted: send empty string
        // - If new image uploaded: send new image path (already set in _pickImage)
        // - If no change: send original path (or empty string if no original)
        if (_isImageDeleted) {
          // User wants to delete image - send empty string
          childController.profileImagePath = '';
        } else if (childController.profileImagePath == null ||
            childController.profileImagePath!.isEmpty) {
          // No new image uploaded and not deleted - keep original if exists
          childController.profileImagePath = _originalProfileImagePath ?? '';
        }
        // If profileImagePath already has a value (new image), use it as-is

        await childController.updateChild(childId!);
      }
    }
  }

  void _clearFields() {
    childController.nameController.clear();
    childController.ageController.clear();
    childController.schoolController.clear();
    childController.emailController.clear();
    childController.pickUpAddressController.clear();
    childController.dropOffAddressController.clear();
    childController.primaryContactNumberController.clear();
    childController.secondaryContactNumberController.clear();
    // Reset image-related state
    _profileImage = null;
    _existingProfileImageUrl = null;
    _originalProfileImagePath = null;
    _isImageDeleted = false;
    childController.profileImagePath = null;
  }

  @override
  void dispose() {
    _clearFields();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        elevation: 1,
        shadowColor: Colors.grey,
        leading: backButton(
          onTap: () {
            Get.back();
          },
        ),
        centerTitle: false,

        title: Text(
          'Edit Details',
          style: poppinFonts(fontSize: xl, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: childController.nameController,
                  label: "Name",
                  hintText: "Enter Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),

                CustomTextField(
                  controller: childController.emailController,
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

                CustomTextField(
                  controller: childController.ageController,
                  label: "Age",
                  hintText: "Enter age",
                  isNumericKeyboard: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Age is required';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid age';
                    }
                    return null;
                  },
                ),

                CustomTextField(
                  controller: childController.schoolController,
                  label: "School",
                  hintText: "Enter School",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'School is required';
                    }
                    return null;
                  },
                ),

                CustomTextField(
                  controller: childController.primaryContactNumberController,
                  label: "Primary Contact",
                  hintText: "Enter Primary Contact",
                  isNumericKeyboard: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Primary contact is required';
                    }
                    return null;
                  },
                ),

                CustomTextField(
                  controller: childController.secondaryContactNumberController,
                  label: "Secondary Contact",
                  hintText: "Enter Secondary Contact",
                  isNumericKeyboard: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Secondary contact is required';
                    }
                    return null;
                  },
                ),

                LocationField(
                  controller: childController.pickUpAddressController,
                  label: "Pickup Address",
                  hintText: "Enter Pickup Address",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pickup address is required';
                    }
                    return null;
                  },
                  onLocationSelected: (locationData) {
                    childController.pickUpAddressLocationData = locationData;
                  },
                ),

                LocationField(
                  controller: childController.dropOffAddressController,
                  label: "Drop-off Address/School",
                  hintText: "Enter Drop-off Address",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Drop-off address is required';
                    }
                    return null;
                  },
                  onLocationSelected: (locationData) {
                    childController.dropOffAddressLocationData = locationData;
                  },
                ),

                SpaceHelper(h: 12.h),

                // Profile Picture Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Picture Circle - Large avatar
                    Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.textFieldBorderColor,
                          width: 1,
                        ),
                        color: AppColor.bgGrayD9D8D8,
                      ),
                      child: _profileImage != null
                          ? ClipOval(
                              child: Image.file(
                                _profileImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : _existingProfileImageUrl != null &&
                                _existingProfileImageUrl!.isNotEmpty
                          ? ClipOval(
                              child: CustomNetworkImageWidget(
                                imageUrl: _existingProfileImageUrl!,
                                width: 120.w,
                                height: 120.w,
                                borderRadius: 60.w,
                                fit: BoxFit.cover,
                                errorWidget: Center(
                                  child: Text(
                                    _childInitials,
                                    style: poppinFonts(
                                      color: AppColor.black,
                                      fontSize: lg,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                _childInitials,
                                style: poppinFonts(
                                  color: AppColor.black,
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                    ),
                    SpaceHelper(w: 16.w),
                    // Change Photo and Remove Photo buttons
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: imageUploadController.isUploading.value
                                ? null
                                : _pickImage,
                            child: Container(
                              width: 132.w,
                              height: 32.h,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColor.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: AppColor.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(
                                    () =>
                                        imageUploadController.isUploading.value
                                        ? SizedBox(
                                            width: 12.w,
                                            height: 12.w,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : SvgPicture.asset(
                                            'assets/images/svg/download.svg',
                                            width: 16.w,
                                            height: 16.w,
                                          ),
                                  ),
                                  SpaceHelper(w: 8.w),
                                  Obx(
                                    () =>
                                        imageUploadController.isUploading.value
                                        ? SizedBox()
                                        : Text(
                                            "Change Photo",
                                            style: poppinFonts(
                                              fontSize: xs,
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.black,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SpaceHelper(h: 8.h),
                          InkWell(
                            onTap: imageUploadController.isDeleting.value
                                ? null
                                : _removePhoto,
                            child: Container(
                              height: 32.h,
                              width: 132.w,
                              padding: EdgeInsets.symmetric(horizontal: 1.w),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red, width: 1),
                                borderRadius: BorderRadius.circular(8),
                                color: AppColor.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(
                                    () => imageUploadController.isDeleting.value
                                        ? SizedBox(
                                            width: 12.w,
                                            height: 12.w,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.red,
                                            ),
                                          )
                                        : Container(
                                            child: SvgPicture.asset(
                                              'assets/images/svg/close.svg',
                                              width: 16.w,
                                              height: 16.w,
                                            ),
                                          ),
                                  ),
                                  SpaceHelper(w: 8.w),
                                  Obx(
                                    () => imageUploadController.isDeleting.value
                                        ? SizedBox()
                                        : Text(
                                            "Remove Photo",
                                            style: poppinFonts(
                                              fontSize: xs,
                                              fontWeight: FontWeight.w500,
                                              color: AppColor.redColor2,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SpaceHelper(h: 12.h),
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
                                fontWeight: FontWeight.w500,
                                fontSize: base,
                                color: AppColor.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SpaceHelper(w: 12.w),
                    Expanded(
                      child: Obx(() {
                        final isSaving = childController.isLoading.value;
                        final isUploading =
                            imageUploadController.isUploading.value;
                        final isDisabled = isSaving || isUploading;

                        return CustomButton(
                          title: "Save",
                          isLoading: isSaving,
                          onPressed: isDisabled ? null : _handleSave,
                        );
                      }),
                    ),
                  ],
                ),
                SpaceHelper(h: 22.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
