import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddi/screens/chatScreens/wait_screen.dart';
import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/constants.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../controller/auth_controller.dart';
import '../../models/avaliable_chat_model.dart';
import 'chat_verification_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:toast/toast.dart';
import 'rating_screen.dart';
import 'package:buddi/widgets/timezone.dart';

class ChatOption extends StatefulWidget {
  static String chatOptionScreenID = "/chat_option";
  @override
  _ChatOptionState createState() => _ChatOptionState();
}

class _ChatOptionState extends State<ChatOption> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<AvailableForChatModel> availableBuddiList;
  int listeners = 0, users = 0;
  startChat() async {
    await Navigator.pushNamed(context, WaitingScreen.waitingScreenID);
  }

  int lastTap = DateTime.now().millisecondsSinceEpoch;
  int consecutiveTaps = 0;

  bool showCard() {
    bool value = false;
    DateTime now = DateTime.now().toESTzone();
    DateTime time(int time) {
      return DateTime(now.year, now.month, now.day, time, 00, 00).toESTzone();
    }

    DateTime startMorningTime = time(09), endMorningTime = time(14);
    DateTime startEveningTime = time(16), endEveningTime = time(22);

    if (now.isAfter(startMorningTime.subtract(Duration(minutes: 1))) &&
        now.isBefore(endMorningTime.subtract(Duration(minutes: 1))))
      value = true;

    if (now.isAfter(startEveningTime.subtract(Duration(minutes: 1))) &&
        now.isBefore(endEveningTime.subtract(Duration(minutes: 1))))
      value = true;

    return value;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor:
          theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
      appBar: AppBar(
        toolbarHeight: 90,
        elevation: 0,
        leadingWidth: 1,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 20),
            InkWell(
              onTap: () async {
                // FindBuddiController.removeChat('W4UZJObQr0bsg6lXo1CaRz1m8jw1_IaZX6igoc3dcrjneJENIgU8V36Q2');
                // FindBuddiController.setAvailability();
              },
              child: Text(
                'Live Chat',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20,
                  height: 0.8,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: FontRefer.PoppinsMedium,
                ),
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Find a Buddi to chat with!',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 16,
                fontFamily: FontRefer.Poppins,
                color: Colors.white,
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.transparent),
        backgroundColor: ColorRefer.kMainThemeColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('available_buddi')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            try {
              final availableBuddi = snapshot.data!.docs;
              availableBuddiList = [];
              users = 0;
              listeners = 0;
              for (var buddies in availableBuddi) {
                AvailableForChatModel buddiData = AvailableForChatModel.fromMap(
                    buddies.data() as Map<String, dynamic>);
                availableBuddiList.add(buddiData);
                availableBuddiList.removeWhere((element) =>
                    element.uid == AuthController.currentUser!.uid);
              }
              availableBuddiList.forEach((element) {
                switch (element.chatType) {
                  case 0:
                    users++;
                    break;
                  case 2:
                    listeners++;
                    break;
                }
              });
            } catch (e) {
              print(e);
            }
          }
          return Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 38),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    color: theme.lightTheme == false
                        ? ColorRefer.kBoxColor
                        : Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width,
                            child: InkWell(
                              onTap: () async {
                                await showDialog(
                                  context: context,
                                  useSafeArea: false,
                                  barrierColor: theme.lightTheme == true
                                      ? ColorRefer.kBackColor.withOpacity(0.96)
                                      : ColorRefer.kBackColor.withOpacity(0.86),
                                  builder: (BuildContext context) {
                                    return MeetSomeonePopup();
                                  },
                                );
                              },
                              child: Icon(
                                Icons.info_outline,
                                color: ColorRefer.kFeroziColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          AutoSizeText(
                            'Live Random Chat',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: theme.lightTheme == true
                                  ? Colors.black54
                                  : Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          AutoSizeText(
                            'Live text chat with another student',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.5,
                              color: theme.lightTheme == true
                                  ? ColorRefer.kHintColor
                                  : ColorRefer.kLightGreyColor,
                            ),
                          ),
                          SizedBox(height: 20),
                          MaterialButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                useSafeArea: false,
                                barrierColor: theme.lightTheme == true
                                    ? ColorRefer.kBackColor.withOpacity(0.30)
                                    : ColorRefer.kBackColor.withOpacity(0.30),
                                builder: (BuildContext context) {
                                  return PreChatAgreement(
                                    onPressed: () async {
                                      setState(() {
                                        Constants.userType = 0; //students
                                        Constants.chatType = 0;
                                        Constants.availableBuddiList = [];
                                        Constants.selectedChatType = 0;
                                        Constants.selectedChatId = '';
                                        Constants.chatAsListener = false;
                                      });
                                      await startChat();
                                      // Navigator.of(context).pop();
                                    },
                                  );
                                },
                              );
                            },
                            minWidth: MediaQuery.of(context).size.width / 1.5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            highlightElevation: 0,
                            height: 50,
                            elevation: 0,
                            color: ColorRefer.kFeroziColor,
                            child: Text(
                              'Chat Now',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: FontRefer.Poppins),
                            ),
                          ),
                          SizedBox(height: 12),
                          Center(
                            child: AutoSizeText(
                              '$users Buddies Online',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: FontRefer.Poppins,
                                  color: ColorRefer.kFeroziColor),
                            ),
                          ),
                          SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  showCard() == true
                      ? Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 10,
                          color: theme.lightTheme == false
                              ? ColorRefer.kBoxColor
                              : Colors.white,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 15, 15, 4),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerRight,
                                      width: MediaQuery.of(context).size.width,
                                      child: InkWell(
                                        onTap: () async {
                                          await showDialog(
                                            context: context,
                                            useSafeArea: false,
                                            barrierColor:
                                                theme.lightTheme == true
                                                    ? ColorRefer.kBackColor
                                                        .withOpacity(0.96)
                                                    : ColorRefer.kBackColor
                                                        .withOpacity(0.86),
                                            builder: (BuildContext context) {
                                              return ClearYourMindPopup();
                                            },
                                          );
                                        },
                                        child: Icon(
                                          Icons.info_outline,
                                          color: ColorRefer.kMainThemeColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    AutoSizeText(
                                      'Peer-to-Peer Support',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: theme.lightTheme == true
                                            ? Colors.black54
                                            : Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    AutoSizeText(
                                      'Get paired with a student listener to vent, express your thoughts, or clear your mind.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: theme.lightTheme == true
                                            ? ColorRefer.kHintColor
                                            : ColorRefer.kLightGreyColor,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    MaterialButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          useSafeArea: false,
                                          barrierColor: theme.lightTheme == true
                                              ? ColorRefer.kBackColor
                                                  .withOpacity(0.30)
                                              : ColorRefer.kBackColor
                                                  .withOpacity(0.30),
                                          builder: (BuildContext context) {
                                            return PreChatAgreement(
                                              onPressed: () async {
                                                setState(() {
                                                  Constants.userType =
                                                      0; //students
                                                  Constants.chatType = 1;
                                                  Constants.availableBuddiList =
                                                      [];
                                                  Constants.selectedChatType =
                                                      2;
                                                  Constants.chatAsListener =
                                                      false;
                                                  Constants.selectedChatId = '';
                                                });
                                                await startChat();
                                                // Navigator.of(context).pop();
                                              },
                                            );
                                          },
                                        );
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      highlightElevation: 0,
                                      height: 50,
                                      elevation: 0,
                                      color: ColorRefer.kMainThemeColor,
                                      minWidth:
                                          MediaQuery.of(context).size.width /
                                              1.5,
                                      child: Text(
                                        'Clear Your Mind',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: FontRefer.Poppins),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Center(
                                      child: AutoSizeText(
                                        '$listeners Listeners Online',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: FontRefer.Poppins,
                                            color: ColorRefer.kMainThemeColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(color: Colors.grey),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 8, 0, 15),
                                child: AutoSizeText(
                                  'Monday - Thursday\n9am - 2pm EST & 4pm - 10pm EST',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: theme.lightTheme == true
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 15,
                                    fontFamily: FontRefer.Poppins,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(),
                  SizedBox(height: 25),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () async {
                      ToastContext().init(context);
                      int now = DateTime.now().millisecondsSinceEpoch;
                      if (now - lastTap < 1000) {
                        consecutiveTaps++;
                        if (consecutiveTaps >= 3) {
                          await showDialog(
                            context: context,
                            useSafeArea: false,
                            barrierColor: theme.lightTheme == true
                                ? ColorRefer.kBackColor.withOpacity(0.40)
                                : ColorRefer.kBackColor.withOpacity(0.40),
                            builder: (BuildContext context) {
                              return VerificationPopup();
                            },
                          );
                        }
                      } else {
                        consecutiveTaps = 0;
                      }
                      lastTap = now;
                    },
                    child: AutoSizeText(
                      'Want to become a listener?\nReach out to Buddi support!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.lightTheme == true
                            ? Colors.black54
                            : Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontFamily: FontRefer.Poppins,
                      ),
                    ),
                  ),
                  SizedBox(height: 38),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
