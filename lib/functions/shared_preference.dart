import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferences {
  static late SharedPreferences preferences;
  static const String showcaseVisited = "showcase_visited";
  static const String OnBoardingScreensVisited = "on_boarding_visited";
  static const String testingMode = "testing_mode";
  static Future<void> initLocalPreferences() async {
    preferences = await SharedPreferences.getInstance();
  }
}
