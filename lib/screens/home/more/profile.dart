import 'package:flutter/material.dart';

///Future <SharedPreferences> _prefs = SharedPreferences.getInstance();

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton( icon: Icon(Icons.arrow_back, color: Theme.of(context).textTheme.bodyText2!.color), onPressed: () {Navigator.pop(context, false);}),),
      body: Stack( children:[ColoredBox(
        color: (Theme.of(context).textTheme.bodyText2!.color)!,
        child: Center(

        ),
      )]),
    );
    //body:
  }
}

//Widget

//String key12312 = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=${getKey()}&sessiontoken=1234567890";