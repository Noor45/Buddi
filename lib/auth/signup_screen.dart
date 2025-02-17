import 'dart:io';
import 'package:buddi/models/user_model.dart';
import 'package:buddi/screens/settingScreens/support.dart';
import 'package:buddi/screens/settingScreens/term_condition.dart';
import 'package:buddi/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';
import '../controller/group_controller.dart';
import 'select_interest.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../utils/constants.dart';
import '../widgets/input_field.dart';
import '../widgets/round_button.dart';
import 'package:buddi/controller/auth_controller.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUpScreen extends StatefulWidget {
  static String signUpScreenID = "/sign_up_screen";
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  late String _password;
  bool _isLoading = false;
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
  Future<void> _signUp(String uniName) async {
    if (!formKey.currentState!.validate()) return;
    if (Constants.checkedValue == false) {
      ToastContext().init(context);

      Toast.show('Accept the term and conditions',
          duration: Toast.lengthLong, gravity: Toast.bottom);
      return;
    }
    if (selectedGrades == 'Select your grade level') {
      ToastContext().init(context);

      Toast.show('Please select goal level',
          duration: Toast.lengthLong, gravity: Toast.bottom);
      return;
    }
    setState(() {
      _isLoading = true;
    });
    formKey.currentState!.save();
    AuthController.currentUser = UserModel(email: _email, name: _name);
    bool success = await AuthController()
        .signupWithCredentials(context, uniName, _password, selectedGrades);
    setState(() {
      _isLoading = false;
    });
    if (success) {
      ToastContext().init(context);
      Toast.show("Account Created Successfully",
          duration: Toast.lengthLong, gravity: Toast.bottom);
      await GroupController.getInterests();
      Get.to(() => SelectInterests());
    }
  }

  final emailTextController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    emailTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    double width = MediaQuery.of(context).size.width;
    List? args = ModalRoute.of(context)!.settings.arguments as List<dynamic>?;
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator:
          CircularProgressIndicator(color: ColorRefer.kMainThemeColor),
      child: Scaffold(
        backgroundColor:
            theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorRefer.kMainThemeColor,
          title: Text(
            'Join Buddi',
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
                  color: Colors.white)),
        ),
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 10, right: 10),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(StringRefer.artwork10,
                              width: width / 2, height: width / 2),
                          InputField(
                            textInputType: TextInputType.name,
                            hint: 'Enter Your Name',
                            suffixText: '',
                            icon: CupertinoIcons.person,
                            formatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[a-zA-Z0-9 ]'))
                            ],
                            validator: (name) {
                              if (name.isEmpty) return "Your name is required";
                              if (name.length < 3)
                                return "Minimum three characters required";
                            },
                            onChanged: (value) => _name = value,
                          ),
                          SizedBox(height: 8),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Your name is safe with us! It will not be displayed.',
                              style: TextStyle(
                                  fontSize: 9,
                                  fontFamily: FontRefer.Poppins,
                                  color: ColorRefer.kHintColor),
                            ),
                          ),
                          SizedBox(height: 10),
                          SelectionBox(
                              label: selectedGrades,
                              value: selectedGrades,
                              selectionList: grades,
                              onChanged: (value) {
                                setState(() {
                                  if (value != 'Select your grade level')
                                    selectedGrades = value;
                                });
                              }),
                          SizedBox(height: 10),
                          Container(
                            child: Constants.testingMode == false
                                ? InputField(
                                    controller: emailTextController,
                                    textInputType: TextInputType.emailAddress,
                                    hint: 'Enter Email',
                                    icon: CupertinoIcons.envelope,
                                    validator: (String? emailValue) {
                                      if (_email?.isEmpty ?? true)
                                        return 'Email is required';
                                      else {
                                        String p =
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                                        RegExp regExp = new RegExp(p);
                                        if (regExp.hasMatch((_email ?? "")))
                                          return null;
                                        else
                                          return 'Email Syntax is not Correct';
                                      }
                                    },
                                    suffixText: args![1],
                                    onChanged: (value) {
                                      _email =
                                          (value + args[1]).toString().trim();
                                      final trimVal = value.trim();
                                      if (value != trimVal)
                                        setState(() {
                                          emailTextController.text = trimVal;
                                          emailTextController.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: trimVal.length));
                                        });
                                    },
                                  )
                                : InputField(
                                    controller: emailTextController,
                                    textInputType: TextInputType.emailAddress,
                                    hint: 'Enter Email',
                                    icon: CupertinoIcons.envelope,
                                    validator: (String? emailValue) {
                                      if (emailValue?.isEmpty ?? true)
                                        return 'Email is required';
                                      else {
                                        String p =
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                                        RegExp regExp = new RegExp(p);
                                        if (regExp.hasMatch((emailValue ?? "")))
                                          return null;
                                        else
                                          return 'Email Syntax is not Correct';
                                      }
                                    },
                                    suffixText: '',
                                    onChanged: (value) {
                                      _email = value.trim();
                                      final trimVal = value.trim();
                                      if (value != trimVal)
                                        setState(() {
                                          emailTextController.text = trimVal;
                                          emailTextController.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: trimVal.length));
                                        });
                                    },
                                  ),
                          ),
                          SizedBox(height: 15),
                          PasswordField(
                            hint: 'Enter Password',
                            icon: CupertinoIcons.lock,
                            textInputType: TextInputType.text,
                            obscureText: true,
                            validator: (String? password) {
                              if (password?.isEmpty ?? true)
                                return "Password is required!";
                              if ((password ?? "").length < 6)
                                return "Minimum 6 characters are required";
                              return null;
                            },
                            onChanged: (value) => _password = value,
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 20, top: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor: theme.lightTheme == true
                                    ? ColorRefer.kHintColor
                                    : Colors.white,
                              ),
                              child: Checkbox(
                                value: Constants.checkedValue,
                                activeColor: ColorRefer.kOrangeColor,
                                onChanged: (bool? value) async {
                                  setState(() {
                                    Constants.checkedValue =
                                        !Constants.checkedValue;
                                  });
                                },
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.only(top: 10),
                              child: RichText(
                                softWrap: true,
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: 'I’ve read and agree with the ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: FontRefer.Poppins,
                                            height: 1.5,
                                            color: theme.lightTheme == true
                                                ? Colors.black
                                                : Colors.white)),
                                    TextSpan(
                                        text: 'Terms of Service',
                                        style: TextStyle(
                                          color: ColorRefer.kOrangeColor,
                                          fontSize: 12,
                                          fontFamily: FontRefer.Poppins,
                                          height: 1.5,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushNamed(
                                                context,
                                                TermConditionScreen
                                                    .termConditionID);
                                          }),
                                    TextSpan(
                                        text: ' and our ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: FontRefer.Poppins,
                                            height: 1.5,
                                            color: theme.lightTheme == true
                                                ? Colors.black
                                                : Colors.white)),
                                    TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                          color: ColorRefer.kOrangeColor,
                                          fontSize: 12,
                                          fontFamily: FontRefer.Poppins,
                                          height: 1.5,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushNamed(context,
                                                SupportScreen.supportID);
                                          }),
                                    TextSpan(
                                        text:
                                            ' and will act responsibly in accordance with our ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: FontRefer.Poppins,
                                            height: 1.5,
                                            color: theme.lightTheme == true
                                                ? Colors.black
                                                : Colors.white),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushNamed(context,
                                                SupportScreen.supportID);
                                          }),
                                    TextSpan(
                                        text: 'Community Guidelines',
                                        style: TextStyle(
                                          color: ColorRefer.kOrangeColor,
                                          fontSize: 12,
                                          fontFamily: FontRefer.Poppins,
                                          height: 1.5,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushNamed(context,
                                                SupportScreen.supportID);
                                          }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: width,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 15),
                          CustomizedButton(
                              title: 'Create Account',
                              buttonRadius: 5,
                              colour: ColorRefer.kMainThemeColor,
                              height: 45,
                              width: width,
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                _signUp(args![0]);
                              }),
                          SizedBox(height: 20),
                          CustomizedButton(
                              title: 'Already on Buddi? Login Here',
                              buttonRadius: 5,
                              colour: ColorRefer.kFeroziColor,
                              height: 45,
                              width: width,
                              onPressed: () async {
                                Navigator.pop(context);
                              }),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
