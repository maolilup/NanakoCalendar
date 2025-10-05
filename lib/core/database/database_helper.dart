import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/schedule.dart';

/// 数据库管理助手类
/// 负责处理数据库的创建、初始化和基本操作
class DatabaseHelper {
  /// 数据库名称
  static const String _dbName = 'schedules.db';
  
  /// 数据库版本
  static const int _dbVersion = 1;
  
  /// 表名
  static const String tableSchedules = 'schedules';
  
  /// 数据库实例
  static Database? _database;
  
  /// 获取数据库实例
  Future<Database> get database async {
    // 检查数据库实例是否已经存在
    if (_database != null) {
      // 如果存在，直接返回现有的数据库实例
      return _database!;
    }
    // 如果不存在，初始化数据库并保存实例
    _database = await _initDatabase();
    return _database!;
  }
  
  /// 初始化数据库
  Future<Database> _initDatabase() async {
    // 获取应用文档目录，这是存储数据库文件的地方
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // 构建数据库文件的完整路径
    String path = join(documentsDirectory.path, _dbName);
    
    // 打开或创建数据库
    // 如果数据库不存在，会调用 _onCreate 方法创建表结构
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }
  
  /// 创建数据库表
  Future<void> _onCreate(Database db, int version) async {
    // 执行 SQL 语句创建日程表
    // 表包含以下字段：
    // - id: 文本类型，主键
    // - title: 文本类型，标题，不能为空
    // - description: 文本类型，描述
    // - dateTime: 文本类型，日期时间，不能为空
    // - priority: 整数类型，优先级，不能为空
    // - category: 文本类型，分类，不能为空
    await db.execute('''
      CREATE TABLE $tableSchedules (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        dateTime TEXT NOT NULL,
        priority INTEGER NOT NULL,
        category TEXT NOT NULL
      )
    ''');
  }
  
  /// 插入新的日程
  Future<void> insertSchedule(Schedule schedule) async {
    // 获取数据库实例
    final db = await database;
    // 将 Schedule 对象转换为 JSON Map 并插入到数据库中
    // 如果遇到冲突（ID已存在），则替换现有记录
    await db.insert(
      tableSchedules,
      schedule.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  /// 获取所有日程
  Future<List<Schedule>> getAllSchedules() async {
    // 获取数据库实例
    final db = await database;
    // 查询所有日程记录
    final List<Map<String, dynamic>> maps = await db.query(tableSchedules);
    
    // 将查询结果转换为 Schedule 对象列表
    // 使用更简单的循环方式替代 List.generate
    List<Schedule> schedules = [];
    for (int i = 0; i < maps.length; i++) {
      schedules.add(Schedule.fromJson(maps[i]));
    }
    return schedules;
  }
  
  /// 根据ID更新日程
  Future<void> updateSchedule(Schedule schedule) async {
    // 获取数据库实例
    final db = await database;
    // 根据 ID 更新日程记录
    await db.update(
      tableSchedules,
      schedule.toJson(),  // 将 Schedule 对象转换为 JSON Map
      where: 'id = ?',  // 更新条件：ID 等于指定值
      whereArgs: [schedule.id],  // 条件参数
    );
  }
  
  /// 根据ID删除日程
  Future<void> deleteSchedule(String id) async {
    // 获取数据库实例
    final db = await database;
    // 根据 ID 删除日程记录
    await db.delete(
      tableSchedules,
      where: 'id = ?',  // 删除条件：ID 等于指定值
      whereArgs: [id],  // 条件参数
    );
  }
  
  /// 关闭数据库连接
  Future<void> close() async {
    // 获取数据库实例
    final db = await database;
    // 关闭数据库连接
    db.close();
  }
}
