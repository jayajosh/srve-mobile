import 'package:shared_preferences/shared_preferences.dart';

class Units {
  setUnits (bool m) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('miles',m);
  }

  getUnits () async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('miles') == null) {setUnits(true);};
      return prefs.getBool('miles');
  }

}