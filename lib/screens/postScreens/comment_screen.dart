import 'dart:convert' as json;
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';
import 'package:buddi/controller/auth_controller.dart';
import 'package:buddi/controller/post_controller.dart';
import 'package:buddi/functions/notification_function.dart';
import 'package:buddi/models/user_model.dart';
import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/constants.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:buddi/widgets/dialogs.dart';
import 'package:buddi/widgets/profile.dart';
import 'package:buddi/widgets/time_ago.dart';

import '../../utils/strings.dart';

class CommentScreen extends StatefulWidget {
  static String commentScreenID = "/comment_screen";
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _firestore = FirebaseFirestore.instance;
  final commentTextController = TextEditingController();
  Comment newComment = Comment();
  UserModel userData = UserModel();
  FocusNode? commentFocus;
  String commentText = '';
  bool _isLoading = false;
  bool isLoadingVertical = false;
  int limit = 20;
  String sunComment = "";
  String? selectedComment = "";
  Stream<QuerySnapshot>? query;

  Future _loadMoreVertical() async {
    () async {
      setState(() {
        isLoadingVertical = true;
        limit = limit + 10;
        query = _firestore
            .collection('post')
            .doc(Constants.commentPostData!.postId)
            .collection('post_comments')
            .snapshots();
      });
      await new Future.delayed(const Duration(seconds: 2));
      setState(() {
        isLoadingVertical = false;
      });
    }();
  }

  initData(){
     setState((){
      query = _firestore
        .collection('post')
        .doc(Constants.commentPostData!.postId)
        .collection('post_comments')
        .snapshots();
     });
  }

