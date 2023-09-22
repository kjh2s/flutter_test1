import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'model_stock.dart';

final String TableName = 'Stocks';

class DBHelper{
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper(){
    return _instance;
  }
  DBHelper._internal();

  static Database? _database;
  Future<Database> get database async{
    if(_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async{
    sqfliteFfiInit();
    //var db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    var db = await databaseFactoryFfi.openDatabase('testdb.db');   //요렇게 하면 (윈도우)Release 폴더 안에 .dart_tool 폴더 안에 db파일 생성됨.(있으면 그냥 여나?)

    if(await db.query('sqlite_master', where: 'name=?', whereArgs: [TableName]) == []){
      await db.execute(
        "Create Table $TableName(stock_ticker TEXT PRIMARY Key, stock_price REAL)",
      );
    }

    return db;

    /*Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final database = createDatabaseFactoryFfi(join(documentsDirectory.path, 'stocks.db'),
        onCreate: (db, version) async{
      await db.execute(
        "Create Table $TableName(stock_ticker TEXT PRIMARY Key, stock_price REAL)",
      );
    }, version: 1);
    return database;*/
  }

  Future<void> insertStock(Stock stock) async{
    final db = await database;

    await db.insert(TableName,
        {'stock_ticker': stock.ticker,
      'stock_price':stock.price}, conflictAlgorithm: ConflictAlgorithm.replace);


  }

  Future<List<Stock>> all_stocks() async{
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('Stocks');

    return List.generate(maps.length, (i){
      return Stock(maps[i]['stock_ticker'],
          maps[i]['stock_price']);
    });
  }
}

