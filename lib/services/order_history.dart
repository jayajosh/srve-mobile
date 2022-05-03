import 'package:sqflite/sqflite.dart';

class OrderHistoryDB {

  var ordersDB = openDatabase('orders.db', onCreate: (db, version) {
    // Run the CREATE TABLE statement on the database.
    return db.execute(
      'CREATE TABLE orders(orderId TEXT PRIMARY KEY, price DOUBLE, date TEXT, venue TEXT, tableNum INTEGER)',
    );
  },
    version: 1,
  );

  var detailsDB = openDatabase('orders.db', onCreate: (db, version) {
    // Run the CREATE TABLE statement on the database.
    return db.execute(
      'CREATE TABLE details(detailsId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, orderId TEXT NOT NULL, product TEXT, price DOUBLE, options TEXT)',
    );
  },
    version: 1,
  );

  createTables() async {
    final orders = await ordersDB;
    final details = await detailsDB;
    orders.execute(
      'CREATE TABLE IF NOT EXISTS orders(orderId TEXT PRIMARY KEY, price DOUBLE, date TEXT, venue TEXT, tableNum INTEGER)',
    );
    details.execute(
      'CREATE TABLE IF NOT EXISTS details(detailsId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, orderId TEXT NOT NULL, product TEXT, price DOUBLE, options TEXT)',
    );
  }

  addOrder(String orderId, DateTime date, String venue, int table, List products) async {
    final orders = await ordersDB;
    createTables();
    await orders.insert('orders',{'orderId':orderId,'date':date.toString(),'venue':venue, 'tableNum':table});
    products.forEach((element) {addDetails(orderId, element['product'], element['price'], element['options']);});
    readFromCart();
  }

  addDetails(String orderId, String name,double price, String? options) async {
    final details = await detailsDB;
    await details.insert('details',{'orderId':orderId,'product':name,'price':price, 'options':options});
  }

  readFromCart() async {
    final db = await detailsDB;
    final List<Map<String, dynamic>> cartMaps = await db.query('details');
    print(cartMaps);
  }

  /*
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
  }*/
}

//todo display the cart on cart page with remove options