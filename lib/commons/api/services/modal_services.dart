import 'package:http/http.dart' as http;
import 'package:popular_films/commons/data_models/data_models.dart';

import '../get_models.dart';

String _key = 'd0066af66423e5666c453b17ce65a444';
String _urlVideos = 'https://api.themoviedb.org/3/movie';

Future<List<YoutubeVideosKeys>> getAllYoutube(int id) async {
  var _uri = Uri.parse('$_urlVideos/$id/videos?api_key=$_key');
  final http.Response response = await http.get(
      _uri,
      headers: {
        "Accept": "application/json",
      }
  );
  return allYoutubeFromJson(response.body);
}

Future getPopular(int page) async {
  var _uri = Uri.parse('$_urlVideos/popular?page=$page&api_key=$_key');
  final http.Response response = await http.get(
      _uri,
      headers: {
        "Accept": "application/json",
      }
  );

}