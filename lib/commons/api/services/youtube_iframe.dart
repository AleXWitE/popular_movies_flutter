import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:popular_films/commons/data_models/data_models.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YouTubePlay extends StatefulWidget {
  final List<YoutubeVideosKeys> yt;
  final int index;

  YouTubePlay({ Key key, this.yt, this.index}) : super(key: key);

  @override
  _YouTubePlayState createState() => _YouTubePlayState();
}

class _YouTubePlayState extends State<YouTubePlay> {
  YoutubePlayerController _controller; //объявляем контроллер для работы iframe

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.yt[widget.index].ytKey,
      params: const YoutubePlayerParams(
        showControls: true,
        autoPlay: false,
        showFullscreenButton: true,
        desktopMode: true,
      ),
    );
    _controller.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    };
    _controller.onExitFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    };
    // print("key id ${widget.yt?[widget.index].ytKey}");
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame(); //определяем под переменную сам iframe
    return YoutubePlayerControllerProvider(
      controller: _controller,
      child: player,
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
