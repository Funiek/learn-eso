import 'package:learneso/models/word.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = (Platform.isAndroid || Platform.isIOS || Platform.isMacOS)
        ? await getApplicationDocumentsDirectory()
        : await getApplicationSupportDirectory();

    String path = join(documentsDirectory.path, 'words.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE words(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          original TEXT,
          translated TEXT,
          description TEXT,
          priority INTEGER,
          translate_from TEXT,
          translate_to TEXT
        )
      ''');
  }

  Future<List<Word>> getWords() async {
    Database db = await instance.database;
    var words = await db.query('words', orderBy: 'id');
    List<Word> wordList = words.isNotEmpty
        ? words
            .map(
              (e) => Word.fromJson(e),
            )
            .toList()
        : [];

    return wordList;
  }

  Future<int> add(Word word) async {
    Database db = await instance.database;
    return await db.insert('words', word.toJson());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('words', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> removeAll() async {
    Database db = await instance.database;
    return await db.delete('words');
  }

  Future<int> update(Word word) async {
    Database db = await instance.database;
    return await db.update('words', word.toJson(), where: 'id = ?', whereArgs: [word.id]);
  }
}
