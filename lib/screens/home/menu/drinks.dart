import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:srve/services/venue_storage.dar.dart';

import '../../../locator.dart';

class Drinks extends StatefulWidget {
  const Drinks({Key? key}) : super(key: key);

  @override
  _Drinks createState() => _Drinks();
}

class _Drinks extends State<Drinks> {

  //FirebaseFirestore firestore = FirebaseFirestore.instance;

  List DrinkTypes = [];

  getArgs() async {
    List? argsList = ModalRoute.of(context)!.settings.arguments as List?;
    setState(() {
      for(var i = 0; i < argsList!.length; i++) {
        DrinkTypes.add(argsList[i]);
      }
    });
  }

  Widget ItemSetup(String text, GestureTapCallback onTap) {
    return Card(
      child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1),
          trailing: const Icon(Icons.chevron_right),
          title: Text(text),
          onTap: onTap
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getArgs();
  }

  @override
  Widget build(BuildContext context) {

    CollectionReference venue = FirebaseFirestore.instance.collection('venues');

    return FutureBuilder<DocumentSnapshot>(
      future: venue.doc(locator<SelectedVenue>().getVenue()).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Center(child: Text("Something went wrong")); //todo Use theme colour
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Center(child: Text("Venue does not exist"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          // Deprecated Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
              appBar: AppBar(
                  title: Text("Drinks"),
                  actions: [IconButton(icon: const Icon(Icons.shopping_cart), onPressed: (){Navigator.pushNamed(context, 'Home/Cart');})]),
              body:
              ListView.builder(
                  itemCount: DrinkTypes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ItemSetup(DrinkTypes[index].replaceAll(RegExp('_'), ' '),(){Navigator.pushNamed(context, 'Home/Drinks/Submenu', arguments: ['drinks',DrinkTypes[index]]);});
                  }
              )
          );

        }

        return Center(child:CircularProgressIndicator());
          },
    );






    /*return Scaffold(
        appBar: AppBar(title: const Text("Venue Name")),

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
    );*/
    //body:
  }
}