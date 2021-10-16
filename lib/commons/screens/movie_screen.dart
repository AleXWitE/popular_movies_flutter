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

    PageController _pageController = PageController(initialPage: 0);
    TabController tabController =
        TabController(length: _tabItems.length, vsync: this);
    int _pageId = 0;
    String _genres = _movDet.movGenres.toString().substring(1, _movDet.movGenres.toString().length - 1);

    _appBarBackground(){
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
                        text: "${_movDet.movOrigTitle}\n",
                        style: TextStyle(color: Colors.white, fontSize: 16.0,height: 1.2),
                      ),
                      TextSpan(
                        text: _movDet.movTagline != '' ? "${_movDet.movTagline.substring(0, 30)}...\n" : "\n",
                        style: TextStyle(color: Colors.white, fontSize: 13.0, height: 1.6),
                      ),
                      // TextSpan(text: "\n", style: TextStyle(fontSize: 5.0, height: 2.0)),
                      TextSpan(
                        text: "$_genres",
                        style: TextStyle(color: Colors.grey[500], height: 1.0),
                      )
                    ]
                ),
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
                    color: _current == e.key
                        ? Colors.teal[400]
                        : Colors.grey[500],
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
                    _inFav == true
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: _inFav == true
                        ? Colors.red[600]
                        : Colors.grey[500],
                    size: 25.0,
                  ),
                ),
              )),
        ],
      );
    }

    return Scaffold(
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
            pinned: true,
            floating: false,
            expandedHeight: 290.0,
            flexibleSpace: FlexibleSpaceBar(
              background: _appBarBackground(),

            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              height: 50.0,
              child: Container(
                color: Theme.of(context).backgroundColor,
                child: TabBar(
                  tabs: _tabItems,
                  controller: tabController,
                  indicatorColor: Colors.teal[500],
                  // indicatorColor: Theme.of(context).cardColor,
                  labelStyle: TextStyle(fontSize: 12.0),
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey[400],
                ),
              ),
            ),
            FutureBuilder<MovieDetails>(
              future: movDetails,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    return Container(
                      height: MediaQuery.of(context).size.height - 130.0,
                      child: TabBarView(
                        children: [
                          TabDescription(
                            id: widget.movie,
                            details: snapshot.data,
                          ),
                          TabTrailers(id: widget.movie),
                          TabReview(id: widget.movie),
                        ],
                        controller: tabController,
                      ),
                    );
                  } else
                    return Text('*-> Ничего нет');
                }
              },
            )
          ]))
        ],
      ),
    );
  }
}

// Future<Null> _changePage(int _id, List _list) async {
//   while (_slider == true) {
//     await Future.delayed(Duration(seconds: 3));
//     if (_pageId == _list.length - 1)
//         _pageId = 0;
//     else
//       _pageId++;
//     _pageController.animateToPage(_pageId,
//         duration: Duration(milliseconds: 500),
//         curve: curve);
//   }
// }

// _changePage(_pageId, snapshot.data);

// return Stack(
//   children: [
//     Positioned(
//       child: PageView(
//         onPageChanged: (value) =>
//             _changePage(value, _cachedImgs),
//         controller: _pageController,
//         children: [
//           for (var imgs in _cachedImgs)
//             Image(
//               image:
//                   CachedNetworkImageProvider(imgs.imageUrl),
//             )
//         ],
//       ),
//     ),
//     Positioned(
//       top: 10.0,
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             for (int _i = 0; _i < _cachedImgs.length; _i++)
//               Container(
//                 height: 10.0,
//                 width: 10.0,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5.0),
//                   color: _i == _pageId
//                       ? Colors.teal[400]
//                       : Colors.grey[500],
//                 ),
//               )
//           ],
//         ),
//       ),
//     ),
//   ],
// );
