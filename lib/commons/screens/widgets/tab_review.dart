import 'package:flutter/material.dart';

// TODO для отзывов мне нужно получать айди фильма и в адрес для рест его подставлять сюда "https://api.themoviedb.org/3/movie/$id/reviews?api_key="
class TabReview extends StatefulWidget {
  int id;
  TabReview({this.id});

  @override
  _TabReviewState createState() => _TabReviewState();

}

class _TabReviewState extends State<TabReview> {
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
    return  Container(height: MediaQuery.of(context).size.height - 50.0,
      width: MediaQuery.of(context).size.width,);
  }
}