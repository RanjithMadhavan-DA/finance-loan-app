import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    print("createservice Creation works");
    var database = initDb();
    return database;
  }

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initDb();
      return _database!;
    }
  }

  String? ls_db;
  Future<Database> initDb() async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      final databaseFactory = databaseFactoryFfi;
      final appDocumentsDir = await getApplicationDocumentsDirectory();
      final dbPath = join(appDocumentsDir.path, "databases", "fin3.db");
      ls_db = appDocumentsDir.path;
      final winLinuxDB = await databaseFactory.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(version: 1, onCreate: _oncreate),
      );
      return winLinuxDB;
    } else if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, "fin3.db");
      final iOSAndroidDB = await openDatabase(
        path,
        version: 1,
        onCreate: _oncreate,
      );
      return iOSAndroidDB;
    }
    throw Exception("Unsupported platform");
  }

  Future<void> _oncreate(Database database, int version) async {
    await database.execute("PRAGMA foreign_keys = ON");
    String sql = """CREATE TABLE IF NOT EXISTS tab_fin(
    id TEXT PRIMARY KEY ,
     customerName TEXT,
    phoneNumber TEXT,
    dateIssued TEXT,
    amountTaken REAL,
     amountPaid REAL,
    description TEXT,
    interestRate REAL,
    fineAmount REAL
    );
    """;
    await database.execute(sql);

    await database.execute(
      '''CREATE TABLE IF NOT EXISTS tab_transaction(id TEXT PRIMARY KEY ,
     loanId TEXT,
     type TEXT,
    amount REAL,
    date TEXT)''',
    );
  }
}
