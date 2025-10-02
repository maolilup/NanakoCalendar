import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/models/schedule.dart';

/// 日历组件
/// 独立的日历视图组件，用于显示和选择日期
/// 处理用户触摸交互，包括日期选择、页面切换和格式切换
class CalendarWidget extends StatefulWidget {
  /// 构造函数
  /// [onDaySelected] 日期选择回调函数 - 处理用户点击日期的触摸事件
  /// [eventLoader] 事件加载器函数
  /// [selectedDay] 当前选中的日期
  /// [focusedDay] 当前聚焦的日期
  /// [calendarFormat] 日历显示格式
  /// [onFormatChanged] 日历格式改变回调函数 - 处理用户切换月视图/周视图的触摸事件
  /// [onPageChanged] 页面改变回调函数 - 处理用户滑动切换月份的触摸事件
  const CalendarWidget({
    super.key,
    required this.onDaySelected,
    required this.eventLoader,
    required this.selectedDay,
    required this.focusedDay,
    required this.calendarFormat,
    this.availableCalendarFormats = const {
      CalendarFormat.month: '月视图',
      CalendarFormat.week: '周视图',
    },
    required this.onFormatChanged,
    required this.onPageChanged,
  });

  /// 日期选择回调函数
  /// 当用户点击日历中的某个日期时触发的触摸事件处理函数
  /// 参数selectedDay表示用户选择的日期，focusedDay表示当前聚焦的日期
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;

  /// 事件加载器函数
  final List<Schedule> Function(DateTime day) eventLoader;

  /// 当前选中的日期
  /// 用于高亮显示用户当前选择的日期
  final DateTime selectedDay;

  /// 当前聚焦的日期
  /// 用于确定日历当前显示的月份/周
  final DateTime focusedDay;

  /// 日历显示格式
  /// 控制日历是显示月视图(CalendarFormat.month)还是周视图(CalendarFormat.week)
  final CalendarFormat calendarFormat;

  /// 可用的日历格式映射
  /// 用于定义每种格式对应的中文显示名称
  final Map<CalendarFormat, String> availableCalendarFormats;

  /// 日历格式改变回调函数
  /// 当用户点击右上角的格式切换按钮时触发的触摸事件处理函数
  /// 用于在月视图和周视图之间切换
  final void Function(CalendarFormat, BuildContext context) onFormatChanged;

  /// 页面改变回调函数
  /// 当用户水平滑动日历切换月份时触发的触摸事件处理函数
  /// 参数focusedDay表示滑动后新聚焦的日期
  final void Function(DateTime) onPageChanged;

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

/// 日历组件状态类
class _CalendarWidgetState extends State<CalendarWidget> {
  @override
  Widget build(BuildContext context) {
    return TableCalendar<Schedule>(
      // firstDay和lastDay定义日历的可选日期范围
      // 设置为2020年1月1日至2030年12月31日
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      // focusedDay表示当前聚焦的日期，决定日历显示哪个月份/周
      focusedDay: widget.focusedDay,
      // selectedDayPredicate用于确定哪些日期被选中，返回true的日期会高亮显示
      selectedDayPredicate: (day) => isSameDay(widget.selectedDay, day),
      // calendarFormat控制日历显示格式，支持月视图和周视图
      calendarFormat: widget.calendarFormat,
      // eventLoader用于加载指定日期的事件，返回该日期的所有日程安排
      eventLoader: widget.eventLoader,
      // startingDayOfWeek设置每周的第一天，这里设置为周一
      startingDayOfWeek: StartingDayOfWeek.monday,
      // calendarStyle自定义日历日期的样式
      calendarStyle: const CalendarStyle(
        // outsideDaysVisible设置是否显示非当前月份的日期（灰色显示）
        outsideDaysVisible: true,
      ),
      // headerStyle自定义日历头部样式
      headerStyle: const HeaderStyle(
        // formatButtonVisible设置是否显示格式切换按钮（月视图/周视图切换）
        formatButtonVisible: true,
        // titleCentered设置标题是否居中
        titleCentered: true,
        // formatButtonShowsNext设置格式按钮是否显示下一个格式
        formatButtonShowsNext: false,
      ),
      // availableCalendarFormats定义可用的日历格式映射
      availableCalendarFormats: widget.availableCalendarFormats,
      // 中文本地化配置，确保日历显示中文
      locale: 'zh_CN',
      // 自定义星期标题，将英文星期转换为中文显示
      daysOfWeekStyle: DaysOfWeekStyle(
        dowTextFormatter: (date, locale) {
          final weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
          return weekdays[date.weekday - 1];
        },
      ),
      // 自定义月份标题格式和日期单元格
      calendarBuilders: CalendarBuilders(
        // 自定义星期标题构建器
        dowBuilder: (context, day) {
          final weekdays = ['一', '二', '三', '四', '五', '六', '日'];
          return Center(
            child: Text(
              weekdays[day.weekday - 1],
              style: const TextStyle(fontSize: 12),
            ),
          );
        },
        // 根据日历格式决定是否显示日期内容
        defaultBuilder: (context, day, focusedDay) {
          // 周视图下不显示日期内容，月视图下正常显示
          return null;
        },
        // 选中日期的构建器
        selectedBuilder: (context, day, focusedDay) {
          // 周视图下不显示选中状态，月视图下正常显示
          return null;
        },
        // 今天日期的构建器
        todayBuilder: (context, day, focusedDay) {
          // 周视图下不显示今天状态，月视图下正常显示
          return null;
        },
      ),
      // onDaySelected处理日期选择事件
      // 当用户点击日历中的某个日期时触发，通过widget.onDaySelected回调传递给父组件
      onDaySelected: widget.onDaySelected,
      // onFormatChanged处理日历格式切换事件
      // 当用户点击右上角的格式切换按钮时触发，用于在月视图和周视图之间切换
      onFormatChanged: (format) {
        widget.onFormatChanged(format, context);
      },
      // onPageChanged处理页面切换事件
      // 当用户水平滑动日历切换月份时触发，通过widget.onPageChanged回调传递给父组件
      onPageChanged: widget.onPageChanged,
    );
  }
}
