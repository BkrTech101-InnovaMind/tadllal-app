import 'package:shared_preferences/shared_preferences.dart';

class SaveTourForFirstTime {
  Future<SharedPreferences> data = SharedPreferences.getInstance();
  static SharedPreferences? preferences;

  static Future init() async =>
      preferences = await SharedPreferences.getInstance();

  void saveTourForFirstTime() async {
    final prefs = await data;
    prefs.setBool('tourForFirstTime', true);
  }

  Future<bool> getTourForFirstTimeState() async {
    final prefs = await data;
    if (prefs.containsKey("tourForFirstTime")) {
      bool? getData = prefs.getBool('tourForFirstTime');
      return getData!;
    } else {
      return false;
    }
  }
}
