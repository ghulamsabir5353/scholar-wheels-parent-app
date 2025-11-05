// ignore_for_file: constant_identifier_names

abstract class AppConstants {
  // declare the URL here

  static const String liveBaseUrl = 'https://api.scholarwheels.co.za/';
  static const String liveBaseUrlIp = 'https://api.scholarwheels.co.za';
  static const String imageBaseUrl = 'https://api.scholarwheels.co.za/';

  // for socket connection
  static const String baseUrlIp = liveBaseUrlIp;
  // for api
  static const String baseUrl = liveBaseUrl;

  /////////////////////////////////
  // declare all the constants keys for local db
  static const String IS_LOGIN = 'isLogin';
  static const String ACCESS_TOKEN = 'acessToken';
  static const String USER_DETAIL = 'user_detail';
  static const String checkProfile = 'checkProfile';
  static const String phone_number = 'phone_number';
  static const String LOCALE = 'locale';
  static const String APP_LANGUAGE = 'app_language';

  // api end point
  static const String registerParent = "register-parent";
  static const String createUser = "user";
  static const String login = "login";
  static const String addChild = "children";
  static const String updateUser = "user";
  static const String chat = "chat";
  static const String changePassword = 'user/change-password';
  static const String route = "route";
  static const String popularRoutes = "route/popular-routes";
  static const String requestBooking = "booking/request";
  static const String contract = "contract";
  static const String booking = "booking";
  static const String uploadFile = "upload/file-upload";
  static const String deleteFile = "upload/file-delete";
  // Fonts
  static const String POPPIN = 'Poppins';
  static const String IS_TARGET_SCREEN_PENDING = 'isTargetScreenPending';

  // Images
  static const String APP_LOGO = 'assets/images/png/logo.png';

  // Google Places API
  static const String googlePlacesApiKey =
      'AIzaSyAh_aYH9eqANGcJWm0ez1paGb6d8hxzz1w';
}
