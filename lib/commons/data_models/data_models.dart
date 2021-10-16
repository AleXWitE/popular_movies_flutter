import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MovieList {
  final List<MovieItem> movies;

  MovieList({this.movies});

}

class MovieItem {
  int id;
  int movId;
  String name;
  String imgUrl;

  MovieItem({this.id, this.name, this.imgUrl, this.movId});

  factory MovieItem.fromJson(Map<String, dynamic> json) {
    int i = 0;

    return MovieItem(
      id: i++,
      movId: json['id'],
      name:  json['original_title'],
      imgUrl: json['poster_path'],
    );
  }
}

class YoutubeVideosKeys {
  String ytKey;
  String ytName;

  YoutubeVideosKeys({this.ytKey, this.ytName});

  factory YoutubeVideosKeys.fromJson(Map<String, dynamic> json){
    return YoutubeVideosKeys(
      ytKey:json['key'],
      ytName:json['name'],
    );
  }
}

class MovieImages{
  String imgUrl;
  int imgId;

  MovieImages({this.imgId, this.imgUrl});

  factory MovieImages.fromJson(Map<String, dynamic> json){
    int i = 0;
    return MovieImages(
      imgUrl: json['file_path'],
      imgId: i++,
    );
  }
}

class PopularMovieImgs{
  int id;
  String title;
  CachedNetworkImage cachedImg;

  PopularMovieImgs({this.id, this.title, this.cachedImg});
}

class MovieReviews{
  int id;
  String author;
  String fullContent;
  String shortContent;
  bool isExpansed;

  MovieReviews({this.id, this.author, this.fullContent, this.shortContent, this.isExpansed});

  factory MovieReviews.fromJson(Map<String, dynamic> json){
    int i = 0;
    bool _result;
    String _fullContent;
    String _shortContent;
    if(json['content'].toString().length < 125){
      _fullContent = json['content'];
      _shortContent = json['content'];
      _result = false;
    }
    else{
      _result = true;
      _fullContent = json['content'];
      _shortContent = json['content'].toString().substring(0, 123) + '...';
    }

    return MovieReviews(
      id: i++,
      author: json['author'],
      fullContent: _fullContent,
      shortContent: _shortContent,
      isExpansed: _result,
    );
  }
}

class IsExpansed{
  int id;
  bool isExpansed;

  IsExpansed({this.id, this.isExpansed});
}