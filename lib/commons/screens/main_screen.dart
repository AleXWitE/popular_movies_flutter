import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:popular_films/commons/api/services/modal_services.dart';
import 'package:popular_films/commons/data_models/data_models.dart';
import 'package:popular_films/commons/screens/widgets/movie_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  GlobalKey<RefreshIndicatorState> refreshKey;
  String popRadio = "popular";
  bool favCheckbox;
  bool animCheckbox;
  String _imgUrl = 'https://image.tmdb.org/t/p/w200';
  ScrollController _scrollController;

  int page = 1;

  Future<List<MovieItem>> movieItems;
  List<PopularMovieImgs> _movPosters = [];

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<Null> refreshList() async {
    //функция обновления списка
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {});
    setState(() {});
    return null;
  }

  _getPrefs() async {
    var prefs = await _prefs;
    setState(() {
      popRadio = (prefs.getString("POPULAR_RADIO") ?? "popular");
      favCheckbox = (prefs.getBool("FAV_CHECKBOX") ?? false);
      animCheckbox = (prefs.getBool("ANIMATION_CHECKBOX") ?? false);
    });
  }

  _savePrefs() async {
    var prefs = await _prefs;
    await prefs.setString("POPULAR_RADIO", popRadio);
    await prefs.setBool("FAV_CHECKBOX", favCheckbox);
    await prefs.setBool("ANIMATION_CHECKBOX", animCheckbox);
  }

  _getMovies(int _page) {
    if (popRadio == "popular")
      movieItems = getPopular(_page);
    else
      movieItems = getTopRated(_page);
    return movieItems;
  }

  @override
  void initState() {
    super.initState();
    _getPrefs();
    _getMovies(page);
    _scrollController = ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true,);
    _addImgs(movieItems);
    WidgetsBinding.instance.addObserver(this);
  }

  _addImgs(Future<List> _list) async {
    for (var item in _list as List<MovieItem>)
      _movPosters.add(PopularMovieImgs(
        cachedImg: CachedNetworkImage(
          imageUrl: "$_imgUrl${item.imgUrl}",
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        id: item.movId,
        title: item.name,
      ));
    return _movPosters;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _savePrefs();
      print('paused');
    }
    if (state == AppLifecycleState.resumed) {
      print('resumed');
      _getPrefs();
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Theme.of(context).cardColor,
        actions: [
          PopupMenuButton(
            initialValue: popRadio,
            color: Theme.of(context).primaryColor,
            itemBuilder: (context) => [
              PopupMenuItem(
                child: RadioListTile(
                  value: "popular",
                  groupValue: popRadio,
                  onChanged: (newValue) {
                    setState(() {
                      popRadio = newValue;
                      movieItems = null;
                      _movPosters.clear();
                      _getMovies(page);
                    });
                    Navigator.pop(context);
                  },
                  title: Text("По популярности"),
                ),
              ),
              PopupMenuItem(
                child: RadioListTile(
                  value: "rate",
                  groupValue: popRadio,
                  onChanged: (newValue) {
                    setState(() {
                      popRadio = newValue;
                      movieItems = null;
                      _movPosters.clear();
                      _getMovies(page);
                    });
                    Navigator.pop(context);
                  },
                  title: Text("По рейтингу"),
                ),
              )
            ],
            child: Icon(
              Icons.sort,
              size: 30.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/settings')
                .then((value) => setState(() {
                      _getPrefs();
                      movieItems = null;
                      _movPosters.clear();
                      _getMovies(page);
                    })),
            child: Icon(
              Icons.settings,
              size: 30.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<MovieItem>>(
          future: movieItems,
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              for (var item in snapshot.data)
                _movPosters.add(PopularMovieImgs(
                  cachedImg: CachedNetworkImage(
                    imageUrl: "$_imgUrl${item.imgUrl}",
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  id: item.movId,
                  title: item.name,
                ));
              return GridView.builder(
                padding: EdgeInsets.all(5.0),
                itemCount: snapshot.data.length,
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.6,
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                itemBuilder: (context, index) {

                  return MovieGridItem(_movPosters[index]);
                },
              );
            } else
              return Text("*- ничего нет");
          }),
    );
  }
}
