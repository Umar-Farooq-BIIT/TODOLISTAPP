import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class DBHelper
{
  Database? _db;
  DBHelper._init();
  static DBHelper instansce=DBHelper._init();
  Future<Database> get database async{
    if(_db!=null)return _db!;
    _db=await _initializeDB();
    return _db!;

  }
  Future<Database> _initializeDB()async{
    String dbPath=await getDatabasesPath();
    dbPath=join(dbPath,"todo.db");
   Database db= await openDatabase(dbPath,version: 1,onCreate:_createDB );
   return db;

  }
  _createDB(Database db,int version) async {
    String query='''
    create table TodoTask(ID integer primary key autoincrement, title text,
    description text,date text,priority integer,completionStatus integer)
''';
  await db.execute(query);
  print('Table created successfully...');

  }
}