import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srve/services/themes.dart';
import 'package:srve/services/url_launcher.dart';

class More extends StatefulWidget {
  const More({Key? key}) : super(key: key);

  @override
  _More createState() => _More();
}

class _More extends State<More> {

  List<bool> isSelected = [true, false];
  List<bool> isSelected2 = [true, false, false];

  Widget ItemSetup(IconData icon, String text, GestureTapCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1),
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap
    );
  }

  Widget ItemSetupButton(IconData icon, String text, Widget button) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1),
        leading: Icon(icon),
        title: Text(text),
        trailing: button
    );
  }


  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    return Scaffold(
        appBar: AppBar(title: const Text("SRVE")),

        //todo Change divider colours

        body: ListView(
                    children: [
                      const Divider(color: Colors.transparent),
                      ItemSetup(Icons.account_circle,"Profile",(){Navigator.pushNamed(context, 'Home/Profile');}),
                      Divider(indent: MediaQuery.of(context).size.width*0.05, endIndent: MediaQuery.of(context).size.width*0.05),
                      ItemSetup(Icons.history,"Order History",(){}),
                      Divider(indent: MediaQuery.of(context).size.width*0.05, endIndent: MediaQuery.of(context).size.width*0.05),
                      ItemSetup(Icons.bug_report,"Report A Bug",(){reportBug();}),
                      Divider(indent: MediaQuery.of(context).size.width*0.05, endIndent: MediaQuery.of(context).size.width*0.05),

                      //todo set units in shared prefs

                      ItemSetupButton(Icons.straighten, "Distance Units", ToggleButtons(
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
                            isSelected: isSelected),),

                      Divider(indent: MediaQuery.of(context).size.width*0.05, endIndent: MediaQuery.of(context).size.width*0.05),

                      //todo set the correct setting on first loading of app

                      ItemSetupButton(Icons.palette, "Theme", ToggleButtons(
                            children: [Column(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.autorenew),Text("System")]),Column(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.wb_sunny),Text("Day")]),Column(mainAxisAlignment: MainAxisAlignment.center, children: const [Icon(Icons.nightlight_round),Text("Night")])],
                            onPressed: (int index) {
                              setState(() {
                                for (int buttonIndex = 0; buttonIndex <
                                    isSelected2.length; buttonIndex++) {
                                  if (buttonIndex == index) {
                                    isSelected2[buttonIndex] = true;
                                  } else {
                                    isSelected2[buttonIndex] = false;
                                  }
                                }
                                if (isSelected2[1] == true) {themeNotifier.setLightTheme();}
                                else if (isSelected2[2] == true) {themeNotifier.setDarkTheme();}
                                else {themeNotifier.setSystemTheme();}

                              });
                            },
                            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width / 7.5, minHeight: 50), /// Sets minimum dimensions for the buttons, dynamically scales based on device size
                            isSelected: isSelected2))],
                  )
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