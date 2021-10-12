import 'package:flutter/material.dart';
import 'package:popular_films/commons/api/services/modal_services.dart';
import 'package:popular_films/commons/api/services/youtube_iframe.dart';
import 'package:popular_films/commons/data_models/data_models.dart';

class TabTrailers extends StatefulWidget {
  int id;

  TabTrailers({Key key, this.id}) : super(key: key);

  @override
  State<TabTrailers> createState() => _TabTrailersState();
}

class _TabTrailersState extends State<TabTrailers> {
  Future<List<YoutubeVideosKeys>> getYoutube;

  void initState(){
    super.initState();
    getYoutube = getAllYoutube(widget.id);
  }
  //
  // _getData(int _id) {
  //   getYoutube = getAllYoutube(_id);
  //   return getYoutube;
  // }

  @override
  Widget build(BuildContext context) {
    getYoutube = getAllYoutube(widget.id);

    return FutureBuilder<List<YoutubeVideosKeys>>(
      future: getYoutube,
      initialData: [],
      builder: (context, snapshot) {
        print('*-> ${snapshot.connectionState}');
        if (snapshot.connectionState != ConnectionState.done) {
          return Text('*-> ${snapshot.connectionState}');
        } else {
          if (snapshot.hasData) {
            int count = snapshot.data.length;
            return ListView.builder(
                itemCount: count,
                itemBuilder: (context, i) =>
                    YouTubePlay(yt: snapshot.data, index: i));
          } else {
            return Text('*-> Ничего нет');
          }
        }
      }
    );
  }
}
