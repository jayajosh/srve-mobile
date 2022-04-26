import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:srve/services/cart.dart';

replace(String s){
  s = s.replaceAll(RegExp('[0-9]'),'');
  s = s.replaceAll(RegExp('_'), ' ');
  return s;
}

DialogMenu(context, name, options) {
  List<Widget> alertList = List<Widget>.generate(options.length, (int index) => TextButton(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Row(
          children: [
            Expanded(child: Text(replace(options.keys.elementAt(index)))),
            Text(options.values.elementAt(index).toStringAsFixed(2))
          ],
        ),
      ),
      onPressed: () {
        //todo deal with null price values
        //todo ordering of list
        CartDB().addToCart(name,options.values.elementAt(index).toDouble(),replace(options.keys.elementAt(index))); //todo push as order
        Navigator.of(context).pop();
      }));

  alertList.add(TextButton(
      child: Text('Cancel'),
      onPressed: () {
        Navigator.of(context).pop();
      }));

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      bool isValid = false;

      if (Platform.isAndroid) {
        return AlertDialog(
          title: Text('Options'),
          content: Text('Content'),
          actions: <Widget>[
            TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            ),
            TextButton(
                child: Text('Confirm'),
                onPressed: () {print('yay');}
              //Navigator.of(context).pop();
            )
          ],
        );
      }

      else{
        return CupertinoActionSheet(
          title: Text('Options'),
          //content: Text('Content'),
          actions: alertList);
      }
    },
  );
}

/*
qrDialog(context,routename,qr){
  Key globalKey = new GlobalKey();
  TextEditingController _textFieldController = TextEditingController();
  final _title = routename;

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {

      if (Platform.isAndroid) {
        return AlertDialog(
          //title: Text(_title),
          content: RepaintBoundary(
              key: globalKey,
              child: Container(child:Column(children: [Text(_title),qr], mainAxisSize: MainAxisSize.min),color: Colors.white)
          ),
          actions: <Widget>[
            TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            ),
            TextButton(
                child: Text('Save'),
                onPressed: () async {qrSave(globalKey,routename);}
            )
          ],
        );
      }

      else{
        return CupertinoAlertDialog(
          //title: Text(_title),
          content: RepaintBoundary(
              key: globalKey,
              child: Container(child:Column(children: [Text(_title),qr], mainAxisSize: MainAxisSize.min),color: Colors.white)
          ),
          actions: <Widget>[
            TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            ),
            TextButton(
                child: Text('Save'),
                onPressed: () async {qrSave(globalKey,routename);}
            )
          ],
        );
      }
    },
  );
}


qrSave(gk,routename) async {

  RenderRepaintBoundary boundary = gk.currentContext.findRenderObject();
  var image = await boundary.toImage();
  ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
  Uint8List pngBytes = byteData.buffer.asUint8List();

  final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(pngBytes),
      name: routename);
  print(result);
}
*/

snackMessage(context,msg){
  FocusScope.of(context).unfocus();
  final snack = SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating );
  ScaffoldMessenger.of(context).showSnackBar(snack);
}