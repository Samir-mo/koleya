class ApiEndpoints {
  // 🧭 العنوان الأساسي للسيرفر
  // غيّر localhost إلى 10.0.2.2 لو بتشغل على Android Emulator

  static const String baseUrl =
      "https://gate-buddy-backend-production-f6df.up.railway.app/api/v1";

  // ======================= Auth & Users =======================
  static const String signup = "/users/signup"; // public
  static const String login = "/users/login"; // public
  static const String forgetPassword = "/users/forgotPassword"; // public
  static const String resetPassword = "/users/resetPassword"; // public
  static const String updateMyPassword = "/users/updateMyPassword"; // protected
  static const String me = "/users/me"; // protected
  static const String updateMe = "/users/updateMe"; // protected
  static const String deleteMe = "/users/deleteMe"; // protected

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

  // ======================= Notifications (⚠️ مش موجودة حالياً في الباك) =======================
  static const String notifications = "/notifications";
  static const String subscribeNotifications = "/notifications/subscribe";
  static const String readNotification = "/notifications/:id/read";

  // ======================= Analytics (⚠️ مش موجودة حالياً في الباك) =======================
  static const String analyticsDownloadClick = "/analytics/download-click";
  static const String analyticsPageView = "/analytics/page-view";

  // ======================= Places (⚠️ مش موجودة حالياً في الباك) =======================
  static const String places = "/places";

  static const String mapAllServices =
      "/services?category=SHOPS&limit=10&page=1";
}
