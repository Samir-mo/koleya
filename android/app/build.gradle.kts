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
    namespace = "com.example.gate_buddy"
    compileSdk = flutter.compileSdkVersion
    
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // ✅ Application ID
        applicationId = "com.example.gate_buddy"

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
    flavorDimensions += "default"

    productFlavors {
        create("development") {
            dimension = "default"
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "Gate Buddy Dev") 
        }
        create("production") {
            dimension = "default"
            resValue("string", "app_name", "Gate Buddy") 
        }
    }
}

flutter {
    source = "../.."
}
