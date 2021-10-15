import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:jiffy/jiffy.dart';
import 'package:popular_films/commons/api/services/modal_services.dart';
import 'package:popular_films/commons/data_models/data_models.dart';
import 'package:popular_films/commons/data_models/movie_details.dart';

import 'widgets/tab_description.dart';
import 'widgets/tab_review.dart';
import 'widgets/tab_trailers.dart';

class MovieScreen extends StatefulWidget {
  MovieScreen({Key key, this.movie}) : super(key: key);

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

  Future<MovieDetails> movDetails;
  MovieDetails _movDet;

  Future<List<MovieImages>> movImages;
  List<MovieImages> _movImgs;

  _getDetails() async {
    movDetails = getDescription(widget.movie);
    _movDet = await movDetails;
  }

  _addImgs(Future<List> _list) async {
    for (var item in await _list as List<MovieImages>)
      _cachedImgs.add(CachedNetworkImage(
        imageUrl: "$_imgUrl${item.imgUrl}",
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ));
    return _cachedImgs;
  }

  @override
  void initState() {
    super.initState();
    _getDetails();
    movImages = getAllImages(widget.movie);
    _addImgs(movImages);
  }

  @override
  void dispose() {
    super.dispose();
    _cachedImgs.clear();
  }

  @override
  Widget build(BuildContext context) {
    final _movTitle = ModalRoute.of(context).settings.arguments as Map;

    PageController _pageController = PageController(initialPage: 0);
    TabController tabController =
        TabController(length: _tabItems.length, vsync: this);
    int _pageId = 0;
    Curve curve = Curves.easeIn;

    return Scaffold(

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).cardColor,
            title: Text(
              _movTitle['movieTitle'],
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
            expandedHeight: 160.0,
            flexibleSpace: FlexibleSpaceBar(),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 200.0,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder<List<MovieImages>>(
                  initialData: [],
                  future: movImages,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.hasData) {
                        return Swiper(
                          itemCount: snapshot.data.length,
                          autoplay: true,
                          autoplayDelay: 1,
                          loop: true,
                          index: 0,
                          duration: 100,
                          onIndexChanged: (value) => print(value),
                          pagination: SwiperPagination(
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                            builder: DotSwiperPaginationBuilder(
                                color: Colors.grey[500],
                                activeColor: Colors.teal[400],
                                size: 5.0,
                                activeSize: 7.0)
                          ),
                          itemWidth: MediaQuery.of(context).size.width,
                          itemBuilder: (context, index) => Image(
                            image: CachedNetworkImageProvider(
                                _cachedImgs[index].imageUrl),
                            fit: BoxFit.fill,
                          ),
                        );
                      } else
                        return Text("*- ничего нет");
                    }
                  }),
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