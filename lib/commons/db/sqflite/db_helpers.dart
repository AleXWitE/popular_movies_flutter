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

  Future get db async{
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
}

Future initDb() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'fav_movies.db');

  Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE Fav_movies (id INTEGER PRIMARY KEY, movId INTEGER, poster_path TEXT)'
                ' movOrigTitle TEXT,'
                ' movLanguage TEXT,'
                ' movOverview TEXT,'
                ' movTagline TEXT,'
                ' movRelease TEXT,'
                ' movHomepage TEXT,'
                ' movRuntime INTEGER,'
                ' movBudget INTEGER,'
                ' movRevenue INTEGER,'
                ' movVote REAL)');
        await db.execute('CREATE TABLE Fav_movies_images (id INTEGER PRIMARY KEY, movId INTEGER, image_path TEXT)');
        await db.execute('CREATE TABLE Fav_movies_youtube (id INTEGER PRIMARY KEY, movId INTEGER, youtube_path TEXT)');
        await db.execute('CREATE TABLE Fav_movies_review (id INTEGER PRIMARY KEY,'
            ' movId INTEGER,'
            ' author TEXT,'
            ' fullContent TEXT,'
            ' shortContent TEXT,'
            ' isExpansed INTEGER,'
            ' isExpState INTEGER)');
      });
}

Future insertFav(MovieDetails _movDet, List<MovieReviews> _movRev, List<YoutubeVideosKeys> _movYt, List<MovieImages> _movImgs) async {

}
