import '../models/schedule.dart';

/// 日程管理服务类
/// 负责处理日程的增删改查等业务逻辑
class ScheduleService {
  /// 内存中的日程列表，用于模拟数据存储
  List<Schedule> _schedules = [];

  /// 获取所有日程
  /// 返回当前所有日程的列表副本
  List<Schedule> getAllSchedules() {
    return _schedules;
  }

  /// 添加新日程
  /// [schedule] 要添加的日程对象
  void addSchedule(Schedule schedule) {
    _schedules.add(schedule);
  }

  /// 更新现有日程
  /// [updatedSchedule] 包含更新信息的日程对象
  void updateSchedule(Schedule updatedSchedule) {
    // 查找要更新的日程在列表中的索引
    int index = _schedules.indexWhere((schedule) => schedule.id == updatedSchedule.id);
    // 如果找到了该日程，则替换它
    if (index != -1) {
      _schedules[index] = updatedSchedule;
    }
  }

  /// 删除指定ID的日程
  /// [id] 要删除的日程的唯一标识符
  void deleteSchedule(String id) {
    // 从列表中移除指定ID的日程
    _schedules.removeWhere((schedule) => schedule.id == id);
  }

  /// 初始化示例数据
  /// 用于演示和测试目的，添加一些预设的日程项
  void initializeSampleData() {
    _schedules = [
      Schedule(
        id: '1',
        title: '团队会议',
        description: '讨论项目进展和下一步计划',
        dateTime: DateTime.now().add(const Duration(hours: 2)),
        priority: 3,
        category: '工作',
      ),
      Schedule(
        id: '2',
        title: '学习Flutter',
        description: '完成NanakoCalendar应用开发',
        dateTime: DateTime.now().add(const Duration(days: 1)),
        priority: 2,
        category: '学习',
      ),
    ];
  }
}
