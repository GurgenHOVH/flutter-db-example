import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProjectDB {
  static Database database;

  static init() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');



    // open the database
    database = await openDatabase(path, version: 2,
        onCreate: (Database db, int version) async {
      var query = '''CREATE TABLE `albums` 
        (`AlbumId`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	        `Title`	NVARCHAR ( 160 ) NOT NULL,
	        `ArtistId`	INTEGER NOT NULL
        )''';

      await db.execute(query);
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      var query = '''CREATE TABLE `count` 
        (`count` INTEGER)
        ''';

      await db.execute(query);
    });

    print(path);
  }

  static Future<int> getCount() async {
    List<Map> data = await database.query('count');

    if (data.isEmpty) {
      return 0;
    } else {
      if (data.first['count'] > 20) {
        await database.delete('count', where: 'count >= ?', whereArgs: [20]);

        return 0;
      }

      return data.first['count'];
    }
  }

  static increment() async {
    List<Map> data = await database.query('count');

    int count = 0;

    if (data.isEmpty) {
      count++;
      await database.insert('count', {'count': count});
    } else {
      count = data.first['count'];
      count++;

      await database.update('count', {'count': count});
    }
  }
}
