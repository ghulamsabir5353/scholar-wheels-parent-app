import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:scholarwheels/core/helper.constants/strings.dart';
import 'package:scholarwheels/core/helper.widgets/custom_toaster.dart';
import 'package:scholarwheels/services/api_services.dart';
import 'package:scholarwheels/services/api_exception.dart';

class ImageUploadController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final RxBool isUploading = false.obs;
  final RxBool isDeleting = false.obs;

  /// Upload one or multiple images
  /// Returns list of image URLs on success, null on failure
  Future<List<String>?> uploadImages(List<File> imageFiles) async {
    if (imageFiles.isEmpty) {
      customToaster('Please select at least one image', color: Colors.orange);
      return null;
    }

    try {
      isUploading.value = true;

      // Create FormData with files parameter
      final formData = FormData.fromMap({
        'files': imageFiles.map((file) {
          return MultipartFile.fromFileSync(
            file.path,
            filename: file.path.split('/').last,
          );
        }).toList(),
      });

      // Upload files
      final response = await apiService.uploadFormData(
        AppConstants.uploadFile,
        formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse response to get image URLs
        List<String> imageUrls = [];

        if (response.data != null) {
          // API returns a list of maps with fileUrl, key, fileOriginalName, fileType
          if (response.data is List) {
            // If response is directly a list of maps
            final List<dynamic> dataList = response.data;
            imageUrls = dataList
                .map((item) {
                  if (item is Map && item['key'] != null) {
                    return item['key'].toString();
                  }
                  return '';
                })
                .where((url) => url.isNotEmpty)
                .toList();
          } else if (response.data['files'] != null &&
              response.data['files'] is List) {
            // If response is { files: [{fileUrl: ...}, ...] }
            final List<dynamic> filesList = response.data['files'];
            imageUrls = filesList
                .map((item) {
                  if (item is Map && item['key'] != null) {
                    return item['key'].toString();
                  }
                  return '';
                })
                .where((url) => url.isNotEmpty)
                .toList();
          } else if (response.data['data'] != null &&
              response.data['data'] is List) {
            // If response is { data: [{fileUrl: ...}, ...] }
            final List<dynamic> dataList = response.data['data'];
            imageUrls = dataList
                .map((item) {
                  if (item is Map && item['key'] != null) {
                    return item['key'].toString();
                  }
                  return '';
                })
                .where((url) => url.isNotEmpty)
                .toList();
          } else if (response.data is Map && response.data['key'] != null) {
            // Single file response as map
            imageUrls = [response.data['key'].toString()];
          }
        }

        if (imageUrls.isNotEmpty) {
          customToaster(
            'Image${imageFiles.length > 1 ? 's' : ''} uploaded successfully',
            color: Colors.green,
          );
          return imageUrls;
        } else {
          customToaster(
            'Upload successful but no image URLs returned',
            color: Colors.orange,
          );
          return null;
        }
      } else {
        customToaster(
          'Failed to upload image${imageFiles.length > 1 ? 's' : ''}',
          color: Colors.red,
        );
        return null;
      }
    } catch (e) {
      showApiError(e, logLabel: 'uploadImages');
      return null;
    } finally {
      isUploading.value = false;
    }
  }

  /// Upload a single image
  /// Returns image URL on success, null on failure
  Future<String?> uploadImage(File imageFile) async {
    final urls = await uploadImages([imageFile]);
    return urls?.isNotEmpty == true ? urls!.first : null;
  }

  /// Deletes one stored file by server key ([fileKey] from user `profileImage`, etc.).
  Future<bool> deleteFileByKey(
    String fileKey, {
    bool showSuccessToast = true,
  }) async {
    final key = fileKey.trim();
    if (key.isEmpty) return true;

    try {
      isDeleting.value = true;

      final response = await apiService.deleteData(
        AppConstants.deleteFile,
        data: {'fileKey': key},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (showSuccessToast) {
          customToaster('Image deleted successfully', color: Colors.green);
        }
        return true;
      }
      customToaster('Failed to delete image', color: Colors.red);
      return false;
    } catch (e) {
      showApiError(e, logLabel: 'deleteFileByKey');
      return false;
    } finally {
      isDeleting.value = false;
    }
  }

  /// Delete image(s) by storage key(s)
  Future<bool> deleteImages(List<String> fileKeys) async {
    if (fileKeys.isEmpty) {
      customToaster('No image keys provided', color: Colors.orange);
      return false;
    }

    var allOk = true;
    for (final k in fileKeys) {
      if (k.trim().isEmpty) continue;
      final ok = await deleteFileByKey(k, showSuccessToast: false);
      allOk = allOk && ok;
    }
    if (allOk) {
      customToaster(
        'Image${fileKeys.length > 1 ? 's' : ''} deleted successfully',
        color: Colors.green,
      );
    } else {
      customToaster(
        'Failed to delete one or more images',
        color: Colors.red,
      );
    }
    return allOk;
  }

  /// Delete a single image by storage key
  Future<bool> deleteImage(String fileKey) async {
    return deleteFileByKey(fileKey, showSuccessToast: true);
  }
}
