import 'package:flutter/material.dart';
import 'package:srve/services/order_history.dart';
import '../../../locator.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreen createState() => _OrderScreen();
}

class _OrderScreen extends State<OrderScreen> {


  getArgs<DocumentReference>() {
    List? args = ModalRoute
        .of(context)!
        .settings
        .arguments as List?;
    return args![0];
    /*setState(() {
      for(var i = 0; i < prods!.length; i++) {
        Products.add(prods[i]);
      }
    });*/
  }

  setSubtitle(options){
    if(options != 'null') {return Text(options);}  //todo null the proper way
  }

  Widget ItemSetup(String text, double price, String? options) {
    return Card(
      child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1),
          trailing: Text('£$price'),//todo fix light mode font
          title: Text(text),
          subtitle: setSubtitle(options)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: locator<OrderHistoryDB>().readDetails(getArgs()),
      builder:
          (BuildContext context, AsyncSnapshot snapshot) {

        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong")); //todo Use theme colour
        }

        if (snapshot.hasData) {

          List Details = snapshot.data;
          //double totalPrice = 0;
          //Orders.forEach((element) {totalPrice += element['price'];});
          //double totalPrice = data;
          return Scaffold(
              appBar: AppBar(title: Text(getArgs().toString())/*,actions: [IconButton(icon: const Icon(Icons.edit), onPressed: (){changeEditMode();})]*/),
              body:
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: Details.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ItemSetup(Details[index]['product'],Details[index]['price'],Details[index]['options']);
                        } //todo Add bottom card like cart has - Total Price, Table Num, Time
                    ),
                  ),
                ],
              )
          );

        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}