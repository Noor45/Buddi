import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddi/auth/select_university.dart';
import 'package:buddi/utils/strings.dart';
import 'package:flutter/services.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';

class WelcomeScreen extends StatefulWidget {
  static const String ID = "/welcome_screen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final  theme = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 60,
        elevation: 0,
        systemOverlayStyle: theme.lightTheme == true ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
        title: Slider(
          value: Constants.progressValue,
          min: 0,
          max: 9,
          inactiveColor: Colors.orange,
          activeColor: ColorRefer.kMainThemeColor,
          onChanged: (double newValue) {},
        ),
      ),
      backgroundColor: theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40),
                Center(
                    child: Image.asset(StringRefer.artwork7, fit: BoxFit.fill,)
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Made by students,',
                          style: TextStyle(
                              fontSize: 25,
                              color: ColorRefer.kMainThemeColor,
                              fontFamily: FontRefer.Poppins,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'for students',
                          style: TextStyle(
                              fontSize: 25,
                              color: ColorRefer.kMainThemeColor,
                              fontFamily: FontRefer.Poppins,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      SizedBox(height: 15),
                      AutoSizeText(
                        'Our team wants to provide students a platform to support each other.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                            fontSize: 13,
                            fontFamily: FontRefer.Poppins,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: AutoSizeText(
                          'We hope you enjoy our app, my Buddi!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                              fontSize: 13,
                              fontFamily: FontRefer.Poppins,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 50),
                        child: RoundedButton(
                            title: 'GET STARTED',
                            buttonRadius: 5,
                            colour: ColorRefer.kMainThemeColor.withOpacity(0.8),
                            height: 40,
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, SelectUniversity.selectUniScreenID);
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
