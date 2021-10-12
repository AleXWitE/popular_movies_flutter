import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
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
        title: Text('film', style: TextStyle(color: Theme.of(context).primaryColor),),
        backgroundColor: Theme.of(context).cardColor,
        leading: GestureDetector(onTap: () => Navigator.pop(context),child: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor, size: 25.0,)),
      ),
      body: Column(children: [
        Expanded(
          flex: 1,
          child: TabBar(
            tabs: _tabItems,
            controller: tabController,
            labelColor: Theme.of(context).backgroundColor,
            unselectedLabelColor: Colors.grey[300],
          ),
        ),
        Expanded(
          flex: 9,
          child: TabBarView(
            children: [
              TabDescription(id: id),
              TabTrailers(id: id),
              TabReview(id: id),
            ],
            controller: tabController,
          ),
        )
      ]),
    );
  }
}
