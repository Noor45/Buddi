import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import '../models/group_model.dart';
import '../utils/fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../utils/strings.dart';

class Profile extends StatefulWidget {
  Profile({this.image});
  final String? image;
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(90),
      child: widget.image != null
          ? CachedNetworkImage(
              placeholder: (context, url) => Image.asset(StringRefer.user),
              imageUrl: widget.image == null ? '' : widget.image!,
              errorWidget: (context, url, error) => new Icon(Icons.error),
              width: 45,
              height: 45,
              fit: BoxFit.cover,
            )
          : Image.asset(
              StringRefer.profileImage,
              width: 45,
              height: 45,
              fit: BoxFit.fill,
            ),
    );
  }
}

class UserProfile extends StatefulWidget {
  UserProfile({this.image, this.size});
  final String? image;
  final double? size;
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(90),
      child: widget.image != null
          ? CachedNetworkImage(
              placeholder: (context, url) => Image.asset(StringRefer.user),
              imageUrl: widget.image == null ? '' : widget.image!,
              errorWidget: (context, url, error) => new Icon(Icons.error),
              width: widget.size,
              height: widget.size,
              fit: BoxFit.cover,
            )
          : Image.asset(
              StringRefer.profileImage,
              width: widget.size,
              height: widget.size,
              fit: BoxFit.fill,
            ),
    );
  }
}

class PostProfile extends StatefulWidget {
  PostProfile({this.image, this.name, this.group, this.showPostInGroup});
  final String? image;
  final String? name;
  final group;
  final bool? showPostInGroup;
  @override
  _PostProfileState createState() => _PostProfileState();
}

class _PostProfileState extends State<PostProfile> {
  GroupModel? groupDetail;
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  UserProfile(
                    image: widget.image,
                    size: 35,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name!,
                        style: TextStyle(
                          color: theme.lightTheme == true
                              ? Colors.black54
                              : Colors.white,
                          fontSize: 15,
                          fontFamily: FontRefer.Poppins,
                        ),
                      ),
                      // widget.group != null ?
                      // InkWell(
                      //   onTap: () async{
                      //     if(widget.showPostInGroup == false){
                      //        groupDetail = await GroupController.getGroupDetail(groupId: widget.group['id']);
                      //        if(groupDetail != null){
                      //          if(groupDetail!.members!.contains(AuthController.currentUser!.uid) == false){
                      //            Get.to(()=>GroupInfo(groupDetail: groupDetail, wantToJoin: true));
                      //          }else{
                      //            await GroupController.getGroupPosts(groupDetail!.id, 20).then((value) {
                      //              Get.to(()=>GroupPosts(groupDetail: groupDetail));
                      //            });
                      //          }
                      //        }
                      //     }
                      //   },
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       RichText(
                      //         softWrap: true,
                      //         textAlign: TextAlign.start,
                      //         text: TextSpan(
                      //           children: [
                      //             TextSpan(
                      //               text: widget.group['title'],
                      //               style: TextStyle(
                      //                 fontSize: 14,
                      //                 fontFamily: FontRefer.Poppins,
                      //                 color: theme.lightTheme == true ? ColorRefer.kHintColor : Colors.white,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //       SizedBox(width: 3),
                      //       widget.showPostInGroup == false ? Icon(Icons.arrow_forward_ios, size: 9, color: theme.lightTheme == true ? ColorRefer.kHintColor : Colors.white) : Container(),
                      //     ],
                      //   ),
                      // )
                      //     : Container(),
                    ],
                  ),
                  SizedBox(width: 5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
