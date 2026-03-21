plugins {
    id("com.android.application")
    id("kotlin-android")

    // ❌ تم تعطيل Google Services مؤقتًا عشان ما يطلبش google-services.json
    // لو رجعت تستخدم Firebase بعدين رجّع السطر ده:
    // id("com.google.gms.google-services")

    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.koleya"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // ✅ Application ID
        applicationId = "com.example.koleya"

        // قيم Flutter الافتراضية
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing مع مفاتيح الـ debug مؤقتاً
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// ✅ حالياً مش محتاج google-services.json لأننا معطلين Google Services plugin فوق
