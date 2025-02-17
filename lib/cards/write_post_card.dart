import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:buddi/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:toast/toast.dart';
import 'package:flutter/cupertino.dart';

import '../controller/post_controller.dart';
import '../screens/postScreens/select_group.dart';
import '../utils/constants.dart';
import '../../controller/group_controller.dart';
import '../../models/group_model.dart';
import '../../utils/service_list.dart';
import '../screens/groupScreens/group_posts.dart';

class SelectAudienceCard extends StatefulWidget {
  const SelectAudienceCard(
      {required this.post,
      this.image,
      this.poll,
      this.camera,
      this.pollOptions,
      Key? key})
      : super(key: key);
  final String? post;
  final File? image;
  final bool? poll;
  final bool? camera;
  final List? pollOptions;
  @override
  State<SelectAudienceCard> createState() => _SelectAudienceCardState();
}

class _SelectAudienceCardState extends State<SelectAudienceCard> {
  int? val = -1;
  void initState() {
    val = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: Constants.postLoading,
      progressIndicator:
          CircularProgressIndicator(color: ColorRefer.kMainThemeColor),
      child: Dialog(
        insetPadding: EdgeInsets.only(left: 15, right: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        elevation: 0,
        child: contentBox(context),
      ),
    );
  }

  contentBox(context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      // height: width/1.5,
      height: width / 1.2,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: theme.lightTheme == true ? Colors.white : ColorRefer.kBoxColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0, theme.lightTheme == true ? 4 : 0),
                blurRadius: theme.lightTheme == true ? 10 : 0),
          ]),
      child: Container(
        padding: EdgeInsets.only(top: 18, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios_rounded,
                          size: 25,
                          color: theme.lightTheme == true
                              ? Colors.black54
                              : Colors.white)),
                  AutoSizeText(
                    'Post Audience',
                    style: TextStyle(
                      color: theme.lightTheme == true
                          ? Colors.black54
                          : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontRefer.PoppinsMedium,
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                'Who can see your post ?',
                style: TextStyle(
                  color:
                      theme.lightTheme == true ? Colors.black54 : Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontRefer.Poppins,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.earthAmericas,
                        size: 25,
                        color: theme.lightTheme == true
                            ? Colors.black54
                            : Colors.white),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('My School',
                            style: TextStyle(
                              color: theme.lightTheme == true
                                  ? Colors.black54
                                  : Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: FontRefer.PoppinsMedium,
                            )),
                        Text('Share with your school only',
                            style: TextStyle(
                              color: theme.lightTheme == true
                                  ? Colors.black54
                                  : Colors.white,
                              fontSize: 13,
                              fontFamily: FontRefer.Poppins,
                            )),
                      ],
                    ),
                  ],
                ),
                Radio(
                  value: 1,
                  groupValue: val,
                  onChanged: (dynamic value) {
                    setState(() {
                      val = value;
                    });
                  },
                  fillColor: MaterialStateColor.resolveWith(
                      (states) => ColorRefer.kMainThemeColor),
                  activeColor: ColorRefer.kMainThemeColor,
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.users,
                        size: 25,
                        color: theme.lightTheme == true
                            ? Colors.black54
                            : Colors.white),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Group',
                            style: TextStyle(
                              color: theme.lightTheme == true
                                  ? Colors.black54
                                  : Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: FontRefer.PoppinsMedium,
                            )),
                        Text('Share with a group',
                            style: TextStyle(
                              color: theme.lightTheme == true
                                  ? Colors.black54
                                  : Colors.white,
                              fontSize: 13,
                              fontFamily: FontRefer.Poppins,
                            )),
                      ],
                    ),
                  ],
                ),
                Radio(
                  value: 2,
                  groupValue: val,
                  onChanged: (dynamic value) {
                    setState(() {
                      val = value;
                    });
                  },
                  fillColor: MaterialStateColor.resolveWith(
                      (states) => ColorRefer.kMainThemeColor),
                  activeColor: ColorRefer.kMainThemeColor,
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: SubmitButton(
                title: 'Done',
                colour: ColorRefer.kMainThemeColor,
                onPressed: () async {
                  if (val == -1) {
                    ToastContext().init(context);
                    Toast.show('Please select one option',
                        duration: Toast.lengthLong, gravity: Toast.bottom);
                  } else
                    await savePost();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  savePost() async {
    if (val == 1) {
      PostController.postData.group = null;
      if (widget.poll == true) {
        save();
      } else if (widget.camera == true) {
        setState(() {
          Constants.postLoading = true;
        });
        await PostController().setImages(widget.image).then((value) async {
          await save();
        });
      } else {
        PostController.postData.poll = null;
        PostController.postData.image = null;
        await save();
      }
    } else {
      if (widget.poll == true)
        Get.to(() => SelectGroupForPost(
            post: widget.post, pollOptions: widget.pollOptions, poll: true));
      if (widget.camera == true)
        Get.to(() => SelectGroupForPost(
            post: widget.post, image: widget.image, camera: true));
      else
        Get.to(() => SelectGroupForPost(post: widget.post));
    }
  }

  save() async {
    setState(() {
      Constants.postLoading = true;
    });
    await PostController().savePostData(widget.post);
    setState(() {
      Constants.postLoading = false;
    });
    ToastContext().init(context);
    Toast.show('Posted', duration: Toast.lengthLong, gravity: Toast.bottom);
    Navigator.pop(context);
    Navigator.pop(context);
    await GroupController.getUniPosts(20).then((value) {
      Get.to(() => GroupPosts(
          groupDetail: GroupModel(
              title: GroupCategories.School.displayTitle,
              image: GroupCategories.School.imagesPath,
              id: GroupCategories.School.id),
          groups: false));
    });
  }
}

class PollOptions extends StatefulWidget {
  PollOptions(
      {this.hint,
      this.controller,
      this.onChanged,
      this.showCancelButton,
      this.onTap,
      Key? key})
      : super(key: key);
  final String? hint;
  final bool? showCancelButton;
  final Function? onChanged, onTap;
  final TextEditingController? controller;

  @override
  State<PollOptions> createState() => _PollOptionsState();
}

class _PollOptionsState extends State<PollOptions> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: TextField(
                controller: widget.controller,
                onChanged: widget.onChanged as void Function(String)?,
                textInputAction: TextInputAction.next,
                style: TextStyle(
                    color: theme.lightTheme == true
                        ? Colors.black54
                        : Colors.white),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: TextStyle(
                      color: theme.lightTheme == true
                          ? Colors.black54
                          : Colors.white,
                      fontSize: 14),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: ColorRefer.kGreyColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: ColorRefer.kGreyColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: ColorRefer.kGreyColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: ColorRefer.kGreyColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          Visibility(
            visible: widget.showCancelButton!,
            child: InkWell(
              onTap: widget.onTap as void Function()?,
              child: Icon(
                CupertinoIcons.clear_circled,
                size: 20,
                color: theme.lightTheme == true ? Colors.black54 : Colors.white,
              ),
            ),
          ),
          SizedBox(width: widget.showCancelButton! ? 30 : 50),
        ],
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({
    Key? key,
    required this.icon,
    required this.text,
    required this.bottomCardHeight,
    required this.onTap,
  }) : super(key: key);

  final IconData? icon;
  final String? text;
  final double bottomCardHeight;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return SafeArea(
      child: Container(
        height: bottomCardHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // color: Colors.green,
          border: Border(
            top: BorderSide(width: 3, color: Colors.grey),
          ),
        ),
        padding: EdgeInsets.only(left: 15, bottom: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onTap as void Function()?,
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: theme.lightTheme == true ? Colors.black54 : Colors.white,
              ),
            ),
            SizedBox(width: 10),
            Icon(icon, size: 15, color: ColorRefer.kMainThemeColor),
            SizedBox(width: 5),
            Text(text!,
                style:
                    TextStyle(fontSize: 13, color: ColorRefer.kMainThemeColor)),
          ],
        ),
      ),
    );
  }
}

