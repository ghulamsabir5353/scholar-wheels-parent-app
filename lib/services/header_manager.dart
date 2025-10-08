class HeaderManager {
  static Map<String, String> getMainHeaders(String? token) {
    // Use a regular Map instead of a constant one
    final Map<String, String> header = {
      'Content-Type': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      header['Authorization'] = "Bearer $token";
    }

    return header;
  }
}
