// import 'dart:io';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:buddi/controller/auth_controller.dart';
// import 'package:buddi/models/group_model.dart';
// import 'package:buddi/screens/groupScreens/group_posts.dart';
// import 'package:buddi/utils/colors.dart';
// import 'package:buddi/utils/fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:buddi/utils/theme_model.dart';
// import 'package:get/get.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:toast/toast.dart';
// import '../../controller/group_controller.dart';
// import '../../widgets/dialogs.dart';
// import '../../widgets/round_button.dart';
//
// class GroupList extends StatefulWidget {
//   @override
//   _GroupListState createState() => _GroupListState();
// }
//
// class _GroupListState extends State<GroupList>{
//   List<GroupModel> listOfGroups = [], groupTempList = [];
//   bool showSpinner = false, isLoadingVertical = false;
//   Stream<QuerySnapshot>? query; FocusNode _focus = FocusNode();
//   TextEditingController editingController = TextEditingController();
//   var searchDecor = InputDecoration(
//     hintText: "Search",
//     filled: true,
//     hintStyle: TextStyle(
//         fontSize: 14,
//         fontFamily: FontRefer.Poppins,
//         color: ColorRefer.kHintColor),
//     contentPadding: EdgeInsets.only(left: 15),
//     enabledBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: ColorRefer.kGreyColor, width: 2.0),
//       borderRadius: BorderRadius.all(Radius.circular(15)),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: ColorRefer.kGreyColor, width: 2.0),
//       borderRadius: BorderRadius.all(Radius.circular(15)),
//     ),
//     focusedErrorBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: ColorRefer.kGreyColor, width: 2.0),
//       borderRadius: BorderRadius.all(Radius.circular(15)),
//     ),
//     errorBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: ColorRefer.kGreyColor, width: 2.0),
//       borderRadius: BorderRadius.all(Radius.circular(15)),
//     ),
//     prefixIcon: Icon(Icons.search, color: ColorRefer.kHintColor),
//   );
//
//   void getData()async{
//     listOfGroups.clear();
//     listOfGroups.addAll(groupTempList);
//     listOfGroups.sort((a, b) => a.title.toString().compareTo(b.title.toString()));
//   }
//
//   void filterSearchResults(String query) async{
//     List<GroupModel> dummySearchList = [];
//     dummySearchList.addAll(listOfGroups);
//     if(query.isNotEmpty) {
//       List<GroupModel> dummyListData = [];
//       dummySearchList.forEach((item) {
//         String name = item.title!;
//         if(name.toLowerCase().startsWith(query) == true) {
//           dummyListData.add(item);
//         }
//       });
//       setState(() {
//         listOfGroups.clear();
//         listOfGroups.addAll(dummyListData);
//       });
//       return;
//     } else {
//       setState(() {
//         getData();
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _focus.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Provider.of<DarkThemeProvider>(context);
//     return Scaffold(
//       backgroundColor: theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
//       appBar: AppBar(
//         backgroundColor: ColorRefer.kMainThemeColor,
//         toolbarHeight: 60,
//         elevation: 0,
//         leading: InkWell(
//          onTap: () {
//           Navigator.pop(context);
//          },
//          child: Icon(Platform.isIOS ? Icons.arrow_back_ios_sharp : Icons.arrow_back_rounded, color: Colors.white)
//         ),
//         title: Text('Groups', style: TextStyle(
//             fontFamily: FontRefer.PoppinsMedium, fontSize: 20, color: Colors.white)),
//       ),
//       body: ModalProgressHUD(
//         inAsyncCall: showSpinner,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: EdgeInsets.fromLTRB(12, 20, 12, 10),
//               child: TextField(
//                 focusNode: _focus,
//                 onChanged: (value) {
//                   setState(() {
//                     filterSearchResults(value);
//                   });
//                 },
//                 controller: editingController,
//                 decoration: searchDecor.copyWith(
//                   fillColor:  theme.lightTheme == true ? ColorRefer.kGreyColor : ColorRefer.kBoxColor,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.fromLTRB(12, 15, 12, 0),
//               child: Text(
//                 'Click on a group to join!',
//                 style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
//                   fontSize: 15,
//                   fontFamily: FontRefer.Poppins,
//                   fontWeight: FontWeight.bold
//                 ),
//               ),
//             ),
//             Expanded(
//               child: ListView(
//                 semanticChildCount: listOfGroups.length,
//                 children: [
//                     StreamBuilder<QuerySnapshot>(
//                         stream: FirebaseFirestore.instance.collection('groups').snapshots(),
//                         builder: (context, snapshot) {
//                           if(_focus.hasFocus == false){
//                             listOfGroups = [];
//                             if (snapshot.hasData) {
//                               final posts = snapshot.data!.docs;
//                               try {
//                                 for (var post in posts) {
//                                   GroupModel postData = GroupModel.fromMap(post.data() as Map<String, dynamic>);
//                                   listOfGroups.add(postData);
//                                 }
//                                 groupTempList.addAll(listOfGroups);
//                               } catch (e) {
//                                 print(e);
//                               }
//                             }
//                             listOfGroups.sort((a, b) => a.title.toString().compareTo(b.title.toString()));
//                           }
//                           return listOfGroups.length == 0 ?
//                           Container(
//                             alignment: Alignment.center,
//                             height: MediaQuery.of(context).size.height / 1.3,
//                              child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   CupertinoIcons.square_list,
//                                   color: ColorRefer.kGreyColor,
//                                   size: 50,
//                                 ),
//                                 SizedBox(height: 6),
//                                 AutoSizeText(
//                                   'No Groups to show',
//                                   style: TextStyle(
//                                       color: ColorRefer.kGreyColor,
//                                       fontFamily: FontRefer.PoppinsMedium,
//                                       fontSize: 20),
//                                 ),
//                               ],
//                             ),
//                           )
//                               : ListView.builder(
//                                 physics: NeverScrollableScrollPhysics(),
//                                 shrinkWrap: true,
//                                 itemCount: listOfGroups.length,
//                                 itemBuilder: (BuildContext context, int index) {
//                                   return Groups(
//                                     icon: listOfGroups[index].icon,
//                                     title: listOfGroups[index].title,
//                                     groupJoin: listOfGroups[index].members!.contains(AuthController.currentUser!.uid),
//                                     onTap: () async {
//                                       if(listOfGroups[index].members!.contains(AuthController.currentUser!.uid)){
//                                         await GroupController.getGroupPosts(listOfGroups[index].id, 20).then((value) {
//                                           Get.to(()=>GroupPosts(groupDetail: listOfGroups[index]));
//                                         });
//                                       }else{
//                                         AppDialog().showOSDialog(
//                                             context, "Confirm",
//                                             "Do you want to join this group ?", "Join",
//                                                 () async{
//                                               showSpinner = true;
//                                               GroupController.joinGroup(id: listOfGroups[index].id);
//                                               showSpinner = false;
//                                               ToastContext().init(context);
//                                               Toast.show('Group Joined Successfully', duration: Toast.lengthLong, gravity: Toast.bottom);
//                                               await GroupController.getGroupPosts(listOfGroups[index].id, 20).then((value) async{
//                                                 if(AuthController.currentUser!.groups == null) AuthController.currentUser!.groups = [];
//                                                 AuthController.currentUser!.groups!.add(listOfGroups[index].id);
//                                                 await AuthController().updateUserFields();
//                                                 Get.to(()=>GroupPosts(groupDetail: listOfGroups[index]));
//                                               });
//                                             },
//                                             secondButtonText: "Cancel",
//                                             secondCallback: () {}
//                                         );
//                                       }
//                                     },
//                                   );
//                                 },
//                              );
//                       }
//                     ),
//                     isLoadingVertical == true
//                     ? Center(
//                        child: CircularProgressIndicator(backgroundColor: ColorRefer.kMainThemeColor),
//                     ) : SizedBox(width: 0, height: 0),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class Groups extends StatelessWidget {
//   const Groups({this.icon, this.title, this.onTap, this.groupJoin = false, Key? key}) : super(key: key);
//   final Function? onTap;
//   final String? title, icon;
//   final bool groupJoin;
//
//   @override
//   Widget build(BuildContext context) {
//     final  theme = Provider.of<DarkThemeProvider>(context);
//     return Padding(
//       padding: EdgeInsets.fromLTRB(12, 15, 5, 0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           AutoSizeText(
//             '$icon   $title',
//             style: TextStyle(
//                 color: theme.lightTheme == true ? Colors.black54 : Colors.white,
//                 fontFamily: FontRefer.Poppins, fontSize: 15),
//           ),
//           ButtonWithOutline(
//             title: groupJoin == false ? 'Join' : 'Joined',
//             colour: groupJoin == false ? ColorRefer.kOrangeColor : Colors.green,
//             radius: 10,
//             height: 35,
//             width: MediaQuery.of(context).size.width/6,
//             textColor: groupJoin == false ? ColorRefer.kOrangeColor : Colors.green,
//             borderColor: Colors.transparent,
//             onPressed: onTap,
//           )
//         ],
//       ),
//     );
//   }
// }
//
