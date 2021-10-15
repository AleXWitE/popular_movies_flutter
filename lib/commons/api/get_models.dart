import 'dart:convert';

import 'package:popular_films/commons/data_models/data_models.dart';
import 'package:popular_films/commons/data_models/movie_details.dart';


List<YoutubeVideosKeys> allYoutubeFromJson(String _str){
  var jsonData = jsonDecode(_str);
  
  return List<YoutubeVideosKeys>.from(jsonData['results'].map((i) => YoutubeVideosKeys.fromJson(i)).toList());
}

MovieDetails allDetailsFromJson(String _str){
  var jsonData = jsonDecode(_str);

  MovieDetails movieDetails = MovieDetails.fromJson(jsonData);
  return movieDetails;

  // return jsonData.map((i) => MovieDetails.fromJson(i));
}

List<MovieImages> allMovieImages(String _str){
  var jsonData = jsonDecode(_str);

  return List<MovieImages>.from(jsonData['backdrops'].map((i) => MovieImages.fromJson(i)).toList());
}

List<MovieItem> pagePopularAndRated(String _str) {
  var jsonData = jsonDecode(_str);
  return List<MovieItem>.from(jsonData['results'].map((i) => MovieItem.fromJson(i)).toList());
}

List<MovieReviews> allReviews(String _str){
  var jsonData = jsonDecode(_str);
  return List<MovieReviews>.from(jsonData['results'].map((i) => MovieReviews.fromJson(i)).toList());
}