  @override
  void initState() {
    super.initState();
    initData();
    commentFocus = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final  theme = Provider.of<DarkThemeProvider>(context);
    var formatter = new DateFormat('dd-MM-yyyy h:mma');
    return GestureDetector(
      onTap: () {
        setState(() {
          isReply = false;
        });
      },
      child: Scaffold(
        backgroundColor: theme.lightTheme == true
            ? Colors.white
            : ColorRefer.kBackColor,
        appBar: AppBar(
          backgroundColor: ColorRefer.kMainThemeColor,
          toolbarHeight: 70,
          elevation: 0,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios_sharp : Icons.arrow_back_rounded, color: Colors.white)
          ),
          title: Text('Comments', style: TextStyle(
              fontFamily: FontRefer.PoppinsMedium, fontSize: 20, color: Colors.white)),

        ),
        body: ModalProgressHUD(
          inAsyncCall: _isLoading,
          progressIndicator: CircularProgressIndicator(color: ColorRefer.kMainThemeColor),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 5,
                  child: Wrap(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10, top: 15, right: 10),
                        alignment: Alignment.center,
                        child: CommentPost(
                          onReply: null,
                          name: Constants.commentPostData!.userData['name'],
                          profileImage: Constants.commentPostData!.userData['profileImage'],
                          commentPost: Constants.commentPostData!.post,
                          comment: false,
                          time: TimeAgo.timeAgoSinceDate(
                              formatter.format(Constants
                                  .commentPostData!.createdAt!
                                  .toDate()),
                              false),
                        ),
                      ),
                      Divider(thickness: 2),
                      Container(                        
                        height: MediaQuery.of(context).size.height / 1.53,
                        padding: EdgeInsets.only(
                            left: 10, top: 4, right: 10, bottom: 8),
                        child: LazyLoadScrollView(
                          isLoading: isLoadingVertical,
                          scrollOffset: 20,
                          onEndOfPage: () => _loadMoreVertical(),
                          child: ListView(
                            children: [
                              StreamBuilder<QuerySnapshot>(
                                  stream: query,
                                  builder: (context, snapshot) {
                                    List<Comment> commentList = [];
                                    if (snapshot.hasData) {
                                      snapshot.data!.docs.forEach((element) {
                                        commentList.add(Comment.fromMap(element.data() as Map<String, dynamic>));
                                      }); 
                                    }
                                    return ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      reverse: true,
                                      itemCount: commentList.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        Comment value = commentList[index];
                                        return Column(
                                          children: [
                                            CommentPost(
                                              name: value.userData!['name'],
                                              uid: value.userData!['uid'],
                                              profileImage: value.userData!['profileImageUrl'],
                                              commentPost: value.comment,
                                              comment: true,
                                              onPressed: () async {
                                                await AppDialog().showOSDialog(
                                                    context,
                                                    "Delete Comment",
                                                    "Are you sure to delete this Comment?",
                                                    "Delete", () async {
                                                  FocusScope.of(context).requestFocus(FocusNode());
                                                  setState(() {
                                                    _isLoading = true;
                                                  });
                                                  await PostController.deleteCommentPost(Constants.commentPostData!.postId, value.commentId);
                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                initData();
                                                }, secondButtonText: "Cancel", secondCallback: () {});
                                              },
                                              commentID: value.commentId,
                                              time: TimeAgo.timeAgoSinceDate(formatter.format(value.createAt!.toDate()), false,
                                              ),
                                              child: (isReply && selectedComment == value.commentId)
                                                  ? Row(
                                                      children: [
                                                        Expanded(
                                                          child: CupertinoTextField(
                                                            onChanged:
                                                                (value) {
                                                              setState(() {
                                                                sunComment =
                                                                    value
                                                                        .trim();
                                                              });
                                                            },
                                                            placeholderStyle: TextStyle( color: theme.lightTheme == true
                                                                ? Color(0xffB5B6B6)
                                                                : Colors.white),
                                                            placeholder:
                                                                'type a comment....',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: theme.lightTheme == true
                                                                  ? Colors.black54
                                                                  : Colors.white,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                            onTap: () =>
                                                                _replyToComment(
                                                                    comment:
                                                                        value),
                                                            child:
                                                                Text('Send', style: TextStyle( color: theme.lightTheme == true
                                                                    ? Color(0xffB5B6B6)
                                                                    : Colors.white,),)),
                                                      ],
                                                    )
                                                  : GestureDetector(
                                                      onTap: () => _enableReply(commentId: value.commentId),
                                                      child: Text(
                                                        "Reply",
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                            SizedBox(height: 15),
                                          ],
                                        );
                                      },
                                    );
                                  }),
                              isLoadingVertical == true
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor:
                                            ColorRefer.kMainThemeColor,
                                      ),
                                    )
                                  : SizedBox(
                                      width: 0,
                                      height: 0,
                                    ),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                isReply
                    ? Offstage()
                    : Expanded(
                        flex: 0,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
                          decoration: BoxDecoration(
                              color: theme.lightTheme == true
                                  ? ColorRefer.kGreyColor
                                  : ColorRefer.kBoxColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: TextField(
                                  controller: commentTextController,
                                  focusNode: commentFocus,
                                  onChanged: (value) {
                                    commentText = value;
                                  },
                                  style: TextStyle(color: theme.lightTheme == true
                                      ? Colors.black
                                      : Colors.white),
                                  decoration:
                                      kMessageTextFieldDecoration.copyWith(
                                    fillColor:
                                        theme.lightTheme == true
                                            ? ColorRefer.kGreyColor
                                            : ColorRefer.kBoxColor,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: theme.lightTheme == true
                                              ? ColorRefer.kGreyColor
                                              : ColorRefer.kBoxColor,
                                          width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: theme.lightTheme == true
                                              ? ColorRefer.kGreyColor
                                              : ColorRefer.kBoxColor,
                                          width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30)),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: theme.lightTheme == true
                                              ? ColorRefer.kGreyColor
                                              : ColorRefer.kBoxColor,
                                          width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30)),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: theme.lightTheme == true
                                              ? ColorRefer.kGreyColor
                                              : ColorRefer.kBoxColor,
                                          width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30)),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (commentText.isNotEmpty == true) {
                                        commentTextController.clear();
                                        newComment = Comment();
                                        newComment.commentId = Uuid().v1obj().uuid;
                                        newComment.comment = commentText;
                                        newComment.userData = {'uid': AuthController.currentUser!.uid,
                                          'profileImageUrl': AuthController.currentUser!.profileImageUrl,
                                          'uniName': AuthController.currentUser!.uniName,
                                          'name': AuthController.currentUser!.name,};

                                        newComment.createAt = Timestamp.now();
                                        PostController.commentPost(newComment,
                                            Constants.commentPostData!.postId);
                                        if (AuthController.currentUser!.uid !=
                                            Constants.commentPostData!
                                                .userData['uid']) {
                                          String commentNotify =
                                              AuthController
                                                      .currentUser!.name! +
                                                  ' comment on your post';
                                          AuthController.saveNotificationData(
                                              commentNotify,
                                              Constants.commentPostData!,
                                              'comment');
                                          NotificationFunction.sendResponse(
                                              commentNotify,
                                              Constants.commentPostData!
                                                  .userData['uid']);
                                        }
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    margin: EdgeInsets.only(right: 15),
                                    padding: EdgeInsets.all(8),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ColorRefer.kMainThemeColor),
                                    child: SvgPicture.asset(
                                        StringRefer.commentSend),
                                  )),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _replyToComment({required Comment comment}) {
    if (sunComment.trim().isEmpty) return;
    setState(() {
      isReply = false;
    });
    commentTextController.clear();
    newComment = Comment();

    newComment.commentId = Uuid().v1obj().uuid;
    newComment.comment = sunComment;
    newComment.userData = {
      'uid': AuthController.currentUser!.uid,
      'profileImageUrl': AuthController.currentUser!.profileImageUrl,
      'uniName': AuthController.currentUser!.uniName,
      'name': AuthController.currentUser!.name,
    };

    newComment.createAt = Timestamp.now();
    PostController.postSubComment(
        newComment, Constants.commentPostData!.postId, comment.commentId);
    if (AuthController.currentUser!.uid !=
        Constants.commentPostData!.userData['uid']) {
      String commentNotify =
          AuthController.currentUser!.name! + ' comment on your post';
      AuthController.saveNotificationData(
          commentNotify, Constants.commentPostData!, 'comment');
      NotificationFunction.sendResponse(
          commentNotify, Constants.commentPostData!.userData['uid']);
    }
  }

  bool isReply = false;
  _enableReply({required String? commentId}) {
    setState(() {
      isReply = true;
      selectedComment = commentId;
    });
  }
}

class CommentPost extends StatefulWidget {
  CommentPost({
    this.commentPost,
    this.profileImage,
    this.time,
    this.name,
    this.uid,
    this.comment,
    this.onPressed,
    // @required this.emojiIndex,
    this.onReply,
    this.child,
    this.commentID,
  });
  final String? name;
  final String? commentID;
  final String? commentPost;
  final String? time;
  final String? uid;
  final bool? comment;
  final Function? onPressed;
  final String? profileImage;
  final VoidCallback? onReply;
  final Widget? child;

