import 'package:buddi/functions/message_notification.dart';
import 'package:buddi/functions/shared_preference.dart';
import 'package:buddi/screens/chatScreens/chat_option.dart';
import 'package:buddi/screens/mainScreens/home_screen.dart';
import 'package:buddi/screens/mainScreens/profile_screen.dart';
import 'package:buddi/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../functions/global_functions.dart';
import '../../utils/colors.dart';
import 'package:coachmaker/coachmaker.dart';
import '../../utils/strings.dart';
import '../ResourceScreens/resources_screen.dart';

class MainScreen extends StatefulWidget {
  static const MainScreenId = 'main_screen';
  MainScreen({this.tab});
  final int? tab;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showSpinner = false;
  final List<dynamic> tabs = [
    HomeScreen(),
    ChatOption(),
    ResourceScreen(),
    ProfileScreen(),
  ];
  Future<void> _initApp() async {
    bool? areShowcaseVisited = LocalPreferences.preferences.getBool(LocalPreferences.showcaseVisited);
    if(areShowcaseVisited == false || areShowcaseVisited == null) await startShowcase(this.context);
  }
  @override
  void initState() {
    PostNotificationSubscription.fcmSubscribe();
    _initApp();
    if (widget.tab == null) {
      Constants.selectedIndex = 0;
    } else {
      Constants.selectedIndex = widget.tab;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final  theme = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
        key: _scaffoldKey,
        body: tabs[Constants.selectedIndex!],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            primaryColor: ColorRefer.kMainThemeColor,
          ),
          child: BottomNavigationBar(
            key: globalKey,
            currentIndex: Constants.selectedIndex!,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: TextStyle(color: ColorRefer.kMainThemeColor),
            unselectedLabelStyle: TextStyle(color: Colors.grey),
            selectedItemColor: ColorRefer.kMainThemeColor,
            selectedIconTheme: Theme.of(context).primaryIconTheme.copyWith(color: ColorRefer.kMainThemeColor),
            backgroundColor: theme.lightTheme == false ? Colors.black87 : Colors.white,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 5),
                  child: SvgPicture.asset(
                    Constants.selectedIndex == 0
                        ? StringRefer.homeFill
                        : StringRefer.home,
                    color: Constants.selectedIndex == 0
                        ? ColorRefer.kMainThemeColor
                        : theme.lightTheme == true ? Colors.black54 : Colors.white,
                  ),
                ),
                label: 'Home',
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: CoachPoint(
                  initial: '2',
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 5),
                    child: SvgPicture.asset(
                      StringRefer.chat,
                      color: Constants.selectedIndex == 1
                          ? ColorRefer.kMainThemeColor
                          : theme.lightTheme == true ? Colors.black54
                          : Colors.white,
                    ),
                  ),
                ),
                label: 'Talk',
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: CoachPoint(
                  initial: '4',
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 5),
                    child: SvgPicture.asset(
                      StringRefer.resource,
                      color: Constants.selectedIndex == 2
                          ? ColorRefer.kMainThemeColor
                          : theme.lightTheme == true ? Colors.black54
                          : Colors.white,
                    ),
                  ),
                ),
                label: 'Resources',
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: CoachPoint(
                  initial: '5',
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 5),
                    child: SvgPicture.asset(
                      StringRefer.setting,
                      color: Constants.selectedIndex == 3
                          ? ColorRefer.kMainThemeColor
                          : theme.lightTheme == true
                              ? Colors.black54
                              : Colors.white,
                    ),
                  ),
                ),
                label: 'Profile',
                backgroundColor: Colors.white,
              ),
            ],
            onTap: (index) {
              setState(() {
                Constants.selectedIndex = index;
              });
            },
          ),
        )
    );
  }
}
