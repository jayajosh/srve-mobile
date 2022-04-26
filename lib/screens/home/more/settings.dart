import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srve/services/themes.dart';

Future <SharedPreferences> _prefs = SharedPreferences.getInstance();

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _Settings createState() => _Settings();
}

class _Settings extends State<Settings> {

  List<bool> isSelected = [true, false];
  List<bool> isSelected2 = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings"),
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Theme.of(context).textTheme.bodyText2!.color), onPressed: () {Navigator.pop(context, false);}),),
      body: Stack( children:[ColoredBox(
        color: (Theme.of(context).textTheme.bodyText2!.color)!,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.15),
          child: Column(children: [
            const Divider(color: Colors.transparent),
            ///odo set text colour as theme\/
            Row(children: [const Expanded(child: Text("Distance Units", style: TextStyle(color: Colors.black),)), ToggleButtons(
                children: const [Text("Miles"),Text("Kilometers")],
                onPressed: (int index) {
                  setState(() {
                    for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                      if (buttonIndex == index) {
                        isSelected[buttonIndex] = true;
                      } else {
                        isSelected[buttonIndex] = false;
                      }
                    }
                  });
                },
                constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width / 5, minHeight: 50), /// Sets minimum dimensions for the buttons, dynamically scales based on device size
                isSelected: isSelected)],),

            const Divider(color: Colors.transparent),

            Row(children: [const Expanded(child: Text("Theme", style: TextStyle(color: Colors.black),)), ToggleButtons(
                children: [Column(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.autorenew),Text("System")]),Column(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.wb_sunny),Text("Day")]),Column(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.nightlight_round),Text("Night")])],
                onPressed: (int index) {
                  setState(() {
                    for (int buttonIndex = 0; buttonIndex < isSelected2.length; buttonIndex++) {
                      if (buttonIndex == index) {
                        isSelected2[buttonIndex] = true;
                      } else {
                        isSelected2[buttonIndex] = false;
                      }
                    }
                  });
                },
                constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width / 7.5, minHeight: 50), /// Sets minimum dimensions for the buttons, dynamically scales based on device size
                isSelected: isSelected2)],),

            ///odo change to togglebutton \/

            Row(children: [const Expanded(child: Text("Theme", style: TextStyle(color: Colors.black))),
              Padding(
                padding: EdgeInsets.only(right: MediaQuery.of(context).size.width / 5),
                child: PopupMenuButton(
                icon: const Icon(Icons.nightlight_round),
                itemBuilder: (context) {return darkModeOptions();},onSelected: (value){
                final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
                if (value == "dark") {themeNotifier.setDarkTheme();}
                else if (value == "light") {themeNotifier.setLightTheme();}
                else {themeNotifier.setSystemTheme();}}),
              )])
          ]

          ),
        ),
      )]),
    );
    //body:
  }
}

//Widget

  darkModeOptions() {
    return [
      PopupMenuItem(value: "system",child: Row(children: const [Padding(padding: EdgeInsets.only(right:10.0), child: Icon(Icons.autorenew)),Text("System")])),
      PopupMenuItem(value: "dark",child: Row(children: const [Padding(padding: EdgeInsets.only(right:10.0), child: Icon(Icons.nightlight_round)),Text("Dark Mode")])),
      PopupMenuItem(value: "light",child: Row(children: const [Padding(padding: EdgeInsets.only(right:10.0), child: Icon(Icons.wb_sunny)),Text("Light Mode")]))
    ];
  }