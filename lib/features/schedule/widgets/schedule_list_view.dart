import 'package:flutter/material.dart';
import '../../../core/models/schedule.dart';
import '../../../core/services/schedule_service.dart';
import 'schedule_card.dart';
import 'monthly_schedule_view.dart';

/// 日程列表视图组件
/// 独立的日程列表组件，用于显示选定日期的日程
class ScheduleListView extends StatelessWidget {
  /// 构造函数
  /// [selectedDay] 当前选中的日期
  /// [scheduleService] 日程服务实例
  /// [onEdit] 编辑日程回调函数
  /// [onDelete] 删除日程回调函数
  const ScheduleListView({
    super.key,
    required this.selectedDay,
    required this.scheduleService,
    required this.onEdit,
    required this.onDelete,
  });

  /// 当前选中的日期
  final DateTime selectedDay;

  /// 日程服务实例
  final ScheduleService scheduleService;

  /// 编辑日程回调函数
  final void Function(Schedule schedule) onEdit;

  /// 删除日程回调函数
  final void Function(String id) onDelete;

  @override
  Widget build(BuildContext context) {
    return MonthlyScheduleView(
      selectedDay: selectedDay,
      scheduleService: scheduleService,
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }
}
