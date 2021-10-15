import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:popular_films/commons/api/services/modal_services.dart';
import 'package:popular_films/commons/data_models/data_models.dart';
import 'package:popular_films/commons/data_models/movie_details.dart';

import 'widgets/tab_description.dart';
import 'widgets/tab_review.dart';
import 'widgets/tab_trailers.dart';

class MovieScreen extends StatefulWidget {
  MovieScreen({Key key, this.movie}) : super(key: key);

  final String movie;

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen>
    with TickerProviderStateMixin {
  int id = 580489;
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

  String movRelease = "2021-09-21";
  String _imgUrl = 'https://image.tmdb.org/t/p/original';

  _setDateDesc(String _date) {
    Jiffy.locale("ru");

    var date = Jiffy(movRelease, "yyyy-mm-dd").format("MMMM, yyyy").toString();
    return date;
  }

  Future<MovieDetails> movDetails;
  MovieDetails _movDet;

  Future<List<MovieImages>> movImages;
  List<MovieImages> _movImgs;

  _getImages() async {
    movImages = getAllImages(id);
    _movImgs = await movImages;
  }

  _getDetails() async {
    movDetails = getDescription(id);
    _movDet = await movDetails;
  }

  @override
  void initState() {
    super.initState();
    _getDetails();
    // _getImages();
    movImages = getAllImages(id);

  }

  @override
  void dispose() {
    super.dispose();
    _cachedImgs.clear();
  }

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(initialPage: 0);
    TabController tabController =
        TabController(length: _tabItems.length, vsync: this);
    int _pageId = 0;
    Curve curve = Curves.easeIn;
    bool _slider = true;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'film',
      //     style: TextStyle(color: Theme.of(context).primaryColor),
      //   ),
      //   backgroundColor: Theme.of(context).cardColor,
      //   leading: GestureDetector(
      //       onTap: () => Navigator.pop(context),
      //       child: Icon(
      //         Icons.arrow_back,
      //         color: Theme.of(context).primaryColor,
      //         size: 25.0,
      //       )),
      // ),
      // body: Column(children: [
      //   Container(
      //     height: 50.0,
      //     child: Container(
      //       color: Theme.of(context).backgroundColor,
      //       child: TabBar(
      //         tabs: _tabItems,
      //         controller: tabController,
      //         // indicatorColor: Theme.of(context).cardColor,
      //         labelStyle: TextStyle(fontSize: 12.0),
      //         labelColor: Theme.of(context).primaryColor,
      //         unselectedLabelColor: Colors.grey[400],
      //       ),
      //     ),
      //   ),
      //   Expanded(
      //     child: FutureBuilder<MovieDetails>(
      //         future: movDetails,
      //         builder: (context, snapshot) {
      //           print('*-> ${snapshot.connectionState}');
      //           if (snapshot.connectionState != ConnectionState.done) {
      //             return Text('*-> ${snapshot.connectionState}');
      //           } else {
      //             if (snapshot.hasData) {
      //               return TabBarView(
      //                 children: [
      //                   TabDescription(
      //                     id: id,
      //                     details: snapshot.data,
      //                   ),
      //                   TabTrailers(id: id),
      //                   TabReview(id: id),
      //                 ],
      //                 controller: tabController,
      //               );
      //             } else
      //               return Text('*-> Ничего нет');
      //           }
      //         }),
      //   ),
      // ]),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).cardColor,
            title: Text("Film", style: TextStyle(fontSize: 21.0, color: Theme.of(context).primaryColor),),
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
                  for(var item in snapshot.data)
                  _cachedImgs.add(CachedNetworkImage(
                    imageUrl: item.imgUrl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ));

                  return Stack(
                  children: [

                    Positioned(
                      child: PageView(
                        onPageChanged: (value) => _pageId = value,
                      controller: _pageController,
                      children: [
                        for(var imgs in _cachedImgs)
                          Image(image: CachedNetworkImageProvider(imgs.imageUrl),)
                      ],
                    ),),
                    Positioned(
                      top: 10.0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for(int i = 0;  i < snapshot.data.length; i++)
                              Container(
                                height: 10.0,
                                width: 10.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: i == _pageId ? Colors.teal[400] : Colors.grey[500],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ); }
              ),
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
                  return Center(child: CircularProgressIndicator(),);
                } else {
                  if (snapshot.hasData) {
                    return Container(
                      height: MediaQuery.of(context).size.height - 130.0,
                      child: TabBarView(
                        children: [
                          TabDescription(
                            id: id,
                            details: snapshot.data,
                          ),
                          TabTrailers(id: id),
                          TabReview(id: id),
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