  @override
  State<CommentPost> createState() => _CommentPostState();
}

class _CommentPostState extends State<CommentPost> {
  Stream<QuerySnapshot>? query;

  @override
  void initState() {
    super.initState();
    query = FirebaseFirestore.instance
        .collection('post')
        .doc(Constants.commentPostData!.postId)
        .collection('post_comments')
        .doc(widget.commentID)
        .collection('sub_comments')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('dd-MM-yyyy h:mma');
    final  theme = Provider.of<DarkThemeProvider>(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.5, color: widget.comment == false ? Colors.transparent : ColorRefer.kGreyColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserProfile(
                      image: widget.profileImage,
                      size: 30,
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                              widget.name!,
                              style: TextStyle(
                                  color: theme.lightTheme == true
                                      ? Colors.black54
                                      : Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontRefer.Poppins)),
                          SizedBox(height: 3),
                          AutoSizeText(
                            widget.commentPost!,
                            style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                                    fontSize: 13,
                                    fontFamily: FontRefer.Poppins),
                          ),
                          // HashTagText(
                          //   text: widget.commentPost,
                          //   basicStyle: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                          //       color: theme.lightTheme == true
                          //           ? Colors.black
                          //           : Colors.white,
                          //       fontSize: 13,
                          //       fontFamily: FontRefer.Poppins),
                          //   decoratedStyle: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                          //       color: ColorRefer.kMainThemeColor,
                          //       fontSize: 13,
                          //       fontFamily: FontRefer.Poppins),
                          // ),
                          // SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AutoSizeText(widget.time!,
                      style: TextStyle(
                          color: theme.lightTheme == true
                              ? Color(0xffB5B6B6)
                              : Colors.white,
                          fontSize: 11,
                          fontFamily: FontRefer.Poppins)),
                  SizedBox(height: 7),
                  Visibility(
                    visible: widget.comment!,
                    child: Visibility(
                      visible: AuthController.currentUser!.uid == widget.uid
                          ? true
                          : false,
                      child: InkWell(
                        onTap: widget.onPressed as void Function()?,
                        child: AutoSizeText('Delete',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 11,
                                fontFamily: FontRefer.Poppins)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 5, left: 5),
            child: widget.child ?? Offstage(),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: StreamBuilder<QuerySnapshot>(
                stream: query,
                builder: (context, snapshot) {
                  List<Comment> commentList = [];
                  if (snapshot.hasData) {
                    snapshot.data!.docs.forEach((element) {
                      commentList.add(Comment.fromMap(element.data() as Map<String, dynamic>));
                    });
                  }
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: commentList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Comment value = commentList[index];
                      return Column(
                        children: [
                          CommentPost(
                            name: value.userData!['name'],
                            uid: value.userData!['uid'],
                            profileImage: value.userData!['profileImageUrl'],
                            commentPost: value.comment,
                            comment: true,
                            onPressed: () async {
                              await AppDialog().showOSDialog(
                                  context,
                                  "Delete Comment",
                                  "Are you sure to delete this Comment?",
                                  "Delete", () async {
                                await PostController.deleteSubCommentPost(
                                  commentList[index],
                                  Constants.commentPostData!.postId,
                                  widget.commentID,
                                  value.commentId,
                                );
                                ToastContext().init(context);
                                setState(() {
                                  Toast.show('Deleted',
                                      duration: Toast.lengthLong,
                                      gravity: Toast.bottom);
                                });
                              },
                                  secondButtonText: "Cancel",
                                  secondCallback: () {});
                            },
                            time: TimeAgo.timeAgoSinceDate(
                              formatter.format(value.createAt!.toDate()),
                              false,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class Comment {
  String? comment;
  String? commentId;
  Timestamp? createAt;
  var userData;
  Comment({
    this.comment,
    this.commentId,
    this.createAt,
    this.userData,
  });

  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'commentId': commentId,
      'createAt': createAt,
      'userData': userData,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      comment: map['comment'] ?? '',
      commentId: map['commentId'] ?? '',
      createAt: map['createAt'],
      userData: map['userData'],
    );
  }

  String toJson() => json.jsonEncode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.jsonDecode(source));

  @override
  String toString() {
    return 'Comment(comment: $comment, commentId: $commentId, createAt: $createAt, userData: $userData)';
  }
}
