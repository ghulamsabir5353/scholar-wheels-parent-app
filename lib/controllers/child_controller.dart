import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scholarwheels/controllers/base.helper.controller.dart';
import 'package:scholarwheels/models/child_model.dart';
import 'package:scholarwheels/models/location_data_model.dart';
import 'package:scholarwheels/services/api_services.dart';
import 'package:scholarwheels/services/api_state.dart';
import 'package:scholarwheels/core/helper.constants/strings.dart';
import 'package:scholarwheels/core/helper.widgets/custom_toaster.dart';

class ChildController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final RxBool isLoading = false.obs;
  final Rx<ViewState<List<ChildModel>>> childrenState =
      Rx<ViewState<List<ChildModel>>>(LoadingState());

  @override
  void onInit() {
    super.onInit();
    getChildrenList();
  }

  // Form controllers
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final schoolController = TextEditingController();
  final pickUpAddressController = TextEditingController();
  final dropOffAddressController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final primaryContactNumberController = TextEditingController();
  final secondaryContactNumberController = TextEditingController();

  // Profile data
  String? profileImagePath;

  // Location data
  LocationData? pickUpAddressLocationData;
  LocationData? dropOffAddressLocationData;

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    schoolController.dispose();
    pickUpAddressController.dispose();
    dropOffAddressController.dispose();
    emailController.dispose();
    passwordController.dispose();
    primaryContactNumberController.dispose();
    secondaryContactNumberController.dispose();
    super.dispose();
  }

  /// Add a new child
  Future<void> addChild() async {
    try {
      isLoading.value = true;

      final requestBody = {
        "email": emailController.text.trim(),
        "password": passwordController.text,
        "name": nameController.text.trim(),
        "age": ageController.text.trim(),
        "school": schoolController.text.trim(),
        "primaryContactNumber": primaryContactNumberController.text.trim(),
        "secondaryContactNumber": secondaryContactNumberController.text.trim(),
        "profileImage": profileImagePath ?? "",
        "pickUpAddress":
            pickUpAddressLocationData?.toJson() ??
            pickUpAddressController.text.trim(),
        "dropOffAddress":
            dropOffAddressLocationData?.toJson() ??
            dropOffAddressController.text.trim(),
      };

      final response = await apiService.createData(
        AppConstants.addChild,
        requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Child added successfully: ${response.data}');

        // Fetch fresh data from API
        await getChildrenList();

        customToaster('Child added successfully!', color: Colors.green);
        resetForm(); // Clear all form fields
        Get.back(); // Go back to previous screen
      } else {
        customToaster('Failed to add child', color: Colors.red);
      }
    } catch (e) {
      customToaster('Something went wrong', color: Colors.red);
      log('error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Reset form
  void resetForm() {
    nameController.clear();
    ageController.clear();
    schoolController.clear();
    pickUpAddressController.clear();
    dropOffAddressController.clear();
    emailController.clear();
    passwordController.clear();
    primaryContactNumberController.clear();
    secondaryContactNumberController.clear();
    profileImagePath = null;
    pickUpAddressLocationData = null;
    dropOffAddressLocationData = null;
  }

  /// Update child details
  Future<void> updateChild(String childId) async {
    try {
      isLoading.value = true;

      final requestBody = {
        "email": emailController.text.trim(),
        "password": passwordController.text,
        "name": nameController.text.trim(),
        "age": ageController.text.trim(),
        "school": schoolController.text.trim(),
        "primaryContactNumber": primaryContactNumberController.text.trim(),
        "secondaryContactNumber": secondaryContactNumberController.text.trim(),
        "profileImage": profileImagePath ?? "",
        "pickUpAddress":
            pickUpAddressLocationData?.toJson() ??
            pickUpAddressController.text.trim(),
        "dropOffAddress":
            dropOffAddressLocationData?.toJson() ??
            dropOffAddressController.text.trim(),
      };

      final endpoint = '${AppConstants.addChild}/$childId';
      final response = await apiService.patchData(endpoint, requestBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Child updated successfully: ${response.data}');

        // Fetch fresh data from API
        await getChildrenList();

        customToaster('Child updated successfully!', color: Colors.green);
        resetForm(); // Clear all form fields
        Get.back(); // Go back to previous screen
      } else {
        customToaster('Failed to update child', color: Colors.red);
      }
    } catch (e) {
      customToaster('Something went wrong', color: Colors.red);
      log('error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete a child
  Future<void> deleteChild(String childId) async {
    try {
      isLoading.value = true;

      final endpoint = '${AppConstants.addChild}/$childId';
      final response = await apiService.deleteData(endpoint);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Child deleted successfully: ${response.data}');

        // Remove from the list if it's DataState
        if (childrenState.value is DataState<List<ChildModel>>) {
          final currentState =
              childrenState.value as DataState<List<ChildModel>>;
          final updatedList = currentState.data
              .where((child) => child.id != childId)
              .toList();

          if (updatedList.isEmpty) {
            childrenState.value = EmptyState(
              message:
                  'No children added yet. Add your first child to get started.',
            );
          } else {
            childrenState.value = DataState(data: updatedList);
          }
        }

        customToaster('Child deleted successfully!', color: Colors.green);
      } else {
        customToaster('Failed to delete child', color: Colors.red);
      }
    } catch (e) {
      customToaster('Something went wrong', color: Colors.red);
      log('error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Get list of children by parent ID
  Future<void> getChildrenList() async {
    try {
      childrenState.value = LoadingState();

      // Get parent ID from roleData
      final parentId = BaseHelper.currentUser.value.roleData?.id;
      if (parentId == null) {
        childrenState.value = ErrorState('Parent ID not found');
        return;
      }

      final endpoint = 'children/parent/$parentId';
      final response = await apiService.fetchData(
        endpoint,
        query: {'presigned': true},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Children list: ${response.data}');

        // Parse and store children list from 'children' array
        if (response.data != null && response.data['children'] != null) {
          final List<dynamic> childrenData = response.data['children'];

          if (childrenData.isEmpty) {
            childrenState.value = EmptyState(
              message:
                  'No children added yet. Add your first child to get started.',
            );
          } else {
            final List<ChildModel> children = childrenData
                .map((json) => ChildModel.fromJson(json))
                .toList();
            childrenState.value = DataState(data: children);
            log('Loaded ${children.length} children');
          }
        } else {
          childrenState.value = EmptyState(message: 'No children found');
        }
      } else {
        childrenState.value = ErrorState(
          response.data['message'] ?? 'Failed to fetch children',
        );
      }
    } catch (e) {
      childrenState.value = ExceptionState(Exception(e.toString()));
      customToaster('Something went wrong', color: Colors.red);
      log('error: $e');
    }
  }
}
