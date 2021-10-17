import 'package:http/http.dart' as http;
import 'package:popular_films/commons/data_models/data_models.dart';
import 'package:popular_films/commons/data_models/movie_details.dart';

import '../get_models.dart';

String _key = 'd0066af66423e5666c453b17ce65a444';
String _url = 'https://api.themoviedb.org/3/movie';
String _urlImg =
    'https://image.tmdb.org/t/p/original/t9nyF3r0WAlJ7Kr6xcRYI4jr9jm.jpg';

Future<List<YoutubeVideosKeys>> getAllYoutube(int id) async {
  var _uri = Uri.parse('$_url/$id/videos?api_key=$_key');
  final http.Response response = await http.get(_uri, headers: {
    "Accept": "application/json",
  });
  return allYoutubeFromJson(response.body);
}

Future<List<MovieItem>> getPopular(int page) async {
  var _uri = Uri.parse('$_url/popular?page=$page&api_key=$_key');
  final http.Response response = await http.get(_uri, headers: {
    "Accept": "application/json",
  });
  return pagePopularAndRated(response.body);
}

Future<List<MovieItem>> updatePopular(int page) async {
  var _uri;
  http.Response response;
  String separator1 = '';
  String separator2 = '';
  String separator3 = '';
  String responseBody = '';

  for (int i = 1; i <= page; i++) {
    _uri = Uri.parse('$_url/popular?page=$page&api_key=$_key');
    response = await http.get(_uri, headers: {
      "Accept": "application/json",
    });
    if (i == page) {
      separator2 = '';
      separator3 = ']';
    } else {
      separator2 = ', ';
      separator3 = '';
    }

    if (i == 1) {
      separator1 = '[';
      separator2 = '';
    } else {
      separator1 = '';
      separator2 = ', ';
    }
    responseBody =
        separator1 + responseBody + separator2 + response.body + separator3;
  }

  return pagePopularAndRated(responseBody);
}

Future<List<MovieItem>> getTopRated(int page) async {
  var _uri = Uri.parse('$_url/top_rated?page=$page&api_key=$_key');
  final http.Response response = await http.get(_uri, headers: {
    "Accept": "application/json",
  });
  return pagePopularAndRated(response.body);
}

Future<List<MovieImages>> getAllImages(int id) async {
  var _uri = Uri.parse('$_url/$id/images?api_key=$_key');
  final http.Response response = await http.get(_uri, headers: {
    "Accept": "application/json",
  });
  return allMovieImages(response.body);
}

Future<MovieDetails> getDescription(int id) async {
  var _uri = Uri.parse('$_url/$id?api_key=$_key');
  final http.Response response = await http.get(_uri, headers: {
    "Accept": "application/json",
  });
  return allDetailsFromJson(response.body);
}

Future<List<MovieReviews>> getReviews(int id) async {
  var _uri = Uri.parse('$_url/$id/reviews?api_key=$_key');
  final http.Response response = await http.get(_uri, headers: {
    "Accept": "application/json",
  });
  return allReviews(response.body);
}
