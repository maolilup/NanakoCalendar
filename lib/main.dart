import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'features/calendar/screens/home_screen.dart';

/// 应用程序入口点
void main() {
  // 初始化中文本地化数据
  initializeDateFormatting('zh_CN', null).then((_) {
    runApp(const MyApp());
  });
}

/// 主应用程序组件
/// 作为应用的根部件，配置全局主题和路由
class MyApp extends StatelessWidget {
  /// 构造函数
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 应用标题
      title: 'Nanako Calendar',
      // 应用主题
      theme: ThemeData(
        // 使用蓝色作为主色调
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        // 启用Material Design 3
        useMaterial3: true,
      ),
      // 主页面
      home: const HomeScreen(),
    );
  }
}
