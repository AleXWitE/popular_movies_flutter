import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:popular_films/commons/data_models/data_models.dart';
import 'package:popular_films/commons/data_models/provider_models.dart';
import 'package:provider/provider.dart';

class MovieGridItem extends StatelessWidget {
  final PopularMovieImgs item;

  MovieGridItem(this.item) : super();

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ProviderModel>(context);
    bool _provFav = _provider.favourite;
    return GestureDetector(
        onTap: () =>
            Navigator.pushNamed(context, '/home/${item.id}', arguments: {
              'movieTitle': item.title,
              'moviePoster': item.cachedImg.imageUrl,
            }),

    child: ClipRRect(
    borderRadius: BorderRadius.circular(5.0),
    child: Image(image: CachedNetworkImageProvider(item.cachedImg.imageUrl), fit: BoxFit.fill,),
    ),
    );
  }
}
