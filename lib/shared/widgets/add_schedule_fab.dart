import 'package:flutter/material.dart';

/// 添加日程浮动操作按钮组件
/// 独立的浮动操作按钮组件，用于触发添加新日程的操作
class AddScheduleFloatingActionButton extends StatelessWidget {
  /// 点击回调函数
  final VoidCallback onPressed;

  /// 构造函数
  /// [onPressed] 点击回调函数
  const AddScheduleFloatingActionButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: '添加日程',
      child: const Icon(Icons.add),
    );
  }
}
