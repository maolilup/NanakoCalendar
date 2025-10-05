import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/models/schedule.dart';
import '../../../core/services/schedule_service.dart';
import '../../calendar/widgets/calendar_widget.dart';
import 'daily_schedule_view.dart';
import 'weekly_schedule_view.dart';
import 'monthly_schedule_view.dart';

/// 统一的视图管理组件
/// 管理日程应用中不同视图（日、周、月视图）的显示和切换
class ScheduleViewManager extends StatefulWidget {
  /// 构造函数
  ///
  /// [key] 组件的键值
  /// [initialView] 初始视图格式，默认为月视图
  /// [onBack] 返回回调函数
  /// [onFormatChanged] 格式改变回调函数
  /// [onDaySelected] 日期选择回调函数
  /// [onPageChanged] 页面改变回调函数
  /// [onSwipeUp] 上滑回调函数
  const ScheduleViewManager({
    super.key,
    this.initialView = CalendarFormat.month,
    this.onBack,
    this.onFormatChanged,
    this.onDaySelected,
    this.onPageChanged,
    this.onSwipeUp,
    this.onSwipeDown,
    this.onEdit,
    this.onDelete,
  });

  /// 初始视图格式
  ///
  /// 决定组件初始化时显示的视图类型（日、周、月视图）
  final CalendarFormat initialView;

  /// 返回回调函数
  ///
  /// 当用户执行返回操作时触发的回调函数
  final VoidCallback? onBack;

  /// 格式改变回调函数
  ///
  /// 当日历视图格式发生改变时触发的回调函数
  /// [CalendarFormat] 参数表示新的视图格式
  final Function(CalendarFormat)? onFormatChanged;

  /// 日期选择回调函数
  ///
  /// 当用户选择一个日期时触发的回调函数
  /// 第一个 [DateTime] 参数表示选中的日期
  /// 第二个 [DateTime] 参数表示聚焦的日期
  final Function(DateTime, DateTime)? onDaySelected;

  /// 页面改变回调函数
  ///
  /// 当日历页面发生改变时触发的回调函数
  /// [DateTime] 参数表示新的聚焦日期
  final Function(DateTime)? onPageChanged;

  /// 上滑回调函数
  ///
  /// 当用户在组件上执行上滑手势时触发的回调函数
  final VoidCallback? onSwipeUp;

  /// 下滑回调函数
  ///
  /// 当用户在组件上执行下滑手势时触发的回调函数
  final VoidCallback? onSwipeDown;

  /// 编辑日程回调函数
  ///
  /// 当用户选择编辑日程时触发的回调函数
  /// [Schedule] 参数表示要编辑的日程对象
  final Function(Schedule)? onEdit;

  /// 删除日程回调函数
  ///
  /// 当用户选择删除日程时触发的回调函数
  /// [String] 参数表示要删除的日程ID
  final Function(String)? onDelete;

  @override
  State<ScheduleViewManager> createState() => ScheduleViewManagerState();
}

/// 视图管理器状态类
///
/// 管理 ScheduleViewManager 组件的所有状态，包括日历格式、聚焦日期、选中日期等。
/// 还负责构建不同视图的内容和处理用户交互事件。
class ScheduleViewManagerState extends State<ScheduleViewManager> {
  /// 日程服务实例
  ///
  /// 用于获取和管理日程数据的服务实例
  final ScheduleService _scheduleService = ScheduleService();

  /// 日历相关状态
  ///
  /// [_calendarFormat] 当前日历视图格式（日、周、月）
  /// [_focusedDay] 当前聚焦的日期（用于确定周视图的范围或月视图的页面）
  /// [_selectedDay] 当前选中的日期（用于高亮显示和日程展示）
  late CalendarFormat _calendarFormat;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  /// 初始化状态
  ///
  /// 在组件初始化时设置初始视图格式和选中日期
  /// 将选中日期默认设置为聚焦日期
  @override
  void initState() {
    super.initState();
    _calendarFormat = widget.initialView;
    _selectedDay = _focusedDay;
    // 加载日程数据
    _loadSchedules();
  }

  /// 当组件的配置发生变化时调用
  ///
  /// 当父组件传递的参数发生变化时，更新内部状态
  @override
  void didUpdateWidget(covariant ScheduleViewManager oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 如果初始视图格式发生变化，更新内部状态
    if (oldWidget.initialView != widget.initialView) {
      setState(() {
        _calendarFormat = widget.initialView;
      });
    }
  }

  /// 存储缓存的日程数据
  List<Schedule> _cachedSchedules = [];

  /// 获取所有日程（缓存版本）
  Future<void> _loadSchedules() async {
    _cachedSchedules = await _scheduleService.getAllSchedules();
  }

