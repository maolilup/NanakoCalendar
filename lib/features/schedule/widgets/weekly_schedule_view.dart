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

  /// 缓存的日程数据
  final List<Schedule>? cachedSchedules;

  /// 构造函数
  WeeklyScheduleView({
    super.key,
    required this.focusedDay,
    required this.scheduleService,
    required this.onEdit,
    required this.onDelete,
    this.onSwipeUp,
    this.onSwipeDown,
    this.cachedSchedules,
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

  /// 存储缓存的日程数据
  List<Schedule> _cachedSchedules = [];

  /// 加载日程数据
  void _loadSchedules(List<Schedule> schedules) {
    _cachedSchedules = schedules;
  }

  /// 获取指定日期的日程
  ///
  /// 从缓存的日程数据中筛选出与指定日期同一天的日程
  /// 使用table_calendar包的isSameDay函数来比较日期是否为同一天
  List<Schedule> _getEventsForDay(DateTime day) {
    final schedules = cachedSchedules ?? _cachedSchedules;
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

    // 生成24小时的时间列表
    final List<int> hours = List.generate(24, (index) => index);

    // 星期几的中文名称
    final List<String> weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

    // 创建一个ScrollController用于同步滚动
    final ScrollController scrollController = ScrollController();

    return Column(
      children: [
        // 顶部工具栏，包含返回按钮
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 返回按钮
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // 调用返回回调函数
                onSwipeDown?.call();
              },
            ),
            // 标题
            Text(
              '周视图',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // 占位符，用于保持标题居中
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.transparent),
              onPressed: null,
            ),
          ],
        ),
        // 创建一个大的整体组件，包含时间轴、星期表和日程区域
        Expanded(
          child: _WeeklyScheduleContent(
            weekDays: weekDays,
            weekdays: weekdays,
            scrollController: scrollController,
            getEventsForDay: _getEventsForDay,
          ),
        ),
      ],
    );
  }
}

/// 大组件：包含时间轴、星期表和日程区域
class _WeeklyScheduleContent extends StatefulWidget {
  final List<DateTime> weekDays;
  final List<String> weekdays;
  final ScrollController scrollController;
  final List<Schedule> Function(DateTime) getEventsForDay;

  const _WeeklyScheduleContent({
    required this.weekDays,
    required this.weekdays,
    required this.scrollController,
    required this.getEventsForDay,
  });

  @override
  _WeeklyScheduleContentState createState() => _WeeklyScheduleContentState();
}

class _WeeklyScheduleContentState extends State<_WeeklyScheduleContent> {
  late ScrollController _horizontalScrollController;

  @override
  void initState() {
    super.initState();
    _horizontalScrollController = ScrollController();
    // 同步滚动控制器
    widget.scrollController.addListener(_syncScroll);
  }

  void _syncScroll() {
    if (_horizontalScrollController.hasClients) {
      _horizontalScrollController.jumpTo(widget.scrollController.offset);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_syncScroll);
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 时间轴（24小时）
        Container(
          height: 50,
          child: Row(
            children: [
              // 左上角占位符
              Container(
                width: 50,
                child: Center(
                  child: Text(
                    '时间',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // 时间刻度
              Expanded(
                child: ListView.builder(
                  controller: widget.scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: 24,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 60,
                      child: Center(
                        child: Text(
                          '${index}:00',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // 整合的星期表和日程区域组件
        Expanded(
          child: _ScheduleAndWeekdaysContent(
            weekDays: widget.weekDays,
            weekdays: widget.weekdays,
            scrollController: _horizontalScrollController,
            getEventsForDay: widget.getEventsForDay,
          ),
        ),
      ],
    );
  }
}

/// 整合的星期表和日程区域组件
class _ScheduleAndWeekdaysContent extends StatelessWidget {
  final List<DateTime> weekDays;
  final List<String> weekdays;
  final ScrollController scrollController;
  final List<Schedule> Function(DateTime) getEventsForDay;

  const _ScheduleAndWeekdaysContent({
    required this.weekDays,
    required this.weekdays,
    required this.scrollController,
    required this.getEventsForDay,
  });

  // 定义一些颜色用于区分不同的日程
  static final List<Color> scheduleColors = [
    Color(0xFFBBDEFB), // blue.shade100
    Color(0xFFC8E6C9), // green.shade100
    Color(0xFFFFE0B2), // orange.shade100
    Color(0xFFF3E5F5), // purple.shade100
    Color(0xFFFFCDD2), // red.shade100
    Color(0xFFB2DFDB), // teal.shade100
    Color(0xFFF8BBD0), // pink.shade100
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左侧星期列表
        Container(
          width: 50,
          child: Column(
            children: List.generate(7, (index) {
              return Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFE0E0E0), // grey.shade300
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      weekdays[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        // 右侧日程内容（一周作为一个整体）
        Expanded(
          child: Container(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: 24,
              itemBuilder: (context, hourIndex) {
                return Container(
                  width: 60,
                  child: Column(
                    children: List.generate(7, (dayIndex) {
                      final day = weekDays[dayIndex];
                      final schedules = getEventsForDay(day);

                      // 获取当前小时的日程
                      final hourSchedules = schedules.where((schedule) {
                        return schedule.dateTime.hour == hourIndex;
                      }).toList();

                      return Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: hourSchedules.isEmpty
                                ? Colors.transparent
                                : scheduleColors[dayIndex %
                                      scheduleColors.length],
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFE0E0E0), // grey.shade300
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: hourSchedules.isEmpty
                              ? null // 无日程时显示空白
                              : Column(
                                  children: hourSchedules.map((schedule) {
                                    return Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(2),
                                        child: Text(
                                          schedule.title,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// 单天日程方格组件
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
      shape: Border.fromBorderSide(BorderSide.none),
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
            // 日程列表：显示当天的日程，最多显示4个
            Expanded(
              child: schedules.isEmpty
                  ? const Center(
                      child: Text(
                        '无日程',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    )
                  // 如果有日程，使用ListView.builder构建日程列表
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: schedules.length > 4
                          ? 4
                          : schedules.length, // 最多显示4个日程
                      itemBuilder: (context, index) {
                        final schedule = schedules[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 1,
                            vertical: 0.5,
                          ),
                          child: Text(
                            schedule.title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 8),
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
