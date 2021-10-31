class MovieDetails {
  int id;
  String movOverview;
  String movOrigTitle;
  String movHomepage;
  String movPosterPath;
  String movRelease;
  int movRuntime;
  int movBudget;
  int movRevenue;
  String movLanguage;
  double movVote;
  List movGenres;
  String movTagline;

  MovieDetails(
      {this.id,
      this.movOrigTitle,
      this.movPosterPath,
      this.movGenres,
      this.movVote,
      this.movLanguage,
      this.movRuntime,
      this.movOverview,
      this.movRelease,
      this.movBudget,
      this.movRevenue,
      this.movHomepage,
      this.movTagline});

  factory MovieDetails.fromJson(Map<String, dynamic> json){
    var list = json['genres'] as List;
    List listGenres = list.map((e) => e['name']).toList();
    var lang = json['spoken_languages'] as List;
    List listLang = lang.map((e) => e['english_name']).toList();

    return MovieDetails(
      id: json['id'],
      movOrigTitle: json['original_title'],
      movPosterPath: json['poster_path'],
      movGenres: listGenres,
      movVote: json['vote_average'],
      movLanguage: listLang.length != 1 ? listLang.singleWhere((e) => e == "English") : listLang.first,
      movRuntime: json['runtime'],
      movOverview: json['overview'],
      movRelease: json['release_date'],
      movBudget: json['budget'],
      movRevenue: json['revenue'],
      movHomepage: json['homepage'],
      movTagline: json['tagline'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "movId": id,
      "poster_path": movPosterPath,
      "movOrigTitle": movOrigTitle,
      "movLanguage": movLanguage,
      "movOverview": movOverview,
      "movTagline": movTagline,
      "movRelease": movRelease,
      "movHomepage": movHomepage,
      "movRuntime": movRuntime,
      "movBudget": movBudget,
      "movRevenue": movRevenue,
      "movVote": movVote,
      "movGenres": movGenres.toString(),
    };
  }
}
