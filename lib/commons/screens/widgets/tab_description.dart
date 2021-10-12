import 'package:flutter/material.dart';

// TODO для полного описания мне нужно получать айди фильма и в адрес для рест его подставлять сюда "https://api.themoviedb.org/3/movie/$id?api_key="
// TODO для картинок и постеров фильма мне нужно получать айди фильма и в адрес для рест его подставлять сюда "https://api.themoviedb.org/3/movie/$id/images?api_key="
class TabDescription extends StatelessWidget {
  int id;
  TabDescription({this.id});

  String movDesc = "Blhbljdafbvadslbhnlubou gdsfaongfof goui goufdgounagf auygongf dosaygoung ufdsgfdsyg uof auo ud sdfsa uighdsuigf ouygf oasgf ouyg jhb";

  @override
  Widget build(BuildContext context) {
    _row() {
      return Row(
        children: [

        ],
      );
    }

    return Column(
      children: [
        _row(),
        Divider(
          thickness: 2.0,
          height: 2.0,
          indent: 5.0,
          endIndent: 5.0,
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          child: Text(movDesc, style: TextStyle(color: Theme.of(context).backgroundColor, fontSize: 18.0),),
        ),

      ],
    );
  }
}
