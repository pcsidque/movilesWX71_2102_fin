import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:app_persistencia_sqflite/models/shopping_list.dart';
import 'package:app_persistencia_sqflite/models/list_items.dart';

class DbHelper{
  final int version = 1;
  Database? db;

  //codigo q controla q solo se abra 1 instancia de la BD
  static final DbHelper dbHelper = DbHelper._internal();
  DbHelper._internal();
  factory DbHelper(){
    return dbHelper;
  }

  Future<Database> openDb() async{
    if (db == null)
    {
      db = await openDatabase(join(await getDatabasesPath(),
          'shopping_miprueba.db'),
          onCreate: (database, version){
            database.execute(
                'CREATE TABLE lists(id INTEGER PRIMARY KEY, '
                    'name TEXT, priority INTEGER)');
            database.execute(
                'CREATE TABLE items(id INTEGER PRIMARY KEY, '
                    'idList INTEGER, name TEXT, quantity TEXT, note TEXT, '
                    'FOREIGN KEY(idlist) REFERENCES lists(id))');
          }, version: version);
    }
    return db!;
  }

  Future testDB() async{
    db = await openDb();

    await db!.execute('INSERT INTO lists VALUES (0, "Discos duros", 1)');
    await db!.execute('INSERT INTO lists VALUES (1, "Monitores", 3)');
    await db!.execute('INSERT INTO items VALUES (0, 0, "SSD", "55 unds.", "Marca WD")');

    List list = await db!.rawQuery('SELECT * FROM lists');
    List item = await db!.rawQuery('SELECT * FROM items');

    print(list[0]);
    print(item[0]);
  }

  //insert list
  Future<int> insertList(ShoppingList list) async{
    int id = await this.db!.insert(
        'lists',
        list.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  //insertar en tabla items
  Future<int> insertItem(ListItem item) async {
    int id = await this.db!.insert(
        'items',
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace); // obligatorio

    return id;
  }

  //metodo para mostrar la tabla "lists"
  Future<List<ShoppingList>> getLists() async {
    final List<Map<String, dynamic>> maps = await db!.query('lists');

    return List.generate(maps.length, (i) {
      return ShoppingList(
        maps[i]['id'],
        maps[i]['name'],
        maps[i]['priority'],
      );
    });
  }

  //metodo para mostrar la tabla "items" a traves del id de "lists"
  Future<List<ListItem>> getItems(int idList) async {
    final List<Map<String, dynamic>> maps = await db!.query('items', where: 'idList = ?',
        whereArgs: [idList]);

    return List.generate(maps.length, (i) {
      return ListItem(
        maps[i]['id'],
        maps[i]['idList'],
        maps[i]['name'],
        maps[i]['quantity'],
        maps[i]['note'],
      );
    });
  }

  Future<int> deleteList(ShoppingList list) async {
    int result = await db!.delete("items", where: "idList = ?", whereArgs: [list.id]);
    result = await db!.delete("lists", where: "id = ?", whereArgs: [list.id]);
    return result;
  }

  Future<int> deleteItem(ListItem item) async {
    int result =
    await db!.delete("items", where: "id = ?", whereArgs: [item.id]);
    return result;
  }
}