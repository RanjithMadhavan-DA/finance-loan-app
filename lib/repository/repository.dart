import 'package:sqflite/sqflite.dart';
import '../database/database_conn.dart';
import '../model/fin_model.dart';

class Repository {
  late DatabaseConnection _databaseConnection;
  Repository() {
    _databaseConnection = DatabaseConnection();
  }

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      print("repo move for initDb()");
      _database = await _databaseConnection.setDatabase();
      return _database!;
    }
  }

  insertItems(table, data) async {
    var connection = await database;
    print('inserted');
    return await connection.insert(table, data);
  }

  updateItems(table, model) async {
    var connection = await database;
    print('updated');
    return await connection.update(
      table,
      model,
      where: 'id=?',
      whereArgs: [model['id']],
    );
  }

  readID(table, data) async {
    var connection = await database;
    return await connection.query(table, where: 'id=?', whereArgs: [data]);
  }

  readItems(table) async {
    var connection = await database;
    print('readed');
    return await connection.query(table);
  }

  deleteItems(table, data) async {
    var connection = await database;
    print('deleted');
    return await connection.delete(table, where: 'id=?', whereArgs: [data]);
  }

  Future<List<FinanceModel>> searchName(String name) async {
    // final db = await databaseConnection.database;
    var connection = await database;

    final data = await connection.query(
      'tab_fin',
      where: 'customerName LIKE ? OR phoneNumber LIKE ?',
      whereArgs: ['%$name%', '%$name%'],
    );
    final items = data.map((e) => FinanceModel.fromJson(e)).toList();

    return items;
    // notifyListeners(); //change to ui
  }

  Future<List<FinanceModel>> filterLoans(String filter) async {
    final db = await database;

    List<Map<String, dynamic>> data;

    if (filter == "OPEN") {
      data = await db.query('tab_fin', where: 'amountTaken > amountPaid');
    } else if (filter == "CLOSED") {
      data = await db.query('tab_fin', where: 'amountTaken <= amountPaid');
    } else {
      data = await db.query('tab_fin');
    }

    return data.map((e) => FinanceModel.fromJson(e)).toList();
  }
}
