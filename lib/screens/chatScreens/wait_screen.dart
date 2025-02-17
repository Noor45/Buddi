import 'dart:io';
import 'dart:math';
import 'package:buddi/controller/auth_controller.dart';
import 'package:buddi/controller/find_buddi_controller.dart';
import 'package:buddi/screens/chatScreens/chat_screen.dart';
import 'package:buddi/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';
import '../../models/avaliable_chat_model.dart';
import '../../utils/strings.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/round_button.dart';

class WaitingScreen extends StatefulWidget {
  static String waitingScreenID = "/waiting_screen";
  @override
  _WaitingScreenState createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> with TickerProviderStateMixin {
  bool saveAvailability = false;
  bool foundBuddi = false;
  saveBuddi() async {
    await FindBuddiController.saveAvailability(chatType: Constants.chatType, user: Constants.userType);
    setState((){
      saveAvailability = true;
    });
  }
  found(BuildContext context) async {
    if(saveAvailability == true){
      Constants.availableBuddiList.removeWhere((element) => element.uid == AuthController.currentUser!.uid);
      if (Constants.availableBuddiList.isNotEmpty == true) {
        Constants.selectedChatId = Constants.availableBuddiList[Random().nextInt(Constants.availableBuddiList.length)].uid;
        foundBuddi = true;
        await FindBuddiController.getBuddiData(Constants.selectedChatId);
        await FindBuddiController.deleteAvailability(AuthController.currentUser!.uid);
        await FindBuddiController.deleteAvailability(Constants.selectedChatId);
        if(mounted){
          setState(() {
            saveAvailability = false;
            print('enter into chat');
          });
          Get.back();
          Get.back();
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new ChatScreen()),
          );
        }
      }
    }
  }

  @override
  void initState() {
    saveBuddi();
    Future.delayed(Duration(seconds: 30), () async{
      if (foundBuddi == false) {
        ToastContext().init(context);
        Toast.show('No Buddi is available', duration: 3);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    if(saveAvailability == false) FindBuddiController.deleteAvailability(AuthController.currentUser!.uid);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final  theme = Provider.of<DarkThemeProvider>(context);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: theme.lightTheme == true
            ? Colors.white
            : ColorRefer.kBackColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: theme.lightTheme == true
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                  Platform.isIOS
                      ? Icons.arrow_back_ios_sharp
                      : Icons.arrow_back_rounded,
                  color: ColorRefer.kMainThemeColor)),
        ),
        body: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('available_buddi')
                .where('chat_type', isEqualTo: Constants.selectedChatType)
                .orderBy('created_at', descending: true).snapshots(),
            builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final buddies = snapshot.data!.docs;
                  try {
                    Constants.availableBuddiList = [];
                    for (var buddi in buddies) {
                      AvailableForChatModel availableForChat = AvailableForChatModel.fromMap(buddi.data() as Map<String, dynamic>);
                      Constants.availableBuddiList.add(availableForChat);
                      Constants.availableBuddiList.removeWhere((element) => element.uid == AuthController.currentUser!.uid);
                    }
                    found(context);
                  } catch (e) {
                    print(e);
                  }
                }
              return Column(
                children: [
                  Container(
                      width: width,
                      child: SvgPicture.asset(StringRefer.design,
                          width: width, fit: BoxFit.fitWidth)),
                  SizedBox(height: 40),
                  AutoSizeText(
                    'Searching for a Buddi!',
                    style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontRefer.PoppinsMedium,
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    child: SpinKitRing(
                      color: ColorRefer.kMainThemeColor,
                      size: 60.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(70, 30, 70, 0),
                    child: CustomizedButton(
                        title: 'Leave',
                        buttonRadius: 3,
                        colour: ColorRefer.kMainThemeColor,
                        height: 45,
                        width: width,
                        onPressed: () async {
                          if(foundBuddi == false){
                            AppDialog().showOSDialog(
                                context,
                                "Leave Buddi Search",
                                "Do you want to leave buddi search?",
                                "Yes",
                                    () {
                                  FindBuddiController.deleteAvailability(AuthController.currentUser!.uid);
                                  Navigator.pop(context);
                                },
                                secondButtonText: "Cancel", secondCallback: () {}
                            );
                          }
                        }
                    ),
                  )
                ],
              );
            }
          ),
        ));
  }
}
