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

// List<MovieItem> movieItems = [
//   MovieItem(id: 1, movId: 580489, name: "Venom", imgUrl: "https://i.pinimg.com/736x/36/4f/c1/364fc1697476b80248bb049155732aa9.jpg"),
//   MovieItem(id: 2, movId: 580489, name: "Venom", imgUrl: "https://i.pinimg.com/736x/36/4f/c1/364fc1697476b80248bb049155732aa9.jpg"),
//   MovieItem(id: 3, movId: 580489, name: "Venom", imgUrl: "https://i.pinimg.com/736x/36/4f/c1/364fc1697476b80248bb049155732aa9.jpg"),
//   MovieItem(id: 4, movId: 580489, name: "Venom", imgUrl: "https://i.pinimg.com/736x/36/4f/c1/364fc1697476b80248bb049155732aa9.jpg"),
// ];

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
  CachedNetworkImage cachedImg;

  PopularMovieImgs({this.id, this.cachedImg});
}