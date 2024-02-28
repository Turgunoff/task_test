//
// @Author: "Eldor Turgunov"
// @Date: 28.02.2024
//

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class ProductDBHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        price INTEGER
      )
    ''');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'products.db',
      version: 1,
      onCreate: (sql.Database database, version) async {
        print("...creating db...");
        await createTables(database);
      },
    );
  }

  //db create Item
  static Future<int> createItem(String title, String price) async {
    final db = await ProductDBHelper.db();
    final data = {'title': title, 'price': price};

    final id = await db.insert('products', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //db get items
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await ProductDBHelper.db();
    return db.query('products', orderBy: 'id');
  }

  //db get item
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await ProductDBHelper.db();
    final data = db.query('products', where: 'id = ?', whereArgs: [id], limit: 1);
    return data;
  }

  //db update item
  static Future<int> updateItem(int id, String title, String price) async {
    final db = await ProductDBHelper.db();
    final data = {
      'title': title,
      'price': price,
    };
    final result =
        await db.update('products', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  //db delete item
  static Future<void> deleteItem(int id) async {
    final db = await ProductDBHelper.db();
    try {
      await db.delete('products', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
