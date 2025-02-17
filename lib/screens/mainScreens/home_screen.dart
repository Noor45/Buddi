import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddi/screens/mainScreens/notification_screen.dart';
import 'package:buddi/screens/postScreens/create_post.dart';
import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/constants.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:buddi/utils/service_list.dart';
import 'package:coachmaker/coachmaker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../cards/home_card.dart';
import '../../controller/group_controller.dart';
import '../../models/group_model.dart';
import '../../utils/strings.dart';
import '../groupScreens/group_posts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  RXConstants controller = Get.put(RXConstants());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor:
            theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          toolbarHeight: 90,
          backgroundColor: ColorRefer.kMainThemeColor,
          title: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: CoachPoint(
                        initial: '1',
                        child: Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: AutoSizeText(
                            'Buddi',
                            style: TextStyle(
                              fontSize: 40,
                              height: 0.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: FontRefer.PoppinsMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, NotificationScreen.notificationScreenID);
                      },
                      child: SvgPicture.asset(
                        StringRefer.notificationBell,
                        width: 35,
                        height: 35,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, CreatePost.createPostScreenID);
                        },
                        child: CoachPoint(
                          initial: '3',
                          child: SvgPicture.asset(
                            StringRefer.writePost,
                            width: 35,
                            height: 35,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        body: ModalProgressHUD(
            inAsyncCall: isLoading,
            progressIndicator:
                CircularProgressIndicator(color: ColorRefer.kMainThemeColor),
            child: Padding(
              padding: EdgeInsets.only(left: 12, right: 10),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'What\'s on your mind? Let\'s talk.',
                        style: TextStyle(
                            color: theme.lightTheme == true
                                ? Colors.black
                                : Colors.white,
                            fontSize: 18,
                            fontFamily: FontRefer.Poppins,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GroupCard(
                            onTap: () async {
                              await onTap(GroupCategories.School);
                            },
                            title: GroupCategories.School.displayTitle,
                            image: GroupCategories.School.imagesPath,
                          ),
                          GroupCard(
                            onTap: () async {
                              await onTap(GroupCategories.Life);
                            },
                            title: GroupCategories.Life.displayTitle,
                            image: GroupCategories.Life.imagesPath,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GroupCard(
                            onTap: () async {
                              await onTap(
                                  GroupCategories.Friends_And_Roommates);
                            },
                            title: GroupCategories
                                .Friends_And_Roommates.displayTitle,
                            image: GroupCategories
                                .Friends_And_Roommates.imagesPath,
                          ),
                          GroupCard(
                            onTap: () async {
                              await onTap(GroupCategories.Relationships);
                            },
                            title: GroupCategories.Relationships.displayTitle,
                            image: GroupCategories.Relationships.imagesPath,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GroupCard(
                            onTap: () async {
                              await onTap(GroupCategories.Activism);
                            },
                            title: GroupCategories.Activism.displayTitle,
                            image: GroupCategories.Activism.imagesPath,
                          ),
                          GroupCard(
                            onTap: () async {
                              await onTap(GroupCategories.Athletics);
                            },
                            title: GroupCategories.Athletics.displayTitle,
                            image: GroupCategories.Athletics.imagesPath,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GroupCard(
                            onTap: () async {
                              await onTap(GroupCategories.Post_Graduate);
                            },
                            title: GroupCategories.Post_Graduate.displayTitle,
                            image: GroupCategories.Post_Graduate.imagesPath,
                          ),
                          GroupCard(
                            onTap: () async {
                              await onTap(GroupCategories.Habit);
                            },
                            title: GroupCategories.Habit.displayTitle,
                            image: GroupCategories.Habit.imagesPath,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ]),
              ),
            )));
  }

  onTap(GroupCategories group) async {
    setState(() {
      isLoading = true;
    });
    if (group.displayTitle != GroupCategories.School.displayTitle) {
      await GroupController.getGroupPosts(group.id, 20).then((value) {
        Get.to(() => GroupPosts(
            groupDetail: GroupModel(
                title: group.displayTitle,
                image: group.imagesPath,
                id: group.id),
            groups: true));
      });
    } else {
      await GroupController.getUniPosts(20).then((value) {
        Get.to(() => GroupPosts(
            groupDetail: GroupModel(
                title: group.displayTitle,
                image: group.imagesPath,
                id: group.id),
            groups: false));
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
// body: ModalProgressHUD(
//   inAsyncCall: _isLoading,
//   progressIndicator: CircularProgressIndicator(color: ColorRefer.kMainThemeColor),
//   child: LazyLoadScrollView(
//     isLoading: isLoadingVertical,
//     scrollOffset: 20,
//     onEndOfPage: () => _loadMore(),
//     child: SmartRefresher(
//       enablePullDown: true,
//       header: WaterDropMaterialHeader(
//         color: Colors.white,
//         backgroundColor: ColorRefer.kMainThemeColor,
//       ),
//       onRefresh: () async {
//        loadData();
//        controller.postDummyList.sort((a, b) => b.createdAt.toString().compareTo(a.createdAt.toString()));
//        controller.postDummyList.unique((x) => x.postId);
//        await Future.delayed(Duration(seconds: 2));
//        _refreshController.refreshCompleted();
//        setState(() {});
//       },
//       controller: _refreshController,
//       child: ListView(
//         children: [
//           Obx(() {
//             return Column(
//               children: [
//                 controller.postDummyList.isEmpty
//                     ? Container()
//                     : Offstage(),
//                 Container(
//                   child: controller.postDummyList.length == 0
//                     ? Container(
//                         alignment: Alignment.center,
//                         height:
//                             MediaQuery.of(context).size.height / 2,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               CupertinoIcons.square_list,
//                               color: ColorRefer.kGreyColor,
//                               size: 50,
//                             ),
//                             SizedBox(height: 6),
//                             Padding(
//                               padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
//                               child: AutoSizeText(
//                                 'No posts to show Select the campfire icon to join a group',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     color: ColorRefer.kGreyColor,
//                                     fontFamily: FontRefer.PoppinsMedium,
//                                     fontSize: 16),
//                               ),
//                             )
//                           ],
//                         ),
//                       )
//                     : ListView.builder(
//                         physics: NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         itemCount: controller.postDummyList.length,
//                         itemBuilder:
//                             (BuildContext context, int index) {
//                           var value = controller.postDummyList[index].userData;
//                           return Container(
//                             child: Column(
//                               children: [
//                                 PostCard(
//                                   key: UniqueKey(),
//                                   group: controller.postDummyList[index].group,
//                                   profileImage: value['profileImage'],
//                                   name: value['name'],
//                                   uniName: value['uni_name'],
//                                   showPostInGroup: false,
//                                   onComment: () {
//                                     setState(() {});
//                                   },
//                                   onDelete: () async {
//                                     await showEditDialogBox(
//                                         onDelete: () async {
//                                       await AppDialog().showOSDialog(
//                                           context,
//                                           "Delete Post",
//                                           "Are you sure to delete this post?",
//                                           "Delete", () async {
//                                         Navigator.pop(context);
//                                         await PostController.deletePost(controller.postDummyList[index].postId);
//                                         controller.postDummyList.removeWhere((r) =>r.postId == controller.postDummyList[index].postId);
//                                         ToastContext().init(context);
//                                         Toast.show('Post Deleted',
//                                             duration: Toast.lengthLong, gravity: Toast.bottom);
//
//                                       },
//                                       secondButtonText: "Cancel",
//                                       secondCallback: () {});
//                                     });
//                                   },
//                                   time: TimeAgo.timeAgoSinceDate(
//                                       formatter.format(controller
//                                           .postDummyList[index]
//                                           .createdAt!
//                                           .toDate()),
//                                       true),
//                                   postText: controller.postDummyList[index].post,
//                                   postData: controller.postDummyList[index],
//                                 ),
//                                 Container(
//                                     child: index % 5 == 0
//                                         ? AdCard()
//                                         : Container()
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                 ),
//                 isLoadingVertical == true && controller.postDummyList.length > 19
//                     ? Center(
//                         child: CircularProgressIndicator(backgroundColor: ColorRefer.kMainThemeColor),
//                       )
//                     : SizedBox(width: 0, height: 0),
//               ],
//             );
//           }),
//           SizedBox(height: 50),
//         ],
//       ),
//     ),
//   ),
// ),
