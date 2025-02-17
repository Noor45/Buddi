import 'dart:io';
import 'package:buddi/auth/profile_picture_screen.dart';
import 'package:buddi/utils/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:toast/toast.dart';
import '../controller/auth_controller.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../widgets/input_field.dart';
import '../widgets/round_button.dart';

class SelectGradeScreen extends StatefulWidget {
  static String selectGradeID = "/select_grade_screen";
  @override
  _SelectGradeScreenState createState() => _SelectGradeScreenState();
}

class _SelectGradeScreenState extends State<SelectGradeScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  String selectedGrades = 'Select your grade level';
  List<String> grades = [
    'Select your grade level',
    'Freshman',
    'Sophomore',
    'Junior',
    'Senior',
    'Graduate',
    'Alumni'
  ];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final  theme = Provider.of<DarkThemeProvider>(context);
    double width = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: CircularProgressIndicator(color: ColorRefer.kMainThemeColor),
      child: Scaffold(
        backgroundColor: theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorRefer.kMainThemeColor,
          title: Text(
            'Select Grade',
            style: TextStyle(
              fontSize: 20,
              fontFamily: FontRefer.Poppins,
              color: Colors.white,
            ),
          ),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                  Platform.isIOS
                      ? Icons.arrow_back_ios_sharp
                      : Icons.arrow_back_rounded,
                  color: Colors.white)
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        StringRefer.artwork6,
                      ),
                      SizedBox(height: 20),
                      AutoSizeText(
                        "Please Select your grade level",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                          fontSize: 13,
                          fontFamily: FontRefer.Poppins,
                        ),
                      ),
                      SizedBox(height: 20),
                      SelectionBox(
                          label: selectedGrades,
                          value: selectedGrades,
                          selectionList: grades,
                          onChanged: (value) {
                            setState(() {
                              if (value != 'Select your grade level')
                                selectedGrades = value;
                            });
                          }
                      ),
                    ],
                  ),
                  Container(
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        CustomizedButton(
                            title: 'Continue',
                            buttonRadius: 5,
                            colour: ColorRefer.kMainThemeColor,
                            height: 45,
                            width: width,
                            onPressed: () async {
                              if (selectedGrades == 'Select your grade level') {
                                ToastContext().init(context);
                                Toast.show('Please select goal level',
                                    duration: Toast.lengthLong, gravity: Toast.bottom);
                                return;
                              } else{
                                setState(() {_isLoading = true;});
                                AuthController.currentUser!.selectGrade = selectedGrades;
                                AuthController.currentUser!.joinDate = Timestamp.fromDate(
                                  DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day));
                                ToastContext().init(context);
                                Toast.show('Updated', duration: Toast.lengthLong, gravity: Toast.bottom);
                                await AuthController().updateUserFields();
                                setState(() {_isLoading = false;});
                                Get.to(()=> ProfilePictureScreen());
                              }
                            }
                        ),
                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
