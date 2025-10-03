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
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  /// 初始化数据库
  Future<Database> _initDatabase() async {
    // 获取应用文档目录
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    
    // 打开或创建数据库
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }
  
  /// 创建数据库表
  Future<void> _onCreate(Database db, int version) async {
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
    final db = await database;
    await db.insert(
      tableSchedules,
      schedule.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  /// 获取所有日程
  Future<List<Schedule>> getAllSchedules() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableSchedules);
    
    return List.generate(maps.length, (i) {
      return Schedule.fromJson(maps[i]);
    });
  }
  
  /// 根据ID更新日程
  Future<void> updateSchedule(Schedule schedule) async {
    final db = await database;
    await db.update(
      tableSchedules,
      schedule.toJson(),
      where: 'id = ?',
      whereArgs: [schedule.id],
    );
  }
  
  /// 根据ID删除日程
  Future<void> deleteSchedule(String id) async {
    final db = await database;
    await db.delete(
      tableSchedules,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  /// 关闭数据库连接
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
