import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/models/schedule.dart';
import '../../schedule/widgets/schedule_list_view.dart';
import '../../calendar/widgets/calendar_widget.dart';
import '../../../core/services/schedule_service.dart';
import '../../../shared/widgets/add_schedule_fab.dart';
import '../../schedule/widgets/schedule_view_manager.dart';

/// 主页面组件
/// 应用的主界面，展示日程列表和操作入口
class HomeScreen extends StatefulWidget {
  /// 构造函数
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// 主页面状态类
class _HomeScreenState extends State<HomeScreen> {
  /// 日程服务实例
  final ScheduleService _scheduleService = ScheduleService();

  /// 日历相关状态
  /// _calendarFormat: 控制日历显示格式（月视图、周视图）
  /// _focusedDay: 当前聚焦的日期（用于页面切换）
  /// _selectedDay: 当前选中的日期
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  /// 初始化状态
  /// 在页面创建时初始化示例数据，并设置默认选中日期为今天
  @override
  void initState() {
    super.initState();

    _scheduleService.initializeSampleData();
    _selectedDay = _focusedDay;
  }

  /// 构建页面UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 应用栏
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Nanako Calendar'),
      ),
      // 页面主体内容
      body: ScheduleViewManager(
        initialView: _calendarFormat,
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
        },
        onSwipeUp: () {
          // 上滑时切换到月视图
          if (_calendarFormat != CalendarFormat.week) {
            setState(() {
              _calendarFormat = CalendarFormat.month;
            });
          }
        },
        onSwipeDown: () {
          // 下滑时切换到月视图
          print('HomeScreen: 检测到下滑手势，切换到月视图');
          setState(() {
            _calendarFormat = CalendarFormat.month;
          });
        },
      ),
      // 浮动操作按钮
      floatingActionButton: AddScheduleFloatingActionButton(
        onPressed: _showAddScheduleDialog,
      ),
    );
  }

  /// 获取指定日期的日程
  /// [day] 指定的日期
  /// 返回该日期的所有日程列表
  List<Schedule> _getEventsForDay(DateTime day) {
    final schedules = _scheduleService.getAllSchedules();
    // 使用isSameDay函数过滤出与指定日期相同的日程
    return schedules.where((schedule) {
      return isSameDay(schedule.dateTime, day);
    }).toList();
  }

  /// 构建日程列表
  /// 根据选中的日期显示对应的日程列表
  Widget _buildScheduleList() {
    return ScheduleListView(
      selectedDay: _selectedDay ?? DateTime.now(),
      scheduleService: _scheduleService,
      onEdit: _editSchedule,
      onDelete: _deleteSchedule,
    );
  }

  /// 添加新日程
  /// [schedule] 要添加的日程对象
  void _addSchedule(Schedule schedule) {
    setState(() {
      _scheduleService.addSchedule(schedule);
    });
  }

  /// 编辑日程
  /// [updatedSchedule] 更新后的日程对象
  void _editSchedule(Schedule updatedSchedule) {
    setState(() {
      _scheduleService.updateSchedule(updatedSchedule);
    });
  }

  /// 删除日程
  /// [id] 要删除的日程ID
  void _deleteSchedule(String id) {
    setState(() {
      _scheduleService.deleteSchedule(id);
    });
  }

  /// 显示添加/编辑日程对话框
  /// [schedule] 要编辑的日程对象，如果为null则表示添加新日程
  void _showAddScheduleDialog({Schedule? schedule}) {
    // 初始化文本控制器
    final titleController = TextEditingController(text: schedule?.title ?? '');
    final descriptionController = TextEditingController(
      text: schedule?.description ?? '',
    );

    // 初始化选择项
    String selectedCategory = schedule?.category ?? '工作';
    int selectedPriority = schedule?.priority ?? 2;

    // 如果是编辑日程，使用日程的日期，否则使用当前选定日期
    DateTime selectedDate =
        schedule?.dateTime ?? (_selectedDay ?? DateTime.now());

    // 分类选项
    final categories = ['工作', '学习', '生活', '娱乐'];

    // 显示对话框
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              // 标题
              title: Text(schedule == null ? '添加日程' : '编辑日程'),
              // 内容
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 标题输入框
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: '标题',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // 描述输入框
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: '描述',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 10),
                    // 日期选择
                    ListTile(
                      title: const Text('日期'),
                      subtitle: Text(
                        '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        // 显示日期选择器
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        // 如果选择了新日期，则更新selectedDate状态
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    // 分类下拉选择
                    DropdownButtonFormField<String>(
                      initialValue: selectedCategory,
                      items: categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: '分类',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // 优先级下拉选择
                    DropdownButtonFormField<int>(
                      initialValue: selectedPriority,
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('低')),
                        DropdownMenuItem(value: 2, child: Text('中')),
                        DropdownMenuItem(value: 3, child: Text('高')),
                      ],
                      onChanged: (int? newValue) {
                        setState(() {
                          selectedPriority = newValue!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: '优先级',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              // 操作按钮
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    // 验证输入
                    if (titleController.text.isNotEmpty) {
                      if (schedule == null) {
                        // 添加新日程
                        final newSchedule = Schedule(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: titleController.text,
                          description: descriptionController.text,
                          dateTime: selectedDate,
                          priority: selectedPriority,
                          category: selectedCategory,
                        );
                        _addSchedule(newSchedule);
                      } else {
                        // 更新日程
                        final updatedSchedule = Schedule(
                          id: schedule.id,
                          title: titleController.text,
                          description: descriptionController.text,
                          dateTime: selectedDate,
                          priority: selectedPriority,
                          category: selectedCategory,
                        );
                        _editSchedule(updatedSchedule);
                      }
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(schedule == null ? '添加' : '更新'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
