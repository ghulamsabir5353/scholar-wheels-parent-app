// ignore_for_file: constant_identifier_names

abstract class AppConstants {
  // declare the URL here

  static const String liveBaseUrl = 'https://chat.wingstea.com:3001/v1/';
  static const String liveBaseUrlIp = 'chat.wingstea.com';
  static const String localBaseUrl = 'http://192.168.100.55:3001/v1/';

  static const String localBaseUrlIp = '192.168.100.55';
  static const String liveBaseImageURL = 'https://chat.wingstea.com:3001';

  // for socket connection
  static const String baseUrlIp = liveBaseUrlIp;
  static const String paymentUrl = 'https://payments.wingstea.com/';
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
  static const String registerPhone = "registerPhone";
  static const String login = "login";
  static const String getDiscount = "getDiscount";
  static const String verifyOtp = "verifyOtp";
  static const String updateProfile = "updateProfile/";
  static const String updateReferal = "updateReferal";
  static const String checkUserReferalPending = 'checkUserReferalPending';
  static const String deleteUser = "deleteProfile";
  static const String updateSurvey = "updateSurvey/";
  static const String updateModerateRelax = 'updateModerateRelax';
  static const String customerBMI = "food/customer-bmi?range=";
  static const String getRangeDietPlans = "food/getRangeDietPlans";
  static const String getRangeWaterIntakes = "food/getRangeWaterIntakes";

  static const String addcustomerBMI = "food/customer-bmi";

  static const String createProfile = "createProfile";
  static const String messageList = "chat/messageList/";
  static const String sendMessage = "chat/sendMessage";
  static const String deleteMessages = "chat/deleteMessage/";
  static const String getDietPlans = "food/getDietPlans";
  static const String getDietIntake = "food/getDietIntake";
  static const String getStrictFoodList = "food/getStrictFoodList/";
  static const String getModerateFoodList = "food/getModerateFoodList/";

  static const String addPortionToFood = "food/addPortionToFood";
  static const String getFoodCategory = 'food/getFoodCategory';
  static const String createManualFood = 'food/createManualFood';
  static const String getAllMyFood = 'food/getAllMyFoods/';
  static const String getAllFoods = 'food/getAllFoods/';
  static const String getWaterDetail = 'food/getWaterDetail';
  static const String deleteManualFood = 'food/deleteManualFood/';
  static const String updateManualFood = 'food/updateManualFood/';
  static const String toggleFavFood = 'food/toggleFavFood';

  static const String user = 'user';
  static const String getProfile = 'getProfile';

  // Fonts
  static const String POPPIN = 'Poppins';
  static const String IS_TARGET_SCREEN_PENDING = 'isTargetScreenPending';

  // Images
  static const String APP_LOGO = 'assets/images/png/logo.png';
  static String apiUrl = "https://api.openai.com/v1/chat/completions";
  static String apiKey =
      "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";
}
