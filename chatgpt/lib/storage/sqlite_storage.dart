import 'package:chatgpt/storage/node_dao.dart';
import 'package:chatgpt/storage/node_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

///数据存储类，可以实现不同的业务接口
class SqliteStorage implements TKNode {
  /// 多实例
  static final Map<String, SqliteStorage> _storageMap = {};

  ///数据库名字
  final String _dbName;

  /// 数据库实例
  late Database _db;

  ///多实例模式，一个数据库一个实例
  SqliteStorage._({required String dbName}) : _dbName = dbName {
    _storageMap[_dbName] = this;
  }

  ///初始化数据库
  Future<SqliteStorage> _init() async {
    _db = await openDatabase(_dbName);
    debugPrint('db ver:${await _db.getVersion()}');
    return this;
  }

  ///获取HiStorage实例
  static Future<SqliteStorage> instance({required String dbName}) async {
    if (!dbName.endsWith('.db')) {
      dbName = '$dbName.db';
    }

    var storage = _storageMap[dbName];
    storage ??= await SqliteStorage._(dbName: dbName)._init();
    return storage;
  }

  ///销毁数据库
  void dispose() {
    _db.close();
    _storageMap.remove(_dbName);
  }

  @override
  Future<List<NoteModel>> getAllNotes() {
    return NoteDao(_db).getAllNotes();
  }

  @override
  Future<int> getNoteCount() {
    return NoteDao(_db).getNoteCount();
  }

  @override
  Future<NoteModel?> getNode(int id) {
    return NoteDao(_db).getNode(id);
  }

  @override
  void saveNode(NoteModel model) {
    NoteDao(_db).saveNode(model);
  }

  @override
  void updateNode(NoteModel model) {
    NoteDao(_db).updateNode(model);
  }

  @override
  void clearNode() {
    NoteDao(_db).clearNode();
  }

  @override
  void deleteNode(int id) {
    NoteDao(_db).deleteNode(id);
  }
}
