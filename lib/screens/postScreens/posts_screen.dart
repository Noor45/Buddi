import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddi/cards/post_card.dart';
import 'package:buddi/controller/auth_controller.dart';
import 'package:buddi/controller/post_controller.dart';
import 'package:buddi/models/post_model.dart';
import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:buddi/widgets/delete_post_sheet.dart';
import 'package:buddi/widgets/dialogs.dart';
import 'package:buddi/widgets/time_ago.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../utils/constants.dart';

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<PostModel> postDummyList = [];
  Key _refreshKey = UniqueKey();
  final _firestore = FirebaseFirestore.instance;
  bool isLoadingVertical = false;
  bool _isLoading = false;
  Stream<QuerySnapshot>? query;
  int limit = 20;
  Future _loadMore() async {
    () async {
      if (postDummyList.length > 19) {
        setState(() {
          isLoadingVertical = true;
          limit = limit + 10;
          query = _firestore
              .collection('post')
              .where("user_data.uid", isEqualTo: AuthController.currentUser!.uid)
              .orderBy('created_at', descending: true)
              .limit(limit)
              .snapshots();
        });
        await new Future.delayed(const Duration(seconds: 2));
        setState(() {
          isLoadingVertical = false;
        });
      }
    }();
  }

  initData(){
    setState((){
      query = _firestore
          .collection('post')
          .where("user_data.uid", isEqualTo: AuthController.currentUser!.uid)
          .orderBy('created_at', descending: true)
          .limit(limit)
          .snapshots();
    });
  }

  void onRefresh() => setState((){
    _refreshKey = UniqueKey();
  });

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('dd-MM-yyyy h:mma');
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: CircularProgressIndicator(color: ColorRefer.kMainThemeColor),
      child: LazyLoadScrollView(
        isLoading: isLoadingVertical,
        scrollOffset: 20,
        onEndOfPage: () => _loadMore(),
        child: ListView(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: query,
                builder: (context, snapshot) {
                  postDummyList = [];
                  if (snapshot.hasData) {
                    final posts = snapshot.data!.docs;
                    try {
                      for (var post in posts) {
                        PostModel postData = PostModel.fromMap(post.data() as Map<String, dynamic>);
                        postDummyList.add(postData);
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                  return postDummyList.length == 0
                      ? Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height / 1.3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.square_list,
                                color: ColorRefer.kGreyColor,
                                size: 50,
                              ),
                              SizedBox(height: 6),
                              AutoSizeText(
                                'No posts to show',
                                style: TextStyle(
                                    color: ColorRefer.kGreyColor,
                                    fontFamily: FontRefer.PoppinsMedium,
                                    fontSize: 20),
                              )
                            ],
                          ),
                        )
                      : ListView.builder(
                          key: _refreshKey,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: postDummyList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var value = postDummyList[index].userData;
                            return Column(
                              children: [
                                PostCard(
                                  profileImage: value['profileImage'],
                                  group: postDummyList[index].group,
                                  name: value['name'],
                                  uniName: value['uni_name'],
                                  showPostInGroup: false,
                                  onDelete: () async {
                                    await showEditDialogBox(
                                        onDelete: () async {
                                          await AppDialog().showOSDialog(
                                              context,
                                              "Delete Post",
                                              "Are you sure to delete this post?",
                                              "Delete", () async {
                                            Navigator.pop(context);
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            await PostController.deletePost(postDummyList[index].postId);
                                            initData();                                            
                                            setState(() {
                                              Constants.reloadHomePosts = true;
                                              _isLoading = false;
                                            }); 
                                          },
                                              secondButtonText: "Cancel",
                                              secondCallback: () {});
                                        });
                                  },
                                  onComment: () {
                                    onRefresh();
                                  },
                                  onLike: () {
                                    onRefresh();
                                  },
                                  time: TimeAgo.timeAgoSinceDate(formatter.format(postDummyList[index].createdAt!.toDate()), true),
                                  postText: postDummyList[index].post,
                                  postData: postDummyList[index],
                                ),
                                SizedBox(height: 5)
                              ],
                            );
                          },
                        );
                }),
                isLoadingVertical == true ? Center(
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
