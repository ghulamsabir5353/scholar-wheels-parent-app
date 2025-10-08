import 'dart:convert';

import 'package:dio/dio.dart';

class ResponseHandler {
  static Response handleResponse(Response response) {
    try {
      if (response.data.runtimeType == bool) {
        return Response(
          data: response.data ?? false,
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          headers: response.headers,
          requestOptions: response.requestOptions,
          isRedirect: response.isRedirect,
          redirects: response.redirects,
          extra: response.extra,
        );
      } else {
        final body = jsonDecode(response.data);

        return Response(
          data: body,
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          headers: response.headers,
          requestOptions: response.requestOptions,
          isRedirect: response.isRedirect,
          redirects: response.redirects,
          extra: response.extra,
        );
      }
    } catch (e) {
      return response; // In case of an error, return the original response
    }
  }
}
