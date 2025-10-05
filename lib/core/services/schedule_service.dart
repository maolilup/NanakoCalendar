import '../models/schedule.dart';
import '../database/database_helper.dart';

/// 日程管理服务类
/// 负责处理日程的增删改查等业务逻辑
class ScheduleService {
  /// 数据库助手实例
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// 获取所有日程
  /// 返回当前所有日程的列表副本
  Future<List<Schedule>> getAllSchedules() async {
    // 调用数据库助手的方法获取所有日程
    return await _dbHelper.getAllSchedules();
  }

  /// 添加新日程
  /// [schedule] 要添加的日程对象
  Future<void> addSchedule(Schedule schedule) async {
    // 调用数据库助手的方法插入新日程
    await _dbHelper.insertSchedule(schedule);
  }

  /// 更新现有日程
  /// [updatedSchedule] 包含更新信息的日程对象
  Future<void> updateSchedule(Schedule updatedSchedule) async {
    // 调用数据库助手的方法更新日程
    await _dbHelper.updateSchedule(updatedSchedule);
  }

  /// 删除指定ID的日程
  /// [id] 要删除的日程的唯一标识符
  Future<void> deleteSchedule(String id) async {
    // 调用数据库助手的方法删除日程
    await _dbHelper.deleteSchedule(id);
  }

  /// 初始化示例数据
  /// 用于演示和测试目的，添加一些预设的日程项
  Future<void> initializeSampleData() async {
    // 检查是否已有数据
    final existingSchedules = await getAllSchedules();
    // 如果数据库中已有日程数据，则不添加示例数据
    if (existingSchedules.isNotEmpty) {
      return; // 如果已有数据，则不初始化示例数据
    }
    
    // 创建示例日程数据
    final schedules = [
      Schedule(
        id: '1',
        title: '团队会议',
        description: '讨论项目进展和下一步计划',
        dateTime: DateTime.now().add(const Duration(hours: 2)),  // 2小时后
        priority: 3,  // 高优先级
        category: '工作',  // 工作分类
      ),
      Schedule(
        id: '2',
        title: '学习Flutter',
        description: '完成NanakoCalendar应用开发',
        dateTime: DateTime.now().add(const Duration(days: 1)),  // 1天后
        priority: 2,  // 中优先级
        category: '学习',  // 学习分类
      ),
    ];
    
    // 插入示例数据到数据库
    for (int i = 0; i < schedules.length; i++) {
      // 遍历示例日程列表，逐个添加到数据库
      await addSchedule(schedules[i]);
    }
  }
}
