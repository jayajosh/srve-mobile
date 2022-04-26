import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class CartDB {

  var database = openDatabase('cart.db', onCreate: (db, version) {
    // Run the CREATE TABLE statement on the database.
    return db.execute(
      'CREATE TABLE cart(cartPos INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, product TEXT, price DOUBLE, options TEXT)',
    );
  },
    version: 1,
  );
  
  createTable() async {
    final db = await database;
    db.execute(
      'CREATE TABLE IF NOT EXISTS cart(cartPos INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, product TEXT, price DOUBLE, options TEXT)',
    );
  }

  addToCart(String name,double price, String? options) async {
    final db = await database;
    createTable();
    print(await db.insert('cart',{'product':name,'price':price, 'options':options}));
  }
  readFromCart() async {
    final db = await database;
    final List<Map<String, dynamic>> cartMaps = await db.query('cart');
    return cartMaps;
  }

  removeFromCart(cartPos) async {
    final db = await database;

    await db.delete(
      'cart',
      where: 'cartPos = ?',
      // Pass cartPos as a whereArg to prevent SQL injection. //todo change to id
      whereArgs: [cartPos],
    );
  }
}

//todo display the cart on cart page with remove options