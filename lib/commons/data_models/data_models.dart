import 'package:cached_network_image/cached_network_image.dart';

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
  String content;

  MovieReviews({this.id, this.author, this.content});

  factory MovieReviews.fromJson(Map<String, dynamic> json){
    int i = 0;
    return MovieReviews(
      id: i++,
      author: json['author'],
      content: json['content'],
    );
  }
}