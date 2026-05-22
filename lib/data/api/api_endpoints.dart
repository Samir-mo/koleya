/// تعريف جميع مسارات الـ API في التطبيق
/// محدث بالكامل بناءً على المسارات الفعلية في الباك إند gateBuddy
class ApiEndpoints {
  // 🧭 العنوان الأساسي للسيرفر
  // غيّر localhost إلى 10.0.2.2 لو بتشغل على Android Emulator
  static const String baseUrl = "http://localhost:3000";
  // ======================= Auth & Users =======================
  static const String signup = "/api/v1/users/signup"; // public
  static const String login = "/api/v1/users/login"; // public
  static const String forgetPassword = "/api/v1/users/forgotPassword"; // public
  static const String resetPassword = "/api/v1/users/resetPassword"; // public
  static const String updateMyPassword =
      "/api/v1/users/updateMyPassword"; // protected
  static const String me = "/api/v1/users/me"; // protected
  static const String updateMe = "/api/v1/users/updateMe"; // protected
  static const String deleteMe = "/api/v1/users/deleteMe"; // protected

  // ======================= Dashboard / Home =======================
  static const String home = "/api/v1/home"; // optional

  // ======================= Flights =======================
  static const String flights = "/api/v1/flights";
  static const String flightsSearch = "/api/v1/flights/search";
  static const String flightsUpdated = "/api/v1/flights/updated";
  static const String flightById = "/api/v1/flights/:id";
  static const String trackedFlights = "/api/v1/flights/tracked";
  static const String trackFlight = "/api/v1/flights/:id/track";
  static const String untrackFlight = "/api/v1/flights/:id/track"; // DELETE

  // ======================= Services =======================
  static const String services = "/api/v1/services";
  static const String serviceById = "/api/v1/services/:id";
  static const String serviceLocation = "/api/v1/services/:id/location";
  static const String vipLounges = "/api/v1/services/vip-lounges";
  static const String vipLoungeById = "/api/v1/services/vip-lounges/:id";

  // ======================= Search =======================
  static const String search = "/api/v1/search";

  // ======================= Shops =======================
  static const String shops = "/api/v1/shops";
  static const String shopById = "/api/v1/shops/:id";

  // ======================= Assistant (Chatbot) =======================
  static const String assistant = "/api/v1/assistant";

  // ======================= Notifications (⚠️ مش موجودة حالياً في الباك) =======================
  static const String notifications = "/api/v1/notifications";
  static const String subscribeNotifications =
      "/api/v1/notifications/subscribe";
  static const String readNotification = "/api/v1/notifications/:id/read";

  // ======================= Analytics (⚠️ مش موجودة حالياً في الباك) =======================
  static const String analyticsDownloadClick =
      "/api/v1/analytics/download-click";
  static const String analyticsPageView = "/api/v1/analytics/page-view";

  // ======================= Places (⚠️ مش موجودة حالياً في الباك) =======================
  static const String places = "/api/v1/places";

  static const String mapAllServices =
      "/services?category=SHOPS&limit=10&page=1";
}
