class ApiEndpoints {
  ApiEndpoints._();
  // ======================= Auth & Users =======================
  static const String signup = "/users/signup";
  static const String login = "/users/login";
  static const String forgetPassword = "/users/forgotPassword";
  static const String resetPassword = "/users/resetPassword";
  static const String updateMyPassword = "/users/updateMyPassword";
  static const String getProfile = "/users/me";
  static const String updateMe = "/users/updateMe"; // protected
  static const String deleteMe = "/users/deleteMe"; // protected
  static const String logout = "/users/logout";
  static const String refreshToken = "/users/refresh";
  static const String verifyResetCode = "/users/verifyResetCode";

  // ======================= Dashboard / Home =======================
  static const String home = "/home"; // optional

  // ======================= Flights =======================
  static const String flights = "/flights";
  static const String flightsSearch = "/flights/search";
  static const String flightsUpdated = "/flights/updated";
  static const String flightById = "/flights/:id";
  static const String trackedFlights = "/flights/tracked";
  static const String trackFlight = "/flights/:id/track";
  static const String untrackFlight = "/flights/:id/track"; // DELETE

  // ======================= Services =======================
  static const String services = "/services?limit=200";
  static const String serviceById = "/services/:id";
  static const String serviceLocation = "/services/:id/location";
  static const String vipLounges = "/services/vip-lounges";
  static const String vipLoungeById = "/services/vip-lounges/:id";

  // ======================= Search =======================
  static const String search = "/search";

  // ======================= Shops =======================
  static const String shops = "/shops";
  static const String shopById = "/shops/:id";

  // ======================= Assistant (Chatbot) =======================
  static const String assistant = "/chat/query";

  static const String notifications = "/notifications";
  static const String subscribeNotifications = "/notifications/subscribe";
  static const String readNotification = "/notifications/:id/read";

  static const String analyticsDownloadClick = "/analytics/download-click";
  static const String analyticsPageView = "/analytics/page-view";

  static const String places = "/places";

  static const String mapAllServices =
      "/services?category=SHOPS&limit=10&page=1";
}
