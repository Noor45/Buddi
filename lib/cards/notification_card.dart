import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:buddi/widgets/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/strings.dart';

class NotificationSection extends StatefulWidget {
  NotificationSection(
      {this.profileImage,
      this.isCommentNotify,
      this.commentString,
      this.post,
      this.read,
      this.reactedString,
      this.isReactionNotify,
      this.time,
      required this.emojiIndex});

  final String? profileImage;
  final bool? isCommentNotify;
  final String? commentString;
  final String? post;
  final bool? isReactionNotify;
  final String? reactedString;
  final bool? read;
  final String? time;
  final int? emojiIndex;

  @override
  _NotificationSectionState createState() => _NotificationSectionState();
}

class _NotificationSectionState extends State<NotificationSection> {
  String? commentOn = '';
  @override
  void initState() {
    if (widget.post!.length > 30) {
      commentOn = widget.post!.substring(0, 30) + '...';
    } else {
      commentOn = widget.post;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 0,
                child: UserProfile(
                  image: widget.profileImage,
                  size: 35,
                ),
              ),
              SizedBox(width: 15),
              Visibility(
                visible: widget.isCommentNotify!,
                child: Expanded(
                  flex: 5,
                  child: RichText(
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: widget.commentString,
                            style: TextStyle(
                              color: widget.read == false
                                  ? theme.lightTheme == true
                                      ? Colors.black
                                      : Colors.white
                                  : Color(0xff868E9D),
                              fontSize: 15,
                              fontFamily: FontRefer.Poppins,
                              fontWeight: widget.read == false
                                  ? FontWeight.bold
                                  : FontWeight.w100,
                            )),
                        TextSpan(
                            text: widget.post,
                            style: TextStyle(
                              color: widget.read == false
                                  ? theme.lightTheme == true
                                      ? Colors.black
                                      : Colors.white
                                  : Color(0xff868E9D),
                              fontSize: 16,
                              height: 1.2,
                              fontFamily: FontRefer.Poppins,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.isReactionNotify!,
                child: Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: widget.reactedString,
                                style: TextStyle(
                                  color: widget.read == false
                                      ? theme.lightTheme == true
                                          ? Colors.black
                                          : Colors.white
                                      : Color(0xff868E9D),
                                  fontSize: 15,
                                  fontFamily: FontRefer.Poppins,
                                  fontWeight: widget.read == false
                                      ? FontWeight.bold
                                      : FontWeight.w100,
                                )),
                            TextSpan(
                                text: widget.post,
                                style: TextStyle(
                                  color: widget.read == false
                                      ? theme.lightTheme == true
                                          ? Colors.black
                                          : Colors.white
                                      : Color(0xff868E9D),
                                  fontSize: 16,
                                  height: 1.2,
                                  fontFamily: FontRefer.Poppins,
                                )),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AutoSizeText(
                            widget.time!,
                            style: TextStyle(
                                color: ColorRefer.kMainThemeColor,
                                fontSize: 13,
                                fontFamily: FontRefer.Poppins,
                                height: 1.5),
                          ),
                          Spacer(),
                          Visibility(
                              visible: widget.read == false ? true : false,
                              child: SvgPicture.asset(StringRefer.bullet)),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Visibility(
            visible: widget.isReactionNotify == true ? false : true,
            child: Row(
              children: [
                SizedBox(width: 50),
                AutoSizeText(
                  widget.time!,
                  style: TextStyle(
                      color: ColorRefer.kMainThemeColor,
                      fontSize: 13,
                      fontFamily: FontRefer.Poppins,
                      height: 1.5),
                ),
                // Spacer(),
                // Visibility(
                //     visible: widget.read == false? true : false,
                //     child: SvgPicture.asset('assets/icons/bullet.svg')
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
