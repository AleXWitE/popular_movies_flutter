import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:popular_films/commons/data_models/data_models.dart';
import 'package:popular_films/commons/screens/widgets/movie_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  String popRadio = "По популярности";

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<Null> refreshList() async {
    //функция обновления списка
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      // _coursesList.clear();
    });
    setState(() {
      // getAllEventsState = getAllCourses(userDivision).asStream();
      // _hasData = true;
      // ifNoData(_hasData);
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Widget _gridViewMovie() {
      return CustomScrollView(
        primary: false,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(5.0),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              childAspectRatio: 0.65,
              children: [
                for (var item in movieItems)
                  MovieGridItem(
                    movieItems[item.id - 1],
                  )
              ],
            ),
          ),
        ],
      );
    }

    Widget refreshIndicator() {
      return RefreshIndicator(
          child: _gridViewMovie(), onRefresh: () => refreshList());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme
            .of(context)
            .cardColor,
        actions: [
          PopupMenuButton(
            color: Colors.white,
            itemBuilder: (context) =>
            [
              PopupMenuItem(
                child: RadioListTile(
                  value: "По популярности",
                  groupValue: popRadio,
                  onChanged: (newValue) {
                    setState(() => popRadio = newValue.toString());
                    Navigator.pop(context);
                  },
                  title: Text("По популярности"),),
              ),
              PopupMenuItem(
                child: RadioListTile(
                  value: "По рейтингу",
                  groupValue: popRadio,
                  onChanged: (newValue) {
                    setState(() => popRadio = newValue.toString());
                    Navigator.pop(context);
                  },
                  title: Text("По рейтингу"),),
              )
            ],
            child: Icon(
              Icons.sort,
              size: 30.0,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/settings'),
            child: Icon(
              Icons.settings,
              size: 30.0,
            ),
          ),
        ],
      ),
      // body: refreshIndicator(),
      body: _gridViewMovie(),
    );
  }
}
