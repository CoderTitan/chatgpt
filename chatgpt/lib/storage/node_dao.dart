import 'package:chatgpt/storage/node_model.dart';
import 'package:sqflite/sqflite.dart';

/// Note的的具体实现
class NoteDao implements TKNode, TKTable {
  final Database db;

  NoteDao(this.db) {
    db.execute('create table if not exists $tableName (id integer primary key autoincrement, content text)');
  }

  @override
  String tableName = 't_node';

  

  @override
  void saveNode(NoteModel model) {
    db.insert(tableName, model.toJson());
  }

  @override
  void updateNode(NoteModel model) {
    db.update(tableName, model.toJson(), where: 'id =?', whereArgs: [model.id]);
  }

  @override
  void deleteNode(int id) {
    db.delete(tableName, where: 'id=$id');
  }

  @override
  void clearNode() {
    db.delete(tableName);
  }

  @override
  Future<List<NoteModel>> getAllNotes() async {
    final results = await db.rawQuery('select * from $tableName');
    return results.map((item) => NoteModel.fromJson(item)).toList();
  }

  @override
  Future<int> getNoteCount() async {
    final result = await db.query(tableName, columns: ['COUNT(*) as cnt']);
    return result.first['cnt'] as int;
  }
  
  @override
  Future<NoteModel?> getNode(int id) async {
    final results = await db.query(tableName, where: 'id=$id');
    final result = results.first;
    return NoteModel.fromJson(result);
  }
}

/// 数据表接口
abstract class TKTable {
  late String tableName;
}

/// Node表数据操作接口
abstract class TKNode {
  /// 根据id查询数据
  Future<NoteModel?> getNode(int id);

  /// 存储数据
  void saveNode(NoteModel model);

  /// 删除数据
  void deleteNode(int id);

  /// 清空数据
  void clearNode();

  /// 更新数据
  void updateNode(NoteModel model);

  /// 获取所有数据
  Future<List<NoteModel>> getAllNotes();

  /// 获取所有数据个数
  Future<int> getNoteCount();
}
