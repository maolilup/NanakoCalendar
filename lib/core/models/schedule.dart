/// 日程数据模型类
/// 用于表示单个日程项的所有属性
class Schedule {
  /// 日程唯一标识符
  final String id;
  
  /// 日程标题
  final String title;
  
  /// 日程描述详情
  final String description;
  
  /// 日程时间
  final DateTime dateTime;
  
  /// 日程优先级 (1-低, 2-中, 3-高)
  final int priority;
  
  /// 日程分类 (如工作、学习、生活等)
  final String category;

  /// 构造函数，创建一个新的日程对象
  /// 所有参数都是必需的
  Schedule({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.priority,
    required this.category,
  });

  /// 从JSON Map创建Schedule对象的工厂构造函数
  /// 用于从持久化存储或网络请求中恢复日程数据
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dateTime: DateTime.parse(json['dateTime']),
      priority: json['priority'],
      category: json['category'],
    );
  }

  /// 将Schedule对象转换为JSON Map
  /// 用于持久化存储或网络传输
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'priority': priority,
      'category': category,
    };
  }
}
