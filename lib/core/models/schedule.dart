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
    // 创建一个新的 Schedule 对象，从 JSON 数据中提取各个字段
    return Schedule(
      id: json['id'] as String,  // 提取 ID 字符串
      title: json['title'] as String,  // 提取标题字符串
      description: json['description'] as String,  // 提取描述字符串
      dateTime: DateTime.parse(json['dateTime'] as String),  // 解析日期时间字符串
      priority: json['priority'] as int,  // 提取优先级整数
      category: json['category'] as String,  // 提取分类字符串
    );
  }

  /// 将Schedule对象转换为JSON Map
  /// 用于持久化存储或网络传输
  Map<String, dynamic> toJson() {
    // 创建一个 Map 来存储 Schedule 对象的所有属性
    final Map<String, dynamic> json = {};
    json['id'] = id;  // 存储 ID
    json['title'] = title;  // 存储标题
    json['description'] = description;  // 存储描述
    json['dateTime'] = dateTime.toIso8601String();  // 将日期时间转换为 ISO 8601 格式的字符串
    json['priority'] = priority;  // 存储优先级
    json['category'] = category;  // 存储分类
    return json;  // 返回包含所有属性的 Map
  }
}
