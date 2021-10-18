import 'package:flutter/material.dart';
import 'package:popular_films/commons/api/services/modal_services.dart';
import 'package:popular_films/commons/api/services/youtube_iframe.dart';
import 'package:popular_films/commons/data_models/data_models.dart';

class TabTrailers extends StatefulWidget {
  List<YoutubeVideosKeys> getYoutube;

  TabTrailers({Key key, this.getYoutube}) : super(key: key);

  @override
  State<TabTrailers> createState() => _TabTrailersState();
}

class _TabTrailersState extends State<TabTrailers> {
  List<YoutubeVideosKeys> _getYt;

  void initState(){
    super.initState();
    _getYt = widget.getYoutube;
  }

  @override
  Widget build(BuildContext context) {
            return ListView.builder(
                itemCount: _getYt.length,
                itemBuilder: (context, i) =>
                    YouTubePlay(yt: _getYt, index: i));

  }
}
