import 'package:flutter/material.dart';
import 'package:popular_films/commons/api/services/modal_services.dart';
import 'package:popular_films/commons/data_models/data_models.dart';

class TabReview extends StatefulWidget {
  List<MovieReviews> movRewiew;

  TabReview({this.movRewiew});

  @override
  _TabReviewState createState() => _TabReviewState();
}

class _TabReviewState extends State<TabReview> {
  List<MovieReviews> _movRew;

  @override
  void initState() {
    super.initState();
    _movRew = widget.movRewiew;
  }

  @override
  void dispose() {
    super.dispose();
    // _movRew.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: ListView(
        shrinkWrap: true,
        children:
        _movRew == null
          ? []
          : _movRew.asMap().entries.map((e) {
          return Container(
            padding: EdgeInsets.all(10.0),
            child: Card(
              color: Colors.grey[100],
              child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(children: [
                    GestureDetector(
                      onTap: () async {
                        if (e.value.isExpansed == true)
                          setState(() {
                            _movRew[e.key].isExpState = !_movRew[e.key].isExpState;
                            _movRew = List.from(_movRew);
                          });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.value.author,
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          e.value.isExpansed == true
                              ? _movRew[e.key].isExpState == true
                                  ? Icon(Icons.keyboard_arrow_up)
                                  : Icon(Icons.keyboard_arrow_down)
                              : Container()
                        ],
                      ),
                    ),
                    Text(
                      _movRew[e.key].isExpState == false
                          ? _movRew[e.key].shortContent
                          : _movRew[e.key].fullContent,
                      style: TextStyle(color: Theme.of(context).backgroundColor),
                    )
                  ])),
            ),
          );
        }).toList(),
      ),
    );
  }
}
