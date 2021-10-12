import 'package:flutter/material.dart';
import 'package:popular_films/commons/data_models/data_models.dart';

class MovieGridItem extends StatelessWidget {
  final MovieItem item;

  MovieGridItem(this.item) : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/home/${item.movId - 1}'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),

        child: Image.network(
          '${item.imgUrl}',
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
