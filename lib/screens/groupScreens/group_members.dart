// import 'dart:io';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:buddi/models/group_model.dart';
// import 'package:buddi/utils/colors.dart';
// import 'package:buddi/utils/fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:buddi/utils/theme_model.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import '../../models/user_model.dart';
//
// class GroupMembers extends StatefulWidget {
//   final GroupModel? groupDetail;
//   GroupMembers({required this.groupDetail});
//   @override
//   _GroupMembersState createState() => _GroupMembersState();
// }
//
// class _GroupMembersState extends State<GroupMembers>{
//   List<GroupModel> listOfGroups = [];
//   bool showSpinner = false, isLoadingVertical = false;
//   Stream<QuerySnapshot>? query; late UserModel userData;
//   final _firestore = FirebaseFirestore.instance;
//   @override
//   Widget build(BuildContext context) {
//     final  theme = Provider.of<DarkThemeProvider>(context);
//     return Scaffold(
//       backgroundColor: theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
//       appBar: AppBar(
//         backgroundColor: ColorRefer.kMainThemeColor,
//         toolbarHeight: 60,
//         elevation: 0,
//         leading: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Icon(Platform.isIOS ? Icons.arrow_back_ios_sharp : Icons.arrow_back_rounded, color: Colors.white)
//         ),
//         title: Text('Members', style: TextStyle(fontSize: 20, color: Colors.white)),
//       ),
//       body: ModalProgressHUD(
//         inAsyncCall: showSpinner,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 10),
//             Expanded(
//               child: ListView(
//                 semanticChildCount: widget.groupDetail!.members?.length ?? 0,
//                 children: widget.groupDetail!.members == null || widget.groupDetail!.members!.length == 0
//                     ? [Container()]
//                     : widget.groupDetail!.members!.map((e) {
//                       return StreamBuilder<DocumentSnapshot>(
//                       stream: _firestore.collection('users').doc(e).snapshots(),
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           userData = UserModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);
//                         }
//                         return snapshot.hasData ?  Groups(
//                           name: userData.username == null ? userData.name : userData.username,
//                           image: userData.profileImageUrl,
//                         ) : Container();
//                       }
//                   );
//                 }).toList(),
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
//   const Groups({this.image, this.name, Key? key}) : super(key: key);
//   final String? name, image;
//   @override
//   Widget build(BuildContext context) {
//     final  theme = Provider.of<DarkThemeProvider>(context);
//      return Padding(
//         padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(90),
//               child: image != null
//                   ? FadeInImage.assetNetwork(
//                 placeholder: 'assets/images/user.png',
//                 image: image!,
//                 width: 45,
//                 height: 45,
//                 fit: BoxFit.cover,
//               ) : Image.asset(
//                 'assets/images/profile_image.png',
//                 width: 45,
//                 height: 45,
//                 fit: BoxFit.fill,
//               ),
//             ),
//             SizedBox(width: 20),
//             AutoSizeText(
//               '$name',
//               style: TextStyle(
//                   color: theme.lightTheme == true ? Colors.black54 : Colors.white,
//                   fontFamily: FontRefer.Poppins, fontSize: 16),
//             ),
//           ],
//         ),
//     );
//   }
// }
