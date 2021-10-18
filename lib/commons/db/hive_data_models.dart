import 'package:hive/hive.dart';
import 'package:popular_films/commons/data_models/data_models.dart';

part 'hive_data_models.g.dart';

@HiveType(typeId: 0)
class HiveMovieDetails extends HiveObject{
  HiveMovieDetails(
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
        this.movTagline,
      this.movBackpacks,
      this.movYoutube,
      this.movReviews,
      this.movId,
        this.movIsFav});

  @HiveField(0)
  int id;

  @HiveField(1)
  String movOrigTitle;

  @HiveField(2)
  String movPosterPath;

  @HiveField(3)
  String movLanguage;

  @HiveField(4)
  String movOverview;

  @HiveField(5)
  String movTagline;

  @HiveField(6)
  String movRelease;

  @HiveField(7)
  String movHomepage;

  @HiveField(8)
  int movRuntime;

  @HiveField(9)
  int movBudget;

  @HiveField(10)
  int movRevenue;

  @HiveField(11)
  double movVote;

  @HiveField(12)
  List movGenres;

  @HiveField(13)
  int movId;

  @HiveField(14)
  List<HiveMovieReviews> movReviews;

  @HiveField(15)
  List<HiveMovieYoutube> movYoutube;

  @HiveField(16)
  List<HiveMovieImages> movBackpacks;

  @HiveField(17)
  bool movIsFav;
}

@HiveType(typeId: 1)
class HiveMovieReviews extends HiveObject{
  HiveMovieReviews({
    this.id, this.author, this.fullContent, this.shortContent, this.isExpansed, this.isExpState,
  });
  @HiveField(0)
  int id;

  @HiveField(1)
  String author;

  @HiveField(2)
  String fullContent;

  @HiveField(3)
  String shortContent;

  @HiveField(4)
  bool isExpansed;

  @HiveField(5)
  bool isExpState;
}

@HiveType(typeId: 2)
class HiveMovieYoutube extends HiveObject{
  HiveMovieYoutube({
    this.ytKey, this.ytName
  });
  @HiveField(0)
  String ytKey;

  @HiveField(1)
  String ytName;
}

@HiveType(typeId: 3)
class HiveMovieImages extends HiveObject{
  HiveMovieImages({
    this.imgId, this.imgUrl
  });
  @HiveField(0)
  int imgId;

  @HiveField(1)
  String imgUrl;
}
