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
- **main.dart**: 应用程序入口点，配置全局主题和路由，加载主页组件。

#### 核心目录 (core/)
- **core/models/**: 数据模型目录
  - `schedule.dart`: 日程数据模型类，定义日程的基本属性和序列化方法
- **core/services/**: 服务层目录
  - `schedule_service.dart`: 日程管理服务类，负责处理日程的增删改查等业务逻辑

#### 功能模块目录 (features/)
- **features/calendar/**: 日历功能模块
  - **features/calendar/screens/**: 日历页面目录
    - `home_screen.dart`: 主页面组件，应用的主界面，展示日程列表和操作入口
  - **features/calendar/widgets/**: 日历组件目录
    - `calendar_widget.dart`: 日历组件，基于table_calendar实现日历展示功能
- **features/schedule/**: 日程功能模块
  - **features/schedule/widgets/**: 日程组件目录
    - `schedule_card.dart`: 日程卡片组件，用于在列表中展示单个日程项
    - `schedule_list_view.dart`: 日程列表视图组件，展示指定日期的日程列表
    - `daily_schedule_view.dart`: 日视图日程展示组件
    - `weekly_schedule_view.dart`: 周视图日程展示组件
    - `monthly_schedule_view.dart`: 月视图日程展示组件
    - `schedule_view_manager.dart`: 统一的视图管理组件，管理不同视图的显示和切换

#### 共享目录 (shared/)
- **shared/widgets/**: 共享组件目录
  - `add_schedule_fab.dart`: 添加日程的浮动操作按钮组件

### 测试目录 (test/)
- **widget_test.dart**: 组件测试文件，包含对应用UI组件的功能测试，验证计数器功能的正确性。

### 构建输出目录
- **build/**: 存放编译生成的文件，如APK、IPA或可执行文件。

## 开发指南

### 代码编写位置
所有Dart业务逻辑代码应放在 **lib/** 目录下。这是Flutter应用的核心源码目录，采用模块化结构组织：

- **main.dart**: 应用程序入口点，配置全局主题和路由
- **core/**: 核心模块，包含数据模型和服务
  - **models/**: 数据模型
  - **services/**: 业务服务
- **features/**: 功能模块，按功能划分目录
  - **calendar/**: 日历相关功能
  - **schedule/**: 日程相关功能
- **shared/**: 共享组件和常量

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
该项目是一个基于Flutter框架的跨平台AI日程管理应用。当前已实现基础的日程管理功能，包括日程的添加、日历视图展示（日、周、月视图切换）以及手势操作支持。后续将在此基础上开发完整的日程管理功能，集成AI智能提醒和自然语言处理能力。

## 功能列表
- ✔ 基础日程管理（添加日程）
- ✔ 日历视图展示（周、月视图切换）
- ✔ 手势操作支持（上滑、改为退出键，新增视图追踪器）
- ✘ 日程编辑和删除功能
- ✘ AI自然语言处理（零代码自然语言交互）
- ✘ 模糊语义识别（精准识别模糊时间表述）
- ✘ 个性化智能推荐（基于历史行为的智能推荐）
- ✘ 权威数据聚合（教育部竞赛库、国际证书考试日历等）
- ✘ 可视化成长路线（生成个性化成长路线图）
- ✘ 多模态学习应用（图片日程信息识别）
- ✔ 数据持久化存储（基础的数据库）
- ✘ 数据库热重载
- ✘ 通知系统
## BUG
-   周视图日程展示错误（颜色未占满格子）

## 快速开始
1. 安装Flutter SDK
2. 克隆项目：`git clone https://github.com/maolilup/NanakoCalendar.git`
3. 获取依赖：`flutter pub get`
4. 运行应用：`flutter run`

## 语法知识总结

### 1. Dart语言特性详解

#### 1.1 类和对象
- **类定义**：使用`class`关键字定义类，如`Schedule`数据模型类
- **属性定义**：使用`final`关键字定义不可变属性，如`final String id;`
- **构造函数**：
  - 普通构造函数：`Schedule({...})`
  - 命名构造函数：`factory Schedule.fromJson(Map<String, dynamic> json)`
  - 常量构造函数：组件中使用`const`构造函数优化性能
- **方法定义**：在类中定义实例方法，如`Map<String, dynamic> toJson()`

#### 1.2 空安全（Null Safety）
- **可空类型**：使用`?`声明可空类型，如`DateTime? _selectedDay;`
- **非空断言**：使用`!`操作符断言变量不为null，如`newValue!`
- **空合并操作符**：使用`??`提供默认值，如`_selectedDay ?? DateTime.now()`

#### 1.3 泛型（Generics）
- **泛型集合**：`List<Schedule>`、`Map<String, dynamic>`
- **泛型函数参数**：`Function(Schedule)`、`Function(String)`

#### 1.4 函数和闭包
- **函数定义**：普通函数如`List<Schedule> _getEventsForDay(DateTime day)`
- **箭头函数**：简洁的单行函数，如`(context, day) => isSameDay(widget.selectedDay, day)`
- **匿名函数**：作为参数传递的函数，如`(details) { ... }`
- **高阶函数**：函数作为参数或返回值，如回调函数参数

#### 1.5 异步编程
- **Future和async/await**：处理异步操作，如`showDatePicker`返回Future
- **异步初始化**：在`main()`函数中使用`initializeDateFormatting().then((_) { ... })`

#### 1.6 集合操作
- **List操作**：
  - 创建：`List.generate()`、`List<Schedule> _schedules = []`
  - 查询：`where()`、`indexWhere()`
  - 修改：`add()`、`removeWhere()`
- **Map操作**：
  - 创建：`Map<String, dynamic>`
  - 访问：`json['id']`
  - 转换：`toJson()`方法返回Map

#### 1.7 控制流程
- **条件语句**：
  - `if-else`语句：用于条件判断
  - `switch-case`语句：如优先级颜色选择
- **循环语句**：
  - `for`循环：`for (int i = 0; i < length; i++)`
  - `for-in`循环：遍历集合
  - `List.generate()`：生成固定长度的列表

#### 1.8 操作符
- **级联操作符**：`..`用于链式调用（项目中未使用但常见）
- **条件成员访问**：`?.`安全访问可能为null的对象成员
- **类型检查**：`is`、`as`关键字

### 2. Flutter框架特性详解

#### 2.1 Widget系统
- **StatelessWidget**：无状态组件，如`ScheduleCard`、`DailyScheduleView`
- **StatefulWidget**：有状态组件，如`HomeScreen`、`CalendarWidget`
- **State管理**：通过`State`类管理组件状态，如`_HomeScreenState`

#### 2.2 布局组件
- **基础布局**：
  - `Column`：垂直布局组件
  - `Row`：水平布局组件
  - `Expanded`：扩展子组件填充可用空间
  - `Container`：通用容器组件
- **列表布局**：
  - `ListView.builder`：动态构建列表项
  - `GridView.builder`：网格布局
- **特殊布局**：
  - `Stack`：层叠布局（项目中未使用但常见）
  - `Card`：卡片布局

#### 2.3 交互组件
- **手势处理**：
  - `GestureDetector`：检测各种手势，如`onVerticalDragEnd`
- **按钮组件**：
  - `FloatingActionButton`：浮动操作按钮
  - `TextButton`：文本按钮
  - `PopupMenuButton`：弹出菜单按钮
- **输入组件**：
  - `TextField`：文本输入框
  - `DropdownButtonFormField`：下拉选择框
  - `AlertDialog`：对话框

#### 2.4 数据展示组件
- **文本展示**：
  - `Text`：基本文本组件
  - `TextStyle`：文本样式
- **图标展示**：
  - `Icon`：图标组件
  - `Icons`：Material Icons图标库
- **列表项**：
  - `ListTile`：列表项组件

#### 2.5 路由和导航
- **页面导航**：
  - `Navigator.of(context).pop()`：关闭当前页面
  - `showDialog`：显示对话框
  - `showDatePicker`：显示日期选择器

#### 2.6 主题和样式
- **MaterialApp**：应用根组件，配置主题
- **Theme.of(context)**：获取主题数据
- **ColorScheme`：颜色方案
- **BoxDecoration`：装饰盒子

#### 2.7 生命周期方法
- **initState()**：组件初始化时调用
- **didUpdateWidget()**：组件更新时调用
- **build()**：构建UI组件树

### 3. 第三方库使用详解

#### 3.1 table_calendar
- **TableCalendar**：功能完整的日历组件
- **CalendarFormat**：日历格式（月视图、周视图）
- **isSameDay()**：比较两个日期是否为同一天

#### 3.2 intl
- **initializeDateFormatting()**：初始化日期格式化
- **本地化支持**：支持多语言日期显示

## 参考资源
- [Flutter官方文档](https://docs.flutter.dev/)
- [编写你的第一个Flutter应用](https://docs.flutter.dev/get-started/codelab)
- [Flutter实用示例集](https://docs.flutter.dev/cookbook)
