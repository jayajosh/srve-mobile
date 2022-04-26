import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srve/services/themes.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _Menu createState() => _Menu();
}

class _Menu extends State<Menu> {

  //FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);

    CollectionReference venues = FirebaseFirestore.instance.collection('venues');
    CollectionReference venuesd = FirebaseFirestore.instance.collection('venues').doc('uqgGPJ4RBUXtOHgKkmYg').collection('drinks');

    return FutureBuilder<DocumentSnapshot>(
      future: venues.doc('uqgGPJ4RBUXtOHgKkmYg').get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Center(child: Text("Something went wrong")); //todo Use theme colour
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Center(child: Text("Venue does not exist"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
              appBar: AppBar(title: Text("${data['name']}"),actions: [IconButton(icon: const Icon(Icons.shopping_cart), onPressed: (){Navigator.pushNamed(context, 'Home/Cart');})]),
              body: Column(children: [
                const Divider(color: Colors.transparent),
                ItemSetup(Icons.lunch_dining, "Food", (){Navigator.pushNamed(context, 'Home/Food', arguments: data['FoodTypes']);}),
                Divider(indent: MediaQuery.of(context).size.width*0.05, endIndent: MediaQuery.of(context).size.width*0.05),
                ItemSetup(Icons.local_bar, "Drinks", (){Navigator.pushNamed(context, 'Home/Drinks', arguments: data['DrinkTypes']);})
              ])
            );

        }

        return Center(child:CircularProgressIndicator());
          },
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