import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' ;
import 'package:timer/model/note.dart';


class NotesDatabase{
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notes.db');

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute("""
          CREATE TABLE $workOutNotes ( 
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  name TEXT NOT NULL,
  color TEXT NOT NULL,
  workoutTime INTEGER DEFAULT 5 ,
  restTime INTEGER DEFAULT 5 ,
  warmUpTime INTEGER DEFAULT 5,
  coolDownTime INTEGER DEFAULT 5,
  rep INTEGER DEFAULT 1,
  startDelay INTEGER DEFAULT 5
  )""");

  }

   Future<int> createWorkOut(WorkOut work) async {
     final db = await instance.database;

    final id = await db.insert(workOutNotes, work.toJson());
    return id;
  }

  Future<WorkOut> getWorkOutById(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      workOutNotes,
      columns: WorkOutFields.values,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return WorkOut.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<WorkOut>> getAllWorkOuts() async {
    final db = await instance.database;

    final result = await db.query(workOutNotes);

    return result.map((json) => WorkOut.fromJson(json)).toList();
  }


  Future<int> updateWorkOut(WorkOut work) async {
    final db = await instance.database;

    return db.update(
      workOutNotes,
      work.toJson(),
      where: 'id = ?',
      whereArgs: [work.id],
    );
  }


  Future<int> deleteWorkOut(int id) async {
    final db = await instance.database;

    return await db.delete(
      workOutNotes,
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future closeWorkOut() async {
    final db = await instance.database;
    db.close();
  }
}