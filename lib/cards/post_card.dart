import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddi/controller/auth_controller.dart';
import 'package:buddi/controller/post_controller.dart';
import 'package:buddi/functions/notification_function.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:buddi/models/like_post_model.dart';
import 'package:buddi/models/post_model.dart';
import 'package:buddi/screens/postScreens/comment_screen.dart';
import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/constants.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:buddi/utils/strings.dart';
import 'package:buddi/widgets/profile.dart';
import 'package:buddi/widgets/reactions.dart';
import 'package:buddi/widgets/report_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:simple_url_preview/simple_url_preview.dart';

class PostCard extends StatefulWidget {
  PostCard(
      {this.profileImage,
      this.name,
      this.postText,
      this.time,
      this.showPostInGroup,
      this.selectedTagCall,
      this.postData,
      this.onDelete,
      this.uniName,
      this.onComment,
      this.onLike,
      required this.group,
      Key? key})
      : super(key: key);
  final String? uniName;
  final String? name;
  final String? profileImage;
  final String? postText;
  final String? time;
  final Function? selectedTagCall;
  final group;
  final bool? showPostInGroup;
  final Function? onDelete;
  final Function? onComment;
  final Function? onLike;
  final PostModel? postData;

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  LikePostModel likePost = LikePostModel();
  int likes = 0;
  int comment = 0;
  int pollId = 0;
  int userPollChoice = 0;
  bool counted = false;
  bool isChecked = false;
  String commentCounter = '';
  int? react;
  List voteOptions = [];
  List voters = [];
  Map<String, int> voteData = {};
  String option1 = '';
  String option2 = '';
  String option3 = '';
  String option4 = '';

  getPollData() {
    print('ernterrrrrrrrr');
    setState(() {
      int pollOptionCount = 0;
      if (widget.postData!.poll != null) {
        voteOptions.clear();
        widget.postData!.poll.forEach((name, value) {
          voteOptions.add(
              {'id': pollOptionCount + 1, 'title': name, 'vote': value.length});
          value.forEach((element) {
            voters.add(element);
          });
          if (pollOptionCount == 0) {
            value.forEach((element) {
              voteData[element] = 1;
            });
          }
          if (pollOptionCount == 1) {
            value.forEach((element) {
              voteData[element] = 2;
            });
          }
          if (pollOptionCount == 2) {
            value.forEach((element) {
              voteData[element] = 3;
            });
          }
          if (pollOptionCount == 3) {
            value.forEach((element) {
              voteData[element] = 4;
            });
          }
          pollOptionCount++;
        });
      }
    });
  }

  void like() {
    setState(() {
      if (widget.postData!.postLike!.isNotEmpty) {
        widget.postData!.postLike!.forEach((element) {
          if (element['uid'] == AuthController.currentUser!.uid) {
            react = element['reaction'];
            counted = true;
            isChecked = true;
          } else {
            counted = false;
            isChecked = false;
          }
        });
      } else {
        counted = false;
        isChecked = false;
      }
    });
  }

