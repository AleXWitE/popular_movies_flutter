import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:popular_films/commons/api/services/modal_services.dart';
import 'package:popular_films/commons/data_models/data_models.dart';
import 'package:popular_films/commons/data_models/movie_details.dart';

import 'widgets/tab_description.dart';
import 'widgets/tab_review.dart';
import 'widgets/tab_trailers.dart';

class MovieScreen extends StatefulWidget {
  MovieScreen({
    Key key,
    this.movie,
  }) : super(key: key);

  final int movie;

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen>
    with TickerProviderStateMixin {
  List<CachedNetworkImage> _cachedImgs = [];

  ScrollController _scrollController = ScrollController();

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

  _setDateDesc(String _date) {
    Jiffy.locale("ru");

    var date = Jiffy(_date, "yyyy-mm-dd").format("MMMM, yyyy").toString();
    return date;
  }

  bool _inFav = false;

  Future<MovieDetails> movDetails;
  MovieDetails _movDet;

  Future<List<MovieImages>> movImages;
  List<MovieImages> _movImgs;

  int _current = 0;
  final CarouselController _carouselController = CarouselController();
  Curve curve = Curves.easeIn;

  _getDetails() async {
    movDetails = getDescription(widget.movie);
    _movDet = await movDetails;
    setState(() => _movDet);
    return _movDet;
  }

  _addImgs(Future<List> _list) async {
    for (var item in await _list as List<MovieImages>)
      _cachedImgs.add(CachedNetworkImage(
        imageUrl: "$_imgUrl${item.imgUrl}",
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ));
    setState(() => _cachedImgs);
    return _cachedImgs;
  }

  @override
  void initState() {
    super.initState();
    _getDetails();
    movImages = getAllImages(widget.movie);
    _addImgs(movImages);
    print(widget.movie);
  }

  @override
  void dispose() {
    super.dispose();
    _cachedImgs.clear();
  }

  @override
  Widget build(BuildContext context) {
    final _movMeta = ModalRoute.of(context).settings.arguments as Map;
    final _cachedPoster = _movMeta['moviePoster'] as CachedNetworkImage;
    int tabIndex = 0;

    PageController _pageController = PageController(initialPage: 0);
    TabController tabController =
        TabController(length: _tabItems.length, vsync: this);
    setState(() => tabController.index = tabIndex);

    String _genres = _movDet.movGenres
        .toString()
        .substring(1, _movDet.movGenres.toString().length - 1);

    _appBarBackground() {
      return Stack(
        overflow: Overflow.visible,
        children: [
          Column(children: [
            Container(
              height: 200.0,
              color: Theme.of(context).cardColor,
              width: MediaQuery.of(context).size.width,
              child: _cachedImgs.length == 0
                  ? Container()
                  : CarouselSlider.builder(
                      itemCount: _cachedImgs.length,
                      carouselController: _carouselController,
                      itemBuilder: (context, index, reason) => Image(
                        image: CachedNetworkImageProvider(
                            _cachedImgs[index].imageUrl),
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
            )
          ]),
          Positioned(
            right: 10.0,
            top: 200.0,
            child: Container(
              // color: Colors.white,
              width: MediaQuery.of(context).size.width / 2,
              height: 125.0,
              child: RichText(
                overflow: TextOverflow.fade,
                text: TextSpan(
                    text: "${_setDateDesc(_movDet.movRelease)}\n",
                    style: TextStyle(color: Colors.grey[500], height: 2.0),
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
                            color: Colors.white, fontSize: 13.0, height: 1.6),
                      ),
                      // TextSpan(text: "\n", style: TextStyle(fontSize: 5.0, height: 2.0)),
                      TextSpan(
                        text: "$_genres",
                        style: TextStyle(color: Colors.grey[500], height: 1.2),
                      )
                    ]),
              ),
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: 40.0,
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
              top: 100.0,
              child: Image(
                image: CachedNetworkImageProvider(_cachedPoster.imageUrl),
                width: 140.0,
                height: 200.0,
                fit: BoxFit.fill,
              )),
          Positioned(
              top: 170.0,
              right: 20.0,
              child: GestureDetector(
                onTap: () {
                  setState(() => _inFav = !_inFav);
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
      );
    }

    return _movDet == null && _movDet.movGenres == null
        ? Scaffold(
            body: CustomScrollView(
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
                  expandedHeight: 290.0,
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
            ),
          )
        : Scaffold(
            body: CustomScrollView(
              controller: _scrollController,
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
                  pinned: true,
                  floating: false,
                  expandedHeight: 330.0,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(50.0),
                    child: Container(
                      height: 50.0,
                      child: Container(
                        color: Theme.of(context).backgroundColor,
                        child: TabBar(
                          tabs: _tabItems,
                          controller: tabController,

                          onTap: (index) => setState(() => tabIndex = index),
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
                  //   future: movDetails,
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState != ConnectionState.done) {
                  //       return Center(
                  //         child: CircularProgressIndicator(),
                  //       );
                  //     } else {
                  //       if (snapshot.hasData) {
                          /*return*/ Container(
                            height: MediaQuery.of(context).size.height - 130.0,
                            child: TabBarView(
                                children: [
                                  TabDescription(
                                    id: widget.movie,
                                    details: _movDet,
                                  ),
                                  TabTrailers(id: widget.movie),
                                  TabReview(id: widget.movie),
                                ],
                                controller: tabController,
                              ),
                          )
                      //   } else
                      //     return Text('*-> Ничего нет');
                      // }

                ]))
              ],
            ),
          );
  }
}
