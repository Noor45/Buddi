import 'dart:io';
import 'package:buddi/auth/select_grade_screen.dart';
import 'package:buddi/controller/auth_controller.dart';
import 'package:buddi/controller/group_controller.dart';
import 'package:buddi/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';
import 'profile_picture_screen.dart';
import '../models/interests_model.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../widgets/round_button.dart';

class SelectInterests extends StatefulWidget {
  SelectInterests({this.signUpFlow = true});
  final bool signUpFlow;
  @override
  _SelectInterestsState createState() => _SelectInterestsState();
}

class _SelectInterestsState extends State<SelectInterests> {
  List<InterestsModel> selectedInterestList = [];
  bool selectInterest = false;
  @override
  void initState() {
    if (widget.signUpFlow == false) {
      GroupController.getInterests();
    }
    if (AuthController.currentUser!.interests == null) {
      AuthController.currentUser!.interests = [];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor:
          theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
      appBar: AppBar(
        backgroundColor: ColorRefer.kMainThemeColor,
        toolbarHeight: 60,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
                Platform.isIOS
                    ? Icons.arrow_back_ios_sharp
                    : Icons.arrow_back_rounded,
                color: Colors.white)),
        title: RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            text: "What are you interested in?",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Please select at least two interests',
                  style: TextStyle(
                      color: theme.lightTheme == true
                          ? Colors.black54
                          : Colors.white,
                      fontSize: 15,
                      fontFamily: FontRefer.Poppins,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Wrap(
                direction: Axis.horizontal,
                children: Constants.interestLists == null ||
                        Constants.interestLists!.length == 0
                    ? [Container()]
                    : Constants.interestLists!.map((e) {
                        return Wrap(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 5, bottom: 15),
                              child: InterestTabs(
                                theme: theme,
                                selected: AuthController.currentUser!.interests!
                                    .contains(e.id),
                                onTap: () {
                                  setState(() {
                                    if (AuthController.currentUser!.interests!
                                        .contains(e.id)) {
                                      AuthController.currentUser!.interests!
                                          .remove(e.id);
                                    } else {
                                      AuthController.currentUser!.interests!
                                          .add(e.id);
                                    }
                                  });
                                },
                                text: '${e.icon}  ${e.title}',
                              ),
                            ),
                          ],
                        );
                      }).toList(),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 40, 10, 20),
                child: CustomizedButton(
                    title: 'Select Interests',
                    buttonRadius: 5,
                    colour: ColorRefer.kMainThemeColor,
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    onPressed: () async {
                      if (AuthController.currentUser!.interests!.length <= 1) {
                        ToastContext().init(context);
                        Toast.show('Please select at least two interests',
                            duration: Toast.lengthLong, gravity: Toast.bottom);
                      } else {
                        await AuthController().updateUserFields();
                        ToastContext().init(context);
                        if (widget.signUpFlow == false) {
                          Toast.show('Updated',
                              duration: Toast.lengthLong,
                              gravity: Toast.bottom);
                          Navigator.pop(context);
                        } else {
                          Toast.show('Interests Selected',
                              duration: Toast.lengthLong,
                              gravity: Toast.bottom);
                          if (AuthController.currentUser!.joinDate == null) {
                            Get.to(() => SelectGradeScreen());
                          } else {
                            Get.to(() => ProfilePictureScreen());
                          }
                        }
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InterestTabs extends StatefulWidget {
  const InterestTabs(
      {required this.theme,
      required this.text,
      required this.selected,
      required this.onTap,
      Key? key})
      : super(key: key);

  final DarkThemeProvider theme;
  final String text;
  final bool selected;
  final Function onTap;
  @override
  State<InterestTabs> createState() => _InterestTabsState();
}

class _InterestTabsState extends State<InterestTabs> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap as void Function()?,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border(
            left: BorderSide(
                width: 1.0,
                color: widget.selected == true
                    ? ColorRefer.kMainThemeColor
                    : widget.theme.lightTheme == true
                        ? Colors.black54
                        : Colors.white),
            right: BorderSide(
                width: 1.0,
                color: widget.selected == true
                    ? ColorRefer.kMainThemeColor
                    : widget.theme.lightTheme == true
                        ? Colors.black54
                        : Colors.white),
            top: BorderSide(
                width: 1.0,
                color: widget.selected == true
                    ? ColorRefer.kMainThemeColor
                    : widget.theme.lightTheme == true
                        ? Colors.black54
                        : Colors.white),
            bottom: BorderSide(
                width: 1.0,
                color: widget.selected == true
                    ? ColorRefer.kMainThemeColor
                    : widget.theme.lightTheme == true
                        ? Colors.black54
                        : Colors.white),
          ),
        ),
        padding: EdgeInsets.all(10),
        child: Text(widget.text,
            style: TextStyle(
                fontSize: 13,
                color: widget.selected == true
                    ? ColorRefer.kMainThemeColor
                    : widget.theme.lightTheme == true
                        ? Colors.black54
                        : Colors.white)),
      ),
    );
  }
}
