import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import '../screens/settingScreens/external_link_screen.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';

class AccessDeniedScreen extends StatefulWidget {
  static const String ID = "/access_denied_screen";
  @override
  _AccessDeniedScreenState createState() => _AccessDeniedScreenState();
}

class _AccessDeniedScreenState extends State<AccessDeniedScreen> {
  @override
  Widget build(BuildContext context) {
    final  theme = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorRefer.kMainThemeColor,
        toolbarHeight: 60,
        elevation: 0,
        systemOverlayStyle: theme.lightTheme == true ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
        title: RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            text: "Unable to Access",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
      backgroundColor: theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Unfortunately, you are not eligible for the Buddi app.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                    fontFamily: FontRefer.Poppins,
                  ),
                ),
              ),
              SizedBox(height: 15),
              AutoSizeText(
                'Buddi is intended for active undergraduate students to keep the community safe and trusted for students. ',
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                    fontSize: 13,
                    fontFamily: FontRefer.Poppins,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 10),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Our resources believe you are not actively attending college as an undergraduate student. If you believe this is a mistake, please contact us',
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: FontRefer.Poppins,
                            fontWeight: FontWeight.w500,
                            color: theme.lightTheme == true
                                ? Colors.black
                                : Colors.white),
                      ),
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context,
                                ExternalLinkScreen.externalLinkScreenID, arguments: 'https://www.talkbuddi.com/contact-4');
                          },
                        text: ' here',
                        style: TextStyle(
                            color: ColorRefer.kOrangeColor,
                            fontSize: 15,
                            fontFamily: FontRefer.Poppins,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 50),
                child: RoundedButton(
                    title: 'Exit App',
                    buttonRadius: 5,
                    colour: ColorRefer.kMainThemeColor.withOpacity(0.8),
                    height: 40,
                    onPressed: () {
                      exit(0);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
