import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:popular_films/commons/api/services/modal_services.dart';
import 'package:popular_films/commons/data_models/data_models.dart';
import 'package:popular_films/commons/db/hive_data_models.dart';
import 'package:popular_films/commons/screens/widgets/empty_movie_grid.dart';
import 'package:popular_films/commons/screens/widgets/movie_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  GlobalKey<RefreshIndicatorState> refreshKey;

  Future<Box<HiveMovieDetails>> box;

  String popRadio = "popular";
  bool favCheckbox = false;
  bool animCheckbox;
  String _imgUrl = 'https://image.tmdb.org/t/p/w200';
  ScrollController _scrollController;

  int _boxMovId;
  String _boxMovName;
  String _boxMovLink;

  int page = 1;
  Curve curve = Curves.easeIn;

  Future<List<MovieItem>> movieItems;
  List<MovieItem> emptyMovieItems = [];
  List<MovieItem> _movItems = [];
  Future<List<MovieItem>> _boxMovieItems;
  List<PopularMovieImgs> _movPosters = [];

  getEmptyList() {
    for (int i = 0; i < 20; i++)
      emptyMovieItems.add(MovieItem(imgUrl: "lib/img/download.png"));

    return emptyMovieItems;
  }

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _getPrefs() async {
    var prefs = await _prefs;
    setState(() {
      popRadio = (prefs.getString("POPULAR_RADIO") ?? "popular");
      favCheckbox = (prefs.getBool("FAV_CHECKBOX") ?? false);
      animCheckbox = (prefs.getBool("ANIMATION_CHECKBOX") ?? false);
    });
    _checkDataHive();
  }

  _savePrefs() async {
    var prefs = await _prefs;
    await prefs.setString("POPULAR_RADIO", popRadio);
    await prefs.setBool("FAV_CHECKBOX", favCheckbox);
    await prefs.setBool("ANIMATION_CHECKBOX", animCheckbox);
  }

  // Future<List<MovieItem>> getFavs() async {
  //   var box = await Hive.openBox<HiveMovieDetails>('movie');
  //
  //
  //   Future<Box<HiveMovieDetails>> _box = Hive.openBox('movie');
  //
  //   for(int i = 0; i < box.length; i++){
  //     _boxMovId = box.getAt(i).movId;
  //     _boxMovName = box.getAt(i).movOrigTitle;
  //     _boxMovLink = box.getAt(i).movPosterPath;
  //     // _movItems.add(MovieItem(movId: _boxMovId,name: _boxMovName, imgUrl: _boxMovLink));
  //     _box.then((value) => _boxMovieItems.)
  //     await _boxMovieItems.then((value) => value.add(MovieItem(movId: _boxMovId, name: _boxMovName, imgUrl: _boxMovLink)));
  //     // _boxMovieItems.then((value) => MovieItem(movId: _boxMovId,name: _boxMovName, imgUrl: _boxMovLink));//add(MovieItem(movId: _boxMovId,name: _boxMovName, imgUrl: _boxMovLink));
  //   }
  //   return _boxMovieItems;
  //   setState(() {
  //     movieItems = null;
  //     movieItems = _boxMovieItems;
  //   });
  //
  // }

  _getMovies(int _page) async {
    // if(favCheckbox){
    //   // movieItems = getFavs();
    // }else{
      if (popRadio == "popular")
        movieItems = getPopular(_page);
      else
        movieItems = getTopRated(_page);
    // }
    _movItems = await movieItems;
    setState(() => _movItems);
    return movieItems;
  }

  Future<Null> _refreshBottom() async {
        setState(() {
          movieItems = null;
          _movPosters.clear();
          page++;
          _scrollController.animateTo(0.1, duration: Duration(milliseconds: 800), curve: curve);
        });

          movieItems = _getMovies(page);
    _addImgs(_movItems);
    await Future.delayed(Duration(milliseconds: 500));
        print("bottom $page");

    return movieItems;
  }

  _refreshTop() async {
    if (page == 1) {
      movieItems = _getMovies(1);
    }else if(page > 1) {
      setState(() {
        page--;
      movieItems = null;
        _movPosters.clear();
      });
      movieItems =  _getMovies(page);
      _addImgs(_movItems);

    }

    print("top $page");

    await Future.delayed(Duration(milliseconds: 500));
    return movieItems;
  }

  _checkDataHive() async {
    box = Hive.openBox<HiveMovieDetails>('movies');
    Box<HiveMovieDetails> _box = await box;

    setState(() {
      movieItems = null;
      _movItems.clear();
      _movPosters.clear();
    });

    if(favCheckbox == true){
      if (_box.isNotEmpty)
        movieItems = null;
    }
    else {
      _getMovies(page);
    }
  }

  @override
  void initState() {
    super.initState();
    _getPrefs();
    getEmptyList();
    // _getMovies(page);
    _checkDataHive();
    _scrollController = ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );
    _addImgs(_movItems);
    WidgetsBinding.instance.addObserver(this);
  }

  _addImgs(List<MovieItem> _restList) {
    for (var item in _restList)
      _movPosters.add(PopularMovieImgs(
        cachedImg: CachedNetworkImage(
          imageUrl: "$_imgUrl${item.imgUrl}",
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        id: item.movId,
        title: item.name,
      ));
    return _movPosters;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _savePrefs();
      print('paused');
    }
    if (state == AppLifecycleState.resumed) {
      print('resumed');
      _getPrefs();
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }


  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if(favCheckbox == false){
        if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent)
          _refreshBottom();
        else if(_scrollController.position.pixels == _scrollController.position.minScrollExtent)
          _refreshTop();
      }

    });



    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Theme.of(context).cardColor,
        actions: [
          PopupMenuButton(
            initialValue: popRadio,
            color: Theme.of(context).primaryColor,
            itemBuilder: (context) => [
              PopupMenuItem(
                child: RadioListTile(
                  value: "popular",
                  groupValue: popRadio,
                  onChanged: (newValue) {
                    setState(() {
                      popRadio = newValue;
                      movieItems = null;
                      _movPosters.clear();
                      page = 1;
                      _getMovies(page);
                    });
                    Navigator.pop(context);
                  },
                  title: Text("По популярности"),
                ),
              ),
              PopupMenuItem(
                child: RadioListTile(
                  value: "rate",
                  groupValue: popRadio,
                  onChanged: (newValue) {
                    setState(() {
                      popRadio = newValue;
                      movieItems = null;
                      _movPosters.clear();
                      page = 1;
                      _getMovies(page);
                    });
                    Navigator.pop(context);
                  },
                  title: Text("По рейтингу"),
                ),
              )
            ],
            child: Icon(
              Icons.sort,
              size: 30.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
          GestureDetector(
            onTap: () async {
              var resultSettings = await Navigator.pushNamedAndRemoveUntil(context, '/settings', (route) => false, arguments: {'sortValue' : popRadio});
              if(resultSettings == true)
                setState(() {
                  _getPrefs();
                  _checkDataHive();
                });
            },
            child: Icon(
              Icons.settings,
              size: 30.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh:() => _refreshTop(),
        child: FutureBuilder(
            future: favCheckbox == false ? movieItems : box,
            initialData: emptyMovieItems,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                // return Center(
                //   child: CircularProgressIndicator(),
                // );
                return GridView.builder(
                    padding: EdgeInsets.all(5.0),
                    itemCount: emptyMovieItems.length,
                    controller: _scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.6,
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                    ),
                    itemBuilder: (context, index) {
                      return EmptyMovieGrid();
                    });


              } else if (snapshot.hasData) {
                // var snapUrl = snapshot.hasData as List<HiveMovieDetails>;
                if(favCheckbox)
                  snapshot.data.toMap().entries.map((e) => _movPosters.add(PopularMovieImgs(
                  cachedImg: CachedNetworkImage(
                    imageUrl:e.value.movPosterPath,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  id: e.value.movId,
                  title: e.value.movOrigTitle,
                ))).toList();
                else
                  snapshot.data.asMap().entries.map((e) => _movPosters.add(PopularMovieImgs(
                    cachedImg: CachedNetworkImage(
                      imageUrl:"$_imgUrl${e.value.imgUrl}",
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    id: e.value.movId,
                    title:e.value.name,
                  ))).toList();
                return GridView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(5.0),
                  itemCount: snapshot.data.length,
                  controller: _scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.6,
                    crossAxisCount: 2,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                  ),
                  itemBuilder: (context, index) {
                    return MovieGridItem(_movPosters[index]);
                  },
                );
              } else
                return Center(child: Text("Проверьте интернет соединение!"));
            }),
      ),
    );
  }
}
