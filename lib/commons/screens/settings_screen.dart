import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  String popRadio;
  bool favCheckBox = false;
  bool animCheckBox = false;

  @override
  void initState() {
    super.initState();
    _getPrefs();
  }

  _getPrefs() async {
    var _prefs = await prefs;
    setState(() {
      popRadio = (_prefs.getString("POPULAR_RADIO") ?? "popular");
      favCheckBox = (_prefs.getBool("FAV_CHECKBOX") ?? true);
      animCheckBox = (_prefs.getBool("ANIMATION_CHECKBOX") ?? false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _savePrefs();
  }

  _savePrefs() async {
    var _prefs = await prefs;
    await _prefs.setString("POPULAR_RADIO", popRadio);
    await _prefs.setBool("FAV_CHECKBOX", favCheckBox);
    await _prefs.setBool("ANIMATION_CHECKBOX", animCheckBox);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor:,
        title: Text('Popular Movies', style: TextStyle(color: Theme.of(context).primaryColor),),
        backgroundColor: Theme.of(context).cardColor,
        leading: GestureDetector(
          onTap: () {
            _savePrefs();
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.fromLTRB(70.0, 15.0, 0.0, 5.0),
              child: Text(
                "Настройки данных",
                style: TextStyle(color: Colors.teal[400], fontSize: 16.0),
              )),
          ListTile(
            leading: Icon(Icons.sort),
            title: Text("Режим сортировки"),
            subtitle: Text(popRadio),
            onTap: () =>
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      AlertDialog(
                        title: Text("Режим сортировки"),
                        content: Container(
                          height: 112.0,
                          child: Column(
                            children: [
                              RadioListTile(
                                value: "По популярности",
                                groupValue: popRadio,
                                onChanged: (newValue) {
                                  setState(() => popRadio = newValue.toString());
                                  Navigator.pop(context, "Популярное");
                                },
                                title: Text("По популярности"),),
                              RadioListTile(
                                value: "По рейтингу",
                                groupValue: popRadio,
                                onChanged: (newValue) {
                                  setState(() => popRadio = newValue.toString());
                                  Navigator.pop(context, "Рейтинг");
                                },
                                title: Text("По рейтингу"),),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context, "Отмена"),
                              child: Text("Отмена"))
                        ],
                      ),
                ),
          ),
          CheckboxListTile(
            title: const Text("Любимые фильмы"),
            subtitle: favCheckBox == false
                ? Text("Данные будут загружаться из Сети.")
                : Text("Данные будут загружаться из локальной базы данных."),
            secondary: Icon(Icons.view_list, color: Colors.deepPurple,),
            onChanged: (bool value) {
              setState(() => favCheckBox = value);
            },
            value: favCheckBox,
          ),
          Divider(
            thickness: 2.0,
            height: 2.0,
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.fromLTRB(70.0, 15.0, 0.0, 15.0),
              child: Text(
                "Настройки интерфейса",
                style: TextStyle(color: Colors.teal[400], fontSize: 16.0),
              )),
          CheckboxListTile(

            title: const Text("Управление Transition эффектами"),
            subtitle: animCheckBox == false
                ? Text(
                "Transition эффекты отключены.\n(Чуть меньше требования к\nресурсам)")
                : Text(
                "Transition эффекты включены.\n(Иногда может подтормаживать)"),
            isThreeLine: true,
            secondary: Icon(Icons.wb_sunny, color: Colors.deepOrange,),
            onChanged: (bool value) {
              setState(() => animCheckBox = value);
            },
            value: animCheckBox,
          ),
        ],
      ),
    );
  }
}
