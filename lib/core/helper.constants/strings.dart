// ignore_for_file: constant_identifier_names

abstract class AppConstants {
  // declare the URL here
  /// Production REST API, sockets, and uploaded images.
  static const String productURL = "https://productionapi.scholarwheels.co.za";

  /// Alternate / legacy API host (also used as default App Links origin below).
  static const String devURL = "https://api.scholarwheels.co.za";
  static const selectedUrl = devURL;
  static const String liveBaseUrl = '$selectedUrl/';
  static const String liveBaseUrlIp = selectedUrl;

  static const String imageBaseUrl = '$selectedUrl/';

  // for socket connections
  static const String baseUrlIp = liveBaseUrlIp;
  // for api
  static const String baseUrl = liveBaseUrl;

  /// HTTPS origin for payment return URLs (App Links / Universal Links).
  /// Must match [appLinksVerifiedHosts], Android intent-filters, iOS Associated Domains,
  /// and `/.well-known/assetlinks.json` + `apple-app-site-association` on this host.
  ///
  /// Keep this on the host where you actually serve `.well-known` (often [devURL]
  /// even when [productURL] is the API), so store builds verify correctly.
  static const String appLinksBaseUrl = devURL;

  /// Hosts that may open `/payment/*` via verified HTTPS links. Each needs its own
  /// `.well-known` files and native config (see AndroidManifest + Runner.entitlements).
  static List<String> get appLinksVerifiedHosts => <String>[
    Uri.parse(devURL).host,
    Uri.parse(productURL).host,
  ];

  /////////////////////////////////
  // declare all the constants keys for local db
  static const String IS_LOGIN = 'isLogin';
  static const String ACCESS_TOKEN = 'acessToken';
  static const String USER_DETAIL = 'user_detail';
  static const String REMEMBER_ME = 'rememberMe';
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
  static const String forgotPassword = "forgot-password";
  static const String verifyOTP = "verify-otp";
  static const String resendOTP = "resend-otp";
  static const String resetPassword = "reset-password";
  static const String verifyRegistrationOTP = "verify-registration-otp";
  static const String resendRegistrationOTP = "resend-registration-otp";
  static const String verifyLoginOTP = "verify-login-otp";
  static const String resendLoginOTP = "resend-login-otp";
  static const String accountDeletionRequest = "user/account-deletion/request";
  static const String accountDeletionResendOtp =
      "user/account-deletion/resend-otp";
  static const String accountDeletionVerify = "user/account-deletion/verify";
  static const String route = "route";
  static const String popularRoutes = "route/popular-routes";
  static const String requestBooking = "booking/request";
  static const String contract = "contract";
  static const String rating = "rating";
  static const String booking = "booking";
  static const String uploadFile = "upload/file-upload";
  static const String deleteFile = "upload/file-delete";
  static const String notification = "notification";
  static const String subscriptionPlans = "subscription/plans";
  static const String subscriptionPaymentRequest =
      "usersubscription/payment-request";
  static const String subscriptionInvoice = "subscription-invoice";
  static const String userSubscriptionCancel = "usersubscription/cancel";
  static const String userSubscriptionMe = "usersubscription/me";
  // Fonts
  static const String POPPIN = 'Poppins';
  static const String IS_TARGET_SCREEN_PENDING = 'isTargetScreenPending';

  // Images
  static const String APP_LOGO = 'assets/images/png/logo.png';

  // Google Places API
  static const String googlePlacesApiKey =
      'AIzaSyBb7gj2cuK0NCmqAyivdDX9iHh2KqrztPE';
}
