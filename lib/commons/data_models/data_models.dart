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
}

List<MovieItem> movieItems = [
  MovieItem(id: 1, movId: 580489, name: "Venom", imgUrl: "https://i.pinimg.com/736x/36/4f/c1/364fc1697476b80248bb049155732aa9.jpg"),
  MovieItem(id: 2, movId: 580489, name: "Venom", imgUrl: "https://i.pinimg.com/736x/36/4f/c1/364fc1697476b80248bb049155732aa9.jpg"),
  MovieItem(id: 3, movId: 580489, name: "Venom", imgUrl: "https://i.pinimg.com/736x/36/4f/c1/364fc1697476b80248bb049155732aa9.jpg"),
  MovieItem(id: 4, movId: 580489, name: "Venom", imgUrl: "https://i.pinimg.com/736x/36/4f/c1/364fc1697476b80248bb049155732aa9.jpg"),
];

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