class PostButton extends StatefulWidget {
  const PostButton(
      {this.text, this.selected, this.icon, required this.onTap, Key? key})
      : super(key: key);

  final String? text;
  final bool? selected;
  final IconData? icon;
  final Function onTap;
  @override
  State<PostButton> createState() => _PostButtonState();
}

class _PostButtonState extends State<PostButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return InkWell(
      onTap: widget.onTap as void Function()?,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border(
            left: BorderSide(
                width: 1.0,
                color: widget.selected == true
                    ? ColorRefer.kMainThemeColor
                    : theme.lightTheme == true
                        ? ColorRefer.kHintColor
                        : Colors.white),
            right: BorderSide(
                width: 1.0,
                color: widget.selected == true
                    ? ColorRefer.kMainThemeColor
                    : theme.lightTheme == true
                        ? ColorRefer.kHintColor
                        : Colors.white),
            top: BorderSide(
                width: 1.0,
                color: widget.selected == true
                    ? ColorRefer.kMainThemeColor
                    : theme.lightTheme == true
                        ? ColorRefer.kHintColor
                        : Colors.white),
            bottom: BorderSide(
                width: 1.0,
                color: widget.selected == true
                    ? ColorRefer.kMainThemeColor
                    : theme.lightTheme == true
                        ? ColorRefer.kHintColor
                        : Colors.white),
          ),
        ),
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              widget.icon,
              size: 15,
              color: widget.selected == true
                  ? ColorRefer.kMainThemeColor
                  : theme.lightTheme == true
                      ? ColorRefer.kHintColor
                      : Colors.white,
            ),
            SizedBox(width: 5),
            Text(widget.text!,
                style: TextStyle(
                    fontSize: 16,
                    color: widget.selected == true
                        ? ColorRefer.kMainThemeColor
                        : theme.lightTheme == true
                            ? ColorRefer.kHintColor
                            : Colors.white)),
          ],
        ),
      ),
    );
  }
}
