import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/constants.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:toast/toast.dart';
import '../../controller/group_controller.dart';
import '../../controller/post_controller.dart';
import '../../models/group_model.dart';
import '../../utils/service_list.dart';
import '../groupScreens/group_posts.dart';

class SelectGroupForPost extends StatefulWidget {
  const SelectGroupForPost({required this.post, this.image, this.poll, this.camera, this.pollOptions, Key? key}) : super(key: key);
  final String? post;
  final File? image;
  final bool? poll;
  final bool? camera;
  final List? pollOptions;
  @override
  _SelectGroupForPostState createState() => _SelectGroupForPostState();
}

class _SelectGroupForPostState extends State<SelectGroupForPost>{
  var notification;
  RXConstants controller = Get.put(RXConstants());
  List<GroupModel> listOfGroups = [], groupTempList = [];
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    final  theme = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor: theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
      appBar: AppBar(
        backgroundColor: ColorRefer.kMainThemeColor,
        toolbarHeight: 70,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Platform.isIOS ? Icons.arrow_back_ios_sharp : Icons.arrow_back_rounded, color: Colors.white)
        ),
        title: Text('Groups', style: TextStyle(
            fontFamily: FontRefer.PoppinsMedium, fontSize: 20, color: Colors.white)),

      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.only(left: 12, right: 10),
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Post on a group',
                    style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                        fontSize: 15,
                        fontFamily: FontRefer.Poppins,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Groups(
                        onTap: () async {
                          await onTap(GroupCategories.Life);
                        },
                        title: GroupCategories.Life.displayTitle,
                        image: GroupCategories.Life.imagesPath,
                      ),
                      Groups(
                        onTap: () async {
                          await onTap(GroupCategories.Friends_And_Roommates);
                        },
                        title: GroupCategories.Friends_And_Roommates.displayTitle,
                        image: GroupCategories.Friends_And_Roommates.imagesPath,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Groups(
                        onTap: () async {
                          await onTap(GroupCategories.Relationships);
                        },
                        title: GroupCategories.Relationships.displayTitle,
                        image: GroupCategories.Relationships.imagesPath,
                      ),
                      Groups(
                        onTap: () async {
                          await onTap(GroupCategories.Athletics);
                        },
                        title: GroupCategories.Activism.displayTitle,
                        image: GroupCategories.Activism.imagesPath,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Groups(
                        onTap: () async {
                          await onTap(GroupCategories.Athletics);
                        },
                        title: GroupCategories.Athletics.displayTitle,
                        image: GroupCategories.Athletics.imagesPath,
                      ),
                      Groups(
                        onTap: () async {
                          await onTap(GroupCategories.Post_Graduate);
                        },
                        title: GroupCategories.Post_Graduate.displayTitle,
                        image: GroupCategories.Post_Graduate.imagesPath,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Groups(
                        onTap: () async {
                          await onTap(GroupCategories.Habit);
                        },
                        title: GroupCategories.Habit.displayTitle,
                        image: GroupCategories.Habit.imagesPath,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ]
            ),
          ),
        ),
      ),
    );
  }

  onTap(GroupCategories groups) async{
    await savePost(GroupModel(title: groups.displayTitle, image: groups.imagesPath, id: groups.id));
  }

  savePost(GroupModel groupDetail) async{
    setState((){
      showSpinner = true;
    });
    if(widget.poll == true){
      bool result = PostController().checkPollData(widget.pollOptions!, context);
      if(result == true){
        await getGroupDetail(groupDetail);
      }
    }
    else if(widget.camera == true){
      await PostController().setImages(widget.image)
          .then((value) async{
        await getGroupDetail(groupDetail);
      });
    }
    else{
     await getGroupDetail(groupDetail);
    }
  }
  getGroupDetail(GroupModel groupDetail) async{
    PostController().assignGroup(groupDetail);
    await PostController().savePostData(widget.post);
    ToastContext().init(context);
    Toast.show('Posted', duration: Toast.lengthLong, gravity: Toast.bottom);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    if(groupDetail.title != GroupCategories.School.displayTitle){
      await GroupController.getGroupPosts(groupDetail.id, 20).then((value) {
        Get.to(()=>GroupPosts(groupDetail: groupDetail, groups: true));
      });
    }else{
      await GroupController.getUniPosts(20).then((value) {
        Get.to(()=>GroupPosts(groupDetail: groupDetail, groups: false));
      });
    }
    if (mounted)
      setState(() {
        showSpinner = false;
      });
  }
}

class Groups extends StatefulWidget {
  const Groups({required this.onTap, this.image, this.title, Key? key}) : super(key: key);
  final Function onTap;
  final String? image;
  final String? title;

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  bool selectGroup = false;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return GestureDetector(
      onTap: () {
        setState((){
          selectGroup = !selectGroup;
          widget.onTap();
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width/2.25,
        child: Stack(
          children: [
           new ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: MediaQuery.of(context).size.width/2.25,
                height: MediaQuery.of(context).size.width/2.8,
                decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: theme.lightTheme == true ? Colors.grey.shade400 : ColorRefer.kBoxColor,
                image: DecorationImage(
                  image: AssetImage(widget.image!), fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(theme.lightTheme == true ? 0.3 : 0.5), BlendMode.darken)
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 50, 15, 0),
              child: AutoSizeText(
                widget.title!,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: FontRefer.Poppins,
                ),
              ),
            ),
            selectGroup == true ?
            Positioned(
              top: 8,
              left: 8,
              child: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 25,
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }
}
