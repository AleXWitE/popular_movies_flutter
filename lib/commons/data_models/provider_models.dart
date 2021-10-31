import 'package:flutter/material.dart';

class ProviderModel extends ChangeNotifier{
  bool favourite = false;
  String popular = "popular";
  bool animation = false;

  void changeFav(bool _input){
    favourite = _input;
    notifyListeners();
  }

  void changePopular(String _input){
    popular = _input;
    notifyListeners();
  }

  void changeAnimation(bool _input){
    animation = _input;
    notifyListeners();
  }
}
