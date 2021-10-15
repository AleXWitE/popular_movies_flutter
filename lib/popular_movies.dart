import 'package:flutter/material.dart';

import 'commons/screens/settings_screen.dart';
import 'commons/screens/movie_screen.dart';
import 'commons/screens/main_screen.dart';


class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Popular movies',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.black,
        cardColor: Colors.blueGrey[800],
        backgroundColor: Colors.blueGrey[700],
      ),
      initialRoute: '/home',
      routes: {
        '/home': (BuildContext context) =>
            MainScreen(title: 'Popular movies'),
        '/settings': (BuildContext context) => SettingScreen(),
      },
      onGenerateRoute: (routeSettings) {
        //генерация путей второго порядка
        var path = routeSettings.name?.split('/'); //разделитель путей в адресе

        if (path[1] == "home") {
          //если первая часть пути такая
          return MaterialPageRoute(
            // то вернуть виджет отрисованного роута
            builder: (context) => MovieScreen(movie: int.parse(path[2])),
            //и отрисовать внутри класс по полученному id
            settings: routeSettings,
          );
        }
      },
    );
  }
}