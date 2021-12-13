import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jiffy/jiffy.dart';
import 'package:popular_films/commons/api/services/modal_services.dart';
import 'package:popular_films/commons/data_models/cache_manager.dart';
import 'package:popular_films/commons/data_models/data_models.dart';
import 'package:popular_films/commons/data_models/movie_details.dart';
import 'package:popular_films/commons/data_models/provider_models.dart';
import 'package:popular_films/commons/db/hive_data_models.dart';
import 'package:popular_films/commons/db/sqflite/db_helpers.dart';
import 'package:popular_films/commons/screens/widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

import 'widgets/tab_description.dart';
import 'widgets/tab_review.dart';
import 'widgets/tab_trailers.dart';

class MovieScreen extends StatefulWidget {
  MovieScreen({
    Key key,
    this.movie,
    this.isFav,
  }) : super(key: key);

  final int movie;
  final bool isFav;

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen>
    with TickerProviderStateMixin {
  BuildContext scaffoldContext;
  // final GlobalKey _appBarKey = GlobalKey();
  // final GlobalKey _sliderKey = GlobalKey();

  Size appBarSize;
  Size sliderSize;

  List<CachedNetworkImage> _cachedImgs = [];
  final myCacheManager = CacheManager();

  ScrollController _scrollController = ScrollController();

  // Box<HiveMovieDetails> box;

  bool _isFav;
  bool _checkMovie;

  final _tabItems = [
    const Tab(
      text: "ИНФОРМАЦИЯ",
    ),
    const Tab(
      text: "ТРЕЙЛЕРЫ",
    ),
    const Tab(
      text: "ОБЗОРЫ",
    ),
  ];

  String _imgUrl = 'https://image.tmdb.org/t/p/w500';

  int _movie;
  String _cachPoster;

  _setDateDesc(String _date) {
    Jiffy.locale("ru");

    var date = Jiffy(_date, "yyyy-mm-dd").format("MMM, yyyy");
    date = date.substring(4, date.length);
    return date;
  }

  bool _inFav = false;

  Future<MovieDetails> movDetails;
  MovieDetails _movDet;
  String _genres;

  Future<List<MovieReviews>> movReviews;
  List<MovieReviews> _movRev = List<MovieReviews>();
  List<HiveMovieReviews> _hiveMovRev = [];

  Future<List<YoutubeVideosKeys>> movYoutube;
  List<YoutubeVideosKeys> _movYt;
  List<HiveMovieYoutube> _hiveMovYt = [];

  Future<List<MovieImages>> movImages;
  List<MovieImages> _movImgs;
  List<String> _hiveMovImgs = [];

  int _current = 0;
  int tabIndex;

  final CarouselController _carouselController = CarouselController();
  Curve curve = Curves.easeIn;

  _getDetails() async {
    movDetails = getDescription(widget.movie);
    _movDet = await movDetails;
    setState(() {
      _movDet;
      _genres = _movDet.movGenres
          .toString()
          .substring(1, _movDet.movGenres.length - 1);
    });
    return _movDet;
  }

  _getReviews() async {
    movReviews = getReviews(widget.movie);
    _movRev = await movReviews;
    for (var item in _movRev)
      _hiveMovRev.add(HiveMovieReviews(
          id: item.id,
          isExpansed: item.isExpansed,
          isExpState: item.isExpState,
          fullContent: item.fullContent,
          shortContent: item.shortContent,
          author: item.author));

    setState(() {
      _movRev;
      _hiveMovRev;
    });
    return _movRev;
  }

  _getYoutube() async {
    movYoutube = getAllYoutube(widget.movie);
    _movYt = await movYoutube;
    setState(() => _movYt);

    _movYt
        .asMap()
        .entries
        .map((e) => _hiveMovYt.add(
            HiveMovieYoutube(ytKey: e.value.ytKey, ytName: e.value.ytName)))
        .toList();
    // for(var item in _movYt)
    //   _hiveMovYt.add(HiveMovieYoutube(ytKey: item.ytKey, ytName: item.ytName));
    setState(() {
      _hiveMovYt;
    });
    return _movYt;
  }

  _addDbImgs(List<MovieImages> _list) {
    print("img count ${_list.length}");
    for (var item in _list) {
      _cachedImgs.add(CachedNetworkImage(
        imageUrl: "$_imgUrl${item.imgUrl}",
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ));
    }
    print(_cachedImgs.length);
  }

  _addImgs(Future<List> _list) async {
    for (var item in await _list as List<MovieImages>) {
      _cachedImgs.add(CachedNetworkImage(
        imageUrl: "$_imgUrl${item.imgUrl}",
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ));
      _hiveMovImgs.add("$_imgUrl${item.imgUrl}");
    }

    setState(() => _cachedImgs);

    _movImgs = await _list;

    for (var i in _cachedImgs)
      _hiveMovImgs.add(i.imageUrl);
    setState(() {
      _cachedImgs;
      _movImgs;
      _hiveMovImgs;
    });
    return _cachedImgs;
  }

  _saveCachedImgs() async {}

  _getRest() async {
    await _getDetails();
    await _getReviews();
    await _getYoutube();
    movImages = getAllImages(widget.movie);
    await _addImgs(movImages);
    _saveCachedImgs();
    print('rest');
  }

  // Future<MovieDetails> _getHiveFuture(var futureBox) async {
  //   return futureBox;
  // }

  _getHiveDetails() async {
    // var _box = await Hive.openBox<HiveMovieDetails>('movie');
    // HiveMovieDetails _dataBox = box.get(_movie);
    // movDetails = _getHiveFuture(_dataBox);
    // setState(() {
    //   _movDet = MovieDetails(
    //       id: _dataBox.id,
    //       movOrigTitle: _dataBox.movOrigTitle,
    //       movTagline: _dataBox.movTagline,
    //       movHomepage: _dataBox.movHomepage,
    //       movRevenue: _dataBox.movRevenue,
    //       movBudget: _dataBox.movBudget,
    //       movRelease: _dataBox.movRelease,
    //       movOverview: _dataBox.movOverview,
    //       movRuntime: _dataBox.movRuntime,
    //       movLanguage: _dataBox.movLanguage,
    //       movVote: _dataBox.movVote,
    //       movPosterPath: _dataBox.movPosterPath,
    //       movGenres: _dataBox.movGenres);
    //
    //   _hiveMovImgs = List.from(_dataBox.movBackpacks);
    //
    //   _hiveMovYt = List.from(_dataBox.movYoutube);
    //
    //   _genres = _dataBox.movGenres
    //       .toString()
    //       .substring(1, _movDet.movGenres.toString().length - 1);
    // });
    // await box.close();
    return _movDet;
  }

  _getHiveReviews() async {
    // var _box = await Hive.openBox<HiveMovieDetails>('movie');
    // HiveMovieDetails _dataBox = box.get(_movie);

    // for (var i in _dataBox.movReviews){
    //   _movRev.add(MovieReviews(
    //       id: i.id,
    //       isExpansed: i.isExpansed,
    //       isExpState: false,
    //       fullContent: i.fullContent,
    //       shortContent: i.shortContent,
    //       author: i.author));
    //
    //   print("${i.id}, ${i.isExpansed}, ${i.author}, ${ i.isExpState}, ${i.shortContent},\n \n ${ i.fullContent},\n ");
    // }


    // await _box.close();

    return _movRev;
  }

  _getHiveYoutube() async {

    _hiveMovYt.asMap().entries.map((e) => _movYt.add(YoutubeVideosKeys(ytKey: e.value.ytKey, ytName: e.value.ytName)));

    // await _box.close();
    return _movYt;
  }

  // _addHiveImgs() async {
  //   // var _box = await Hive.openBox<HiveMovieDetails>('movie');
  //   HiveMovieDetails _dataBox = box.get(_movie);
  //   for (var item in _dataBox.movBackpacks)
  //     myCacheManager
  //         .cacheImage("$_imgUrl$item")
  //         .then((value) { _cachedImgs.add(CachedNetworkImage(
  //               imageUrl: value,
  //               placeholder: (context, url) => CircularProgressIndicator(),
  //               errorWidget: (context, url, error) => Icon(Icons.error),
  //             ));
  //         });
  //   setState(() => _cachedImgs);
  //   return _cachedImgs;
  // }

  // _getCachedImgs() async {}

  _getHive() async {
    await _getHiveDetails();
    await _getHiveReviews();
    await _getHiveYoutube();
    // _getCachedImgs();
    // await _addHiveImgs();
    print('hive');
    setState(() => _inFav = true);
  }

  _getFromDb() async {
    _movDet = await DatabaseHelper.instance.getDetails(widget.movie);
    print("in movie screen $_movie");
    _movYt = await DatabaseHelper.instance.getYt(widget.movie);
    _movRev = await DatabaseHelper.instance.getRev(widget.movie);
    // _movImgs = await DatabaseHelper.instance.getImgs(widget.movie);
    setState(() {
      _genres = _movDet.movGenres;
    });
    _addDbImgs(await DatabaseHelper.instance.getImgs(widget.movie));
    setState(() => _inFav = true);
  }

  _checkDataHive() async {
    // box = await Hive.openBox<HiveMovieDetails>('movies');
    // var _dataBox;
    // await Future.delayed(Duration(milliseconds: 10));
    // if (box.isNotEmpty) _dataBox = box.get(_movie);
    _checkMovie = await DatabaseHelper.instance.checkMovie(widget.movie);
    if (_checkMovie)
      setState(() => _inFav = true);
    else
      setState(() => _inFav = false);

    if (_isFav) {
      // _getHive();
      _getFromDb();
    } else {
      _getRest();
    }
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   getSliderSize();
    //   getAppBarSize();
    // });
    //
    // Future.delayed(Duration(seconds: 1));
    setState(() {
      _isFav = widget.isFav;
    });

    print(_isFav);
    _checkDataHive();
    tabIndex = 0;
    _movie = widget.movie;
    print(widget.movie);
    // getAppBarSize();
  }

  @override
  void dispose() {
    super.dispose();
    _cachedImgs.clear();
  }

  addToFav() async {
    await DatabaseHelper.instance.insertFav(_movDet, _movRev, _movYt, _movImgs, _genres);
    // await box.put(
    //     _movie,
    //     HiveMovieDetails(
    //       movId: _movie,
    //       movOrigTitle: _movDet.movOrigTitle,
    //       movTagline: _movDet.movTagline,
    //       movPosterPath: _cachPoster,
    //       movBackpacks: _hiveMovImgs,
    //       movGenres: _movDet.movGenres,
    //       movVote: _movDet.movVote,
    //       movRelease: _movDet.movRelease,
    //       movLanguage: _movDet.movLanguage,
    //       movRuntime: _movDet.movRuntime,
    //       movRevenue: _movDet.movRevenue,
    //       movBudget: _movDet.movBudget,
    //       movHomepage: _movDet.movHomepage,
    //       movOverview: _movDet.movOverview,
    //       movReviews: _hiveMovRev,
    //       movYoutube: _hiveMovYt,
    //     ));
    print("add");
  }

  delFromFav() async {
    // await box.delete(_movie);
    await DatabaseHelper.instance.deleteFav(_movDet.id);
    print("delete");
  }


  @override
  Widget build(BuildContext context) {
    final _movMeta = ModalRoute.of(context).settings.arguments as Map;
    final _cachedPoster = _movMeta['moviePoster'] as String;

    final _provider = Provider.of<ProviderModel>(context);
    setState(() {
      _isFav = _provider.favourite;
    });

    setState(() => _cachPoster = _cachedPoster);

    TabController tabController =
        TabController(initialIndex: tabIndex, length: _tabItems.length, vsync: this);
    // setState(() => tabController.index = tabIndex);

    _appBarBackground() {
      // return Stack(
      //   overflow: Overflow.visible,
      //   children: [
          return Column(
              children: [
            Container(
              // height: /*Platform.isIOS ? 235.0 : */200.0,
              color: Theme.of(context).cardColor,
              width: MediaQuery.of(context).size.width,
              child: _cachedImgs.length == 0
                  ? Container()
                  : CarouselSlider.builder(
                      itemCount: _cachedImgs.length,
                      carouselController: _carouselController,
                      itemBuilder: (context, index, reason) => Image(
                        height: 200.0,
                        // key: _sliderKey,
                        image: CachedNetworkImageProvider(_cachedImgs[index].imageUrl),
                        fit: BoxFit.fill,
                      ),
                      options: CarouselOptions(
                          autoPlay: true,
                          autoPlayCurve: curve,
                          autoPlayInterval: Duration(seconds: 5),
                          enlargeCenterPage: false,
                          viewportFraction: 1.0,
                          autoPlayAnimationDuration:
                              Duration(microseconds: 800),
                          onPageChanged: (index, reason) =>
                              setState(() => _current = index)),
                    ),
            ),
            Container(
              color: Theme.of(context).cardColor,
              height: 125.0,
              child: Stack(
                overflow: Overflow.visible,
                children: [
                  Positioned(
                    right: 10.0,
                    top:/* Platform.isIOS ? 210.0 : */0.0,
                    child: Container(
                      // color: Colors.white,
                      width: MediaQuery.of(context).size.width / 2,
                      height: 125.0,
                      child: RichText(
                        overflow: TextOverflow.fade,
                        text: TextSpan(
                            text: "${/*_setDateDesc(*/ _movDet.movRelease /*)*/}\n",
                            style: TextStyle(color: Colors.grey[500], height: 1.8),
                            children: [
                              TextSpan(
                                text: _movDet.movOrigTitle.length < 17
                                    ? "${_movDet.movOrigTitle}\n"
                                    : "${_movDet.movOrigTitle.substring(0, 15)}...\n",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0, height: 1.2),
                              ),
                              TextSpan(
                                text: _movDet.movTagline != ''
                                    ? _movDet.movTagline.length > 27
                                    ? "${_movDet.movTagline.substring(0, 25)}...\n"
                                    : "${_movDet.movTagline}...\n"
                                    : "\n",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13.0, height: 1.5),
                              ),
                              // TextSpan(text: "\n", style: TextStyle(fontSize: 5.0, height: 2.0)),
                              TextSpan(
                                text: "$_genres",
                                style: TextStyle(color: Colors.grey[500], height: 1.15),
                              )
                            ]),
                      ),
                    ),
                  ),
                  Positioned(
                    width: MediaQuery.of(context).size.width,
                    top: /*Platform.isIOS ? 20.0 : */-150.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _cachedImgs.asMap().entries.map((e) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color:
                            _current == e.key ? Colors.teal[400] : Colors.grey[500],
                          ),
                          width: _current == e.key ? 10.0 : 5.0,
                          height: _current == e.key ? 10.0 : 5.0,
                        );
                      }).toList(),
                    ),
                  ),
                  Positioned(
                      left: 20.0,
                      top: /*Platform.isIOS ? 110.0 : */-100.0,
                      child: Image(
                        image: CachedNetworkImageProvider(_cachedPoster),
                        width: 140.0,
                        height: 200.0,
                        fit: BoxFit.fill,
                      )),
                  Positioned(
                      top: /*Platform.isIOS ? 180.0 : */-30.0,
                      right: 20.0,
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            _inFav = !_inFav;
                          });
                          if (_inFav)
                            addToFav();
                          else
                            delFromFav();
                          Scaffold.of(scaffoldContext)
                              .showSnackBar(customSnackBar(_inFav));
                        },
                        child: Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.teal[500],
                          ),
                          child: Icon(
                            _inFav == true ? Icons.favorite : Icons.favorite_border,
                            color: _inFav == true ? Colors.red[600] : Colors.grey[500],
                            size: 25.0,
                          ),
                        ),
                      )),
                ],
              ),
            )
          ]);//,

      //   ],
      // );
    }

    Widget _scaffoldStructure = CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            _movMeta['movieTitle'],
            style: TextStyle(
                fontSize: 18.0, color: Theme.of(context).primaryColor),
          ),
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back,
                color: Theme.of(context).primaryColor,
                size: 25.0,
              )),
          expandedHeight: /*Platform.isIOS ? 320.0 :*/ 290.0,
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
            height: 50.0,
            color: Theme.of(context).backgroundColor,
          ),
          Container(
            height: MediaQuery.of(context).size.height - 340.0,
          )
        ]))
      ],
    );

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: _movDet == null
          ? SafeArea(bottom: false, child: _scaffoldStructure)
          : SafeArea(
        bottom: false,
            child: Builder(builder: (BuildContext context) {
                scaffoldContext = context;
                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Theme.of(context).cardColor,
                      title: Text(
                        _movMeta['movieTitle'],
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).primaryColor),
                      ),
                      leading: GestureDetector(
                          onTap: () => Navigator.pop(context, true),
                          child: Icon(
                            Icons.arrow_back,
                            color: Theme.of(context).primaryColor,
                            size: 25.0,
                          )),
                      pinned: true,
                      floating: false,
                      expandedHeight:/* Platform.isIOS ? 360.0 :*/ 370.0,
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(50.0),
                        child: Container(
                          height: 50.0,
                          child: Container(
                            color: Theme.of(context).backgroundColor,
                            child: TabBar(
                              tabs: _tabItems,
                              controller: tabController,
                              onTap: (i) => setState((){
                                tabIndex = i;
                                // tabController.index = i;
                              }),
                              indicatorColor: Colors.teal[500],
                              labelStyle: TextStyle(fontSize: 12.0),
                              labelColor: Theme.of(context).primaryColor,
                              unselectedLabelColor: Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        background: _appBarBackground(),
                      ),
                    ),
                    SliverList(
                        delegate: SliverChildListDelegate([
                      // FutureBuilder<MovieDetails>(
                      //     future: movDetails,
                      //     builder: (context, snapshot) {
                      //       if (snapshot.connectionState !=
                      //           ConnectionState.done) {
                      //         return Center(
                      //           child: CircularProgressIndicator(),
                      //         );
                      //       } else {
                      //         if (snapshot.hasData) {
                      /*return */ Container(
                        height: MediaQuery.of(context).size.height - 130.0,
                        child: TabBarView(
                          children: [
                            TabDescription(
                              id: widget.movie,
                              details: _movDet,
                            ),
                            TabTrailers(
                              getYoutube: _movYt,
                            ),
                            TabReview(
                              movRewiew: _movRev,
                            ),
                          ],
                          controller: tabController,
                        ),
                      )
                      //   } else
                      //     return Text('*-> Ничего нет');
                      // }
                      // })
                    ]))
                  ],
                );
              }),
          ),
    );
  }
}
