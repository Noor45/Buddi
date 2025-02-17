import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddi/auth/select_university.dart';
import 'package:buddi/functions/message_notification.dart';
import 'package:buddi/functions/global_functions.dart';
import 'package:buddi/screens/settingScreens/support.dart';
import 'package:buddi/screens/settingScreens/term_condition.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:buddi/widgets/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:get/get.dart';
import '../../auth/profile_picture_screen.dart';
import '../../cards/home_card.dart';
import '../../controller/account_controller.dart';
import '../../utils/colors.dart';
import '../../auth/select_interest.dart';
import 'community_guidelines_screens.dart';
import 'external_link_screen.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final  theme = Provider.of<DarkThemeProvider>(context);
    return ModalProgressHUD(
        inAsyncCall: _isLoading,
        progressIndicator: CircularProgressIndicator(color: ColorRefer.kMainThemeColor),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SettingTab(
                  color: theme.lightTheme == true ? Colors.black54
                      : Colors.white,
                  title: 'Change Profile Picture',
                  onPressed: () {
                    Get.to(()=>ProfilePictureScreen(signUpFlow: false));
                  },
                ),
                SettingTab(
                  color: theme.lightTheme == true ? Colors.black54
                      : Colors.white,
                  title: 'Privacy Policy',
                  onPressed: () {
                    Navigator.pushNamed(context, SupportScreen.supportID);
                  },
                ),
                SettingTab(
                  color: theme.lightTheme == true ? Colors.black54
                      : Colors.white,
                  title: 'Terms and Conditions',
                  onPressed: () {
                    Navigator.pushNamed(
                        context, TermConditionScreen.termConditionID);
                  },
                ),
                SettingTab(
                    color: theme.lightTheme == true
                        ? Colors.black54
                        : Colors.white,
                    title: 'Community Guidelines',
                    onPressed: () {
                      Navigator.pushNamed(context, CommunityGuidelinesScreen.ID,
                          arguments: [
                            'Community Guidelines',
                            'https://www.talkbuddi.com/legal'
                          ]);
                    },
                  ),
                SettingTab(
                    color: theme.lightTheme == true
                        ? Colors.black54
                        : Colors.white,
                    title: theme.lightTheme == true ? 'Light Mode' : 'Dark Mode',
                    onPressed: () async{
                      await showDialog(
                          context: context,
                          useSafeArea: false,
                          barrierColor: theme.lightTheme == true ? ColorRefer.kBackColor.withOpacity(0.40) : ColorRefer.kBackColor.withOpacity(0.30),
                          builder: (BuildContext context) {
                            return ThemeCard();
                          },
                      );
                    },
                ),
                SettingTab(
                    color: theme.lightTheme == true
                        ? Colors.black54
                        : Colors.white,
                    title: 'Become a Listener',
                    onPressed: () {
                      Navigator.pushNamed(context,
                          ExternalLinkScreen.externalLinkScreenID, arguments: 'www.talkbuddi.com/careers');
                    },
                  ),
                SettingTab(
                  color: theme.lightTheme == true ? Colors.black54
                      : Colors.white,
                  title: 'Change interests',
                  onPressed: () {
                    Get.to(()=>SelectInterests(signUpFlow: false));
                  },
                ),
                SettingTab(
                  color: theme.lightTheme == true ? Colors.black54
                      : Colors.white,
                  title: 'Logout',
                  onPressed: () {
                    AppDialog().showOSDialog(context, "Logout",
                        "Are you sure you want to logout?", "Logout", () {
                      clearData();
                      _auth.signOut();
                      PostNotificationSubscription.fcmUnSubscribe();
                      Navigator.pushNamedAndRemoveUntil(context,
                          SelectUniversity.selectUniScreenID, (route) => false);
                    }, secondButtonText: "Cancel", secondCallback: () {});
                  },
                ),
                SettingTab(
                  color: theme.lightTheme == true ? Colors.black54
                      : Colors.white,
                  title: 'Delete Account',
                  onPressed: () {
                    AppDialog().showOSDialog(context, "Delete Account",
                        "When you press the delete button your data will be removed permanently and will not be recoverable. Do you really want to delete your account?", "Delete", () async{
                          setState(() {
                            _isLoading = true;
                          });
                          clearData();
                          await AccountController().deleteUserData();
                          PostNotificationSubscription.fcmUnSubscribe();
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.pushNamedAndRemoveUntil(context,
                              SelectUniversity.selectUniScreenID, (route) => false);
                        }, secondButtonText: "Cancel", secondCallback: () {});
                  },
                ),
              ]
           ),
        ));
  }
}

class SettingTab extends StatefulWidget {
  SettingTab({this.color, this.title, this.onPressed});
  final Color? color;
  final String? title;
  final Function? onPressed;
  @override
  _SettingTabState createState() => _SettingTabState();
}

class _SettingTabState extends State<SettingTab> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return InkWell(
      onTap: widget.onPressed as void Function()?,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width/5,
        padding: EdgeInsets.only(left: 20, right: 20),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.5, color: ColorRefer.kGreyColor),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoSizeText(
              widget.title!,
              style: TextStyle(
                fontSize: 14,
                fontFamily: FontRefer.Poppins,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: widget.color,
              ),
            ),
            Icon(Icons.arrow_forward_ios_sharp, size: 20, color: theme.lightTheme == true ? Colors.black54 : Colors.white,)
          ],
        ),
      ),
    );
  }
}
