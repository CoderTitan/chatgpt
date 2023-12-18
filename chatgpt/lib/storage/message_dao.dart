import 'package:chatgpt/page/chat/message_model.dart';
import 'package:chatgpt/storage/db_manager.dart';
import 'package:chatgpt/storage/node_dao.dart';

///IMessage的的具体实现
class MessageDao implements TKMessage, TKTable {
  final DBManager manager;

  ///会话id
  final int cid;

  MessageDao(this.manager, {required this.cid}) : tableName = tableNameByCid(cid) {
    manager.db.execute('create table if not exists $tableName (id integer primary key autoincrement, content	text'
        ', createdAt	integer, ownerName	text, ownerType	text, avatar	text)');
  }

  ///获取带cid的表名称
  static String tableNameByCid(int cid) {
    return 'tb_$cid';
  }

  @override
  String tableName = '';

  @override
  Future<int> deleteMessage(int id) {
    return manager.db.delete(tableName, where: 'id=$id');
  }

  @override
  Future<List<MessageModel>> getAllMessage() async {
    var results = await manager.db.rawQuery('select * from $tableName order by id asc');

    ///将查询结果转成Dart Model以方便使用
    var list = results.map((item) => MessageModel.fromJson(item)).toList();
    return list;
  }

  @override
  Future<int> getMessageCount() async {
    var result = await manager.db.query(tableName, columns: ['COUNT(*) as cnt']);
    return result.first['cnt'] as int;
  }

  @override
  Future<List<MessageModel>> getMessages({int pageIndex = 1, int pageSize = 20}) async {
    var offset = (pageIndex - 1) * pageSize;
    var results = await manager.db.rawQuery('select * from $tableName order by id desc limit $pageSize offset $offset');

    ///将查询结果转成Dart Model以方便使用
    var list = results.map((item) => MessageModel.fromJson(item)).toList();

    ///反转列表以适应分页查询
    return List.from(list.reversed);
  }

  @override
  void saveMessage(MessageModel model) {
    manager.db.insert(tableName, model.toJson());
  }

  @override
  void update(MessageModel model) {
    manager.db.update(tableName, model.toJson(), where: 'id = ?', whereArgs: [model.id]);
  }
}

///消息表数据操作接口
abstract class TKMessage {
  /// 存储消息
  void saveMessage(MessageModel model);

  /// 更新消息
  void update(MessageModel model);

  /// 删除消息
  Future<int> deleteMessage(int id);

  /// 获取所有消息
  Future<List<MessageModel>> getAllMessage();

  ///分页查询，pageIndex页码从1开始，pageSize每页显示的数据量
  Future<List<MessageModel>> getMessages({int pageIndex = 1, int pageSize = 20});

  /// 获取消息个数
  Future<int> getMessageCount();
}
