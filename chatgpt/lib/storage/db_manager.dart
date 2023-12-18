import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

///用于管理数据库的创建和销毁
class DBManager {
  ///多实例
  static final Map<String, DBManager> _storageMap = {};

  ///数据库名称
  final String _dbName;

  ///数据库实例
  late Database _db;

  Database get db => _db;

  ///获取Storage实例
  static Future<DBManager> instance({required String dbName}) async {
    if (!dbName.endsWith(".db")) {
      dbName = '$dbName.db';
    }
    var storage = _storageMap[dbName];
    storage ??= await DBManager._(dbName: dbName)._init();
    return storage;
  }

  ///多实例模式，一个数据库一个实例
  DBManager._({required String dbName}) : _dbName = dbName {
    _storageMap[dbName] = this;
  }

  ///初始化数据库
  Future<DBManager> _init() async {
    _db = await openDatabase(_dbName);
    debugPrint('db ver:${await _db.getVersion()}');
    return this;
  }

  ///销毁数据库
  void destroy() {
    _db.close();
    _storageMap.remove(_dbName);
  }

  ///账号唯一标识
  static String getAccountHash() {
    return 'test';
  }
}
