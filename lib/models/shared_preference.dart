import 'package:shared_preferences/shared_preferences.dart';
import 'package:taches/models/tri_enum.dart';

// SharedPreference s'occuppe d'enregistrer les preferences
class SharedPreference {
  static const String SHOWISFINISH = "isFinishSP";
  static const String TRI = "tri";

  // getters
  Future<Tri> getTri() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? triValue = prefs.getString(TRI);
    Tri result = Tri.NORMAL; // Valeur par défaut
    if (triValue != null) {
      result = Tri.values.firstWhere(
        (element) => element.toString() == 'Tri.$triValue',
        orElse: () => Tri.NORMAL,
      );
    }
    return result;
  }

  Future<bool> getShowIsFinish() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SHOWISFINISH) ?? true;
  }

  // setters
  Future<void> setTri(Tri value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(TRI, value.name);
  }

  Future<void> setShowIsFinish(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(SHOWISFINISH,value);
  }
}
