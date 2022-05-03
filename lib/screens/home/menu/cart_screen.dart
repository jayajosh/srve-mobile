import 'package:flutter/material.dart';
import 'package:srve/components/venue_storage_alert.dart';
import 'package:srve/services/cart.dart';
import 'package:srve/services/order_history.dart';
import 'package:srve/services/venue_storage.dar.dart';

import '../../../locator.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreen createState() => _CartScreen();
}

class _CartScreen extends State<CartScreen> {

  //FirebaseFirestore firestore = FirebaseFirestore.instance;
  //final orderId = Uuid().v1();
  final orderId = DateTime.now().toString(); //todo fix orderID
  bool editMode = false;

  changeEditMode(){
    setState((){editMode = !editMode;});

  }

  getArgs<DocumentReference>() {
    List? args = ModalRoute.of(context)!.settings.arguments as List?;
    return args;
    /*setState(() {
      for(var i = 0; i < prods!.length; i++) {
        Products.add(prods[i]);
      }
    });*/
  }

  setSubtitle(options){
    if(options != 'null') {return Text(options);}  //todo null the proper way
  }

  Widget ItemSetup(String text, String price, String? options, id) {

    Widget trail = Text('£$price');
    if (editMode == true){trail = IconButton(icon: const Icon(Icons.delete), onPressed: (){setState((){CartDB().removeFromCart(id);});});} //todo make a button
    return Card(
      child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1),
          trailing: trail,
          title: Text(text),
          subtitle: setSubtitle(options)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (locator<SelectedVenue>().getVenue() == null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        await showDialog<String>(
            context: context,
            builder: (BuildContext context) => noVenue(context)
        );
      });
    }

    if (locator<SelectedVenue>().getTable() == null) {
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        await showDialog<String>(
            context: context,
            builder: (BuildContext context) => noTable(context)
        );
      });
    }
    // CollectionReference venue = FirebaseFirestore.instance.collection('venues');

    addToHistory(DateTime date, List products){
      locator<OrderHistoryDB>().addOrder(orderId, date, locator<SelectedVenue>().getVenue()!, locator<SelectedVenue>().getTable()!, products);
    }

    return FutureBuilder(
      future: locator<CartDB>().readFromCart(),
      builder:
          (BuildContext context, AsyncSnapshot snapshot) {

        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong")); //todo Use theme colour
        }

        if (snapshot.hasData) {

          List Products = snapshot.data;
          double totalPrice = 0;
          Products.forEach((element) {totalPrice += element['price'];});
          //double totalPrice = data;
          return Scaffold(
              appBar: AppBar(title: const Text('Cart'),actions: [IconButton(icon: const Icon(Icons.edit), onPressed: (){changeEditMode();})]),
              body:
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: Products.length,
                        itemBuilder: (BuildContext context, int index) {
                          //print(Products);
                          return ItemSetup(Products[index]['product'].replaceAll(RegExp('_'), ' '),Products[index]['price'].toStringAsFixed(2),Products[index]['options'].toString().replaceAll(RegExp('_'), ' '),Products[index]['cartPos']); //todo change cart pos to id
                        }
                    ),
                  ),
                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width*0.1,
                      0,
                      MediaQuery.of(context).size.width*0.1,
                      MediaQuery.of(context).size.height*0.05,),
                    trailing: OutlinedButton(child: Text('Checkout'),onPressed: (){addToHistory(DateTime.now(), Products);}), //todo if prod length 0 disable //todo add checkout options that lead into add history
                    // todo when on edit become add instructions button
                    title: Text('Total Price: £${totalPrice.toStringAsFixed(2)}'),)
                ],
              )
          );

        }

        return Center(child:Text("loading"));
      },
    );
  }
}