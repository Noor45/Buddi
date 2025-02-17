import 'package:buddi/controller/auth_controller.dart';
import 'package:buddi/controller/post_controller.dart';
import 'package:buddi/models/post_model.dart';
import 'package:buddi/models/report_post_user.dart';
import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/constants.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:buddi/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../utils/strings.dart';

class EditBottomSheet extends StatefulWidget {
  EditBottomSheet({this.postData});
  final PostModel? postData;
  @override
  _EditBottomSheetState createState() => _EditBottomSheetState();
}

class _EditBottomSheetState extends State<EditBottomSheet> {
  ReportUserData report = ReportUserData();
  var controller = Get.put(RXConstants());
  @override
  Widget build(BuildContext context) {
    final  theme = Provider.of<DarkThemeProvider>(context);
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      padding: EdgeInsets.only(left: 20, top: 15),
      height: 250,
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 4,
            height: 9,
            decoration: BoxDecoration(
                color: Color(0xffDEE2E7),
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
          SizedBox(height: 50),
          Container(
            child: Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      AppDialog().showOSDialog(
                          context,
                          "Report",
                          "Are you sure you want to Block ${widget.postData!.userData['name']}'?",
                          "Yes", () async {
                        var userId = widget.postData!.userData['uid'];
                        Constants.blockUsers.add(userId);
                        AuthController()
                            .blockUser(userId, context)
                            .then((value) {
                          if (value == true) {
                            setState(() {
                              controller.postDummyList.removeWhere((element) =>
                                  Constants.blockUsers
                                      .contains(element.userData['uid']));
                            });
                          }
                        }).whenComplete(() {
                          Navigator.of(context).pop();
                          setState(() {});
                        });
                      }, secondButtonText: "NO", secondCallback: () {});
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.block_sharp,
                          size: 30,
                          color: Colors.red,
                        ),
                        SizedBox(width: 17),
                        Text(
                          'Block ${widget.postData!.userData['name']}',
                          style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                              fontSize: 18,
                              fontFamily: FontRefer.Poppins),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      AppDialog().showOSDialog(
                          context,
                          "Report",
                          "Are you sure you want to Report this post?",
                          "Yes", () async {
                        await PostController.reportPost(
                            widget.postData!,
                            'report',
                            'Post Reported for misconduct Successfully',
                            context);
                      }, secondButtonText: "Cancel", secondCallback: () {});
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(StringRefer.flag, width: 30, height: 30, color: Colors.green),
                        SizedBox(width: 20),
                        Text(
                          'Flag for misconduct',
                          style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                              fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      AppDialog().showOSDialog(
                          context,
                          "Concerned",
                          "Are you sure you want to send review?",
                          "Yes", () async {
                        await PostController.reportPost(
                            widget.postData!,
                            'concerned',
                            'Your request submit successfully, Thank you for Review',
                            context);
                      }, secondButtonText: "Cancel", secondCallback: () {});
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: SvgPicture.asset(StringRefer.report, color: Colors.amber),
                        ),
                        SizedBox(width: 20),
                        Flexible(
                          child: Text(
                            'I am concerned about this user\'s health',
                            style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                                fontSize: 18,
                                fontFamily: FontRefer.Poppins),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
