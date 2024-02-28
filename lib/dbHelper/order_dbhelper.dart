//
// @Author: "Eldor Turgunov"
// @Date: 28.02.2024
//

import 'package:sqflite/sqflite.dart' as sql;

class OrderDBHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        totalPrice INTEGER,
        roomNumber TEXT,
        orderTime TEXT
      )
    ''');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'orders.db',
      version: 1,
      onCreate: (sql.Database database, version) async {
        print("...creating db...");
        await createTables(database);
      },
    );
  }

  //db add item
  static Future<int> addItem(int totalPrice, String roomNumber, String orderTime) async {
    final db = await OrderDBHelper.db();
    final data = {'totalPrice': totalPrice, 'roomNumber': roomNumber, 'orderTime': orderTime};

    final id = await db.insert('orders', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //db get items
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await OrderDBHelper.db();
    return db.query('orders', orderBy: 'id');
  }
}
