import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taches/models/task.dart';

class MyDataBase {
  static const _nameTableTasks = "tasks";
  static Database? _database; // la base de donné

  // getter pour recuperer la base de donnée
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  // initio=alisation de la bas de donnée
  Future<Database?> initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), "tasks_database.db"),
      onCreate: (Database db, int version) async {
        return db.execute(
            "CREATE TABLE IF NOT EXISTS $_nameTableTasks(id TEXT PRIMARY KEY, content TEXT, description TEXT, isPrio INTEGER, isFinish INTEGER, dateEnd TEXT, dateEdit TEXT, address TEXT, latitude REAL, longitude REAL)");
      },
      version: 1,
    );
  }

  // inserer un element
  Future<void> insertTask(Task task) async {
    final Database? db = await database;
    await db?.insert(
      _nameTableTasks,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // suprimer un element
  Future<void> deleteTask(String id) async {
    final Database? db = await database;
    await db?.delete(
      _nameTableTasks,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // mettre a jour un element
  Future<void> updateTask(Task task) async {
    final Database? db = await database;
    await db?.update(
      _nameTableTasks,
      task.toMap(),
      where: "id = ?",
      whereArgs: [task.id],
    );
  }

  // recuperer la liste des taches sauvés
  Future<List<Task>> tasks() async {
    final Database? db = await database;
    List<Map<String, Object?>>? maps = await db?.query(_nameTableTasks);
    return List.generate(maps!.length, (index) => Task.fromMap(maps[index]));
  }
}
