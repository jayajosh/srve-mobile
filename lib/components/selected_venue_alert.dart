import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:srve/services/venue_storage.dar.dart';

import '../locator.dart';

noVenue(context) {
  if (Platform.isAndroid) {
    return Center(
      child: AlertDialog(
          title: const Text('No Venue Selected'),
          content: const Text('Please select a venue from the map page.'),
          actions: <Widget>[
            TextButton(
                child: const Text('Okay'),
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
          title: const Text('No Venue Selected'),
          content: const Text('Please select a venue from the map page.'),
          actions: <Widget>[
            TextButton(
                child: const Text('Okay'),
                onPressed: () {Navigator.pop(context);}
              //Navigator.of(context).pop();
            )
          ]
      ),
    );
  }
}


noTable(context) {

  TextEditingController _textFieldController = TextEditingController();

  if (Platform.isAndroid) {
    return Center(
      child: AlertDialog(
          title: const Text('Please enter your table:'),
          content: TextField(
            onChanged: (value) { },
            controller: _textFieldController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('Confirm'),
                onPressed: () {locator<SelectedVenue>().setTable(int.parse(_textFieldController.text));}
              //Navigator.of(context).pop();
            )
          ]
      ),
    );
  }

  else{
    return Center(
      child: CupertinoAlertDialog(
          title: const Text('No Table Selected'),
          content: CupertinoTextField(
            onChanged: (value) {},
            controller: _textFieldController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('Confirm'),
                onPressed: () {locator<SelectedVenue>().setTable(int.parse(_textFieldController.text));}//todo snack bar table set
              //Navigator.of(context).pop();
            )
          ]
      ),
    );
  }
}