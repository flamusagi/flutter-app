import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'newslist.dart';

class NewsDatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }
  Future<Database> initDatabase() async {
    if (_database != null) {
      return _database!;
    }

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'news_db.db');

    _database = await openDatabase(path, version: 1, onCreate: (db, version) async {
      _createNewsTable(db);
      _createNewsView(db);

    });

    return _database!;
  }
  // 创建 news_view 视图
  Future<void> _createNewsView(Database db) async {
   await db.execute('''
      CREATE VIEW news_view AS
      SELECT * FROM news
      ORDER BY ctime DESC;
    ''');
  }
  // 创建 news 表
  Future<void> _createNewsTable(Database db) async {
    await db.execute('''
      CREATE TABLE news(
        id TEXT PRIMARY KEY,
        ctime TEXT,
        title TEXT,
        description TEXT,
        source TEXT,
        picUrl TEXT,
        url TEXT
      )
    ''');
  }



  Future<List<NewsItem>> getNewsByPage(int page) async {
    final db = await database;
    int pageSize=10;
    final offset = (page - 1) * pageSize;

    // 在 SQL 查询中使用 news_view 视图
    /**
     * 展示第一页的数据(1到10的新闻)
     * SELECT * FROM news_view
        LIMIT 10 OFFSET 0;
     */
    final List<Map<String, dynamic>> newsList = await db.rawQuery('''
    SELECT * FROM news_view
    LIMIT ? OFFSET ?
  ''', [pageSize, offset]);

    return newsList.map((map) => NewsItem.fromMap(map)).toList();
  }



  Future<void> insertNews(NewsItem news) async {
    final db = await database;

    // 检查是否已存在相同 id 的记录
    final existingNews = await db.query('news', where: 'id = ?', whereArgs: [news.id]);

    try {
      if (existingNews.isEmpty) {
        // 如果没有相同 id 的记录，才插入新记录
        await db.transaction((txn) async {
          await txn.insert('news', news.toMap());
        });
        // print('Insert successful');
      } else {
        // print('Record with id ${news.id} already exists.');
        // print('Title is ${news.title}');
      }
    } catch (error) {
      print('Insert failed: $error'); // 插入失败
    }
  }


  Future<List<NewsItem>> getAllNews() async {
    final db = await database;

    // 执行查询
    final List<Map<String, dynamic>> newsList = await db.query('news');

    // 返回查询结果
    return newsList.map((map) => NewsItem.fromMap(map)).toList();
  }

  Future<void> deleteNews(String id) async {
    final db = await database;

    // 开启事务
    await db.transaction((txn) async {
      await txn.delete('news', where: 'id = ?', whereArgs: [id]);
    }).catchError((error) {
      print('Delete failed: $error'); // 删除失败
    });
  }
}



