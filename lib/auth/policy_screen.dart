import 'package:buddi/auth/start_screen.dart';
import 'package:buddi/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../functions/shared_preference.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../widgets/round_button.dart';

class PrivacyPolicyScreens extends StatefulWidget {
  static const String ID = "/privacy_policy_screen";
  @override
  _PrivacyPolicyScreensState createState() => _PrivacyPolicyScreensState();
}

class _PrivacyPolicyScreensState extends State<PrivacyPolicyScreens> {
  ScrollController _controller = ScrollController();
  bool checkedValue = false;
  int timerCount = 3;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.position.isScrollingNotifier.addListener(() {
        if (_controller.offset == _controller.position.maxScrollExtent) {
          if (timerCount == 3) countDownTimer();
        }
      });
    });
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor:
          theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
      body: SingleChildScrollView(
        controller: _controller,
        child: Container(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Disclaimer ',
                    style: TextStyle(
                      fontSize: 25,
                      color: ColorRefer.kMainThemeColor,
                      fontFamily: FontRefer.Poppins,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Very Important',
                    style: TextStyle(
                        fontSize: 25,
                        color: ColorRefer.kMainThemeColor,
                        fontFamily: FontRefer.PoppinsMedium,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Must scroll to bottom',
                        style: TextStyle(
                          color: Color(0xffFA7A35),
                          fontSize: 15,
                          fontFamily: FontRefer.Poppins,
                        ),
                      ),
                      SizedBox(height: 5),
                      RichText(
                        softWrap: true,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.visible,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Health Advice',
                              style: TextStyle(
                                color: theme.lightTheme == true
                                    ? Colors.black54
                                    : Colors.white,
                                fontSize: 16,
                                fontFamily: FontRefer.PoppinsMedium,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '\n${StringRefer.kFirstDisclaimerString}\n\n',
                              style: TextStyle(
                                color: theme.lightTheme == true
                                    ? Colors.black54
                                    : Colors.white,
                                fontSize: 16,
                                fontFamily: FontRefer.Poppins,
                              ),
                            ),
                            TextSpan(
                              text: 'Liability',
                              style: TextStyle(
                                color: theme.lightTheme == true
                                    ? Colors.black54
                                    : Colors.white,
                                fontSize: 16,
                                fontFamily: FontRefer.PoppinsMedium,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '\n${StringRefer.kSecondDisclaimerString}\n\n',
                              style: TextStyle(
                                color: theme.lightTheme == true
                                    ? Colors.black54
                                    : Colors.white,
                                fontSize: 16,
                                fontFamily: FontRefer.Poppins,
                              ),
                            ),
                            TextSpan(
                              text: '\n${StringRefer.kDisclaimer}\n',
                              style: TextStyle(
                                color: theme.lightTheme == true
                                    ? Colors.black54
                                    : Colors.white,
                                fontSize: 16,
                                fontFamily: FontRefer.PoppinsMedium,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: StringRefer.kDisclaimerPoints.length,
                          itemBuilder: (BuildContext context, int index) {
                            return AutoSizeText(
                              '• ${StringRefer.kDisclaimerPoints[index]}',
                              style: TextStyle(
                                  color: theme.lightTheme == true
                                      ? Colors.black54
                                      : Colors.white,
                                  fontSize: 14,
                                  fontFamily: FontRefer.Poppins,
                                  fontWeight: FontWeight.w400),
                            );
                          }),
                      SizedBox(height: 15),
                      RoundedButton(
                          title:
                              '${timerCount == 0 ? 'I\'ve read, understood and agree!' : timerCount}',
                          buttonRadius: 10,
                          colour: timerCount == 0
                              ? ColorRefer.kMainThemeColor
                              : ColorRefer.kMainThemeColor.withOpacity(0.3),
                          height: 45,
                          onPressed: () async {
                            if (timerCount == 0) {
                              await LocalPreferences.preferences.setBool(
                                  LocalPreferences.OnBoardingScreensVisited,
                                  true);
                              Constants.progressValue =
                                  Constants.progressValue + 2;
                              Navigator.pushReplacementNamed(
                                  context, WelcomeScreen.ID);
                            }
                          }),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  countDownTimer() async {
    try {
      for (int x = 3; x >= 0; x--) {
        await Future.delayed(Duration(seconds: 1)).then((_) {
          if (mounted) {
            setState(() {
              timerCount = x;
            });
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
