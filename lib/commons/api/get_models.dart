import 'dart:convert';

import 'package:popular_films/commons/data_models/data_models.dart';


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
