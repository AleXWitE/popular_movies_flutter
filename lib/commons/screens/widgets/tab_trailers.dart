import 'package:flutter/material.dart';
import 'package:popular_films/commons/api/services/modal_services.dart';
import 'package:popular_films/commons/api/services/youtube_iframe.dart';
import 'package:popular_films/commons/data_models/data_models.dart';

class TabTrailers extends StatefulWidget {
  int id;

  TabTrailers({ this.id});

  @override
  State<TabTrailers> createState() => _TabTrailersState();
}

class _TabTrailersState extends State<TabTrailers> {
  Future<List<YoutubeVideosKeys>> getYoutube;

  void initState(){
    super.initState();
    _getData(widget.id);
  }

  _getData(int _id) {
    getYoutube = getAllYoutube(_id);
    return getYoutube;
  }

  @override
  Widget build(BuildContext context) {

    return  FutureBuilder<List<YoutubeVideosKeys>>(
      future: getYoutube,
      initialData: [],
      builder: (_, snapshot) {

        int count = snapshot.requireData.length;
        // int count = 5;
        print("snapshot has data ${snapshot.hasData}");
        // return ListView.builder(
        //   shrinkWrap: true,
        //   itemBuilder: (context, index) => YouTubePlay(yt: snapshot.data, index: index,),
        //   itemCount: count,
        // );
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: count,
              itemBuilder: (context, i) => YouTubePlay(yt: snapshot.requireData, index: i)
          );
        }
        return const CircularProgressIndicator();
      },

    );
  }
}
