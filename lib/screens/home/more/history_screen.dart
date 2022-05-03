import 'package:flutter/material.dart';
import 'package:srve/services/order_history.dart';

import '../../../locator.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreen createState() => _HistoryScreen();
}

class _HistoryScreen extends State<HistoryScreen> {

  //FirebaseFirestore firestore = FirebaseFirestore.instance;
  //final orderId = Uuid().v1();
  final orderId = DateTime.now().toString(); //todo fix orderID

  Widget ItemSetup(String orderId, String venue, String date) {

    Widget trail = Icon(Icons.arrow_forward_ios);
    return Card(
      child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1),
          trailing: trail,
          title: Text(venue),
          subtitle: Text(date),
          onTap: () {Navigator.pushNamed(context, 'Home/HistoryScreen/OrderScreen', arguments: [orderId]);},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: locator<OrderHistoryDB>().readOrders(),
      builder:
          (BuildContext context, AsyncSnapshot snapshot) {

        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong")); //todo Use theme colour
        }

        if (snapshot.hasData) {

          List Orders = snapshot.data;
          //double totalPrice = 0;
          //Orders.forEach((element) {totalPrice += element['price'];});
          //double totalPrice = data;
          return Scaffold(
              appBar: AppBar(title: const Text('Order History')/*,actions: [IconButton(icon: const Icon(Icons.edit), onPressed: (){changeEditMode();})]*/),
              body:
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: Orders.length,
                        itemBuilder: (BuildContext context, int index) {
                          //print(Products);
                          return ItemSetup(Orders[index]['orderId'],Orders[index]['venue'],Orders[index]['date']);
                        }
                    ),
                  ),
                ],
              )
          );

        }

        return Center(child:Text("loading")); //todo make a loading componentc
      },
    );
  }
}