import 'package:http/http.dart' as http;
import 'package:popular_films/commons/data_models/data_models.dart';

import '../get_models.dart';

String _key = 'd0066af66423e5666c453b17ce65a444';
String _urlVideos = 'https://api.themoviedb.org/3/movie/';
String _urlPopular = 'https://api.themoviedb.org/3/movie/popular?page=';

Future<List<YoutubeVideosKeys>> getAllYoutube(int id) async {
  _urlVideos = _urlVideos + '$id/videos';
  final http.Response response = await http.get(
      Uri.parse('$_urlVideos?api_key=$_key'),
      headers: {
        "Accept": "application/json",
      }
  );
  print("id of youtube $id");
  print(" getallyotube fyagouaygf oagauo ygfsaof ydgfouasg ofua\n${response.body}");

  return allYoutubeFromJson(response.body);
}

Future getPopular(int page) async {
  _urlPopular = _urlPopular + '$page&api_key=$_key';
  final http.Response response = await http.get(
      Uri.parse(_urlPopular),
      headers: {
        "Accept": "application/json",
      }
  );

}