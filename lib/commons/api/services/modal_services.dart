import 'package:http/http.dart' as http;
import 'package:popular_films/commons/data_models/data_models.dart';
import 'package:popular_films/commons/data_models/movie_details.dart';

import '../get_models.dart';

String _key = 'd0066af66423e5666c453b17ce65a444';
String _url = 'https://api.themoviedb.org/3/movie';
String _urlImg = 'https://image.tmdb.org/t/p/original/t9nyF3r0WAlJ7Kr6xcRYI4jr9jm.jpg';

Future<List<YoutubeVideosKeys>> getAllYoutube(int id) async {
  var _uri = Uri.parse('$_url/$id/videos?api_key=$_key');
  final http.Response response = await http.get(
      _uri,
      headers: {
        "Accept": "application/json",
      }
  );
  return allYoutubeFromJson(response.body);
}

Future getPopular(int page) async {
  var _uri = Uri.parse('$_url/popular?page=$page&api_key=$_key');
  final http.Response response = await http.get(
      _uri,
      headers: {
        "Accept": "application/json",
      }
  );
  // return
}

Future getAllPosters(int id) async {
  var _uri = Uri.parse('$_url/$id/images?api_key=$_key');
  final http.Response response = await http.get(
      _uri,
      headers: {
        "Accept": "application/json",
      }
  );
  // return
}

Future<MovieDetails> getDescription(int id) async {
  var _uri = Uri.parse('$_url/$id?api_key=$_key');
  final http.Response response = await http.get(
      _uri,
      headers: {
        "Accept": "application/json",
      }
  );
  // return
}