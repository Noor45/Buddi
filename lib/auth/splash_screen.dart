import 'package:buddi/controller/auth_controller.dart';
import 'package:buddi/functions/shared_preference.dart';
import 'package:buddi/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';

import '../utils/strings.dart';

class SplashScreen extends StatefulWidget {
  static String splashScreenId = "/splash_screen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _initApp() async {
    await LocalPreferences.initLocalPreferences();
    await AuthController().checkUserExists(context);
  }

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack, overlays: []);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.initState();
    _initApp();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor: theme.lightTheme == true
          ? ColorRefer.kBackgroundColor
          : ColorRefer.kBackColor,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(StringRefer.splash),
                  fit: BoxFit.cover)),
          child: Center(
            child: Image.asset(
              StringRefer.logo,
              width: MediaQuery.of(context).size.width / 2.4,
              height: MediaQuery.of(context).size.width / 2.4,
            ),
          ),
        ),
      ),
    );
  }
}
