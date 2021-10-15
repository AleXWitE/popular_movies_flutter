import 'package:flutter/material.dart';
import 'package:popular_films/commons/api/services/modal_services.dart';
import 'package:popular_films/commons/data_models/data_models.dart';

class TabReview extends StatefulWidget {
  int id;

  TabReview({this.id});

  @override
  _TabReviewState createState() => _TabReviewState();
}

class _TabReviewState extends State<TabReview> {
  Future<List<MovieReviews>> movReviews;

  _getReviews(int _id) {
    movReviews = getReviews(_id);
  }

  @override
  void initState() {
    super.initState();
    _getReviews(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MovieReviews>>(
        future: movReviews,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
              return ExpansionPanelList(
                children: [],
              );
            } else
              Text("*- ничего нет");
        });
  }
}
