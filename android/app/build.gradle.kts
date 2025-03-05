plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.tourscan"
    compileSdk = 35  // تأكد من استخدام أحدث إصدار من SDK
    ndkVersion = "27.0.12077973"  // تعديل إصدار NDK

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.tourscan"
        minSdk = 23  // حدّد الحد الأدنى المطلوب لـ Flutter
        targetSdk = 34  // استخدم أحدث إصدار مستهدف
        versionCode = 1
        versionName = "1.0.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
