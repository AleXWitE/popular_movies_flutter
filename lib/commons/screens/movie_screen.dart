import 'package:flutter/material.dart';
import 'package:popular_films/commons/api/services/modal_services.dart';
import 'package:popular_films/commons/data_models/movie_details.dart';
import 'package:popular_films/commons/screens/widgets/tab_description.dart';
import 'package:popular_films/commons/screens/widgets/tab_review.dart';
import 'package:popular_films/commons/screens/widgets/tab_trailers.dart';

class MovieScreen extends StatefulWidget {
  MovieScreen({Key key, this.movie}) : super(key: key);

  final String movie;

  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen>
    with TickerProviderStateMixin {
  int id = 580489;

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

  Future<MovieDetails> movDetails;
  MovieDetails _movDet;

  _getDetails() async {
    movDetails = getDescription(id);
    _movDet = await movDetails;
  }

  @override
  void initState() {
    super.initState();
    _getDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController =
        TabController(length: _tabItems.length, vsync: this);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'film',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Theme.of(context).cardColor,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: Theme.of(context).primaryColor,
              size: 25.0,
            )),
      ),
      body: Column(children: [
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
        Expanded(
          child: FutureBuilder<MovieDetails>(
              future: movDetails,
              builder: (context, snapshot) {
                print('*-> ${snapshot.connectionState}');
                if (snapshot.connectionState != ConnectionState.done) {
                  return Text('*-> ${snapshot.connectionState}');
                } else {
                  if (snapshot.hasData) {
                    return TabBarView(
                      children: [
                        TabDescription(
                          id: id,
                          details: snapshot.data,
                        ),
                        TabTrailers(id: id),
                        TabReview(id: id),
                      ],
                      controller: tabController,
                    );
                  } else
                    return Text('*-> Ничего нет');
                }
              }),
        ),
      ]),
    );
  }
}