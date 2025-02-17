// import 'dart:io';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:buddi/screens/groupScreens/list_of_groups.dart';
// import 'package:buddi/utils/colors.dart';
// import 'package:buddi/utils/fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:buddi/utils/theme_model.dart';
// import 'package:get/get.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import '../../controller/auth_controller.dart';
// import '../../controller/group_controller.dart';
// import '../../models/group_model.dart';
// import 'group_posts.dart';
//
// class SelectedGroupList extends StatefulWidget {
//   @override
//   _SelectedGroupListState createState() => _SelectedGroupListState();
// }
//
// class _SelectedGroupListState extends State<SelectedGroupList>{
//   var notification;
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
//     listOfGroups.sort((a, b) => a.toString().compareTo(b.toString()));
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
//     final  theme = Provider.of<DarkThemeProvider>(context);
//     return Scaffold(
//       backgroundColor: theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
//       appBar: AppBar(
//         backgroundColor: ColorRefer.kMainThemeColor,
//         toolbarHeight: 70,
//         elevation: 0,
//         leading: InkWell(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Icon(Platform.isIOS ? Icons.arrow_back_ios_sharp : Icons.arrow_back_rounded, color: Colors.white)
//         ),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Image.asset(
//                   'assets/images/group.png',
//                   width: 35,
//                   height: 35,
//                 ),
//                 SizedBox(width: 10),
//                 Text('Groups', style: TextStyle(
//                     fontFamily: FontRefer.PoppinsMedium, fontSize: 20, color: Colors.white)),
//               ],
//             ),
//             GestureDetector(
//               onTap: (){
//                 setState(() { });
//                 Get.to(() => GroupList());
//               },
//               child: Image.asset(
//                 'assets/images/write_post.png',
//                 width: 35,
//                 height: 35,
//               ),
//             )
//           ],
//         ),
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
//                 style: TextStyle(color: Colors.black54),
//                 controller: editingController,
//                 decoration: searchDecor.copyWith(
//                   fillColor:  theme.lightTheme == true ? ColorRefer.kGreyColor : ColorRefer.kBoxColor,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.fromLTRB(12, 15, 12, 0),
//               child: Text(
//                 'Joined Groups',
//                 style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
//                     fontSize: 15,
//                     fontFamily: FontRefer.Poppins,
//                     fontWeight: FontWeight.bold
//                 ),
//               ),
//             ),
//             Expanded(
//               child: ListView(
//                 children: [
//                   StreamBuilder<QuerySnapshot>(
//                       stream: FirebaseFirestore.instance.collection("groups")
//                       .where("members", arrayContains: AuthController.currentUser!.uid).snapshots(),
//                       builder: (context, snapshot) {
//                         if(_focus.hasFocus == false){
//                           listOfGroups = [];
//                           if (snapshot.hasData) {
//                             final groups = snapshot.data!.docs;
//                             try {
//                               for (var group in groups) {
//                                 GroupModel groupData = GroupModel.fromMap(group.data() as Map<String, dynamic>);
//                                 listOfGroups.add(groupData);
//                               }
//                               groupTempList.addAll(listOfGroups);
//                             } catch (e) {
//                               print(e);
//                             }
//                           }
//                         }
//                         return listOfGroups.length == 0 ?
//                         Container(
//                           alignment: Alignment.center,
//                           height: MediaQuery.of(context).size.height / 1.3,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 CupertinoIcons.square_list,
//                                 color: ColorRefer.kGreyColor,
//                                 size: 50,
//                               ),
//                               SizedBox(height: 6),
//                               AutoSizeText(
//                                 'No Groups to show',
//                                 style: TextStyle(
//                                     color: ColorRefer.kGreyColor,
//                                     fontFamily: FontRefer.PoppinsMedium,
//                                     fontSize: 20),
//                               ),
//                             ],
//                           ),
//                         ) : ListView.builder(
//                           physics: NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemCount: listOfGroups.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             return Groups(
//                               icon: listOfGroups[index].icon,
//                               title: listOfGroups[index].title,
//                               des:  listOfGroups[index].des,
//                               count: listOfGroups[index].members!.length,
//                               onTap: () async{
//                                 await GroupController.getGroupPosts(listOfGroups[index].id, 20).then((value) {
//                                  Get.to(()=>GroupPosts(groupDetail: listOfGroups[index]));
//                                });
//                               },
//                             );
//                           },
//                         );
//                       }
//                   ),
//                   isLoadingVertical == true
//                       ? Center(
//                         child: CircularProgressIndicator(backgroundColor: ColorRefer.kMainThemeColor),
//                   ) : SizedBox(width: 0, height: 0),
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
//   const Groups({this.icon, this.title, this.count, this.des, this.onTap, this.groupJoin = false, Key? key}) : super(key: key);
//   final Function? onTap;
//   final int? count;
//   final String? title, des, icon;
//   final bool groupJoin;
//
//   @override
//   Widget build(BuildContext context) {
//     final  theme = Provider.of<DarkThemeProvider>(context);
//     return GestureDetector(
//       onTap: onTap as void Function()?,
//       child: Padding(
//         padding: EdgeInsets.fromLTRB(12, 15, 12, 0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             AutoSizeText(
//               '$icon',
//               style: TextStyle(
//                   fontFamily: FontRefer.Poppins, fontSize: 18),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 15),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     AutoSizeText(
//                       '$title',
//                       style: TextStyle(
//                           color: theme.lightTheme == true ? Colors.black54 : Colors.white,
//                           fontFamily: FontRefer.Poppins, fontWeight: FontWeight.bold, fontSize: 15),
//                     ),
//                     SizedBox(height: 5),
//                     AutoSizeText(
//                       '${des!.length > 20 ? des!.substring(0, 20)+'...' : des}',
//                       style: TextStyle(
//                           color: theme.lightTheme == true ? Colors.black54 : Colors.white,
//                           fontFamily: FontRefer.Poppins, fontSize: 13),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 AutoSizeText(
//                   '⦿',
//                   style: TextStyle(
//                       fontFamily: FontRefer.Poppins, fontSize: 20, color: ColorRefer.kOrangeColor),
//                 ),
//                 SizedBox(width: 12),
//                 AutoSizeText(
//                  '$count',
//                   style: TextStyle(
//                       color: theme.lightTheme == true ? Colors.black54 : Colors.white,
//                       fontFamily: FontRefer.Poppins, fontSize: 10),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