  @override
  void initState() {

    super.initState();
    getPollData();
    _getLikesCounter();
    _getCommentsCounter();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    double width = MediaQuery.of(context).size.width;
    print(widget.postData!.post);
    // print(widget.postData!.poll['op 1']);
    return Container(
      width: width,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.5, color: ColorRefer.kGreyColor),
        ),
        color: theme.lightTheme == true ? Colors.white : ColorRefer.kBoxColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostProfile(
            image: widget.postData!.userData["uid"] ==
                    AuthController.currentUser!.uid
                ? AuthController.currentUser!.profileImageUrl
                : widget.profileImage,
            name: widget.name,
            group: widget.group,
            showPostInGroup: widget.showPostInGroup,
          ),
          SizedBox(height: 4),
          widget.postData!.poll == null
              ? Container(
                  padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        Constants.commentPostData = widget.postData;
                      });
                      await Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.bottomToTop,
                          duration: Duration(milliseconds: 350),
                          child: CommentScreen(),
                          settings: RouteSettings(
                              name: CommentScreen.commentScreenID),
                        ),
                      );
                      setState(() {});
                    },
                    child: AutoSizeText(
                      widget.postText!,
                      style: TextStyle(
                          fontSize: 16.5,
                          height: 1.4,
                          fontFamily: FontRefer.Poppins,
                          color: theme.lightTheme == true
                              ? Colors.black54
                              : ColorRefer.kLightGreyColor),
                    ),
                  ),
                )
              : Offstage(),
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.20),
            child: SimpleUrlPreview(
              url: convertStringToLink(widget.postText!),
              imageLoaderColor: ColorRefer.kMainThemeColor,
              previewHeight: 130,
            ),
          ),
          widget.postData!.image == null
              ? Offstage()
              : Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.postData!.image!,
                      headers: {'accept': 'image/*'},
                      height: 130,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width / 1.6,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return const CupertinoActivityIndicator();
                      },
                    ),
                  ),
                ),
          widget.postData!.gif == null || widget.postData!.gif!.isEmpty
              ? Offstage()
              : Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.postData!.gif!,
                      headers: {'accept': 'image/*'},
                      height: 130,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width / 1.6,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return const CupertinoActivityIndicator();
                      },
                    ),
                  ),
                ),

          widget.postData!.poll == null
              ? Offstage()
              // : Text(widget.postData!.poll.toString(), style: TextStyle(color: Colors.black)),

          : Padding(
                  padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                  child: FlutterPolls(
                    pollId: '1',
                    hasVoted: voters.contains(AuthController.currentUser!.uid!),
                    userVotedOptionId: this.voteData[AuthController.currentUser!.uid!],
                    createdBy: this.widget.postData!.userData['uid'],
                    pollTitle: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.postData!.post!,
                        style: TextStyle(
                            fontSize: 15,
                            height: 2,
                            fontFamily: FontRefer.Poppins,
                            color: theme.lightTheme == true
                                ? Colors.black
                                : ColorRefer.kLightGreyColor),
                      ),
                    ),
                    pollOptions: List<PollOption>.from(
                      voteOptions.map(
                        (option) {
                          var a = PollOption(
                            id: option['id'],
                            title: Text(
                              option['title'],
                              style: TextStyle(
                                color: theme.lightTheme == true
                                    ? voters.contains(
                                            AuthController.currentUser!.uid!)
                                        ? ColorRefer.kLightGreyColor
                                        : Colors.black
                                    : ColorRefer.kLightGreyColor,
                              ),
                            ),
                            votes: int.parse(option['vote'].toString()),
                          );
                          return a;
                        },
                      ),
                    ),
                    pollOptionsBorder: Border.all(
                      width: 1,
                      color: theme.lightTheme == true
                          ? Colors.black
                          : ColorRefer.kLightGreyColor,
                    ),
                    votedBackgroundColor: Colors.grey,
                    votedProgressColor: const Color(0xff0496FF),
                    leadingVotedProgessColor: ColorRefer.kMainThemeColor,
                    votedCheckmark: Icon(
                      Icons.check_circle_outline,
                      color: ColorRefer.kLightGreyColor,
                      size: 18,
                    ),
                    votesTextStyle:
                        TextStyle(color: ColorRefer.kLightGreyColor),
                    votedPercentageTextStyle: TextStyle(
                      color: ColorRefer.kLightGreyColor,
                    ),
                    onVoted: (PollOption pollOption, int choice) async {
                      setState(() {
                        if (pollOption.id == 1) {
                          int pollOptionCount = 0;
                          widget.postData!.poll.forEach((index, value) {
                            if (pollOptionCount == 0) {
                              value.add(AuthController.currentUser!.uid);
                              PostController.polling(
                                  value, index, widget.postData!.postId);
                            }
                            pollOptionCount++;
                          });
                        }
                        if (pollOption.id == 2) {
                          int pollOptionCount = 0;
                          widget.postData!.poll.forEach((index, value) {
                            if (pollOptionCount == 1) {
                              value.add(AuthController.currentUser!.uid);
                              PostController.polling(
                                  value, index, widget.postData!.postId);
                            }
                            pollOptionCount++;
                          });
                        }
                        if (pollOption.id == 3) {
                          int pollOptionCount = 0;
                          widget.postData!.poll.forEach((index, value) {
                            if (pollOptionCount == 2) {
                              value.add(AuthController.currentUser!.uid);
                              PostController.polling(
                                  value, index, widget.postData!.postId);
                            }
                            pollOptionCount++;
                          });
                        }
                        if (pollOption.id == 4) {
                          int pollOptionCount = 0;
                          widget.postData!.poll.forEach((name, value) {
                            if (pollOptionCount == 3) {
                              value.add(AuthController.currentUser!.uid);
                              PostController.polling(
                                  value, name, widget.postData!.postId);
                            }
                            pollOptionCount++;
                          });
                        }
                      });
                      setState(() => getPollData());
                      return true;
                    },
                  ),
                ),
          SizedBox(height: 14),
          Container(
            width: width,
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: ReactionButtonToggle<String>(
                          isChecked: isChecked,
                          onReactionChanged: (String? value, bool isChecked) {
                            int index = int.parse(value!);
                            // setState(() {Constants.sort = false;});
                            if (isChecked == true) {
                              if (index == -1) {
                                index = 0;
                              }
                              setState(() {
                                react = index;
                              });
                              if (counted == false) {
                                if (AuthController.currentUser!.uid !=
                                    widget.postData!.userData['uid']) {
                                  likePost.uid =
                                      AuthController.currentUser!.uid;
                                  likePost.reaction = index;
                                  widget.postData!.postLike!
                                      .add(likePost.toMap());
                                  PostController.likePost(
                                      likePost, widget.postData!.postId);
                                  AuthController.saveNotificationData(
                                      '${widget.postData!.postLike!.length} reacted to your post',
                                      widget.postData!,
                                      'like');
                                  NotificationFunction.sendResponse(
                                      '${widget.postData!.postLike!.length} reacted to your post',
                                      widget.postData!.userData['uid']);
                                } else {
                                  likePost.uid =
                                      AuthController.currentUser!.uid;
                                  likePost.reaction = index;
                                  widget.postData!.postLike!
                                      .add(likePost.toMap());
                                  PostController.likePost(
                                      likePost, widget.postData!.postId);
                                }
                              } else {
                                widget.postData!.postLike!.forEach((element) {
                                  if (element['uid'] ==
                                      AuthController.currentUser!.uid)
                                    element['reaction'] = index;
                                });
                                likePost.uid = AuthController.currentUser!.uid;
                                likePost.reaction = index;
                                PostController.likePost(
                                    likePost, widget.postData!.postId);
                              }
                            } else {
                              setState(() {
                                widget.postData!.postLike!.removeWhere(
                                    (element) =>
                                        element['uid'] ==
                                        AuthController.currentUser!.uid);
                                likePost.uid = AuthController.currentUser!.uid;
                                likePost.reaction = react;
                                widget.onLike!();
                                PostController.unLikePost(
                                    likePost, widget.postData!.postId);
                              });
                            }
                            like();
                          },
                          boxPadding: EdgeInsets.only(left: 10, right: 10),
                          reactions: reactions,
                          initialReaction: Reaction(
                              value: '-1',
                              icon: Icon(CupertinoIcons.smiley,
                                  color: theme.lightTheme == true
                                      ? Color(0xff666666)
                                      : ColorRefer.kLightGreyColor,
                                  size: 23)),
                          selectedReaction: Reaction(
                            value: react == null || react == -1
                                ? '-1'
                                : react.toString(),
                            icon: react == null || react == -1
                                ? Icon(
                                    CupertinoIcons.smiley,
                                    color: theme.lightTheme == true
                                        ? Color(0xff666666)
                                        : ColorRefer.kLightGreyColor,
                                    size: 22,
                                  )
                                : Image.asset(
                                    react == 0
                                        ? StringRefer.kLikeReaction
                                        : react == 1
                                            ? StringRefer.kDisLikeReaction
                                            : react == 2
                                                ? StringRefer.kOpenMouthReaction
                                                : react == 3
                                                    ? StringRefer
                                                        .kTearOfJoyReaction
                                                    : react == 4
                                                        ? StringRefer
                                                            .kHeartEyesReaction
                                                        : react == 5
                                                            ? StringRefer
                                                                .kSadReaction
                                                            : StringRefer
                                                                .kClapReaction,
                                    height:
                                        react == null || react == -1 ? 22 : 25,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        widget.postData!.postLike!.length == 0
                            ? ''
                            : widget.postData!.postLike!.length.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: FontRefer.Poppins,
                          color: theme.lightTheme == true
                              ? Color(0xff666666)
                              : ColorRefer.kLightGreyColor,
                        ),
                      ),
                      SizedBox(width: 15),
                      InkWell(
                          onTap: () async {
                            setState(() {
                              Constants.commentPostData = widget.postData;
                            });
                            await Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.bottomToTop,
                                duration: Duration(milliseconds: 350),
                                child: CommentScreen(),
                                settings: RouteSettings(
                                    name: CommentScreen.commentScreenID),
                              ),
                            );
                            widget.onComment!();
                          },
                          child: Icon(CupertinoIcons.bubble_left,
                              size: 22,
                              color: theme.lightTheme == true
                                  ? Color(0xff868E9D)
                                  : ColorRefer.kLightGreyColor)),
                      SizedBox(width: 3),
                      Text(
                        commentCounter == '0' ? '' : commentCounter,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: FontRefer.Poppins,
                          color: theme.lightTheme == true
                              ? Color(0xff666666)
                              : ColorRefer.kLightGreyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Text(
                        widget.time!,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: FontRefer.Poppins,
                          color: theme.lightTheme == true
                              ? Color(0xff868E9D)
                              : ColorRefer.kLightGreyColor,
                        ),
                      ),
                    ),
                    Container(
                      height: 20,
                      width: 25,
                      child: InkWell(
                        onTap: () async {
                          try {
                            if (widget.postData!.userData['uid'] ==
                                AuthController.currentUser!.uid) {
                              widget.onDelete!.call();
                            } else {
                              await showEditDialogBox(widget.postData);
                              setState(() {});
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: SvgPicture.asset(StringRefer.ellipsisH,
                              color: ColorRefer.kHintColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  showEditDialogBox(PostModel? postData) async {
    try {
      await showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)),
          ),
          context: context,
          builder: (context) {
            return EditBottomSheet(postData: postData);
          });
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getCommentsCounter() async {
    await FirebaseFirestore.instance
        .collection('post')
        .doc(widget.postData!.postId)
        .collection('post_comments')
        .get()
        .then((value) {
      if (mounted) {
        setState(() {
          commentCounter = value.docs.length.toString();
        });
      }
    });
  }

  Future<void> _getLikesCounter() async {
    await FirebaseFirestore.instance
        .collection('post')
        .doc(widget.postData!.postId)
        .collection('post_likes')
        .get()
        .then((value) {
      if (mounted) {
        setState(() {
          widget.postData!.postLike!.clear();
          value.docs.forEach((element) {
            widget.postData?.postLike!.add(element.data());
          });
          if (widget.postData!.postLike!.isNotEmpty) {
            widget.postData!.postLike!.forEach((element) {
              if (element['uid'] == AuthController.currentUser!.uid) {
                react = element['reaction'];
                counted = true;
                isChecked = true;
                return;
              }
            });
          }
        });
      }
    });
  }
}
