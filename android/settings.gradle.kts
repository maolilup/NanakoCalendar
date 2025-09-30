// Gradle插件管理配置
pluginManagement {
    // 获取Flutter SDK路径
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            // 检查local.properties文件中是否已设置flutter.sdk
            require(flutterSdkPath != null) { "flutter.sdk未在local.properties中设置" }
            flutterSdkPath
        }

    // 包含Flutter工具的Gradle构建脚本
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    // 配置插件仓库
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

// 应用项目所需的Gradle插件
plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.9.1" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

// 包含应用模块
include(":app")
