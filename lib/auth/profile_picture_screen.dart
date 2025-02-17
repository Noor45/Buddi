import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../utils/strings.dart';
import '../widgets/ImagePicker.dart';
import '../widgets/round_button.dart';
import 'package:buddi/controller/auth_controller.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'get_address_screen.dart';

class ProfilePictureScreen extends StatefulWidget {
  ProfilePictureScreen({this.signUpFlow = true});
  final bool signUpFlow;
  @override
  _ProfilePictureScreenState createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  final formKey = GlobalKey<FormState>();
  File? image;
  bool newUser = false;
  bool _isLoading = false;
  final picker = ImagePicker();

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
            'Profile Picture',
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
            padding: EdgeInsets.only(left: 23, right: 23),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(90),
                    child: image != null
                        ? Image.file(
                            image!,
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
                  AutoSizeText(
                    "Upload a profile photo!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.lightTheme == true
                          ? Colors.black54
                          : Colors.white,
                      fontSize: 14,
                      fontFamily: FontRefer.Poppins,
                    ),
                  ),
                  SizedBox(height: 20),
                  AutoSizeText(
                    "If photos aren’t your thing, there is not pressure to have one. We will fill in your profile with a default photo.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.lightTheme == true
                          ? Colors.black54
                          : Colors.white,
                      fontSize: 14,
                      fontFamily: FontRefer.Poppins,
                    ),
                  ),
                  SizedBox(height: 25),
                  CustomizedButton(
                      title: 'Upload Photo',
                      buttonRadius: 5,
                      colour: ColorRefer.kMainThemeColor,
                      height: 45,
                      width: width,
                      onPressed: () async {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return CameraGalleryBottomSheet(
                                cameraClick: () =>
                                    pickImage(ImageSource.camera),
                                galleryClick: () =>
                                    pickImage(ImageSource.gallery),
                              );
                            });
                      }),
                  SizedBox(height: 20),
                  CustomizedButton(
                      title: 'Continue',
                      buttonRadius: 5,
                      colour: ColorRefer.kFeroziColor,
                      height: 45,
                      width: width,
                      onPressed: () async {
                        if (image != null) {
                          setState(() {
                            _isLoading = true;
                          });
                          await AuthController().updateUserImages(image);
                          setState(() {
                            _isLoading = false;
                          });
                          ToastContext().init(context);
                          Toast.show('Image saved', duration: 2);
                          Get.to(() => GetAddressScreen(image: image));
                        } else {
                          if (widget.signUpFlow == false) {
                            Get.to(() => GetAddressScreen(
                                image: image, signUpFlow: false));
                          } else {
                            Get.to(() => GetAddressScreen(image: image));
                          }
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void pickImage(ImageSource imageSource) async {
    XFile? galleryImage =
        await picker.pickImage(source: imageSource, imageQuality: 40);
    setState(() {
      image = File(galleryImage!.path);
    });
  }
}
