import 'package:flutter/foundation.dart';

class CurrentUser {
  static final ValueNotifier<int> _version = ValueNotifier<int>(0);
  static ValueListenable<int> get listenable => _version;

  static String? id;
  static String? name;
  static String? email;
  static String? image;
  static String? token;

  static void setUser({
    String? id,
    String? name,
    String? email,
    String? image,
    String? token,
  }) {
    CurrentUser.id = id;
    CurrentUser.name = name;
    CurrentUser.email = email;
    CurrentUser.image = image;
    CurrentUser.token = token;
    _version.value++; // 👈 يخلي أي UI بيسمع يتحدث
  }

  static void clear() {
    id = null;
    name = null;
    email = null;
    image = null;
    token = null;
    _version.value++;
  }
}
