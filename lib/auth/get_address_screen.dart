import 'package:buddi/auth/username_screen.dart';
import 'package:buddi/controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import 'dart:io';
import '../utils/strings.dart';
import '../utils/theme_model.dart';
import '../widgets/input_field.dart';
import '../widgets/round_button.dart';
import 'package:provider/provider.dart';

class GetAddressScreen extends StatefulWidget {
  GetAddressScreen({this.image, this.signUpFlow = true});
  final bool signUpFlow;
  final File? image;
  @override
  _GetAddressScreenState createState() => _GetAddressScreenState();
}

class _GetAddressScreenState extends State<GetAddressScreen> {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool newUser = false;
  String? _address;
  String? selectedValue = '';

  TextEditingController controller = TextEditingController();

  _nextScreen() {
    if (widget.signUpFlow == false) {
      Get.to(() => UsernameScreen(image: widget.image, signUpFlow: false));
    } else {
      Get.to(() => UsernameScreen(image: widget.image));
    }
  }

  @override
  void initState() {
    if (AuthController.currentUser?.liveOnCampus == false) {
      selectedValue = 'No';
      _address = AuthController.currentUser?.address;
      controller.text = _address!;
    }
    if (AuthController.currentUser?.liveOnCampus == true) {
      selectedValue = 'Yes';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    double width = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator:
          CircularProgressIndicator(color: ColorRefer.kMainThemeColor),
      child: Scaffold(
        backgroundColor:
            theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
        appBar: AppBar(
          backgroundColor: ColorRefer.kMainThemeColor,
          elevation: 0,
          title: Text(
            'Where do you live',
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
            padding: EdgeInsets.only(left: 20, right: 20),
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
                            )
                          : AuthController.currentUser!.profileImageUrl != null
                              ? FadeInImage.assetNetwork(
                                  placeholder: StringRefer.user,
                                  image: AuthController
                                      .currentUser!.profileImageUrl!,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  StringRefer.profileImage,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.fill,
                                ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: AutoSizeText(
                        "During the semester, do you live on-campus?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.lightTheme == true
                              ? Colors.black54
                              : Colors.white,
                          fontSize: 14,
                          fontFamily: FontRefer.Poppins,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SelectBox(
                      label: selectedValue!.isEmpty
                          ? 'Choose option'
                          : selectedValue!,
                      selectionList: ['Yes', 'No'],
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    selectedValue == 'No'
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 30),
                            child: InputField(
                              textInputType: TextInputType.text,
                              hint: 'Address',
                              suffixText: '',
                              controller: controller,
                              icon: CupertinoIcons.home,
                              validator: (name) {
                                if (name.isEmpty) return "Address is required";
                              },
                              onChanged: (value) => _address = value,
                            ),
                          )
                        : Container(),
                    CustomizedButton(
                        title: 'Continue',
                        buttonRadius: 5,
                        colour: selectedValue!.isNotEmpty
                            ? ColorRefer.kMainThemeColor
                            : ColorRefer.kMainThemeColor.withOpacity(0.5),
                        height: 45,
                        width: width,
                        onPressed: () async {
                          if (selectedValue == 'No') {
                            if (!formKey.currentState!.validate()) return;
                            formKey.currentState!.save();
                            AuthController.currentUser!.address = _address;
                            AuthController.currentUser!.liveOnCampus = false;
                            setState(() {
                              _isLoading = true;
                            });
                            await AuthController().updateUserFields();
                            setState(() {
                              _isLoading = false;
                            });
                            _nextScreen();
                          } else {
                            AuthController.currentUser!.address = null;
                            AuthController.currentUser!.liveOnCampus = true;
                            setState(() {
                              _isLoading = true;
                            });
                            await AuthController().updateUserFields();
                            setState(() {
                              _isLoading = false;
                            });
                            _nextScreen();
                          }
                        }),
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

class SelectBox extends StatefulWidget {
  SelectBox(
      {required this.label, this.selectionList, this.onChanged, this.value});
  final String label;
  final List<String>? selectionList;
  final Function? onChanged;
  final String? value;
  @override
  _SelectBoxState createState() => _SelectBoxState();
}

class _SelectBoxState extends State<SelectBox> {
  final _focusNode = FocusNode();
  Color focusColor = ColorRefer.kHintColor;
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus == false) {
        setState(() {
          focusColor = ColorRefer.kHintColor;
        });
      } else {
        setState(() {
          focusColor = ColorRefer.kMainThemeColor;
        });
      }
    });
  }

  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButton<String>(
        itemHeight: 70.0,
        isExpanded: true,
        focusColor: Colors.transparent,
        dropdownColor:
            theme.lightTheme == true ? Colors.white : Color(0xff28282B),
        value: widget.value!.isNotEmpty ? widget.value : null,
        focusNode: _focusNode,
        onChanged: widget.onChanged as void Function(String?)?,
        icon: Icon(
          Icons.expand_more_outlined,
          color: focusColor,
        ),
        hint: Text(
          widget.label,
          style: TextStyle(fontSize: 14, color: focusColor),
        ),
        underline: Container(
          height: 2,
          color: focusColor,
        ),
        items:
            widget.selectionList?.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(color: focusColor)),
          );
        }).toList(),
      ),
    );
  }
}
