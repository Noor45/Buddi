import 'dart:io';
import 'package:toast/toast.dart';
import 'package:username_gen/username_gen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:flutter/services.dart';
import '../screens/mainScreens/main_screen.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../utils/strings.dart';
import '../widgets/dialogs.dart';
import '../widgets/input_field.dart';
import '../widgets/round_button.dart';
import 'package:buddi/controller/auth_controller.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UsernameScreen extends StatefulWidget {
  UsernameScreen({this.image, this.signUpFlow = true});
  final bool signUpFlow;
  final File? image;
  @override
  _UsernameScreenState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool newUser = false;
  String? _username;
  TextEditingController controller = TextEditingController();

  assignUsername(){
    controller.text = AuthController.currentUser!.username == null ? '' : AuthController.currentUser!.username!;
    _username = AuthController.currentUser!.username;
  }

  @override
  void initState() {
    if (AuthController.currentUser!.createdAt!.toDate().day == DateTime.now().day) {
      if (AuthController.currentUser!.username == null)
        newUser = true;
      else assignUsername();
    }else{
      assignUsername();
    }
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
          backgroundColor: ColorRefer.kMainThemeColor,
          title: Text(
            'Username',
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
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 25, right: 25),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: widget.image != null
                          ? Image.file(
                        widget.image!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ) : AuthController.currentUser!.profileImageUrl != null
                          ? FadeInImage.assetNetwork(
                        placeholder: StringRefer.user,
                        image: AuthController.currentUser!.profileImageUrl!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ) : Image.asset(
                        StringRefer.profileImage,
                        width: 150,
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(height: 20),
                    AutoSizeText(
                      "Last, but not least, let’s get you a username!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                        fontSize: 14,
                        fontFamily: FontRefer.Poppins,
                      ),
                    ),
                    SizedBox(height: 20),
                    AutoSizeText(
                      "Select the “random” button to have one generated for you or you can create your own!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                        fontSize: 14,
                        fontFamily: FontRefer.Poppins,
                      ),
                    ),
                    SizedBox(height: 25),
                    InputField(
                      textInputType: TextInputType.name,
                      hint: 'Username',
                      suffixText: '',
                      controller: controller,
                      icon: CupertinoIcons.at,
                      formatter: [
                        FilteringTextInputFormatter.allow(
                            RegExp('[a-zA-Z0-9]'))
                      ],
                      validator: (name) {
                        if (name.isEmpty) return "Username is required";
                        if (name.length < 3)
                          return "Minimum three characters required";
                      },
                      onChanged: (value) => _username = value,
                    ),
                    SizedBox(height: 25),
                    CustomizedButton(
                        title: 'Random Username',
                        buttonRadius: 5,
                        colour: ColorRefer.kMainThemeColor,
                        height: 45,
                        width: width,
                        onPressed: () async {
                          setState(() {
                            _username = UsernameGen().generate();
                            controller.text = _username!;
                          });
                        }
                    ),
                    SizedBox(height: 20),
                    CustomizedButton(
                        title: 'Finish',
                        buttonRadius: 5,
                        colour: ColorRefer.kFeroziColor,
                        height: 45,
                        width: width,
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;
                          formKey.currentState!.save();
                          bool verify = await AuthController().usernameCheck(_username);
                          if(verify == true){
                            AuthController.currentUser!.username = _username;
                            setState(() {_isLoading = true;});
                            if (newUser == true) {
                              await AuthController().updateUserFields();
                              setState(() {_isLoading = false;});
                              AppDialog().showOSDialog(
                                  context,
                                  "Success",
                                  "Your account created successfully, Please verify your email and try to sign in.",
                                  "OK", () {
                                Navigator.pop(context);Navigator.pop(context);
                                Navigator.pop(context);Navigator.pop(context);
                                Navigator.pop(context);
                              });
                            } else {
                              await AuthController().updateUserFields();
                              setState(() {_isLoading = false;});
                              if(widget.signUpFlow == false){
                                ToastContext().init(context);
                                Toast.show('Updated', duration: Toast.lengthLong, gravity: Toast.bottom);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }else{
                                Navigator.pushNamedAndRemoveUntil(context, MainScreen.MainScreenId,  (Route<dynamic> route) => false);
                              }
                            }
                          }else{
                            FocusScope.of(context).requestFocus(FocusNode());
                            ToastContext().init(context);
                            Toast.show('Username already exist.', duration: Toast.lengthLong, gravity: Toast.bottom);
                          }

                        }
                    ),
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
