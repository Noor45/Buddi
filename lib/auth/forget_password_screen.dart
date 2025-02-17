import 'dart:io';
import 'package:buddi/controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../widgets/input_field.dart';
import '../widgets/round_button.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const String ID = "forget_password_screen";
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  bool _isLoading = false;

  Future<void> _sendPasswordResetEmail() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    await AuthController().sendPasswordResetEmail(context, _email!);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List args = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    double width = MediaQuery.of(context).size.width;
    final  theme = Provider.of<DarkThemeProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: Theme(
        data: Theme.of(context).copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: ColorRefer.kMainThemeColor)),
        child: CircularProgressIndicator(),
      ),
      child: Scaffold(
        backgroundColor: theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            systemOverlayStyle: theme.lightTheme == true ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
            elevation: 0,
            leading: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Platform.isIOS ? Icons.arrow_back_ios_sharp : Icons.arrow_back_rounded, color: ColorRefer.kMainThemeColor)
         )
        ),
        body: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              AutoSizeText(
                'Enter your email below, We will send you password reset email.',
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                  fontSize: 15,
                  fontFamily: FontRefer.Poppins,
                ),
              ),
              SizedBox(height: 50),
              Form(
                key: _formKey,
                child: InputField(
                  textInputType: TextInputType.emailAddress,
                  hint: 'Enter your Email',
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
                  suffixText: args[1],
                  onChanged: (value) {
                    _email = (value+args[1]).toString().trim();
                  },
                ),
              ),
              SizedBox(height: 30),
              CustomizedButton(
                title: 'Send Email',
                buttonRadius: 5,
                colour: ColorRefer.kMainThemeColor,
                height: 45,
                width: width,
                onPressed: () => _sendPasswordResetEmail()
              ),
            ],
          ),
        ),
      ),
    );
  }
}
