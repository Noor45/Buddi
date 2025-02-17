import 'package:buddi/auth/signin_screen.dart';
import 'package:buddi/auth/university_list.dart';
import 'package:buddi/functions/shared_preference.dart';
import 'package:buddi/utils/strings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toast/toast.dart';
import '../screens/settingScreens/external_link_screen.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../widgets/input_field.dart';
import 'dart:convert' as json;
import 'package:flutter/services.dart' show rootBundle;
import '../widgets/round_button.dart';

class SelectUniversity extends StatefulWidget {
  static String selectUniScreenID = "/select_uni_screen";
  @override
  _SelectUniversityState createState() => _SelectUniversityState();
}

class _SelectUniversityState extends State<SelectUniversity> {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  int consecutiveTaps = 0;
  int lastTap = DateTime.now().millisecondsSinceEpoch;
  TextEditingController _controller = TextEditingController();
  List result = [];
  loadJson() async {
    Constants.universityList.clear();
    String data = await rootBundle.loadString('assets/data.json');
    Constants.universityList = json.jsonDecode(data);
    Constants.universitySecondList = json.jsonDecode(data);
    // Constants.universityList = [{
    //   'name': 'A.T. Still University',
    //   'email': '@atsu.edu',
    // }];
    // Constants.universitySecondList = [{
    //   'name': 'A.T. Still University',
    //   'email': '@atsu.edu',
    // }];
  }
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final  theme = Provider.of<DarkThemeProvider>(context);
    double width = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: CircularProgressIndicator(color: ColorRefer.kMainThemeColor),
      child: Scaffold(
        backgroundColor: theme.lightTheme == true
            ? Colors.white
            : ColorRefer.kBackColor,
        appBar: AppBar(
          elevation: 0,
          title: Text(
              'Find Your University',
              style: TextStyle(
                    fontSize: 20,
                    fontFamily: FontRefer.Poppins,
                    color: Colors.white,
              )
          ),
          backgroundColor: ColorRefer.kMainThemeColor,
        ),
        body: SafeArea(
          child: Center(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          ToastContext().init(context);
                          int now = DateTime.now().millisecondsSinceEpoch;
                          if (now - lastTap < 1000) {
                            consecutiveTaps++;
                            if (consecutiveTaps >= 2) {
                              setState(() {
                                Constants.testingMode = LocalPreferences.preferences.getBool(LocalPreferences.testingMode);
                                if (Constants.testingMode == false || Constants.testingMode == null) {                                 
                                  LocalPreferences.preferences.setBool(LocalPreferences.testingMode, true);
                                   Constants.testingMode = LocalPreferences.preferences.getBool(LocalPreferences.testingMode);
                                  Toast.show("Testing mode on",
                                      duration: Toast.lengthLong,
                                      gravity: Toast.bottom);
                                } else {
                                  LocalPreferences.preferences.setBool(LocalPreferences.testingMode, false);   
                                   Constants.testingMode = LocalPreferences.preferences.getBool(LocalPreferences.testingMode);                             
                                  Toast.show("Testing mode off",
                                      duration: Toast.lengthLong,
                                      gravity: Toast.bottom);
                                }
                              });
                            }
                          } else {
                            consecutiveTaps = 0;
                          }
                          lastTap = now;
                        },
                        child: Image.asset(
                          StringRefer.artwork8,
                        ),
                      ),
                      SizedBox(height: 20),
                      AutoSizeText(
                        "Please choose your school’s name from the list",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                          fontSize: 14,
                          fontFamily: FontRefer.Poppins,
                        ),
                      ),
                      SizedBox(height: 40),
                      SelectBox(
                        controller: _controller,
                        hint: 'Select University',
                        icon: FontAwesomeIcons.building,
                        onPressed: () {
                          setState(() {
                            selectUniversity();
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Can’t find your school or it has the wrong domain? Contact us',
                              style: TextStyle(
                                  fontSize: 14,
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
                                  fontSize: 14,
                                  fontFamily: FontRefer.Poppins,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      CustomizedButton(
                          title: 'Next',
                          buttonRadius: 5,
                          colour: result.isNotEmpty
                              ? ColorRefer.kMainThemeColor
                              : ColorRefer.kMainThemeColor.withOpacity(0.4),
                          height: 47,
                          width: width,
                          onPressed: () async {
                            if (result.isNotEmpty) {
                              Navigator.pushNamed(
                                  context, SignInScreen.signInScreenID,
                                  arguments: result);
                            }
                          }),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  selectUniversity() async {
    await loadJson();
    var data = await Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.bottomToTop,
        duration: Duration(milliseconds: 400),
        child: UniversityList(),
        settings: RouteSettings(name: UniversityList.uniListScreenID),
      ),
    );
    if (data != null) {
      result = data;
    } else {
      return;
    }
    setState(() {
      _controller.text = result[0];
    });
  }
}
