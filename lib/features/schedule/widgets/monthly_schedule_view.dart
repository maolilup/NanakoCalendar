import 'package:flutter/material.dart';
import '../../../core/models/schedule.dart';
import '../../../core/services/schedule_service.dart';
import 'schedule_card.dart';
import 'package:table_calendar/table_calendar.dart';

/// 月视图日程展示组件
/// 独立的月视图组件，用于显示选定日期的日程列表
class MonthlyScheduleView extends StatelessWidget {
  /// 构造函数
  /// [selectedDay] 当前选中的日期
  /// [scheduleService] 日程服务实例
  /// [onEdit] 编辑日程回调函数
  /// [onDelete] 删除日程回调函数
  MonthlyScheduleView({
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

  /// 存储缓存的日程数据
  List<Schedule> _cachedSchedules = [];

  /// 加载日程数据
  void loadSchedules(List<Schedule> schedules) {
    _cachedSchedules = schedules;
  }

  /// 获取指定日期的日程
  /// [day] 指定的日期
  /// [service] 日程服务实例
  /// 返回该日期的所有日程列表
  List<Schedule> _getEventsForDay(DateTime day, ScheduleService service) {
    // 使用isSameDay函数过滤出与指定日期相同的日程
    return _cachedSchedules.where((schedule) {
      return isSameDay(schedule.dateTime, day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // 获取选定日期的日程
    
    final schedules = _getEventsForDay(selectedDay, scheduleService);

    // 如果没有日程，显示提示信息
    if (schedules.isEmpty) {
      return const Center(
        child: Text('暂无日程安排', style: TextStyle(fontSize: 18)),
      );
    }

    // 显示选定日期的日程列表
    return ListView.builder(
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        return ScheduleCard(
          schedule: schedules[index],
          onEdit: onEdit,
          onDelete: onDelete,
        );
      },
    );
  }
}
