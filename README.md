# NanakoCalendar
基于Flutter开发的AI日程管理软件

## 项目结构说明

### 根目录文件
- **.gitignore**: 指定Git版本控制系统忽略的文件和目录，如构建输出、依赖包等。
- **analysis_options.yaml**: Flutter项目的静态分析配置文件，定义代码风格检查规则和警告级别。
- **pubspec.lock**: 锁定项目依赖包的确切版本，确保团队成员使用相同的依赖版本。
- **pubspec.yaml**: 项目配置文件，包含应用元数据（名称、描述、版本）、依赖包列表和资源引用。
- **README.md**: 项目说明文档，包含项目介绍、安装指南和使用方法。

### 平台特定目录

#### Android (android/)
- **build.gradle.kts**: 项目级Gradle构建脚本，配置Android构建工具版本和插件。
- **settings.gradle.kts**: Gradle设置文件，定义项目包含的模块。
- **gradle.properties**: Gradle构建属性配置，设置JVM参数和构建选项。
- **app/build.gradle.kts**: 应用级Gradle构建脚本，配置应用版本、依赖和构建类型。
- **app/src/main/AndroidManifest.xml**: Android应用清单文件，声明应用组件、权限和设备特性要求。
- **app/src/main/kotlin/com/example/flutter_application_1/MainActivity.kt**: 主Activity入口，继承FlutterActivity并作为Flutter视图的容器。
- **app/src/main/res/values/styles.xml**: 定义Android主题样式，包括启动主题和正常主题。
- **app/src/main/res/drawable/launch_background.xml**: 启动画面背景定义，配置启动时的视觉效果。

#### iOS (ios/)
- **Flutter/AppFrameworkInfo.plist**: Flutter框架信息文件，由Flutter工具自动生成。
- **Flutter/Debug.xcconfig** 和 **Flutter/Release.xcconfig**: Xcode配置文件，包含Flutter引擎的编译设置。
- **Runner/AppDelegate.swift**: iOS应用委托类，负责应用生命周期管理，注册Flutter插件。
- **Runner/Info.plist**: iOS应用信息属性列表，包含应用标识、显示名称、版本号和设备方向支持。
- **Runner/Assets.xcassets/**: 资源目录，包含应用图标(AppIcon)和启动画面(LaunchImage)的各种尺寸。
- **Runner/Base.lproj/LaunchScreen.storyboard**: 启动屏幕界面设计文件。
- **Runner.xcodeproj/**: Xcode项目文件，包含构建配置和目标设置。

#### Web (web/)
- **index.html**: Web应用的HTML入口文件，加载Flutter应用。
- **manifest.json**: PWA清单文件，定义应用名称、图标、主题色和启动模式。
- **favicon.png**: 网站收藏夹图标。
- **icons/**: 存放不同尺寸的应用图标，用于PWA和浏览器标签页。

#### 桌面平台
- **linux/**: Linux桌面应用支持，包含CMake构建系统文件和原生代码。
- **macos/**: macOS桌面应用支持，类似iOS但使用SwiftUI和Cocoa框架。
- **windows/**: Windows桌面应用支持，包含C++原生代码和Visual Studio项目文件。

### 核心源码目录 (lib/)
- **main.dart**: 应用程序入口点和主界面代码。包含：
  - `MyApp`: 主应用程序组件，配置Material主题和路由。
  - `MyHomePage`: 主页状态组件，实现计数器功能演示。
  - `_MyHomePageState`: 管理主页状态，处理用户交互。

### 测试目录 (test/)
- **widget_test.dart**: 组件测试文件，包含对应用UI组件的功能测试，验证计数器功能的正确性。

### 构建输出目录
- **build/**: 存放编译生成的文件，如APK、IPA或可执行文件。

## 开发指南

### 代码编写位置
所有Dart业务逻辑代码应放在 **lib/** 目录下。这是Flutter应用的核心源码目录，包含：
- **main.dart**: 应用程序入口和主界面
- 可创建子目录如 **screens/** (页面), **widgets/** (组件), **services/** (服务), **models/** (数据模型) 来组织代码

### 资源文件管理
资源文件通过 **pubspec.yaml** 文件进行声明和管理：

1. **图像资源**: 在 `pubspec.yaml` 的 `assets` 部分声明，例如：
   ```yaml
   flutter:
     assets:
       - images/logo.png
       - assets/icons/
   ```
   将图像文件放在项目目录中，如 `assets/images/` 或 `assets/icons/`

2. **字体资源**: 在 `pubspec.yaml` 的 `fonts` 部分声明，例如：
   ```yaml
   flutter:
     fonts:
       - family: CustomFont
         fonts:
           - asset: fonts/CustomFont-Regular.ttf
           - asset: fonts/CustomFont-Bold.ttf
             weight: 700
   ```
   将字体文件放在如 `assets/fonts/` 目录中

3. **其他资源**: 任何需要打包到应用中的文件都可以通过 `assets` 字段添加

### API接口
本项目目前为Flutter基础模板，主要提供以下接口能力：

1. **Flutter框架API**: 使用Material Design和Cupertino组件库构建跨平台UI
2. **平台通道(Platform Channel)**: 可通过MethodChannel与原生Android/iOS代码通信
3. **HTTP客户端**: 可使用`http`或`dio`包与后端API通信
4. **本地存储**: 可使用`shared_preferences`或`hive`进行本地数据存储
5. **状态管理**: 可集成Provider、Riverpod或Bloc等状态管理方案

要添加新的功能模块，建议在 `lib/` 目录下创建相应的子目录和文件，遵循Dart语言规范和Flutter最佳实践。

## 功能概述
该项目是一个基于Flutter框架的跨平台AI日程管理应用原型。当前实现了基础的计数器示例应用，展示了Flutter的核心特性，包括状态管理和Material Design组件。后续将在此基础上开发完整的日程管理功能，集成AI智能提醒和自然语言处理能力。

## 快速开始
1. 安装Flutter SDK
2. 克隆项目：`git clone https://github.com/maolilup/NanakoCalendar.git`
3. 获取依赖：`flutter pub get`
4. 运行应用：`flutter run`

## 参考资源
- [Flutter官方文档](https://docs.flutter.dev/)
- [编写你的第一个Flutter应用](https://docs.flutter.dev/get-started/codelab)
- [Flutter实用示例集](https://docs.flutter.dev/cookbook)
