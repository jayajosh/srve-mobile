import 'package:flutter/material.dart';
import 'package:srve/components/venue_storage_alert.dart';
import 'package:srve/services/venue_storage.dar.dart';
import '../locator.dart';
import 'home/map.dart';
import 'home/menu.dart';
import 'home/more.dart';

class Home extends StatefulWidget {
  Home({int currentIndex = 0});

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

  @override
  void initState() {
    super.initState();
  }

  void goToMenu() {
    setState(() {
      currentIndex = 1;
    });
  }

  void onTapped(int index) {
    setState(() {
      //(index==3){qrScan(context); index = currentIndex;} ///------///
      currentIndex = index;
    });
  }

  final GlobalKey<ScaffoldState> _mainScaffold = GlobalKey();
  final GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

    final List<Widget> pages = [
      MapScreen(onTapped),
      Menu(),
      Scaffold(),
      More()
    ];

    if (locator<SelectedVenue>().getVenue() == null && currentIndex == 1) {
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        await showDialog<String>(
            context: context,
            builder: (BuildContext context) => noVenue(context)
        );
        setState(() {
          //(index==3){qrScan(context); index = currentIndex;} ///------///
          currentIndex = 0;
        });
      });
    }

    return Scaffold(
      key: _mainScaffold,
      body: IndexedStack(
          index: currentIndex,
          children: pages,
        ),

      bottomNavigationBar: BottomAppBar(
          child: BottomNavigationBar(
            key: _bottomNavigationKey,
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

}