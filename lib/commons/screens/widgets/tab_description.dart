import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// TODO для полного описания мне нужно получать айди фильма и в адрес для рест его подставлять сюда "https://api.themoviedb.org/3/movie/$id?api_key="
// TODO для картинок и постеров фильма мне нужно получать айди фильма и в адрес для рест его подставлять сюда "https://api.themoviedb.org/3/movie/$id/images?api_key="
class TabDescription extends StatelessWidget {
  int id;

  TabDescription({this.id});

  String movDesc =
      "Blhbljdafbvadslbhnlubou gdsfaongfof goui goufdgounagf auygongf dosaygoung ufdsgfdsyg uof auo ud sdfsa uighdsuigf ouygf oasgf ouyg jhb";
  String movTitle = "Movie title";
  String movRelease = "11.08.2021";
  String movBudget = "\$110,000,000.00";
  String movRevenue = "\$324,000,000.00";
  String movLink = "\$324,000,000.00";

  @override
  Widget build(BuildContext context) {
    _row() {
      return Row(
        children: [
          SizedBox(height: 30.0,)
        ],
      );
    }

    _spanHeader(String str) {
      return TextSpan(
        text: str,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      );
    }

    _spanText(String str) {
      return TextSpan(
        text: "$str\n\n",
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.grey[600],
        ),
      );
    }

    return Column(
      children: [
        _row(),
        Divider(
          thickness: 1.0,
          height: 1.0,
          indent: 10.0,
          endIndent: 10.0,
        ),
        Container(
          padding: EdgeInsets.all(15.0),
          child: Text(
            movDesc,
            style: TextStyle(
                color: Theme.of(context).backgroundColor, fontSize: 14.0),
          ),
        ),
        Container(width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: RichText(
            text: TextSpan(
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                    fontSize: 14.0),
                text: "Оригинальный заголовок: ",
                children: [
                  _spanText(movTitle),
                  _spanHeader("Дата релиза: "),
                  _spanText(movRelease),
                  _spanHeader("Бюджет: "),
                  _spanText(movBudget),
                  _spanHeader("Доход: "),
                  _spanText(movRevenue),
                  _spanHeader("Страница: "),
                  TextSpan(
                    text: movLink,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.teal[400],
                      fontWeight: FontWeight.normal,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => print('tap'),
                  ),
                ]),
          ),
        ),
      ],
    );
  }
}
