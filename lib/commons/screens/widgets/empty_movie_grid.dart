import 'package:flutter/material.dart';

class EmptyMovieGrid extends StatelessWidget {
  EmptyMovieGrid({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Image.asset('lib/img/download.png', fit: BoxFit.fitWidth,),
    );
  }
}