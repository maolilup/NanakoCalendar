plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle插件必须在Android和Kotlin Gradle插件之后应用。
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.flutter_application_1"
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
        // TODO: 指定您自己的唯一应用程序ID (https://developer.android.com/studio/build/application-id.html)。
        applicationId = "com.example.flutter_application_1"
        // 您可以更新以下值以匹配您的应用程序需求。
        // 更多信息，请参见：https://flutter.dev/to/review-gradle-config。
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: 为发布版本添加您自己的签名配置。
            // 目前使用调试密钥签名，以便`flutter run --release`可以工作。
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
