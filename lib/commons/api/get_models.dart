import 'dart:convert';

import 'package:popular_films/commons/data_models/data_models.dart';
import 'package:popular_films/commons/data_models/movie_details.dart';


List<YoutubeVideosKeys> allYoutubeFromJson(String _str){
  var jsonData = jsonDecode(_str);

  // return List<YoutubeVideosKeys>.from(jsonData.map((i) => YoutubeVideosKeys.fromJson(i)).toList());
  var result = <YoutubeVideosKeys>[];
  // TODO переделать на мапу
  for(var item in jsonData['results']) {
    result.add(YoutubeVideosKeys.fromJson(item));
  }
  return result;
}

MovieDetails allDetailsFromJson(String _str){
  var jsonData = jsonDecode(_str);

  MovieDetails movieDetails = MovieDetails.fromJson(jsonData);
  return movieDetails;

  // return jsonData.map((i) => MovieDetails.fromJson(i));
}
