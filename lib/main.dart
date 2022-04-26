import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/locator.dart';
import 'screens/home.dart';
import 'screens/home/menu/cart_screen.dart';
import 'screens/home/menu/drinks.dart';
import 'screens/home/menu/food.dart';
import 'screens/home/menu/submenu.dart';
import 'screens/home/more/profile.dart';
import 'services/navigation.dart';
import 'services/dynamic_link.dart';
import 'services/themes.dart';
import 'screens/splash.dart';

import 'package:firebase_core/firebase_core.dart';



main() {
  setUpLocator();

  WidgetsFlutterBinding.ensureInitialized();
  return runApp(ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier(),child: Main()));

}

class Main extends StatefulWidget {
  @override
  _Main createState() => _Main();
}

class _Main extends State<Main> with WidgetsBindingObserver{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    handleLinks();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      handleLinks();
    }
  }

  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
          navigatorKey: locator<Navigation>().navigationKey,
          theme: theme.lightTheme,
          darkTheme: theme.darkTheme,
          themeMode: theme.getThemeMode(),
          home: FutureBuilder(
            future: _fbApp,
            builder: (context, snapshot){
              /*handleStartUpLogic(context);*/
              handleLinks();
              if (snapshot.hasError) {
                print ('An error has occurred ${snapshot.error.toString()}');
                return const Text('Something went wrong!');
              } else if (snapshot.hasData) {
                return Splash();
              }
              else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),

          initialRoute: '/',
          routes: <String, WidgetBuilder>{
            '/Home': (context) => Home(),
            '/Splash': (context) => Splash(),
            'Home/Profile': (context) => Profile(),
            'Home/Food': (context) => Food(),
            'Home/Drinks': (context) => Drinks(),
            'Home/Food/Submenu': (context) => Submenu(),
            'Home/Drinks/Submenu': (context) => Submenu(),
            'Home/Cart': (context) => CartScreen(),
            /*'/WelcomePage': (context) => WelcomePage(),
            '/LoginPage': (context) => LoginPage(),
            '/SignUpPage': (context) => SignUpPage(),
            '/Home/RouteEditor': (context) => RouteEditor(),
            '/Home/RouteEditor/PlaceSearch': (context) => PlaceSearch(),
            '/Home/Profile': (context) => Profile(),
            '/Home/SavedRoutes': (context) => SavedRoutes(),
            '/Home/RouteViewer': (context) => RouteViewer(),
            '/Home/RouteMap': (context) => RouteMap(),*/

          },
        )


    );
  }

}

/*
Future handleStartUpLogic(context) async {
*/
/*  final AuthenticationService _authenticationService =
  locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final PushNotificationService _pushNotificationService =
  locator<PushNotificationService>();*//*

  final DynamicLink _dynamicLinkService = locator<DynamicLink>();


  await _dynamicLinkService.handleDynamicLinks(context);

*/
/*  // Register for push notifications
  await _pushNotificationService.initialise();*//*

}*/

handleLinks() async {
  final DynamicLink _dynamicLinkService = locator<DynamicLink>();
  await _dynamicLinkService.handleDynamicLinks();
}

