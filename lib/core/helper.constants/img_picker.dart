import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mime/mime.dart';

Future<String?> pickAndConvertImage(BuildContext context) async {
  final picker = ImagePicker();

  // Wait for result from bottom sheet
  final base64Image = await showModalBottomSheet<String>(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                try {
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedFile != null) {
                    // String base64 =
                    //     await compressAndConvertToBase64(File(pickedFile.path));
                    Get.back(result: pickedFile.path);
                  } else {
                    Get.back(result: null);
                  }
                } catch (e) {
                  print(e.toString());
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                final pickedFile = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (pickedFile != null) {
                  // String base64 =
                  //     await compressAndConvertToBase64(File(pickedFile.path));
                  Get.back(result: pickedFile.path);
                } else {
                  Get.back(result: null);
                }
              },
            ),
          ],
        ),
      );
    },
  );

  return base64Image; // This can be null if cancelled
}

// Future<String> compressAndConvertToBase64(File file) async {
//   final result = await FlutterImageCompress.compressWithFile(
//     file.absolute.path,
//     quality: 70,
//   );

//   if (result != null) {
//     String rawBase64 = base64Encode(result);
//     // Detect MIME type from file path
//     final mimeType = lookupMimeType(file.path) ?? "image/jpeg"; // fallback

//     return "data:$mimeType;base64,$rawBase64";
//   } else {
//     throw Exception("Image compression failed");
//   }
// }

convertImagetoBase64(File file) {
  String rawBase64 = base64Encode(file.readAsBytesSync());
  // Detect MIME type from file path
  final mimeType = lookupMimeType(file.path) ?? "image/jpeg"; // fallback
  return "data:$mimeType;base64,$rawBase64";
}
