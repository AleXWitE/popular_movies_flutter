import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:popular_films/commons/db/hive_data_models.dart';
import 'package:popular_films/popular_movies.dart';
import 'package:provider/provider.dart';

import 'commons/data_models/provider_models.dart';

void main() {
  Future<void> initHiveDriver() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    final hiveDb = Directory('${appDocumentDirectory.path}/database');

    Hive.registerAdapter<HiveMovieDetails>(HiveMovieDetailsAdapter());
    Hive.registerAdapter<HiveMovieReviews>(HiveMovieReviewsAdapter());
    Hive.registerAdapter<HiveMovieYoutube>(HiveMovieYoutubeAdapter());
    Hive.registerAdapter<HiveMovieImages>(HiveMovieImagesAdapter());

    await Hive.initFlutter(hiveDb.path);
  }

  WidgetsFlutterBinding.ensureInitialized();

  initHiveDriver().then((value) => runApp(
          // MultiProvider(providers: [
          //   Provider<ProviderModel>(create: (_) => ProviderModel(),),
          //   Provider<PopularModel>(create: (_) => PopularModel(),),
          //   Provider<RateModel>.value(value: rate,),
          // ],
          ChangeNotifierProvider<ProviderModel>(
        create: (_) => ProviderModel(),
        child: MyApp(),
      )));
}
