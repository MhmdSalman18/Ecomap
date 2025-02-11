import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'drafts';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'draft_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        imagePath TEXT,
        location TEXT,
        date TEXT
      )
    ''');
  }

  Future<int> insertDraft(Map<String, dynamic> draft) async {
    final db = await database;
    return await db.insert(tableName, draft);
  }

  Future<List<Map<String, dynamic>>> getDrafts() async {
    final db = await database;
    return await db.query(tableName);
  }

  Future<Map<String, dynamic>?> getLatestDraft() async {
      final db = await database;
      List<Map<String, dynamic>> drafts = await db.query(
        tableName,
        orderBy: 'id DESC',
        limit: 1,
      );
      if (drafts.isNotEmpty) {
        return drafts.first;
      } else {
        return null;
      }
    }


  Future<int> updateDraft(int id, Map<String, dynamic> draft) async {
    final db = await database;
    return await db.update(tableName, draft, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteDraft(int id) async {
    final db = await database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getDraft(int id) async {
  final db = await database;
  List<Map<String, dynamic>> drafts = await db.query(
    tableName,
    where: 'id = ?',
    whereArgs: [id],
  );
  if (drafts.isNotEmpty) {
    return drafts.first;
  } else {
    return null;
  }
}


}





