import 'package:shared_preferences/shared_preferences.dart';

// Deprecated

/*Future <SharedPreferences> _prefs = SharedPreferences.getInstance();

class VenueNotifier with ChangeNotifier {

  setVenue(String venue) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('venue',venue);
  }

  setTable(int table) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('table',table);
  }

  Future<String?> getVenue() async{
    final prefs = await SharedPreferences.getInstance();
    String? venue = prefs.getString('venue');
    return venue;
  }

  Future<int> getTable() async{
    final prefs = await SharedPreferences.getInstance();
    int table = prefs.getInt('table') ?? 0;
    return table;
  }


}*/

class SelectedVenue{

  String? venue;
  int? table;

  setVenue (String? v) {
    venue = v;
  }

  setTable (int? t) {
    table = t;
  }

  String? getVenue () {
    return venue;
  }

  int? getTable () {
    return table;
  }

}