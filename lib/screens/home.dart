import 'package:flutter/material.dart';
import 'package:srve/components/selected_venue_alert.dart';
import 'package:srve/services/venue_storage.dar.dart';
import '../locator.dart';
import 'home/map.dart';
import 'home/menu.dart';
import 'home/more.dart';

class Home extends StatefulWidget {
  Home({int currentIndex = 0});



  final List<Widget> _page = [
    MapScreen(),
    Menu(),
    Scaffold(),
    More()

    /*MapWidget(),
    RouteSearch(),
    MapWidget(),
    Scanner()*/
  ];

/*
  final List<Widget> _appbar = [
    MapBar(),
    RouteSearchBar(),
    MapBar(),
    RouteSearchBar(),
    MapBar()
  ]
*/

  _Home createState() => _Home();
}

class _Home extends State<Home>{
  int currentIndex = 0;

  void onTapped(int index) {
    setState(() {
      //(index==3){qrScan(context); index = currentIndex;} ///------///
      currentIndex = index;
    });
  }

  GlobalKey<ScaffoldState> mainScaffold = GlobalKey();

  @override
  Widget build(BuildContext context) {

    if (locator<SelectedVenue>().getVenue() == null && currentIndex == 1) {
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        await showDialog<String>(
            context: context,
            builder: (BuildContext context) => noTable(context)
        );
        setState(() {
          //(index==3){qrScan(context); index = currentIndex;} ///------///
          currentIndex = 0;
        });
      });
    }

    return Scaffold(
      key: mainScaffold,
      body: widget._page[currentIndex],/*Stack( //todo do i need the stack to be indexed
          index: currentIndex,
          children: widget._page,
        ),
      ]),*/

      bottomNavigationBar: BottomAppBar(
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const [BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map',
            ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: 'Menu',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code_scanner),
                label: 'QR Scanner',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz),
                label: 'More',
              ),
            ],
            currentIndex: currentIndex,
            onTap: onTapped,
          )
      ),
      //floatingActionButton: CenterButton(),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  void initState() {
    super.initState();


  }

}