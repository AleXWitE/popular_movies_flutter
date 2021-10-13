import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:money2/money2.dart';
import 'package:popular_films/commons/data_models/movie_details.dart';

// TODO для полного описания мне нужно получать айди фильма и в адрес для рест его подставлять сюда "https://api.themoviedb.org/3/movie/$id?api_key="
// TODO для картинок и постеров фильма мне нужно получать айди фильма и в адрес для рест его подставлять сюда "https://api.themoviedb.org/3/movie/$id/images?api_key="

class TabDescription extends StatelessWidget {
  int id;
  MovieDetails details;

  TabDescription({this.id, this.details});


  var totalBud;
  var totalRev;

  Widget _starRow;

  @override
  Widget build(BuildContext context) {
    String movDesc = details.movOverview;
    String movTitle = details.movOrigTitle;
    String movRelease = details.movRelease;
    int movBudget = details.movBudget;
    int movRevenue = details.movRevenue;
    String movLink = details.movHomepage;
    double movVote = details.movVote;
    String movLang = details.movLanguage;
    int movRuntime = details.movRuntime;

    final usd = Currency.create(
      'USD',
      2,
      symbol: '\$',
      invertSeparators: true,
      pattern: '#,##0.00 S',
    );

    // totalBud = Money.fromInt(movBudget, usd);
    // totalRev = Money.fromInt(movRevenue, usd);

    _setDateDesc(String _date) async {
      await Jiffy.locale("ru");

      var date = Jiffy(movRelease, "yyyy-mm-dd").format("MMMM, yyyy").toString();
      return date;
    }

    if (movVote < 1.5)
      _starRow = Row(
        children: [
          Icon(
            Icons.star_border,
            size: 10.0,
          ),
          Icon(Icons.star_border, size: 10.0), Icon(Icons.star_border, size: 10.0),
          Icon(Icons.star_border, size: 10.0), Icon(Icons.star_border, size: 10.0)
        ],
      );
    else if (movVote > 1.5 && movVote < 2.5)
      _starRow = Row(
        children: [
          Icon(Icons.star_half, size: 10.0), Icon(Icons.star_border, size: 10.0),
          Icon(Icons.star_border, size: 10.0), Icon(Icons.star_border, size: 10.0),
          Icon(Icons.star_border, size: 10.0)
        ],
      );
    else if (movVote > 2.5 && movVote < 3.5)
      _starRow = Row(
        children: [
          Icon(Icons.star, size: 10.0), Icon(Icons.star_border, size: 10.0),
          Icon(Icons.star_border, size: 10.0), Icon(Icons.star_border, size: 10.0),
          Icon(Icons.star_border, size: 10.0)
        ],
      );
    else if (movVote > 3.5 && movVote < 4.5)
      _starRow = Row(
        children: [
          Icon(Icons.star, size: 10.0), Icon(Icons.star_half, size: 10.0),
          Icon(Icons.star_border, size: 10.0), Icon(Icons.star_border, size: 10.0),
          Icon(Icons.star_border, size: 10.0)
        ],
      );
    else if (movVote > 4.5 && movVote < 5)
      _starRow = Row(
        children: [
          Icon(Icons.star, size: 10.0), Icon(Icons.star, size: 10.0),
          Icon(Icons.star_border, size: 10.0), Icon(Icons.star_border, size: 10.0),
          Icon(Icons.star_border, size: 10.0)
        ],
      );
    else if (movVote > 5 && movVote < 5.5)
      _starRow = Row(
        children: [
          Icon(Icons.star, size: 10.0), Icon(Icons.star, size: 10.0),
          Icon(Icons.star_half, size: 10.0), Icon(Icons.star_border, size: 10.0),
          Icon(Icons.star_border, size: 10.0)
        ],
      );
    else if (movVote > 5.5 && movVote < 6.5)
      _starRow = Row(
        children: [
          Icon(Icons.star, size: 10.0), Icon(Icons.star, size: 10.0),
          Icon(Icons.star, size: 10.0), Icon(Icons.star_border, size: 10.0),
          Icon(Icons.star_border, size: 10.0)
        ],
      );
    else if (movVote > 6.5 && movVote < 7.5)
      _starRow = Row(
        children: [
          Icon(Icons.star, size: 10.0), Icon(Icons.star, size: 10.0),
          Icon(Icons.star, size: 10.0), Icon(Icons.star_half, size: 10.0),
          Icon(Icons.star_border, size: 10.0)
        ],
      );
    else if (movVote > 7.5 && movVote < 8.5)
      _starRow = Row(
        children: [
          Icon(Icons.star, size: 10.0), Icon(Icons.star, size: 10.0),
          Icon(Icons.star, size: 10.0), Icon(Icons.star, size: 10.0),
          Icon(Icons.star_border, size: 10.0)
        ],
      );
    else if (movVote > 8.5 && movVote < 9)
      _starRow = Row(
        children: [
          Icon(Icons.star, size: 10.0), Icon(Icons.star, size: 10.0),
          Icon(Icons.star, size: 10.0), Icon(Icons.star, size: 10.0),
          Icon(Icons.star_half, size: 10.0)
        ],
      );
    else if (movVote > 9)
      _starRow = Row(
        children: [
          Icon(Icons.star, size: 10.0), Icon(Icons.star, size: 10.0),
          Icon(Icons.star, size: 10.0), Icon(Icons.star, size: 10.0),
          Icon(Icons.star, size: 10.0)
        ],
      );

    String formatTimeH(int _hour) {
      return _hour.toString();
    }

    String formatTimeM(int _minute) {
      return _minute < 10 ? "0" + _minute.toString() : _minute.toString();
    }

    String _formatTime(int _minute) {
      int hour = _minute ~/ 60;
      int minute = _minute % 60;
      return formatTimeH(hour) + "h " + formatTimeM(minute) + "m";
    }

    _row() {
      return Row(
        children: [
          Container(
            child: Row(
              children: [
                Image.asset(
                  "lib/img/tmdb.png",
                  width: 35.0,
                ),
                Column(
                  children: [
                    Text(
                      "$movVote/10",
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                    _starRow,
                  ],
                )
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Icon(
                  Icons.language,
                  color: Colors.blue[700],
                  size: 35.0,
                ),
                Text(
                  "Язык\n$movLang",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                )
              ],
            ),
          ),
          Container(
              child: Row(children: [
            Icon(
              Icons.language,
              color: Colors.blue[700],
              size: 35.0,
            ),
            Text(
              "Время\n${_formatTime(movRuntime)}",
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            )
          ])),
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
        Container(
          width: MediaQuery.of(context).size.width,
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
                  _spanText(details.movBudget.toString()),
                  _spanHeader("Доход: "),
                  _spanText(totalRev.toString()),
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
