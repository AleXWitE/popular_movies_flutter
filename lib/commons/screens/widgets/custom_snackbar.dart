import 'package:flutter/material.dart';

customSnackBar(bool fav) {
  String msg;
  if(fav)
    msg = "Фильм был добавлен в коллекцию любимых фильмов";
  else
    msg = "Фильм был удален из коллекции любимых фильмов";

  return SnackBar(
      duration: Duration(seconds: 3),
      elevation: 5.0,
      backgroundColor: Colors.blueGrey[700],
      width: 400.0,
      // Width of the SnackBar.
      padding: const EdgeInsets.all(
        16.0, // Inner padding for SnackBar content.
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Text(
        msg,
        style: TextStyle(
            fontSize: 18.0, color: Colors.white, height: 1.5),
      ));
}
