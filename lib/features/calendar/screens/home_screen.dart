import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/models/schedule.dart';
import '../../schedule/widgets/schedule_list_view.dart';
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
  
  /// 视图管理器key
  final GlobalKey<ScheduleViewManagerState> _viewManagerKey =
      GlobalKey<ScheduleViewManagerState>();

  /// 视图历史记录
  final List<CalendarFormat> _viewHistory = [CalendarFormat.month];

  /// 初始化状态
  /// 在页面创建时初始化示例数据，并设置默认选中日期为今天
  @override
  void initState() {
    super.initState();

    _initializeData();
    _selectedDay = _focusedDay;
  }

  /// 初始化数据
  Future<void> _initializeData() async {
    await _scheduleService.initializeSampleData();
  }

  /// 处理返回操作
  Future<bool> _onWillPop() async {
    // 如果有视图历史记录且当前不是月视图，则返回到上一个视图
    if (_viewHistory.length > 1 && _calendarFormat != CalendarFormat.month) {
      setState(() {
        // 移除当前视图
        _viewHistory.removeLast();
        // 获取上一个视图
        _calendarFormat = _viewHistory.last;
      });
      return false; // 不退出应用
    } 
    // 如果当前是月视图且有历史记录，则移除月视图记录但不退出
    else if (_viewHistory.length > 1 && _calendarFormat == CalendarFormat.month) {
      setState(() {
        _viewHistory.removeLast();
      });
      return false; // 不退出应用
    }
    // 如果只有一种视图或没有历史记录，则退出应用
    else {
      return true; // 退出应用
    }
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
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) return;
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        },
        child: ScheduleViewManager(
          key: _viewManagerKey,
          initialView: _calendarFormat,
          onFormatChanged: (format) {
            // 更新视图历史记录
            if (_viewHistory.isEmpty || _viewHistory.last != format) {
              setState(() {
                _viewHistory.add(format);
                // 限制历史记录数量为10
                if (_viewHistory.length > 10) {
                  _viewHistory.removeAt(0);
                }
              });
            }
            
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
          onEdit: _editSchedule,
          onDelete: _confirmDeleteSchedule,
        ),
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
  Future<List<Schedule>> _getEventsForDay(DateTime day) async {
    // 获取所有日程
    final schedules = await _scheduleService.getAllSchedules();
    // 创建一个空列表来存储指定日期的日程
    List<Schedule> events = [];
    // 遍历所有日程，找出与指定日期相同的日程
    for (int i = 0; i < schedules.length; i++) {
      Schedule schedule = schedules[i];
      // 使用isSameDay函数检查日期是否相同
      if (isSameDay(schedule.dateTime, day)) {
        events.add(schedule);
      }
    }
    // 返回指定日期的日程列表
    return events;
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
    // 刷新视图
    _viewManagerKey.currentState?.refreshSchedules();
    // 显示添加成功的提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('日程添加成功')),
    );
  }

  /// 编辑日程
  /// [updatedSchedule] 更新后的日程对象
  void _editSchedule(Schedule updatedSchedule) {
    setState(() {
      _scheduleService.updateSchedule(updatedSchedule);
    });
    // 刷新视图
    _viewManagerKey.currentState?.refreshSchedules();
    // 显示编辑成功的提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('日程更新成功')),
    );
  }

  /// 删除日程
  /// [id] 要删除的日程ID
  void _deleteSchedule(String id) {
    setState(() {
      _scheduleService.deleteSchedule(id);
    });
    // 刷新视图
    _viewManagerKey.currentState?.refreshSchedules();
    // 显示删除成功的提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('日程删除成功')),
    );
  }

  /// 确认删除日程
  /// [id] 要删除的日程ID
  void _confirmDeleteSchedule(String id) {
    // 显示确认对话框
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('确认删除'),
          content: const Text('确定要删除这个日程吗？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
                _deleteSchedule(id); // 执行删除操作
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
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
