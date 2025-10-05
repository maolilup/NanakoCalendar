import 'package:flutter/material.dart';
import '../../../core/models/schedule.dart';

/// 日程卡片组件
/// 用于在列表中展示单个日程项的UI组件
class ScheduleCard extends StatelessWidget {
  /// 要显示的日程对象
  final Schedule schedule;
  
  /// 编辑日程的回调函数
  final Function(Schedule) onEdit;
  
  /// 删除日程的回调函数
  final Function(String) onDelete;

  /// 构造函数
  /// [schedule] 要显示的日程对象
  /// [onEdit] 编辑日程的回调函数
  /// [onDelete] 删除日程的回调函数
  const ScheduleCard({
    super.key,
    required this.schedule,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // 根据优先级确定颜色
    Color priorityColor;
    // 使用if-else语句替代switch语句，更简单易懂
    if (schedule.priority == 1) {
      priorityColor = Colors.green;  // 低优先级 - 绿色
    } else if (schedule.priority == 2) {
      priorityColor = Colors.orange; // 中优先级 - 橙色
    } else if (schedule.priority == 3) {
      priorityColor = Colors.red;    // 高优先级 - 红色
    } else {
      priorityColor = Colors.grey;   // 默认灰色
    }

    // 返回卡片组件
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        // 日程标题
        title: Text(schedule.title),
        // 日程详细信息
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 日程描述
            Text(schedule.description),
            const SizedBox(height: 5),
            // 时间和分类信息行
            Row(
              children: [
                // 时间图标
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                // 格式化的时间显示
                Text(
                  '${schedule.dateTime.month}-${schedule.dateTime.day} ${schedule.dateTime.hour}:${schedule.dateTime.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 10),
                // 分类标签
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.2),  // 使用withOpacity替代withValues
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    schedule.category,
                    style: TextStyle(
                      fontSize: 12,
                      color: priorityColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // 优先级指示器（左侧小圆点）
        leading: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: priorityColor,
            shape: BoxShape.circle,
          ),
        ),
        // 右侧操作菜单
        trailing: PopupMenuButton<String>(
          onSelected: (String result) {
            // 根据选择执行相应操作
            // 使用if-else语句替代switch语句，更简单易懂
            if (result == 'edit') {
              // 调用编辑回调
              onEdit(schedule);
            } else if (result == 'delete') {
              // 直接调用删除回调，确认对话框在HomeScreen中显示
              onDelete(schedule.id);
            }
          },
          // 菜单项
          itemBuilder: (BuildContext context) {
            // 创建菜单项列表
            List<PopupMenuEntry<String>> menuItems = [];
            // 添加编辑菜单项
            menuItems.add(
              const PopupMenuItem<String>(
                value: 'edit',
                child: Text('编辑'),
              ),
            );
            // 添加删除菜单项
            menuItems.add(
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('删除'),
              ),
            );
            // 返回菜单项列表
            return menuItems;
          },
        ),
      ),
    );
  }
}
