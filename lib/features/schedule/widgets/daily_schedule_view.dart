import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/models/schedule.dart';
import '../../../core/services/schedule_service.dart';
import 'schedule_card.dart';

/// 日视图日程展示组件
/// 用于在日视图模式下展示选定日期的详细日程信息
class DailyScheduleView extends StatelessWidget {
  /// 构造函数
  /// [selectedDay] 选定的日期
  /// [scheduleService] 日程服务实例
  /// [onEdit] 编辑日程回调函数
  /// [onDelete] 删除日程回调函数
  /// [onSwipeDown] 下滑回调函数
  DailyScheduleView({
    super.key,
    required this.selectedDay,
    required this.scheduleService,
    required this.onEdit,
    required this.onDelete,
    this.onSwipeDown,
  });

  /// 选定的日期
  final DateTime selectedDay;

  /// 日程服务实例
  final ScheduleService scheduleService;

  /// 编辑日程回调函数
  final void Function(Schedule schedule) onEdit;

  /// 删除日程回调函数
  final void Function(String id) onDelete;

  /// 下滑回调函数
  final VoidCallback? onSwipeDown;

  @override
  Widget build(BuildContext context) {
    // 使用手势检测器包装整个组件，用于检测下滑手势
    return GestureDetector(
      // 垂直拖拽结束时的回调函数，用于检测下滑手势
      onVerticalDragEnd: (details) {
        // 检测下滑手势（垂直拖拽结束时，velocity.pixelsPerSecond.dy为正值表示向下滑动）
        if (details.velocity.pixelsPerSecond.dy > 500) {
          onSwipeDown?.call();
        }
      },
      child: Builder(
        builder: (context) {
          // 获取选定日期的日程
          final schedules = _getEventsForDay(selectedDay);

          // 如果没有日程，显示提示信息
          if (schedules.isEmpty) {
            return const Center(
              child: Text(
                '暂无日程安排',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          // 显示选定日期的日程列表
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
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
      ),
    );
  }

  /// 存储缓存的日程数据
  List<Schedule> _cachedSchedules = [];

  /// 加载日程数据
  void loadSchedules(List<Schedule> schedules) {
    _cachedSchedules = schedules;
  }

  /// 获取指定日期的日程
  /// [day] 指定的日期
  /// 返回该日期的所有日程列表
  List<Schedule> _getEventsForDay(DateTime day) {
    // 创建一个空列表来存储指定日期的日程
    List<Schedule> events = [];
    // 遍历缓存的所有日程
    for (int i = 0; i < _cachedSchedules.length; i++) {
      Schedule schedule = _cachedSchedules[i];
      // 使用isSameDay函数检查日期是否相同
      if (isSameDay(schedule.dateTime, day)) {
        events.add(schedule);
      }
    }
    // 返回指定日期的日程列表
    return events;
  }
}
