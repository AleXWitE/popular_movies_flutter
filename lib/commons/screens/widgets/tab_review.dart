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
  List<MovieReviews> _movRew;

  _getReviews(int _id) async {
    // setState(() => _movRew.clear());
    movReviews = getReviews(_id);
    _movRew = await movReviews;
    setState(() => _movRew);
    return _movRew;
  }

  @override
  void initState() {
    super.initState();
    _getReviews(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
    _movRew.clear();
    movReviews = null;
  }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<List<MovieReviews>>(
    //     future: movReviews,
    //     initialData: [],
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState != ConnectionState.done) {
    //         return Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       } else if (snapshot.hasData) {
    // return ExpansionPanelList(
    //   animationDuration: Duration(milliseconds: 800),
    //   expansionCallback: (index, isExpansion) {
    //     snapshot.data[index].isExpansed = isExpansion;
    //   },
    //   children: [
    //     for(var i in snapshot.data)
    //       ExpansionPanel(
    //           headerBuilder: (context, isExpansion) =>
    //           ListTile(title: Text(i.author),
    //               leading: i.isExpansed == true
    //                   ? isExpansion == true
    //                   ? Icon(Icons.keyboard_arrow_up)
    //               : Icon(Icons.keyboard_arrow_down)
    //             : Container(),),
    //           body: ListTile(
    //             title: Text(i.shortContent),
    //           )),
    //   ],
    // );
    List<bool> isExpansion = [];
    // for (var i in _movRew) {
    //   isExpansion.add(false);
    // }
    bool state = false;
    // print(_movRew[1].id);
    // return ListView.builder(
    //     shrinkWrap: true,
    //     itemCount: _movRew.length,
    // itemBuilder: (context, index) => Container(
    //       padding: EdgeInsets.all(10.0),
    //       child: Card(
    //         color: Colors.grey[100],
    //         child: Container(
    //             padding: EdgeInsets.all(10.0),
    //             child: Column(children: [
    //               GestureDetector(
    //                 onTap: () {
    //                   if (_movRew[index].isExpansed == true)
    //                     setState(() {
    //                       state = !isExpansion[index];
    //                       isExpansion[index] = state;
    //                     });
    //                   print("$index, ${isExpansion[index]}, $state");
    //                 },
    //                 child: Row(
    //                   mainAxisAlignment:
    //                       MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Text(
    //                       _movRew[index].author,
    //                       style: TextStyle(
    //                           fontSize: 16.0,
    //                           fontWeight: FontWeight.bold),
    //                     ),
    //                     _movRew[index].isExpansed == true
    //                         ? isExpansion[index] == true
    //                             ? Icon(Icons.keyboard_arrow_up)
    //                             : Icon(Icons.keyboard_arrow_down)
    //                         : Container()
    //                   ],
    //                 ),
    //               ),
    //               Text(
    //                 isExpansion[index] == false
    //                     ? _movRew[index].shortContent
    //                     : _movRew[index].fullContent,
    //                 style: TextStyle(
    //                     color: Theme.of(context).backgroundColor),
    //               )
    //             ])),
    //       ),
    //     ));
    List<IsExpansed> _isExp = [];
    return ListView(
      shrinkWrap: true,
      children: _movRew.asMap().entries.map((e) {
        _isExp.add(IsExpansed(id: e.key, isExpansed: false));

        return new Container(
          padding: EdgeInsets.all(10.0),
          child: Card(
            color: Colors.grey[100],
            child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(children: [
                  GestureDetector(
                    onTap: () {
                      if (e.value.isExpansed == true)
                        setState(() {
                          state = _isExp[e.key].isExpansed;
                          _isExp[e.key].isExpansed = !state;
                        });
                      setState(() {
                        _isExp = List.from(_isExp);
                        _movRew = List.from(_movRew);
                      } );
                      print("${e.key}, ${_isExp[e.key].isExpansed}, $state");
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
                            ? _isExp[e.key].isExpansed == true
                                ? Icon(Icons.keyboard_arrow_up)
                                : Icon(Icons.keyboard_arrow_down)
                            : Container()
                      ],
                    ),
                  ),
                  Text(
                    _isExp[e.key].isExpansed == false
                        ? _movRew[e.key].shortContent
                        : _movRew[e.key].fullContent,
                    style: TextStyle(color: Theme.of(context).backgroundColor),
                  )
                ])),
          ),
        );
      }).toList(),
    );

    // return ExpansionPanelList(
    //   expansionCallback: (index, isExpansed) {},
    //   children: _movRew.asMap().entries.map((e) {
    //     _isExp.add(IsExpansed(id: e.key, isExpansed: false));
    //     return ExpansionPanel(
    //         canTapOnHeader: e.value.isExpansed == true ? true : false,
    //         headerBuilder: (context, isExpansion) => ListTile(
    //               title: Text(
    //                 e.value.author,
    //               ),
    //             ),
    //         isExpanded:
    //             e.value.isExpansed == true && _isExp[e.key].isExpansed == true
    //                 ? true
    //                 : false,
    //         body: Container(
    //           padding: EdgeInsets.all(10.0),
    //           child: Text(e.value.isExpansed == true
    //               ? _isExp[e.key].isExpansed == true
    //                   ? e.value.fullContent
    //                   : e.value.shortContent
    //               : e.value.fullContent),
    //         )
    //         // padding: EdgeInsets.all(10.0),
    //         // child: Card(
    //         //   color: Colors.grey[100],
    //         //   child: Container(
    //         //       padding: EdgeInsets.all(10.0),
    //         //       child: Column(children: [
    //         //         GestureDetector(
    //         //           onTap: () {
    //         //             if (e.value.isExpansed == true)
    //         //               this.setState(() {
    //         //                 state = _isExp[e.key].isExpansed;
    //         //                 _isExp[e.key].isExpansed = !state;
    //         //               });
    //         //             this.setState(() => _movRew = List.from(_movRew));
    //         //             print("${e.key}, ${_isExp[e.key].isExpansed}, $state");
    //         //           },
    //         //           child: Row(
    //         //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         //             children: [
    //         //               Text(
    //         //                 e.value.author,
    //         //                 style: TextStyle(
    //         //                     fontSize: 16.0, fontWeight: FontWeight.bold),
    //         //               ),
    //         //               e.value.isExpansed == true
    //         //                   ? _isExp[e.key].isExpansed == true
    //         //                   ? Icon(Icons.keyboard_arrow_up)
    //         //                   : Icon(Icons.keyboard_arrow_down)
    //         //                   : Container()
    //         //             ],
    //         //           ),
    //         //         ),
    //         //         Text(
    //         //           _isExp[e.key].isExpansed == false
    //         //               ? _movRew[e.key].shortContent
    //         //               : _movRew[e.key].fullContent,
    //         //           style: TextStyle(color: Theme.of(context).backgroundColor),
    //         //         )
    //         //       ])),
    //         // ),
    //         );
    //   }).toList(),
    // );
  }
}
