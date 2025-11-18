import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/controllers/auth_controller.dart';
import 'package:scholarwheels/controllers/image_upload_controller.dart';
import 'package:scholarwheels/core/helper.constants/color.dart';
import 'package:scholarwheels/core/helper.constants/textStyle.dart';
import 'package:scholarwheels/core/helper.widgets/custom_button.dart';
import 'package:scholarwheels/core/helper.widgets/custom_toaster.dart';
import 'package:scholarwheels/core/helper.widgets/space_helper.dart';
import 'package:scholarwheels/screens/auth/profile_screen.dart';

class ProfilePictureScreen extends StatefulWidget {
  static const route = '/profile-picture';
  const ProfilePictureScreen({super.key});

  @override
  State<ProfilePictureScreen> createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  final AuthController authController = Get.find<AuthController>();
  final ImageUploadController imageUploadController =
      Get.find<ImageUploadController>();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImageFile;

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
        });

        // Upload image and get URL
        final imageUrl = await imageUploadController.uploadImage(file);
        if (imageUrl != null && mounted) {
          print('imageUrl: $imageUrl');
          // Store URL in controller
          authController.profileImagePath = imageUrl;
        }
      }
    } catch (e) {
      if (mounted) {
        customToaster('Failed to pick image: $e', color: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 52.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BaseHelper.getLogo(width: 160, height: 100),
              Column(
                children: [
                  Text(
                    'Profile Picture',
                    style: poppinFonts(
                      fontWeight: FontWeight.w600,
                      fontSize: 28,
                    ),
                  ),
                  Text(
                    'Add a profile picture to personalize your account',
                    textAlign: TextAlign.center,
                    style: poppinFonts(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: AppColor.lightGreenColorText,
                    ),
                  ),
                ],
              ),
              SpaceHelper(h: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: imageUploadController.isUploading.value
                        ? null
                        : _pickImage,
                    child: Obx(() {
                      final hasImage = _selectedImageFile != null;

                      return Container(
                        width: 120.w,
                        height: 120.w,
                        padding: hasImage
                            ? EdgeInsets.zero
                            : EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColor.primary, width: 2),
                          color: AppColor.white,
                        ),
                        child: imageUploadController.isUploading.value
                            ? Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : _selectedImageFile != null
                            ? ClipOval(
                                child: Image.file(
                                  _selectedImageFile!,
                                  width: 120.w,
                                  height: 120.w,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : SvgPicture.asset(
                                'assets/images/svg/bag-icon.svg',
                              ),
                      );
                    }),
                  ),
                ],
              ),
              SpaceHelper(h: 24),
              Obx(
                () => CustomButton(
                  onPressed: () {
                    Get.toNamed(ProfileScreen.route);
                  },
                  title: "Continue",
                  isDisabled: imageUploadController.isUploading.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
