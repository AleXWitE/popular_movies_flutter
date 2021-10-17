import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:money2/money2.dart';
import 'package:popular_films/commons/data_models/movie_details.dart';
import 'package:url_launcher/url_launcher.dart';


class TabDescription extends StatelessWidget {
  int id;
  MovieDetails details;

  TabDescription({this.id, this.details});

  var totalBud;
  var totalRev;

  Widget _starRow;

  String emptyInfo = "Нет информации";
  String shortEmptyInfo = "Нет инф...";

  _launchUrl() async {
    final _url = details.movHomepage;
    await launch(_url);
  }

  @override
  Widget build(BuildContext context) {
    final usd = Currency.create(
      'USD',
      2,
      symbol: '\$',
      invertSeparators: false,
      pattern: 'S#,##0.00',
    );

    String movDesc = details.movOverview != null ? details.movOverview : emptyInfo;
    String movTitle = details.movOrigTitle != null ? details.movOrigTitle : emptyInfo;
    String movRelease = details.movRelease != null ? details.movRelease : emptyInfo;
    var movBudget = details.movBudget != 0.0 ? Money.fromInt(details.movBudget, usd).toString() : emptyInfo;
    var movRevenue = details.movRevenue != 0.0 ? Money.fromInt(details.movRevenue, usd).toString() : emptyInfo;
    String movLink = details.movHomepage != null ? details.movHomepage : emptyInfo;
    var movVote = details.movVote != 0.0 ? details.movVote : 0.1;
    String movLang = details.movLanguage != '' ? details.movLanguage : shortEmptyInfo;
    var movRuntime = details.movRuntime != 0 ? details.movRuntime : shortEmptyInfo;


    _setDateInfo(String _date) {
      var date = Jiffy(movRelease, "yyyy-mm-dd").format("dd.mm.yyyy");
      return date;
    }

    Icon _star = Icon(Icons.star, size: 15.0, color: Colors.yellow[700]);
    Icon _starHalf = Icon(Icons.star_half, size: 15.0, color: Colors.yellow[700]);
    Icon _starBorder = Icon(Icons.star_border, size: 15.0, color: Colors.yellow[700]);

    if (movVote < 1.5)
      _starRow = Row(
        children: [
          _starBorder, _starBorder, _starBorder, _starBorder, _starBorder,
        ],
      );
    else if (movVote >= 1.5 && movVote < 2.5)
      _starRow = Row(
        children: [
          _starHalf, _starBorder, _starBorder, _starBorder, _starBorder,
        ],
      );
    else if (movVote >= 2.5 && movVote < 3.5)
      _starRow = Row(
        children: [
          _star, _starBorder, _starBorder, _starBorder, _starBorder,
        ],
      );
    else if (movVote >= 3.5 && movVote < 4.5)
      _starRow = Row(
        children: [
          _star, _starHalf, _starBorder, _starBorder, _starBorder,
        ],
      );
    else if (movVote >= 4.5 && movVote < 5)
      _starRow = Row(
        children: [
          _star, _star, _starBorder, _starBorder, _starBorder,
        ],
      );
    else if (movVote >= 5 && movVote < 5.5)
      _starRow = Row(
        children: [
          _star, _star, _starHalf, _starBorder, _starBorder,
        ],
      );
    else if (movVote >= 5.5 && movVote < 6.5)
      _starRow = Row(
        children: [
          _star, _star, _star, _starBorder, _starBorder,
        ],
      );
    else if (movVote >= 6.5 && movVote < 7.5)
      _starRow = Row(
        children: [
          _star, _star, _star, _starHalf, _starBorder,
        ],
      );
    else if (movVote >= 7.5 && movVote < 8.5)
      _starRow = Row(
        children: [
          _star, _star, _star, _star, _starBorder,
        ],
      );
    else if (movVote >= 8.5 && movVote < 9)
      _starRow = Row(
        children: [
          _star, _star, _star, _star, _starHalf,
        ],
      );
    else if (movVote >= 9)
      _starRow = Row(
        children: [
          _star, _star, _star, _star, _star,
        ],
      );

    String formatTimeH(int _hour) {
      return _hour.toString();
    }

    String formatTimeM(int _minute) {
      return _minute < 10 ? "0" + _minute.toString() : _minute.toString();
    }

    String _formatTime(var _minute) {
      if (_minute is int){
        int hour = _minute ~/ 60;
        int minute = _minute % 60;
        return formatTimeH(hour) + "h " + formatTimeM(minute) + "m";
      }
      else
        return shortEmptyInfo;
    }

    _row() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 10.0),
                  child: Image.asset(
                    "lib/img/tmdb.png",
                    width: 35.0,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$movVote/10",
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(
                    Icons.language,
                    color: Colors.blue[700],
                    size: 35.0,
                  ),
                ),
                Text(
                  "Язык\n$movLang",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                )
              ],
            ),
          ),
          Container(
              child: Row(children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(
                Icons.av_timer,
                color: Colors.deepOrange[500],
                size: 35.0,
              ),
            ),
            Text(
              "Время\n${_formatTime(movRuntime)}",
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
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
        SizedBox(height: 20.0,),
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
                  _spanText(_setDateInfo(movRelease)),
                  _spanHeader("Бюджет: "),
                  _spanText(movBudget),
                  _spanHeader("Доход: "),
                  _spanText(movRevenue),
                  _spanHeader("Страница: "),
                  TextSpan(
                    text: movLink,
                    style: TextStyle(
                      decoration:movLink == emptyInfo ? TextDecoration.none : TextDecoration.underline,
                      color: movLink == emptyInfo ? Colors.grey[700] : Colors.teal[400],
                      fontWeight: FontWeight.normal,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _launchUrl(),
                  ),
                ]),
          ),
        ),
      ],
    );
  }
}
