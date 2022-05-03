import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:srve/components/options_alert.dart';
import 'package:srve/services/cart.dart';
import 'package:srve/services/venue_storage.dar.dart';
import '../../../locator.dart';
import '../../../services/cart.dart';

class Submenu extends StatefulWidget {
  const Submenu({Key? key}) : super(key: key);

  @override
  _Submenu createState() => _Submenu();
}

class _Submenu extends State<Submenu> {

  //FirebaseFirestore firestore = FirebaseFirestore.instance;

  List Products = [];

  getArgs<DocumentReference>() {
    List? args = ModalRoute
        .of(context)!
        .settings
        .arguments as List?;
    return args;
    /*setState(() {
      for(var i = 0; i < prods!.length; i++) {
        Products.add(prods[i]);
      }
    });*/
  }

  Widget ItemSetup(String text, double price, options) {
    return Card(
      child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: MediaQuery
              .of(context)
              .size
              .width * 0.1),
          trailing: Text('£${price.toStringAsFixed(2)}'), //todo add options
          title: Text(text),
          onTap: () {

            if (options != null) {
              DialogMenu(context, text, options);

            }
            else {
              locator<CartDB>().addToCart(text, price, null);
              print('sort adding to cart properly');
            }
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('venues').doc(
          locator<SelectedVenue>().getVenue()).collection(getArgs()![0])
          .doc(getArgs()![1])
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text("Something went wrong")); //todo Use theme colour
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Center(child: Text("Data does not exist"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<
              String,
              dynamic>;
          data.values.forEach((element) {
            Products.add(element);
          });
          return Scaffold(
              appBar: AppBar(
                  title: Text(getArgs()[1].replaceAll(RegExp('_'), ' ')),
                  actions: [IconButton(icon: const Icon(Icons.shopping_cart), onPressed: (){Navigator.pushNamed(context, 'Home/Cart');})]
              ),
              body:
              ListView.builder(
                  itemCount: Products.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ItemSetup(
                        Products[index]['name'].replaceAll(RegExp('_'), ' '),
                        Products[index]['price'].toDouble(),
                        Products[index]['options']);
                  }
              )
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}