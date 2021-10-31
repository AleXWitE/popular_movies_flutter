import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:popular_films/commons/data_models/data_models.dart';
import 'package:popular_films/commons/data_models/movie_details.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static String path;
  static final _dbName = 'fav_movies.db';
  static final _dbVersion = 1;

  static final _table_fav_mov = 'Fav_movies';
  static final _table_fav_mov_imgs = 'Fav_movies_images';
  static final _table_fav_mov_yt = 'Fav_movies_youtube';
  static final _table_fav_mov_rev = 'Fav_movies_review';
  static final _table_fav_mov_det = 'Fav_movies_details';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _db;

  Future db() async{
  if(_db != null) return _db;

  _db = await _initDb();

  return _db;
  }

  _initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _dbName);

    return await openDatabase(path, version: _dbVersion,
    onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE $_table_fav_mov_det (id INTEGER PRIMARY KEY AUTOINCREMENT,'
              ' movId INTEGER,'
              ' poster_path TEXT,'
              ' movOrigTitle TEXT,'
              ' movLanguage TEXT,'
              ' movOverview TEXT,'
              ' movTagline TEXT,'
              ' movRelease TEXT,'
              ' movHomepage TEXT,'
              ' movRuntime INTEGER,'
              ' movBudget INTEGER,'
              ' movRevenue INTEGER,'
              ' movVote REAL,'
              ' movGenres TEXT)');
      await db.execute('CREATE TABLE $_table_fav_mov (id INTEGER PRIMARY KEY AUTOINCREMENT, movId INTEGER, name TEXT, image_path TEXT)');
      await db.execute('CREATE TABLE $_table_fav_mov_imgs (id INTEGER PRIMARY KEY AUTOINCREMENT, movId INTEGER, image_path TEXT)');
      await db.execute('CREATE TABLE $_table_fav_mov_yt (id INTEGER PRIMARY KEY AUTOINCREMENT, movId INTEGER, youtube_path TEXT)');
      await db.execute('CREATE TABLE $_table_fav_mov_rev (id INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' movId INTEGER,'
          ' author TEXT,'
          ' fullContent TEXT,'
          ' shortContent TEXT,'
          ' isExpansed INTEGER,'
          ' isExpState INTEGER)');
    });
  }

  Future<List<MovieItem>> showListMovie() async{
    final Database _db = await db();
    final List<Map<String, dynamic>> maps = await _db.query(_table_fav_mov);

    return List.generate(maps.length, (i) {
      return MovieItem(
        movId: maps[i]["movId"],
        name: maps[i]["name"],
        imgUrl: maps[i]["image_path"],
      );
    });
  }

  Future insertFav(MovieDetails _movDet, List<MovieReviews> _movRev, List<YoutubeVideosKeys> _movYt, List<MovieImages> _movImgs) async {
    final Database _db = await db();
    final MovieItem _mov = MovieItem(movId: _movDet.id, imgUrl: _movDet.movPosterPath, name: _movDet.movOrigTitle);

    await _db.insert(_table_fav_mov, _mov.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    await _db.insert(_table_fav_mov_det, _movDet.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    for(int i = 0; i <= _movYt.length - 1; i++)
      await _db.insert(_table_fav_mov_yt, _movYt[i].toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    for(int i = 0; i <= _movRev.length - 1; i++)
      await _db.insert(_table_fav_mov_rev, _movRev[i].toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    for(int i = 0; i <= _movImgs.length - 1; i++)
      await _db.insert(_table_fav_mov_imgs, _movImgs[i].toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    print("insert done");
  }

  Future deleteFav(int _movId) async {
    final Database _db = await db();

    await _db.delete(_table_fav_mov, where: "movId = ?", whereArgs: [_movId]);
    await _db.delete(_table_fav_mov_det, where: "movId = ?", whereArgs: [_movId]);
    await _db.delete(_table_fav_mov_yt, where: "movId = ?", whereArgs: [_movId]);
    await _db.delete(_table_fav_mov_rev, where: "movId = ?", whereArgs: [_movId]);
    await _db.delete(_table_fav_mov_imgs, where: "movId = ?", whereArgs: [_movId]);

    print("delete done");
  }

}
