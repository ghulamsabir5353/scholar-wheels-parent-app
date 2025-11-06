import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/base.helper.controller.dart';
import '../../core/helper.constants/color.dart';
import '../../core/helper.constants/font_sized.dart';
import '../../core/helper.constants/textStyle.dart';
import '../../core/helper.widgets/back_button.dart';
import '../../core/helper.widgets/custom_button.dart';
import '../../core/helper.widgets/custom_textfield.dart';
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
  }

  void _handleSaveChanges() async {
    if (_formKey.currentState?.validate() ?? false) {
      await authController.updateUser();
    }
  }

  void _clearFields() {
    authController.firstNameController.clear();
    authController.surNameController.clear();
    authController.emailController.clear();
    authController.phoneController.clear();
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
          title: Text(
            'Personal Profile',
            style: poppinFonts(fontSize: lg, fontWeight: FontWeight.w500),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Profile picture
                  Card(
                    color: Colors.white,
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 42,
                            backgroundColor: AppColor.white,
                            child: Image.asset('assets/images/png/profile.png'),
                          ),
                          SpaceHelper(w: 6.w),
                          GestureDetector(
                            onTap: () {
                              // TODO: Implement image picker
                            },
                            child: SvgPicture.asset(
                              'assets/images/svg/edit_icon.svg',
                            ),
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
                    hintText: "Enter Phone",
                    isNumericKeyboard: true,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone is required';
                      }
                      return null;
                    },
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
                            isLoading: authController.isLoading.value,
                            onPressed: authController.isLoading.value
                                ? null
                                : _handleSaveChanges,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
