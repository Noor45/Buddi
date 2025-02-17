// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:buddi/screens/groupScreens/group_members.dart';
// import 'package:buddi/screens/groupScreens/group_posts.dart';
// import 'package:buddi/utils/colors.dart';
// import 'package:buddi/utils/fonts.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:buddi/utils/theme_model.dart';
// import 'package:get/get.dart';
// import 'package:buddi/controller/auth_controller.dart';
// import 'package:buddi/controller/group_controller.dart';
// import '../../models/group_model.dart';
// import 'package:intl/intl.dart';
// import 'package:toast/toast.dart';
// import '../../utils/constants.dart';
// import '../../widgets/dialogs.dart';
//
// // ignore: must_be_immutable
// class GroupInfo extends StatefulWidget {
//   GroupModel? groupDetail;
//   final bool wantToJoin;
//   GroupInfo({required this.groupDetail, this.wantToJoin = false});
//   @override
//   _GroupInfoState createState() => _GroupInfoState();
// }
//
// class _GroupInfoState extends State<GroupInfo> {
//   var formatter = new DateFormat('MMMM dd, yyyy');
//   String category = '';
//   @override
//   void initState() {
//     Constants.interestLists!.forEach((element) {
//       if(element.id == widget.groupDetail!.category)
//         category = '${element.icon} ${element.title}';
//     });
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     final theme = Provider.of<DarkThemeProvider>(context);
//     return Scaffold(
//       backgroundColor: theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
//       appBar: AppBar(
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.white),
//         backgroundColor: ColorRefer.kMainThemeColor,
//         title: Text(
//           'Group Info',
//           style: TextStyle(
//             fontFamily: FontRefer.PoppinsMedium,
//             fontSize: 18,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.only(top: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(20, 0, 15, 0),
//                   child: Text(
//                     'Description',
//                     style: TextStyle(
//                       fontFamily: FontRefer.PoppinsMedium,
//                       fontSize: 20,
//                       color: theme.lightTheme == true ? Colors.black54 : Colors.white,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(20, 0, 15, 0),
//                   child: Text(
//                     widget.groupDetail!.des!,
//                     style: TextStyle(
//                       fontFamily: FontRefer.Poppins,
//                       fontSize: 14,
//                       color: theme.lightTheme == true ? Colors.black54 : Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 MemberTab(
//                   title: 'Members',
//                   color: ColorRefer.kOrangeColor,
//                   subTitle: widget.groupDetail!.members!.length.toString(),
//                   onPressed: (){
//                     Get.to(()=>GroupMembers(groupDetail: widget.groupDetail));
//                   },
//                 ),
//                 TextTab(
//                   title: 'Category:  $category',
//                   onPressed: (){},
//                 ),
//                 widget.wantToJoin == true?
//                 SettingTab(
//                   title: 'Join Group',
//                   onPressed: (){
//                     AppDialog().showOSDialog(
//                         context, "Confirm",
//                         "Do you want to Join this group ?", "Join",
//                             () async{
//                           await GroupController.joinGroup(id: widget.groupDetail!.id);
//                           widget.groupDetail = await GroupController.getGroupDetail(groupId: widget.groupDetail!.id);
//                           if(AuthController.currentUser!.groups == null) AuthController.currentUser!.groups = [];
//                           AuthController.currentUser!.groups!.add(widget.groupDetail!.id);
//                           await AuthController().updateUserFields();
//                           ToastContext().init(context);
//                           Toast.show('Group Join Successfully', duration: Toast.lengthLong, gravity: Toast.bottom);
//                           Navigator.pop(context);
//                           Get.to(()=>GroupPosts(groupDetail: widget.groupDetail));
//                         },
//                         secondButtonText: "Cancel",
//                         secondCallback: () {}
//                     );
//                   },
//                 )
//                  : Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SettingTab(
//                       title: 'Leave Group',
//                       onPressed: (){
//                         AppDialog().showOSDialog(
//                             context, "Confirm",
//                             "Do you want to Leave this group ?", "Leave",
//                                 () async{
//                                 await GroupController.leaveGroup(memberId: AuthController.currentUser!.uid, groupId: widget.groupDetail!.id);
//                                 if(AuthController.currentUser!.groups == null) AuthController.currentUser!.groups = [];
//                                 AuthController.currentUser!.groups!.remove(widget.groupDetail!.id);
//                                 await AuthController().updateUserFields();
//                                 ToastContext().init(context);
//                                 Toast.show('Group Leave Successfully', duration: Toast.lengthLong, gravity: Toast.bottom);
//                                 Navigator.pop(context);
//                                 Navigator.pop(context);
//                             },
//                             secondButtonText: "Cancel",
//                             secondCallback: () {}
//                         );
//                       },
//                     ),
//                     SettingTab(
//                       title: 'Report Group',
//                       onPressed: (){
//                         if(widget.groupDetail!.reportedBy!.contains(AuthController.currentUser!.uid)){
//                           AppDialog().showOSDialog(
//                               context, "Invalid", "You have already submit the request for report", "OK",
//                                   () {
//                                 Navigator.pop(context);
//                                 return;
//                               });
//                         }else{
//                           AppDialog().showOSDialog(
//                               context, "Confirm",
//                               "Do you want to report this group ?", "Report",
//                                   () async{
//                                 await GroupController.reportGroup(groupId: widget.groupDetail!.id, uid: AuthController.currentUser!.uid)
//                                     .then((value) {
//                                   ToastContext().init(context);
//                                   Toast.show('Group Reported Successfully', duration: Toast.lengthLong, gravity: Toast.bottom);
//                                   Navigator.pop(context);
//                                   Navigator.pop(context);
//                                 });
//
//                               },
//                               secondButtonText: "Cancel",
//                               secondCallback: () {}
//                           );
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//
//                 TextTab(
//                   title: 'Date Created:  ${formatter.format(widget.groupDetail!.createdAt!.toDate())}',
//                   onPressed: (){},
//                 ),
//
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class SettingTab extends StatelessWidget {
//   const SettingTab({this.onPressed, this.title,  Key? key}) : super(key: key);
//   final String? title;
//   final Function? onPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//         onTap: onPressed as void Function()?,
//         child: Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.width/6,
//           padding: EdgeInsets.only(left: 20, right: 20),
//           alignment: Alignment.centerLeft,
//           decoration: BoxDecoration(
//             border: Border(
//               bottom: BorderSide(color: ColorRefer.kYellowColor),
//             ),
//           ),
//           child: AutoSizeText(
//             title!,
//             style: TextStyle(
//               fontSize: 15,
//               fontFamily: FontRefer.Poppins,
//               color: Colors.red,
//               letterSpacing: 0.5,
//             ),
//           ),
//         )
//     );
//   }
// }
//
//
// class TextTab extends StatelessWidget {
//   const TextTab({this.onPressed, this.title,  Key? key}) : super(key: key);
//   final String? title;
//   final Function? onPressed;
//   @override
//   Widget build(BuildContext context) {
//     final  theme = Provider.of<DarkThemeProvider>(context);
//     return Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.width/6,
//         padding: EdgeInsets.only(left: 20, right: 20),
//         alignment: Alignment.centerLeft,
//         decoration: BoxDecoration(
//           border: Border(
//             bottom: BorderSide(color: ColorRefer.kYellowColor),
//           ),
//         ),
//         child: AutoSizeText(
//          title!,
//           style: TextStyle(
//             color: theme.lightTheme == true ? Colors.black54 : Colors.white,
//             fontSize: 14,
//             fontFamily: FontRefer.Poppins,
//             letterSpacing: 0.5,
//           ),
//         ),
//       );
//   }
// }
//
// class MemberTab extends StatelessWidget {
//   MemberTab({this.color, this.subTitle, this.title, this.onPressed});
//   final Color? color;
//   final String? title, subTitle;
//   final Function? onPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Provider.of<DarkThemeProvider>(context);
//     return InkWell(
//       onTap: onPressed as void Function()?,
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.width/6,
//         padding: EdgeInsets.only(left: 20, right: 20),
//         alignment: Alignment.centerLeft,
//         decoration: BoxDecoration(
//           border: Border(
//             bottom: BorderSide(color: ColorRefer.kYellowColor),
//             top: BorderSide(color: ColorRefer.kYellowColor),
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 AutoSizeText(
//                   title!,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontFamily: FontRefer.Poppins,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 0.5,
//                     color: theme.lightTheme == true ? Colors.black54 : Colors.white,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 AutoSizeText(
//                   subTitle!,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontFamily: FontRefer.Poppins,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 0.5,
//                     color: color,
//                   ),
//                 ),
//               ],
//             ),
//             Icon(Icons.arrow_forward_ios_sharp, size: 20, color: theme.lightTheme == true ? Colors.black54 : Colors.white)
//           ],
//         ),
//       ),
//     );
//   }
// }
//
