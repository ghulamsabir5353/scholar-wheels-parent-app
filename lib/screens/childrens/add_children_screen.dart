import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scholarwheels/controllers/child_controller.dart';
import 'package:scholarwheels/controllers/image_upload_controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/font_sized.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/back_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_textfield.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/location_autocomplete_field.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';

class AddChildrenScreen extends StatefulWidget {
  static const route = '/add-children';
  const AddChildrenScreen({super.key});

  @override
  State<AddChildrenScreen> createState() => _AddChildrenScreenState();
}

class _AddChildrenScreenState extends State<AddChildrenScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final ImageUploadController imageUploadController =
      Get.find<ImageUploadController>();
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  final confirmPasswordController = TextEditingController();
  String? _profileImagePath;

  @override
  void dispose() {
    confirmPasswordController.dispose();
    super.dispose();
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
          _profileImagePath = image.path; // For display
        });

        // Upload image and get URL
        final imageUrl = await imageUploadController.uploadImage(file);
        if (imageUrl != null && mounted) {
          // Store URL in controller
          final ChildController childController = Get.find<ChildController>();
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

  void _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      final ChildController childController = Get.find<ChildController>();

      // Validate that passwords match
      if (childController.passwordController.text !=
          confirmPasswordController.text) {
        Get.snackbar(
          'Error',
          'Passwords do not match',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Call the create child API
      await childController.addChild();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ChildController childController = Get.find<ChildController>();

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
          'Add Children',
          style: poppinFonts(fontSize: xl, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
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
                SpaceHelper(h: 3.h),

                // Email Field
                CustomTextField(
                  controller: childController.emailController,
                  label: "Email",
                  hintText: "Enter Email",
                  keyboardType: TextInputType.emailAddress,
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

                SpaceHelper(h: 3.h),

                // Password Field
                CustomTextField(
                  controller: childController.passwordController,
                  label: "Password",
                  hintText: "Enter Password",
                  isObsecure: passwordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                  hasSuffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppColor.black,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                ),

                SpaceHelper(h: 3.h),

                // Confirm Password Field
                CustomTextField(
                  controller: confirmPasswordController,
                  label: "Confirm Password",
                  hintText: "Enter Confirm Password",
                  isObsecure: confirmPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm password is required';
                    }
                    if (value != childController.passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  hasSuffixIcon: IconButton(
                    icon: Icon(
                      confirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColor.black,
                    ),
                    onPressed: () {
                      setState(() {
                        confirmPasswordVisible = !confirmPasswordVisible;
                      });
                    },
                  ),
                ),

                SpaceHelper(h: 3.h),

                CustomTextField(
                  controller: childController.ageController,
                  label: "Age",
                  hintText: "Enter age",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Age is required';
                    }
                    return null;
                  },
                ),

                LocationAutocompleteField(
                  controller: childController.schoolController,
                  label: "School",
                  hintText: "Enter School",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'School is required';
                    }
                    return null;
                  },
                  onLocationSelected: (locationData) {
                    childController.schoolLocationData = locationData;
                  },
                ),

                CustomTextField(
                  controller: childController.primaryContactNumberController,
                  label: "Primary Contact Number",
                  hintText: "Enter Primary Contact Number",
                  isNumericKeyboard: true,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Primary contact is required';
                    }
                    return null;
                  },
                ),

                CustomTextField(
                  controller: childController.secondaryContactNumberController,
                  label: "Secondary Contact Number",
                  hintText: "Enter Secondary Contact Number",
                  isNumericKeyboard: true,
                  keyboardType: TextInputType.phone,
                ),

                LocationAutocompleteField(
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

                LocationAutocompleteField(
                  controller: childController.dropOffAddressController,
                  label: "Drop-off Address",
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

                SpaceHelper(h: 3.h),

                // Upload Photo Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Upload Photo",
                      style: poppinFonts(
                        color: Color(0xff212529),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SpaceHelper(h: 6.h),
                    Container(
                      height: 70.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColor.textFieldBorderColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: AppColor.appColorWhite,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: imageUploadController.isUploading.value
                                ? null
                                : _pickImage,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.backgroundColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Obx(
                                () => imageUploadController.isUploading.value
                                    ? SizedBox(
                                        width: 16.w,
                                        height: 16.w,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        "Upload Image",
                                        style: poppinFonts(
                                          fontSize: base,
                                          fontWeight: FontWeight.w500,
                                          color: AppColor
                                              .textLightBlackColor4A4A4A,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          SpaceHelper(w: 12.w),
                          Expanded(
                            child: Text(
                              _profileImagePath != null
                                  ? _profileImagePath!.split('/').last
                                  : "No file chosen",
                              style: poppinFonts(
                                fontSize: sm,
                                color: AppColor.textLightBlackColor4A4A4A,
                              ),
                              overflow: TextOverflow.ellipsis,
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
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
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
                          width: double.infinity,
                          title: "Save",
                          isLoading: childController.isLoading.value,
                          onPressed: childController.isLoading.value
                              ? null
                              : _handleSave,
                        ),
                      ),
                    ),
                  ],
                ),
                SpaceHelper(h: 12.w),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
