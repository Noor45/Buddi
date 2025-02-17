import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddi/controller/auth_controller.dart';
import 'package:buddi/screens/filterScreens/find_another_buddi.dart';
import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/constants.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:buddi/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';

class RatingScreen extends StatefulWidget {
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  List rateList = [];
  List rateStarList = List.filled(5, 0);
  int _rating = 0;

  void rate(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  @override
  void initState() {
    _rating = 3;
    super.initState();
  }

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
      height: 280,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color:
              theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.black45, offset: Offset(0, 4), blurRadius: 10),
          ]),
      child: Container(
        decoration: BoxDecoration(
            color: theme.lightTheme == true
                ? ColorRefer.kDarkGreyColor
                : ColorRefer.kBoxColor,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.lightTheme == true
                    ? ColorRefer.kLightGreyColor
                    : ColorRefer.kBackColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'Your opinion matters to us!',
                      softWrap: true,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.lightTheme == true
                            ? Colors.black54
                            : Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: FontRefer.PoppinsMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  AutoSizeText(
                    'How helpful did you find your conversation?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.lightTheme == true
                          ? Colors.black54
                          : Colors.white,
                      fontSize: 14,
                      fontFamily: FontRefer.Poppins,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new GestureDetector(
                        child: new Icon(
                          Icons.star,
                          size: 40,
                          color: _rating >= 1
                              ? ColorRefer.kStarColor
                              : Colors.grey,
                        ),
                        onTap: () => rate(1),
                      ),
                      new GestureDetector(
                        child: new Icon(
                          Icons.star,
                          size: 40,
                          color: _rating >= 2
                              ? ColorRefer.kStarColor
                              : Colors.grey,
                        ),
                        onTap: () => rate(2),
                      ),
                      new GestureDetector(
                        child: new Icon(
                          Icons.star,
                          size: 40,
                          color: _rating >= 3
                              ? ColorRefer.kStarColor
                              : Colors.grey,
                        ),
                        onTap: () => rate(3),
                      ),
                      new GestureDetector(
                        child: new Icon(
                          Icons.star,
                          size: 40,
                          color: _rating >= 4
                              ? ColorRefer.kStarColor
                              : Colors.grey,
                        ),
                        onTap: () => rate(4),
                      ),
                      new GestureDetector(
                        child: new Icon(
                          Icons.star,
                          size: 40,
                          color: _rating >= 5
                              ? ColorRefer.kStarColor
                              : Colors.grey,
                        ),
                        onTap: () => rate(5),
                      )
                    ],
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.only(left: 50, right: 50),
                    child: RoundedButton(
                      title: 'Rate Now',
                      colour: ColorRefer.kMainThemeColor,
                      height: 45,
                      buttonRadius: 30,
                      onPressed: () async {
                        AuthController()
                            .rateUser(Constants.selectedChatId!, _rating);
                        Navigator.pop(context);
                        if (_rating <= 2) {
                          await showDialog(
                            context: context,
                            useSafeArea: false,
                            barrierColor: theme.lightTheme == true
                                ? ColorRefer.kBackColor.withOpacity(0.96)
                                : ColorRefer.kBackColor.withOpacity(0.96),
                            builder: (BuildContext context) {
                              return FindAnotherBuddi();
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                Navigator.pop(context);
                if (_rating <= 2) {
                  await showDialog(
                    context: context,
                    useSafeArea: false,
                    barrierColor: theme.lightTheme == true
                        ? ColorRefer.kBackColor.withOpacity(0.96)
                        : ColorRefer.kBackColor.withOpacity(0.96),
                    builder: (BuildContext context) {
                      return FindAnotherBuddi();
                    },
                  );
                }
              },
              child: Container(
                width: width,
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.lightTheme == true
                      ? ColorRefer.kLightGreyColor
                      : ColorRefer.kBackColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: theme.lightTheme == true
                          ? Colors.black54
                          : Colors.white,
                      fontFamily: FontRefer.Poppins,
                      fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PreChatAgreement extends StatefulWidget {
  PreChatAgreement({required this.onPressed});
  final Function onPressed;
  @override
  _PreChatAgreementState createState() => _PreChatAgreementState();
}

class _PreChatAgreementState extends State<PreChatAgreement> {
  @override
  void initState() {
    super.initState();
  }

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
      padding: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color:
              theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.black45, offset: Offset(0, 4), blurRadius: 10),
          ]),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 15, 15, 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AutoSizeText(
                'DISCLAIMER',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.lightTheme == true
                      ? ColorRefer.kMainThemeColor
                      : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontRefer.PoppinsMedium,
                ),
              ),
              SizedBox(height: 5),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: AutoSizeText(
                      '''
Users providing this chat support are regular people with no professional certifications behind their advice. Venting to a stranger can be incredibly dangerous if you are in a very mentally sensitive state. By entering the chat, you understand that Buddi is not liable for any advice given or conversations conducted during a chat session. If you are in an immediate crisis, contact 811 or 911

By clicking "I agree, Proceed to Chat" you agree to the following:''',
                      style: TextStyle(
                        color: theme.lightTheme == true
                            ? Colors.black
                            : Colors.white,
                        fontSize: 11,
                        fontFamily: FontRefer.Poppins,
                      ),
                      minFontSize: 5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: AutoSizeText(
                      '''
⚫️ I am not homicidal or suicidal. (If you are we strongly urge you to speak to one of our licensed therapists. Must be 18 or older)
⚫️ I understand that no action can be taken toward any claims made during a chat as all users are anonymous.
⚫️ I understand that the chat is intended for casual venting and not for mental illness diagnosing or psychological therapy.
⚫️ I understand that I am not to perform the role of a real therapist and will refer any user to seek appropriate help from a therapist if the case permits it.''',
                      style: TextStyle(
                        color: theme.lightTheme == true
                            ? Colors.black
                            : Colors.white,
                        fontSize: 11,
                        fontFamily: FontRefer.Poppins,
                      ),
                      minFontSize: 5,
                    ),
                  ),
                ],
              ),
              // Container(
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Container(
              //         child: Theme(
              //           data: Theme.of(context).copyWith(
              //             unselectedWidgetColor: theme.lightTheme == true
              //                 ? ColorRefer.kHintColor
              //                 : Colors.white,
              //           ),
              //           child: Checkbox(
              //             value: checkOne,
              //             activeColor: ColorRefer.kMainThemeColor,
              //             onChanged: (bool? value) async {
              //               setState(() {
              //                 checkOne = !checkOne;
              //               });
              //             },
              //           ),
              //         ),
              //       ),
              //       Flexible(
              //         child: Container(
              //           padding: EdgeInsets.only(top: 10, right: 5),
              //           child: AutoSizeText(
              //             'By clicking each checkbox, you’ve read and agree to the following:',
              //             style: TextStyle(
              //               color: theme.lightTheme == true
              //                   ? Colors.black54
              //                   : Colors.white,
              //               fontSize: 12,
              //               fontFamily: FontRefer.Poppins,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // Container(
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Container(
              //         child: Theme(
              //           data: Theme.of(context).copyWith(
              //             unselectedWidgetColor: theme.lightTheme == true
              //                 ? ColorRefer.kHintColor
              //                 : Colors.white,
              //           ),
              //           child: Checkbox(
              //             value: checkTwo,
              //             activeColor: ColorRefer.kMainThemeColor,
              //             onChanged: (bool? value) async {
              //               setState(() {
              //                 checkTwo = !checkTwo;
              //               });
              //             },
              //           ),
              //         ),
              //       ),
              //       Flexible(
              //         child: Container(
              //           padding: EdgeInsets.only(top: 10, right: 5),
              //           child: AutoSizeText(
              //             'I understand this platform is intended for casual venting. Buddi is not a replacement for medication or professional healthcare. If you have any health conditions, please consult your healthcare provider.',
              //             style: TextStyle(
              //               color: theme.lightTheme == true
              //                   ? Colors.black54
              //                   : Colors.white,
              //               fontSize: 12,
              //               fontFamily: FontRefer.Poppins,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Container(
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Container(
              //         child: Theme(
              //           data: Theme.of(context).copyWith(
              //             unselectedWidgetColor: theme.lightTheme == true
              //                 ? ColorRefer.kHintColor
              //                 : Colors.white,
              //           ),
              //           child: Checkbox(
              //             value: checkThree,
              //             activeColor: ColorRefer.kMainThemeColor,
              //             onChanged: (bool? value) async {
              //               setState(() {
              //                 checkThree = !checkThree;
              //               });
              //             },
              //           ),
              //         ),
              //       ),
              //       Flexible(
              //         child: Container(
              //           padding: EdgeInsets.only(top: 10, right: 5),
              //           child: AutoSizeText(
              //             'Users providing this chat therapy are regular students with no professional training behind their advice. Venting to a stranger can be incredibly dangerous if you are at a very mentally sensitive state. By entering the chat, you understand that Buddi is not liable for any advice given or conversations conducted during a chat session.',
              //             style: TextStyle(
              //               color: theme.lightTheme == true
              //                   ? Colors.black54
              //                   : Colors.white,
              //               fontSize: 12,
              //               fontFamily: FontRefer.Poppins,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Container(
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Container(
              //         child: Theme(
              //           data: Theme.of(context).copyWith(
              //             unselectedWidgetColor: theme.lightTheme == true
              //                 ? ColorRefer.kHintColor
              //                 : Colors.white,
              //           ),
              //           child: Checkbox(
              //             value: checkFour,
              //             activeColor: ColorRefer.kMainThemeColor,
              //             onChanged: (bool? value) async {
              //               setState(() {
              //                 checkFour = !checkFour;
              //               });
              //             },
              //           ),
              //         ),
              //       ),
              //       Flexible(
              //         child: Container(
              //           padding: EdgeInsets.only(top: 10, right: 5),
              //           child: RichText(
              //             text: TextSpan(
              //               children: [
              //                 TextSpan(
              //                   text: 'I will act in accordance to the Buddi ',
              //                   style: TextStyle(
              //                     color: theme.lightTheme == true
              //                         ? Colors.black54
              //                         : Colors.white,
              //                     fontSize: 14,
              //                     fontFamily: FontRefer.Poppins,
              //                   ),
              //                 ),
              //                 TextSpan(
              //                   recognizer: TapGestureRecognizer()
              //                     ..onTap = () {
              //                       Navigator.pushNamed(context,
              //                           ExternalLinkScreen.externalLinkScreenID,
              //                           arguments:
              //                               'https://www.talkbuddi.com/contact-4');
              //                     },
              //                   text: 'Community Guidelines',
              //                   style: TextStyle(
              //                     color: ColorRefer.kOrangeColor,
              //                     fontSize: 13,
              //                     fontFamily: FontRefer.Poppins,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              Container(
                margin: EdgeInsets.only(left: 10, top: 10),
                child: RoundedButton(
                    title: 'I Agree, Proceed to Chat',
                    buttonRadius: 5,
                    colour: ColorRefer.kMainThemeColor,
                    height: 45,
                    onPressed: () async {
                      Navigator.pop(context);
                      widget.onPressed.call();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
