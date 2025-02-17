import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddi/cards/post_card.dart';
import 'package:buddi/controller/auth_controller.dart';
import 'package:buddi/controller/post_controller.dart';
import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:buddi/widgets/delete_post_sheet.dart';
import 'package:buddi/widgets/dialogs.dart';
import 'package:buddi/widgets/time_ago.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../models/group_model.dart';
import '../../utils/constants.dart';
import '../../utils/strings.dart';
import '../postScreens/create_post.dart';

class GroupPosts extends StatefulWidget {
  final GroupModel? groupDetail;
  final bool? groups;
  GroupPosts({required this.groupDetail, this.groups});
  @override
  _GroupPostsState createState() => _GroupPostsState();
}

class _GroupPostsState extends State<GroupPosts> {
  Key _refreshKey = UniqueKey();
  RXConstants controller = Get.put(RXConstants());
  final _firestore = FirebaseFirestore.instance;
  bool isLoadingVertical = false;
  bool _isLoading = false;
  Stream<QuerySnapshot>? query;
  int limit = 20;
  String selectedItem = 'New';
  List list = ['New', 'Popular'];

  void onRefresh() => setState(() {
        _refreshKey = UniqueKey();
      });

  Future _loadMoreVertical() async {
    () async {
      if (controller.groupPosts.length > 19) {
        setState(() {
          isLoadingVertical = true;
          limit = limit + 10;
          query = widget.groups == true
              ? _firestore
                  .collection('post')
                  .where("group.id", isEqualTo: widget.groupDetail?.id)
                  .orderBy('created_at', descending: true)
                  .limit(limit)
                  .snapshots()
              : _firestore
                  .collection('post')
                  .where("group", isNull: true)
                  .where("user_data.uni_name",
                      isEqualTo: AuthController.currentUser?.uniName)
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

  @override
  void initState() {
    super.initState();
    // controller.groupPosts.sort((a, b) => b.postLike!.length.compareTo(a.postLike!.length));
    controller.groupPosts.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
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
        automaticallyImplyLeading: false,
        title: TopBar(
          tapOnFilter: (value) {
            setState(() {
              selectedItem = value;
            });
            if (selectedItem == 'Popular') {
              setState(() {
                controller.groupPosts.sort(
                    (a, b) => b.postLike!.length.compareTo(a.postLike!.length));
                onRefresh();
              });
              setState(() {});
            }
            if (selectedItem == 'New') {
              setState(() {
                controller.groupPosts
                    .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
                onRefresh();
              });
            }
            setState(() {});
          },
          list: list,
          selectedItem: selectedItem,
          groupTitle: widget.groupDetail!.title,
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: LazyLoadScrollView(
            isLoading: isLoadingVertical,
            scrollOffset: 20,
            onEndOfPage: () => _loadMoreVertical(),
            child: Obx(() {
              return ListView(
                key: _refreshKey,
                children: [
                  Container(
                    child: controller.groupPosts.length == 0
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
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.groupPosts.length,
                            itemBuilder: (BuildContext context, int index) {
                              // print(controller.groupPosts[index].poll);
                              var value = controller.groupPosts[index].userData;
                              return PostCard(
                                // key: _refreshKey,
                                group: controller.groupPosts[index].group,
                                profileImage: value['profileImage'],
                                name: value['name'],
                                uniName: value['uni_name'],
                                showPostInGroup: true,
                                onComment: () {
                                  onRefresh();
                                },
                                onLike: () {
                                  onRefresh();
                                },
                                onDelete: () async {
                                  await showEditDialogBox(onDelete: () async {
                                    await AppDialog().showOSDialog(
                                        context,
                                        "Delete Post",
                                        "Are you sure to delete this post?",
                                        "Delete", () async {
                                      Navigator.pop(context);
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      await PostController.deletePost(
                                          controller.groupPosts[index].postId);
                                      setState(() {
                                        _isLoading = false;
                                        Constants.reloadHomePosts = true;
                                        controller.groupPosts.removeWhere((r) =>
                                            r.postId ==
                                            controller
                                                .groupPosts[index].postId);
                                      });
                                      // ToastContext().init(context);
                                      // Toast.show('Deleted',
                                      //     duration: Toast.lengthLong,
                                      //     gravity: Toast.bottom);
                                    },
                                        secondButtonText: "Cancel",
                                        secondCallback: () {});
                                  });
                                },
                                time: TimeAgo.timeAgoSinceDate(
                                    formatter.format(controller
                                        .groupPosts[index].createdAt!
                                        .toDate()),
                                    true),
                                postText: controller.groupPosts[index].post,
                                postData: controller.groupPosts[index],
                              );
                            },
                          ),
                  ),
                  isLoadingVertical == true
                      ? Center(
                          child: CircularProgressIndicator(
                              backgroundColor: ColorRefer.kMainThemeColor))
                      : SizedBox(width: 0, height: 0),
                  SizedBox(height: 50),
                ],
              );
            })),
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

class TopBar extends StatefulWidget {
  TopBar(
      {this.groupTitle,
      required this.tapOnFilter,
      this.list,
      this.selectedItem,
      Key? key})
      : super(key: key);
  final String? groupTitle, selectedItem;
  final Function(dynamic) tapOnFilter;
  final List? list;

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                  Platform.isIOS
                      ? Icons.arrow_back_ios_sharp
                      : Icons.arrow_back_rounded,
                  color: Colors.white),
            ),
            SizedBox(width: 10),
            Text(
              '${widget.groupTitle}',
              style: TextStyle(
                  fontFamily: FontRefer.PoppinsMedium,
                  fontSize: 24,
                  color: Colors.white),
            ),
          ],
        ),
        Spacer(),
        InkWell(
          onTap: () {
            Get.off(CreatePost(fromGroup: true, groupName: widget.groupTitle ?? ""));
            setState(() {});
          },
          child: SvgPicture.asset(
            StringRefer.writePost,
            width: 35,
            height: 35,
          ),
        ),
        DropdownButton(
          isDense: true,
          focusColor: Colors.transparent,
          hint: SvgPicture.asset(
            StringRefer.filterCircle,
            width: 40,
            height: 40,
          ),
          dropdownColor:
              theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
          underline: SizedBox.shrink(),
          icon: SizedBox.shrink(),
          alignment: AlignmentDirectional.centerEnd,
          onChanged: widget.tapOnFilter,
          items: widget.list!.map(
            (e) {
              return DropdownMenuItem(
                value: e,
                alignment: AlignmentDirectional.center,
                child: Text(
                  e,
                  style: TextStyle(
                      color: e == widget.selectedItem
                          ? ColorRefer.kMainThemeColor
                          : theme.lightTheme == true
                              ? Colors.black54
                              : Colors.white),
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
