import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/models/schedule.dart';
import '../../../core/services/schedule_service.dart';

/// 周视图日程展示组件
/// 左侧显示星期几，右侧用方格展示每天的日程
///
/// 该组件用于以网格形式展示一周内的日程安排，支持手势操作和日程的编辑删除功能
class WeeklyScheduleView extends StatelessWidget {
  /// 当前聚焦的日期（用于确定周的范围）
  final DateTime focusedDay;
  
  /// 日程服务实例
  final ScheduleService scheduleService;
  
  /// 编辑日程的回调函数
  final Function(Schedule) onEdit;
  
  /// 删除日程的回调函数
  final Function(String) onDelete;
  
  /// 上滑回调函数
  final VoidCallback? onSwipeUp;

  /// 下滑回调函数
  final VoidCallback? onSwipeDown;

  /// 构造函数
  const WeeklyScheduleView({
    super.key,
    required this.focusedDay,
    required this.scheduleService,
    required this.onEdit,
    required this.onDelete,
    this.onSwipeUp,
    this.onSwipeDown,
  });

  /// 获取一周的开始日期（周一）
  ///
  /// 根据传入的日期计算所在周的周一日期
  /// Flutter的weekday属性中，1代表周一，7代表周日
  DateTime _getStartOfWeek(DateTime date) {
    // 计算需要减去的天数以得到周一
    // 例如：周三(weekday=3)需要减去2天得到周一
    int daysToSubtract = date.weekday - 1;
    return date.subtract(Duration(days: daysToSubtract));
  }

  /// 获取指定日期的日程
  ///
  /// 从日程服务中获取所有日程，然后筛选出与指定日期同一天的日程
  /// 使用table_calendar包的isSameDay函数来比较日期是否为同一天
  List<Schedule> _getEventsForDay(DateTime day) {
    final schedules = scheduleService.getAllSchedules();
    return schedules.where((schedule) {
      return isSameDay(schedule.dateTime, day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // 计算本周的开始日期（周一）
    final startOfWeek = _getStartOfWeek(focusedDay);
    
    // 生成一周7天的日期列表
    final List<DateTime> weekDays = List.generate(
      7,
      (index) => startOfWeek.add(Duration(days: index)),
    );
    
    // 星期几的中文名称
    final List<String> weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

    // 使用手势检测器包装整个组件，用于检测下滑手势
    return GestureDetector(
      // 垂直拖拽结束时的回调函数，用于检测下滑手势
      onVerticalDragEnd: (details) {
        // 检测下滑手势（垂直拖拽结束时，velocity.pixelsPerSecond.dy为正值表示向下滑动）
        if (details.velocity.pixelsPerSecond.dy > 300) {
          // 添加调试日志
          print('WeeklyScheduleView: 检测到下滑手势, velocity: ${details.velocity.pixelsPerSecond.dy}');
          onSwipeDown?.call();
        }
        // 检测上滑手势（垂直拖拽结束时，velocity.pixelsPerSecond.dy为负值表示向上滑动）
        else if (details.velocity.pixelsPerSecond.dy < -300) {
          // 添加调试日志
          print('WeeklyScheduleView: 检测到上滑手势, velocity: ${details.velocity.pixelsPerSecond.dy}');
          onSwipeUp?.call();
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧星期列表：显示周一到周日的文本标签
          SizedBox(
            width: 50,
            child: Column(
              children: List.generate(7, (index) {
                return Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      weekdays[index],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          // 右侧日程方格：使用GridView构建7列的日程网格
          Expanded(
            child: GridView.builder(
              // 网格代理，设置为固定列数的网格布局
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, // 7列，对应一周7天
                crossAxisSpacing: 1, // 列间距
                mainAxisSpacing: 1, // 行间距
                childAspectRatio: 0.7, // 调整方格的宽高比
              ),
              // 禁用 GridView 的滚动，避免与手势检测冲突
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 7, // 总共7个子项，对应一周7天
              itemBuilder: (context, index) {
                // 获取当前索引对应的日期
                final day = weekDays[index];
                // 获取该日期的所有日程
                final schedules = _getEventsForDay(day);
                
                // 构建单天日程卡片组件
                return _DayScheduleCard(
                  day: day,
                  schedules: schedules,
                  onEdit: onEdit,
                  onDelete: onDelete,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 单天日程方格组件
///
/// 用于展示单天的日程信息，以卡片形式呈现
/// 包含日期标题、分隔线和日程列表三个部分
class _DayScheduleCard extends StatelessWidget {
  final DateTime day;
  final List<Schedule> schedules;
  final Function(Schedule) onEdit;
  final Function(String) onDelete;

  /// 构造函数
  ///
  /// [day] 当前日期
  /// [schedules] 当天的日程列表
  /// [onEdit] 编辑日程的回调函数
  /// [onDelete] 删除日程的回调函数
  const _DayScheduleCard({
    required this.day,
    required this.schedules,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 日期标题：显示当前日期的天数
            Container(
              padding: const EdgeInsets.all(1),
              alignment: Alignment.center,
              child: Text(
                '${day.day}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // 分隔线：用于分隔日期标题和日程列表
            const Divider(height: 1, thickness: 1),
            // 日程列表：显示当天的日程，最多显示4个
            Expanded(
              child: schedules.isEmpty
                  // 如果没有日程，显示"无日程"提示
                  ? const Center(
                      child: Text(
                        '无日程',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  // 如果有日程，使用ListView.builder构建日程列表
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: schedules.length > 4 ? 4 : schedules.length, // 最多显示4个日程
                      itemBuilder: (context, index) {
                        final schedule = schedules[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 0.5),
                          child: Text(
                            schedule.title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 8,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
