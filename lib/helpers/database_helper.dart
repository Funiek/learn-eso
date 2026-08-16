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
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
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
          translate_to TEXT,
          return_at_count INTEGER DEFAULT 0
        )
      ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE words ADD COLUMN return_at_count INTEGER DEFAULT 0',
      );
    }
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

  Future<List<Word>> getPrioritisedWords(int currentAskedCount) async {
    Database db = await instance.database;

    // Auto-restore words that completed their 100 asked words cooldown back to priority 1
    await db.rawUpdate(
      'UPDATE words SET priority = 1, return_at_count = 0 WHERE (priority <= 0 OR priority IS NULL) AND return_at_count > 0 AND return_at_count <= ?',
      [currentAskedCount],
    );

    var words = await db.query(
      'words',
      where: 'priority > ?',
      whereArgs: [0],
      orderBy: 'priority ASC',
    );
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
