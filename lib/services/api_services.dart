import 'dart:io';
import 'package:dio/dio.dart';
import 'api_client.dart'; // Ensure to import your ApiClient and related classes

/// A service class that provides methods for API interaction.
/// This class acts as a bridge between the UI and the API client,
/// making it easier to perform various HTTP operations.

class ApiService {
  final ApiClient _apiClient;

  /// Constructor that accepts an [ApiClient] instance.
  ApiService(this._apiClient);

  /// Fetches data from the specified [uri] using a GET request.
  ///
  /// Returns a [Response] object containing the server's response.
  Future<Response> fetchData(String uri,
      {Map<String, dynamic>? query, Map<String, dynamic>? body}) {
    return _apiClient.getData(uri, query: query, body: body);
  }

  /// Sends data to the specified [uri] using a POST request.
  ///
  /// [data] is the payload to be sent in the request body.
  /// Returns a [Response] object containing the server's response.
  Future<Response> createData(
    String uri,
    Map<String, dynamic> data, {
    isFromData = false,
    File? file,
    String? fileKey,
  }) {
    return _apiClient.postData(uri, data,
        isFromData: isFromData, file: file, fileKey: fileKey);
  }

  /// Updates data at the specified [uri] using a PUT request.
  ///
  /// [data] is the payload to be sent in the request body.
  /// Returns a [Response] object containing the server's response.
  Future<Response> updateData(String uri, Map<String, dynamic> data) {
    return _apiClient.putData(uri, data);
  }

  /// Deletes data from the specified [uri] using a DELETE request.
  ///
  /// Returns a [Response] object containing the server's response.
  Future<Response> deleteData(String uri, {Map<String, dynamic>? data}) {
    return _apiClient.deleteData(uri, body: data);
  }

  /// Uploads a file to the specified [uri] using a POST request with multipart/form-data.
  ///
  /// [data] contains the additional fields to be sent along with the file.
  /// [file] is the file to be uploaded.
  /// [fileKey] is the key for the file in the form data.
  ///
  /// Returns a [Response] object containing the server's response.
  Future<Response> uploadFile(
      String uri, Map<String, String> data, File file, String fileKey) {
    // Create FormData for the file upload
    final formData = FormData.fromMap({
      ...data,
      fileKey: MultipartFile.fromFileSync(
        file.path,
        filename: file.path.split('/').last,
      ),
    });

    // Send the POST request with FormData
    return _apiClient.postFormData(uri, formData);
  }
}