  /// 刷新缓存数据
  Future<void> refreshSchedules() async {
    await _loadSchedules();
    // 重新构建视图
    setState(() {});
  }

  /// 获取指定日期的日程
  ///
  /// 从缓存的日程数据中筛选出与指定日期同一天的日程
  /// 使用 table_calendar 包的 isSameDay 函数来比较日期是否为同一天
  ///
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

  /// 默认的下滑回调函数
  void _defaultOnSwipeDown() {
    // 如果没有提供 onSwipeDown 回调，则默认切换到月视图
    setState(() {
      _calendarFormat = CalendarFormat.month;
    });
    // 调用外部传入的回调函数
    widget.onFormatChanged?.call(CalendarFormat.month);
  }

  /// 构建月视图内容
  Widget _buildMonthlyView() {
    final monthlyView = MonthlyScheduleView(
      selectedDay: _selectedDay ?? DateTime.now(),
      scheduleService: _scheduleService,
      onEdit: widget.onEdit ?? (schedule) {},
      onDelete: widget.onDelete ?? (id) {},
    );
    
    // 传递缓存数据到月视图
    monthlyView.loadSchedules(_cachedSchedules);
    
    return monthlyView;
  }

  /// 构建周视图内容
  Widget _buildWeeklyView() {
    print(
      'ScheduleViewManager: 构建周视图，onSwipeDown是否为空: ${widget.onSwipeDown == null}',
    );
    return WeeklyScheduleView(
      focusedDay: _focusedDay,
      scheduleService: _scheduleService,
      onEdit: widget.onEdit ?? (schedule) {},
      onDelete: widget.onDelete ?? (id) {},
      onSwipeUp: widget.onSwipeUp,
      onSwipeDown: widget.onSwipeDown ?? _defaultOnSwipeDown,
      cachedSchedules: _cachedSchedules,
    );
  }

  /// 构建日视图内容
  Widget _buildDailyView() {
    final dailyView = DailyScheduleView(
      selectedDay: _selectedDay ?? DateTime.now(),
      scheduleService: _scheduleService,
      onEdit: widget.onEdit ?? (schedule) {},
      onDelete: widget.onDelete ?? (id) {},
      onSwipeDown: widget.onSwipeDown ?? _defaultOnSwipeDown,
    );
    
    // 传递缓存数据到日视图
    dailyView.loadSchedules(_cachedSchedules);
    
    return dailyView;
  }

  /// 构建视图内容
  ///
  /// 根据当前的日历格式（_calendarFormat）构建相应的视图组件：
  /// - 月视图：MonthlyScheduleView
  /// - 周视图：WeeklyScheduleView
  /// - 日视图：DailyScheduleView（默认）
  ///
  /// 每个视图组件都会传递相应的参数，包括日期、日程服务实例和回调函数
  Widget _buildViewContent() {
    // 根据当前的日历格式返回相应的视图组件
    if (_calendarFormat == CalendarFormat.month) {
      // 月视图：显示月度日程概览
      return _buildMonthlyView();
    } else if (_calendarFormat == CalendarFormat.week) {
      // 周视图：显示周度日程详情
      return _buildWeeklyView();
    } else {
      // 默认使用日视图：显示每日日程详情
      return _buildDailyView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 仅在月视图和日视图时显示日历组件
        // 周视图时隐藏日历组件以节省空间
        if (_calendarFormat != CalendarFormat.week)
          CalendarWidget(
            selectedDay: _selectedDay ?? DateTime.now(),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            // 处理日期选择触摸事件
            onDaySelected: (selectedDay, focusedDay) {
              // 调用外部传入的回调函数
              widget.onDaySelected?.call(selectedDay, focusedDay);

              // 更新状态：设置选中日期和聚焦日期
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            // 处理日历格式切换触摸事件
            onFormatChanged: (format, context) {
              // 调用外部传入的回调函数
              widget.onFormatChanged?.call(format);

              // 更新状态：设置新的日历格式
              setState(() {
                _calendarFormat = format;
              });
            },
            // 处理页面切换事件
            onPageChanged: (focusedDay) {
              // 调用外部传入的回调函数
              widget.onPageChanged?.call(focusedDay);

              // 更新状态：设置新的聚焦日期
              setState(() {
                _focusedDay = focusedDay;
              });
            },
          ),
        // 在日历组件和视图内容之间添加间距
        if (_calendarFormat != CalendarFormat.week) const SizedBox(height: 8.0),
        // 视图内容：根据当前格式显示相应的日程视图
        Expanded(child: _buildViewContent()),
      ],
    );
  }
}
