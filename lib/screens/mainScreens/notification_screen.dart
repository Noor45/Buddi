import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddi/cards/notification_card.dart';
import 'package:buddi/controller/auth_controller.dart';
import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:buddi/widgets/delete_post_sheet.dart';
import 'package:buddi/widgets/time_ago.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../utils/strings.dart';

class NotificationScreen extends StatefulWidget {
  static String notificationScreenID = "/notification_screen";
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  bool isLoadingVertical = false;
  Stream<QuerySnapshot>? query;
  int limit = 20;
  Future _loadMoreVertical() async {
    () async {
      setState(() {
        isLoadingVertical = true;
        limit = limit + 10;
        query = _firestore
            .collection('notifications')
            .where('user_id', isEqualTo: AuthController.currentUser!.uid)
            .snapshots();
      });
      await new Future.delayed(const Duration(seconds: 2));
      setState(() {
        isLoadingVertical = false;
      });
    }();
  }

  @override
  void initState() {
    query = _firestore
        .collection('notifications')
        .where('user_id', isEqualTo: AuthController.currentUser!.uid)
        .snapshots();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    var formatter = new DateFormat('dd-MM-yyyy h:mma');
    return Scaffold(
      backgroundColor:
          theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
      appBar: AppBar(
        backgroundColor: ColorRefer.kMainThemeColor,
        toolbarHeight: 70,
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
        title: Row(
          children: [
            SvgPicture.asset(
              StringRefer.notificationBell,
              width: 35,
              height: 35,
            ),
            SizedBox(width: 10),
            Text('Notifications',
                style: TextStyle(
                    fontFamily: FontRefer.PoppinsMedium,
                    fontSize: 20,
                    color: Colors.white)),
          ],
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Container(
            child: LazyLoadScrollView(
          isLoading: isLoadingVertical,
          scrollOffset: 20,
          onEndOfPage: () => _loadMoreVertical(),
          child: ListView(
            children: [
              SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                  stream: query,
                  builder: (context, snapshot) {
                    List notificationsList = [];
                    if (snapshot.hasData) {
                      try {
                        notificationsList = snapshot.data!.docs;
                        notificationsList.reversed;
                      } catch (e) {
                        print(e);
                      }
                    }
                    return notificationsList.length == 0
                        ? Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height / 1.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.bell,
                                  color: ColorRefer.kGreyColor,
                                  size: 50,
                                ),
                                SizedBox(height: 6),
                                AutoSizeText(
                                  'No notifications yet',
                                  style: TextStyle(
                                      color: ColorRefer.kGreyColor,
                                      fontFamily: FontRefer.PoppinsMedium,
                                      fontSize: 20),
                                )
                              ],
                            ),
                          )
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            reverse: true,
                            itemCount: notificationsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              var value = notificationsList[index]['notify_by'];
                              return Column(
                                children: [
                                  NotificationSection(
                                    emojiIndex: value["emojiIndex"],
                                    profileImage: value['profileImage'],
                                    isCommentNotify: notificationsList[index]
                                                ['notify_for'] ==
                                            'comment'
                                        ? true
                                        : false,
                                    isReactionNotify: notificationsList[index]
                                                ['notify_for'] ==
                                            'like'
                                        ? true
                                        : false,
                                    read: true,
                                    commentString: notificationsList[index]
                                                ['notify_for'] ==
                                            'comment'
                                        ? notificationsList[index]
                                            ['notification']
                                        : '',
                                    post: ' “' +
                                        notificationsList[index]['post'] +
                                        '”',
                                    time: TimeAgo.timeAgoSinceDate(
                                        formatter.format(
                                            notificationsList[index]
                                                    ['created_at']
                                                .toDate()),
                                        true),
                                    reactedString: notificationsList[index]
                                                ['notify_for'] ==
                                            'like'
                                        ? notificationsList[index]
                                            ['notification']
                                        : '',
                                  ),
                                  SizedBox(height: 12),
                                ],
                              );
                            },
                          );
                  }),
              isLoadingVertical == true
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: ColorRefer.kMainThemeColor,
                      ),
                    )
                  : SizedBox(
                      width: 0,
                      height: 0,
                    ),
              SizedBox(height: 50),
            ],
          ),
        )),
      ),
    );
  }

  showEditDialogBox({Function? onDelete}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        context: context,
        builder: (context) {
          return DeletePostBottomSheet(onDelete: onDelete);
        });
  }
}
