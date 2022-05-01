import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:srve/services/venue_storage.dar.dart';

import '../../locator.dart';

//todo implement no location error message

Future <SharedPreferences> _prefs = SharedPreferences.getInstance();

class MapScreen extends StatefulWidget {
  Function callback;
  MapScreen(this.callback);

  @override
  _MapScreen createState() => _MapScreen();
}

class _MapScreen extends State<MapScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  final venues = FirebaseFirestore.instance.collection('venues');
  var radius = BehaviorSubject.seeded(100.0);
  late StreamSubscription subscription;

  bool markersUpdated = false;
  bool isMapCreated = false;

  late GoogleMapController mapController;
  Set<Marker> markers = {};

  _animateToUser() async {
    var status = await Permission.locationWhenInUse.request();
    if (status.isDenied){
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          const CameraPosition(
            target: LatLng(0, 0),
            zoom: 10.0,
          )
      )
      );
    }
    else {
      var pos = await Geolocator.getCurrentPosition();
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(pos.latitude, pos.longitude),
            zoom: 15.0,
          )
      )
      );
    }
  }

  addMarker(id,name,location,info) async{
    var marker = Marker(
        markerId: MarkerId(name),
        position: location,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: '$name (10km)',snippet: info),//todo add distance
        onTap: () {
          final snackBar = SnackBar(
            content: Text(name),
            margin: const EdgeInsets.symmetric(horizontal: 75, vertical: 20),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Confirm',
              onPressed: () {
                locator<SelectedVenue>().setVenue(id);
                locator<SelectedVenue>().setTable(null);
                widget.callback(1);
                // Some code to undo the change.
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
    );
    markers.add(marker);

  }

  _findMarkers() async {
    // Get users location
    var pos = await Geolocator.getCurrentPosition();

    // Make a reference to firestore
    var ref = firestore.collection('venues');
    GeoFirePoint center = geo.point(latitude: pos.latitude, longitude: pos.longitude);

    // subscribe to query
    subscription = radius.switchMap((rad) {
      return geo.collection(collectionRef: ref).within(
          center: center,
          radius: rad,
          field: 'position',
          strictMode: true
      );
    }).listen((List<DocumentSnapshot> documentList) {
      for (var element in documentList) {
        print(element.id);
        addMarker(element.id, element['name'],LatLng(element['position']['geopoint'].latitude,element['position']['geopoint'].longitude),element['info']);}
      if (markersUpdated == false) {setState((){markersUpdated = true;});}
    });

  }

  changeMapMode() {
    getDarkMode().then((value) {
      if (value == false) {getJsonFile("assets/mapStyles/day.json").then(setMapStyle);}
      else if (value == true) {getJsonFile("assets/mapStyles/night.json").then(setMapStyle);}
      else {
        var theme = MediaQuery
            .of(context)
            .platformBrightness;
        if (theme == Brightness.dark) {
          getJsonFile("assets/mapStyles/night.json").then(setMapStyle);
        }
        else {
          getJsonFile("assets/mapStyles/day.json").then(setMapStyle);
        }
      }
    });
  }

  getDarkMode() async {return await _prefs.then((SharedPreferences prefs) {return prefs.getBool('Theme');});}


  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    mapController.setMapStyle(mapStyle);
  }

  _Map() {
    var _initialCameraPosition = const CameraPosition(
      target: LatLng(0.0, 0.0),
      zoom: 5.0,
    );

    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;
      isMapCreated = true;
      changeMapMode();
      _animateToUser();
    }

    if (isMapCreated) {
      changeMapMode();
      _animateToUser();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:
      Container(
        alignment: Alignment.center,
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          initialCameraPosition: _initialCameraPosition,
          markers: markers,
        ),
      ),
    );
  }

  @override
  dispose() {
    markers.clear();
    subscription.cancel();
    markersUpdated = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _findMarkers();
    return Scaffold(
      appBar: AppBar(),
      //leading: IconButton( icon: Icon(Icons.arrow_back, /*color: Theme.of(context).textTheme.bodyText2.color*/), onPressed: () {Navigator.pop(context, false);})),
      body: Stack(children: [ColoredBox(
        color: Colors.blue,
        //todo Theme.of(context).textTheme.bodyText2!.color!,
        child: Center(
            child: _Map()
        ),
      )
      ]),
    );    //body:
  }
}

//Widget

//String key12312 = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=${getKey()}&sessiontoken=1234567890";