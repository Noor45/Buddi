import 'dart:io';
import 'package:buddi/controller/auth_controller.dart';
import 'package:buddi/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'forget_password_screen.dart';
import 'signup_screen.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../widgets/input_field.dart';
import '../widgets/round_button.dart';

class SignInScreen extends StatefulWidget {
  static String signInScreenID = "/sign_in_screen";
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  String? _email;
  late String _password;
  bool _isLoading = false;
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
            'Login',
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
                        StringRefer.artwork10,
                        width: width / 1.5,
                      ),
                      SizedBox(height: 20),
                      AutoSizeText(
                        "Please enter your email and password.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.lightTheme == true
                              ? Colors.black54
                              : Colors.white,
                          fontSize: 13,
                          fontFamily: FontRefer.Poppins,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        child: Constants.testingMode == false
                            ? InputField(
                                controller: emailTextController,
                                textInputType: TextInputType.emailAddress,
                                hint: 'Enter Email',
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
                                icon: CupertinoIcons.envelope,
                                suffixText: args![1],
                                onChanged: (value) {
                                  _email = (value + args[1]).toString().trim();
                                  print(_email);
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
                                icon: CupertinoIcons.envelope,
                                suffixText: '',
                                onChanged: (value) {
                                  _email = value.trim();
                                  print(_email);
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
                          return null;
                        },
                        onChanged: (value) => _password = value,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            'Forget Password?',
                            style: TextStyle(
                                color: ColorRefer.kHintColor,
                                fontSize: 13,
                                fontFamily: FontRefer.Poppins,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(width: 5),
                          InkWell(
                            onTap: () => Navigator.pushNamed(
                                context, ForgetPasswordScreen.ID,
                                arguments: args),
                            child: AutoSizeText(
                              'Click here',
                              style: TextStyle(
                                  color: ColorRefer.kOrangeColor,
                                  fontSize: 13,
                                  fontFamily: FontRefer.Poppins,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
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
                            title: 'Login',
                            buttonRadius: 5,
                            colour: ColorRefer.kMainThemeColor,
                            height: 45,
                            width: width,
                            onPressed: () async {
                              if (!formKey.currentState!.validate()) return;
                              formKey.currentState!.save();
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                _isLoading = true;
                              });
                              await AuthController().loginWithCredentials(
                                  context, _email!, _password);
                              setState(() {
                                _isLoading = false;
                              });
                            }),
                        SizedBox(height: 12),
                        CustomizedButton(
                            title: 'Not on Buddi? Create an Account',
                            buttonRadius: 5,
                            colour: ColorRefer.kFeroziColor,
                            height: 45,
                            width: width,
                            onPressed: () async {
                              Navigator.pushNamed(
                                  context, SignUpScreen.signUpScreenID,
                                  arguments: args);
                            }),
                        SizedBox(height: 30),
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
