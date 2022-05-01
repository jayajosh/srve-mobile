import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

noVenue(context) {
  if (Platform.isAndroid) {
    return Center(
      child: AlertDialog(
          title: Text('No Venue Selected'),
          content: Text('Please select a venue from the map page.'),
          actions: <Widget>[
            TextButton(
                child: Text('Okay'),
                onPressed: () {Navigator.pop(context);}
              //Navigator.of(context).pop();
            )
          ]
      ),
    );
  }

  else{
    return Center(
      child: CupertinoAlertDialog(
          title: Text('No Venue Selected'),
          content: Text('Please select a venue from the map page.'),
          actions: <Widget>[
            TextButton(
                child: Text('Okay'),
                onPressed: () {Navigator.pop(context);}
              //Navigator.of(context).pop();
            )
          ]
      ),
    );
  }
}