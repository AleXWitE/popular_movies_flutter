import 'dart:convert';

import 'package:popular_films/commons/data_models/data_models.dart';


List<YoutubeVideosKeys> allYoutubeFromJson(String str){
  final List jsonData = jsonDecode(str);

  return List<YoutubeVideosKeys>.from(jsonData.map((i) => YoutubeVideosKeys.fromJson(i)).toList());
}
