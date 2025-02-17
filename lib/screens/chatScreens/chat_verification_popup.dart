import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/constants.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:buddi/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:toast/toast.dart';

import '../../controller/auth_controller.dart';
import '../../widgets/input_field.dart';
import 'wait_screen.dart';

class VerificationPopup extends StatefulWidget {
  const VerificationPopup({Key? key}) : super(key: key);

  @override
  State<VerificationPopup> createState() => _VerificationPopupState();
}

class _VerificationPopupState extends State<VerificationPopup> {
  String code1 = '', code2 = '', code3 = '', code4 = '', code5 = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(left: 20, right: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      elevation: 0,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: 200.0,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color:
              theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0, theme.lightTheme == true ? 4 : 0),
                blurRadius: theme.lightTheme == true ? 10 : 0),
          ]),
      child: Container(
        padding: EdgeInsets.only(top: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 25,
                        color: theme.lightTheme == true
                            ? Colors.black54
                            : Colors.white,
                      )),
                  SizedBox(width: 10),
                  AutoSizeText(
                    'Listener Authentication',
                    style: TextStyle(
                      color: theme.lightTheme == true
                          ? Colors.black54
                          : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontRefer.PoppinsMedium,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VerifyTextField(
                  onChanged: (value) {
                    code1 = value;
                    if (code1 != "") FocusScope.of(context).nextFocus();
                  },
                ),
                SizedBox(width: 5),
                VerifyTextField(
                  onChanged: (value) {
                    code2 = value;
                    if (code2 != "") FocusScope.of(context).nextFocus();
                  },
                ),
                SizedBox(width: 5),
                VerifyTextField(
                  onChanged: (value) {
                    code3 = value;
                    if (code3 != "") FocusScope.of(context).nextFocus();
                  },
                ),
                SizedBox(width: 5),
                VerifyTextField(
                  onChanged: (value) {
                    code4 = value;
                    if (code4 != "") FocusScope.of(context).nextFocus();
                  },
                ),
                SizedBox(width: 5),
                VerifyTextField(
                  onChanged: (value) {
                    code5 = value;
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: SubmitButton(
                title: 'Verify',
                colour: code1.isNotEmpty &&
                        code2.isNotEmpty &&
                        code3.isNotEmpty &&
                        code4.isNotEmpty &&
                        code5.isNotEmpty
                    ? ColorRefer.kMainThemeColor
                    : ColorRefer.kMainThemeColor.withOpacity(0.2),
                onPressed: () {
                  if (code1.isNotEmpty &&
                      code2.isNotEmpty &&
                      code3.isNotEmpty &&
                      code4.isNotEmpty &&
                      code5.isNotEmpty) {
                    String _code = code1 + code2 + code3 + code4 + code5;
                    int code = int.parse(_code);
                    if (code == AuthController.currentUser!.listenerCode) {
                      Constants.userType = 1; // Listeners
                      Constants.chatType = 2;

                      Constants.availableBuddiList = [];
                      Constants.selectedChatType =
                          1; //chat type selected by listener
                      Constants.chatAsListener = true;
                      Constants.selectedChatId = '';

                      Navigator.pushNamed(
                          context, WaitingScreen.waitingScreenID);
                    } else
                      Toast.show('Please enter correct listener code',
                          duration: 2);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MeetSomeonePopup extends StatefulWidget {
  @override
  _MeetSomeonePopupState createState() => _MeetSomeonePopupState();
}

class _MeetSomeonePopupState extends State<MeetSomeonePopup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(left: 20, right: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      elevation: 0,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: 190.0,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: theme.lightTheme == true ? Colors.white : ColorRefer.kBoxColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0, theme.lightTheme == true ? 4 : 0),
                blurRadius: theme.lightTheme == true ? 10 : 0),
          ]),
      child: Container(
        padding: EdgeInsets.only(top: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 10),
                  AutoSizeText(
                    'Live Random Chat',
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorRefer.kChatColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontRefer.PoppinsMedium,
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.cancel_outlined,
                        size: 25,
                        color: Colors.grey,
                      )),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 35, right: 35),
              child: Text(
                'Get randomly paired with another student seeking to chat.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: theme.lightTheme == true
                        ? Colors.black54
                        : Colors.white,
                    fontFamily: FontRefer.Poppins,
                    fontSize: 14),
              ),
            ),
            SizedBox(height: 30)
          ],
        ),
      ),
    );
  }
}

class ClearYourMindPopup extends StatefulWidget {
  @override
  _ClearYourMindPopupState createState() => _ClearYourMindPopupState();
}

class _ClearYourMindPopupState extends State<ClearYourMindPopup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(left: 20, right: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      elevation: 0,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: 190.0,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color:
              theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0, theme.lightTheme == true ? 4 : 0),
                blurRadius: theme.lightTheme == true ? 10 : 0),
          ]),
      child: Container(
        padding: EdgeInsets.only(top: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 10),
                  AutoSizeText(
                    'Peer-to-Peer Support',
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorRefer.kMainThemeColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontRefer.PoppinsMedium,
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.cancel_outlined,
                        size: 25,
                        color: Colors.grey,
                      )),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 35, right: 35),
              child: Text(
                'Get paired with a student listener to vent, express your thoughts or clear your mind.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: theme.lightTheme == true
                        ? Colors.black54
                        : Colors.white,
                    fontFamily: FontRefer.Poppins,
                    fontSize: 14),
              ),
            ),
            SizedBox(height: 30)
          ],
        ),
      ),
    );
  }
}
