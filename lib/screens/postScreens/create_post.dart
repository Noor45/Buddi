import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddi/controller/auth_controller.dart';
import 'package:buddi/controller/post_controller.dart';
import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/constants.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:buddi/widgets/profile.dart';
import 'package:buddi/widgets/round_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:flutter_url_shortener/flutter_url_shortener.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_url_preview/simple_url_preview.dart';
import 'package:toast/toast.dart';
import '../../cards/write_post_card.dart';
import '../../controller/group_controller.dart';
import '../../models/group_model.dart';
import '../../utils/service_list.dart';
import '../../utils/strings.dart';
import '../groupScreens/group_posts.dart';

class CreatePost extends StatefulWidget {
  static String createPostScreenID = "/create_post_screen";
  CreatePost({this.fromGroup = false, this.groupName = ''});
  final bool fromGroup;
  final String groupName;
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  TextEditingController writeController = TextEditingController();
  String? post = '';
  File? image;
  final _focusNode = FocusNode();
  final picker = ImagePicker();
  GiphyGif? gif;
  IconData? selectedIcon;
  String? insertLink = '',
      selectedText = '',
      textHint = 'What\'s on your mind?';
  bool showOptions = true, showTextField = false;
  bool text = false, camera = false, poll = false, link = false, giff = false;
  int pollOptionValue = 0;
  List pollOptions = ['', ''];
  double topCardHeight = 0.0, bottomCardHeight = 0.0;

  openBox(
      {bool txt = false,
      cam = false,
      pol = false,
      lin = false,
      gif = false,
      IconData? icon,
      String? title}) {
    setState(() {
      text = txt;
      camera = cam;
      poll = pol;
      link = lin;
      giff = gif;
      selectedIcon = icon;
      selectedText = title;
      showTextField = true;
    });
    if (txt == true || cam == true || pol == true || lin == true || gif == true)
      return false;
  }

  setHeight(BuildContext context) {
    setState(() {
      if (showOptions == true) {
        topCardHeight = MediaQuery.of(context).size.height * 0.3;
        bottomCardHeight = MediaQuery.of(context).size.height * 0.28;
      } else {
        topCardHeight = MediaQuery.of(context).size.height * 0.75;
        bottomCardHeight = MediaQuery.of(context).size.height * 0.1;
      }
    });
  }

  selectAudience(DarkThemeProvider theme) async {
    if (post != '') {
      FocusManager.instance.primaryFocus?.unfocus();
      if (poll == true) {
        bool result = PostController().checkPollData(pollOptions, context);
        if (result == true) {
          await showDialog(
            context: context,
            useSafeArea: false,
            barrierColor: theme.lightTheme == true
                ? ColorRefer.kBackColor.withOpacity(0.40)
                : ColorRefer.kBackColor.withOpacity(0.30),
            builder: (BuildContext context) {
              return SelectAudienceCard(
                  post: post, pollOptions: pollOptions, poll: true);
            },
          );
        }
      } else if (camera == true) {
        await showDialog(
          context: context,
          useSafeArea: false,
          barrierColor: theme.lightTheme == true
              ? ColorRefer.kBackColor.withOpacity(0.40)
              : ColorRefer.kBackColor.withOpacity(0.30),
          builder: (BuildContext context) {
            return SelectAudienceCard(post: post, image: image, camera: true);
          },
        );
      } else {
        await showDialog(
          context: context,
          useSafeArea: false,
          barrierColor: theme.lightTheme == true
              ? ColorRefer.kBackColor.withOpacity(0.40)
              : ColorRefer.kBackColor.withOpacity(0.30),
          builder: (BuildContext context) {
            if (giff == false) PostController.postData.gif = null;
            return SelectAudienceCard(post: post);
          },
        );
      }
    }
  }


  @override
  void initState() {
    pollOptions = ['', ''];
    FShort.instance.setup(token: 'c54f80a86898ec5dd15a37fbb524ccbc4844dd2f');
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    setHeight(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
      appBar: AppBar(
        backgroundColor: ColorRefer.kMainThemeColor,
        toolbarHeight: 70,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: 20,
            padding: EdgeInsets.only(left: 15),
            child: Icon(
                Platform.isIOS
                    ? Icons.arrow_back_ios_sharp
                    : Icons.arrow_back_rounded,
                color: Colors.white),
          ),
        ),
        title: Row(
          children: [
            SvgPicture.asset(
              StringRefer.writePost,
              width: 30,
              height: 30,
            ),
            SizedBox(width: 10),
            Text(
              'Create Post',
              style: TextStyle(
                  fontFamily: FontRefer.PoppinsMedium,
                  fontSize: 20,
                  color: Colors.white),
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () async {
              if(widget.fromGroup == true){
                postWithinGroup();
              }
              else{
                if (post!.trim().isEmpty) return;
                await selectAudience(theme);
              }
            },
            child: Container(
              padding: EdgeInsets.only(right: 15, top: 20),
              child: AutoSizeText(
                'Post',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: FontRefer.Poppins,
                  color: post == ''
                      ? Colors.white.withOpacity(0.4)
                      : ColorRefer.kFeroziColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: Constants.postLoading,
        progressIndicator:
        CircularProgressIndicator(color: ColorRefer.kMainThemeColor),
        child: Container(
          child: ListView(
            children: [
              Container(
                height: topCardHeight,
                padding: EdgeInsets.only(top: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //****************** Profile image ******************
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            UserProfile(
                              image: AuthController.currentUser!.profileImageUrl,
                              size: 40,
                            ),
                            SizedBox(width: 15),
                            AutoSizeText(
                              AuthController.currentUser!.username == null
                                  ? AuthController.currentUser!.name!
                                  : AuthController.currentUser!.username!,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: FontRefer.Poppins,
                                  color: theme.lightTheme == true
                                      ? Colors.black54
                                      : ColorRefer.kLightGreyColor),
                            ),
                          ],
                        ),
                      ),
                      //****************** Main Text Editor ******************
                      showTextField == false
                          ? Offstage()
                          : Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: TextField(
                                focusNode: _focusNode,
                                style:
                                    TextStyle(color: ColorRefer.kMainThemeColor),
                                controller: writeController,
                                maxLines: 5,
                                keyboardType: TextInputType.multiline,
                                onChanged: (value) {
                                  setState(() {
                                    post = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: textHint,
                                    hintStyle: TextStyle(
                                        fontFamily: FontRefer.Poppins,
                                        color: ColorRefer.kHintColor,
                                        fontSize: 15)),
                              ),
                            ),
                      //****************** URL Viewer ******************
                      Uri.parse(convertStringToLink(post!)).isAbsolute == false
                          ? Offstage()
                          : Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: SimpleUrlPreview(
                                url: convertStringToLink(post!),
                                imageLoaderColor: ColorRefer.kMainThemeColor,
                              ),
                            ),
                      //****************** Polling Option ******************
                      poll == false
                          ? Offstage()
                          : Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: pollOptions.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return PollOptions(
                                      hint: 'Answer #${index + 1}',
                                      onChanged: (value) {
                                        if (index == 0) pollOptions[0] = value;
                                        if (index == 1) pollOptions[1] = value;
                                        if (index == 2) pollOptions[2] = value;
                                        if (index == 3) pollOptions[3] = value;
                                      },
                                      showCancelButton: index < 2 ? false : true,
                                      onTap: () {
                                        setState(() {
                                          pollOptions.removeAt(index);
                                        });
                                      },
                                    );
                                  }),
                            ),
                      poll == false
                          ? Offstage()
                          : Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: CustomizedButton(
                                  title: '+ Add answers',
                                  buttonRadius: 5,
                                  colour: ColorRefer.kOrangeColor,
                                  height: 45,
                                  width: MediaQuery.of(context).size.width / 2,
                                  onPressed: () async {
                                    setState(() {
                                      if (pollOptions.length > 3) {
                                        ToastContext().init(context);
                                        Toast.show(
                                            'more than 4 answers are not allowed',
                                            duration: Toast.lengthLong,
                                            gravity: Toast.bottom);
                                      } else
                                        pollOptions.add('');
                                    });
                                  }),
                            ),
                      //****************** Show Gif Image ******************
                      gif == null || gif!.images.original == null
                          ? Offstage()
                          : Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      gif!.images.original!.url!,
                                      headers: {'accept': 'image/*'},
                                      height: 150,
                                      fit: BoxFit.cover,
                                      width:
                                          MediaQuery.of(context).size.width / 1.3,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const CupertinoActivityIndicator();
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    right: -12,
                                    top: -12,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            gif = GiphyGif(id: '123123');
                                            PostController().removeGif();
                                          });
                                        },
                                        child: Icon(
                                          CupertinoIcons.clear_thick_circled,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                      //****************** Show Capture Image ******************
                      image == null || image!.path == ''
                          ? Offstage()
                          : Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      image!,
                                      height: 150,
                                      fit: BoxFit.cover,
                                      width:
                                          MediaQuery.of(context).size.width / 1.3,
                                    ),
                                  ),
                                  Positioned(
                                    right: -12,
                                    top: -12,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            image = null;
                                          });
                                        },
                                        child: Icon(
                                          Icons.clear_rounded,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              showOptions == true
                  ? Container(child: postOptions(context, theme))
                  : BottomBar(
                      icon: selectedIcon,
                      text: selectedText,
                      onTap: () {
                        setState(() {
                          showOptions = true;
                          setHeight(context);
                        });
                      },
                      bottomCardHeight: bottomCardHeight,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget postOptions(BuildContext context, DarkThemeProvider theme) {
    return Container(
      height: bottomCardHeight,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 3, color: Colors.grey),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('What’s on your mind?',
              style: TextStyle(
                  fontFamily: FontRefer.Poppins,
                  fontSize: 16,
                  color:
                      theme.lightTheme == true ? Colors.black : Colors.white)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PostButton(
                text: "Text",
                selected: text,
                icon: FontAwesomeIcons.barsStaggered,
                onTap: () async {
                  showOptions = openBox(
                    txt: true,
                    title: "Text",
                    icon: FontAwesomeIcons.barsStaggered,
                  );
                  textHint = 'What\'s on your mind?';
                  setHeight(context);
                },
              ),
              SizedBox(width: 10),
              PostButton(
                text: "Camera",
                selected: camera,
                icon: CupertinoIcons.camera,
                onTap: () async {
                  showOptions = openBox(
                    cam: true,
                    title: "Camera",
                    icon: CupertinoIcons.camera,
                  );
                  textHint = 'Write caption here';
                  setHeight(context);
                  pickImage();
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PostButton(
                text: "Poll",
                selected: poll,
                icon: CupertinoIcons.chart_bar_square,
                onTap: () async {
                  showOptions = openBox(
                    pol: true,
                    title: "Poll",
                    icon: CupertinoIcons.chart_bar_square,
                  );
                  textHint = 'Write your question here';
                  setHeight(context);
                },
              ),
              SizedBox(width: 10),
              PostButton(
                text: "Link",
                selected: link,
                icon: CupertinoIcons.link,
                onTap: () async {
                  showOptions = openBox(
                    lin: true,
                    title: "Link",
                    icon: CupertinoIcons.link,
                  );
                  setHeight(context);
                  await showInsertLinkDialog();
                  setState(() {});
                },
              ),
              SizedBox(width: 10),
              PostButton(
                text: "GIF",
                icon: CupertinoIcons.play,
                selected: giff,
                onTap: () async {
                  showOptions = openBox(
                    gif: true,
                    title: "GIF",
                    icon: CupertinoIcons.play,
                  );
                  setHeight(context);
                  await showGifDialog();
                  setState(() {});
                },
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  void pickImage() async {
    XFile? galleryImage =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 40);
    setState(() {
      image = File(galleryImage!.path);
    });
  }

  showGifDialog() async {
    gif = await GiphyPicker.pickGif(
      context: context,
      apiKey: Constants.gifyAPIKey,
      showPreviewPage: false,
      fullScreenDialog: true,
      previewType: GiphyPreviewType.previewGif,
      // decorator: GiphyDecorator(
      //   showAppBar: false,
      //   searchElevation: 0,
      //   giphyTheme: themeData,
      // ),
    );
    if (gif?.images.original?.url != null) {
      PostController().setGif(gifUrl: gif!.images.original!.url);
    }
  }

  showInsertLinkDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Provider.of<DarkThemeProvider>(context);
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Dialog(
                child: Container(
                  color: theme.lightTheme == true
                      ? Colors.white
                      : ColorRefer.kBoxColor,
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.clear,
                                size: 17,
                                color: theme.lightTheme == true
                                    ? Colors.black
                                    : Colors.white)),
                      ),
                      insertLink!.isEmpty
                          ? Offstage()
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: SimpleUrlPreview(
                                url: convertStringToLink(post!),
                                imageLoaderColor: ColorRefer.kMainThemeColor,
                              ),
                            ),
                      TextField(
                        style: TextStyle(color: ColorRefer.kMainThemeColor),
                        controller: writeController,
                        maxLines: 2,
                        minLines: 1,
                        keyboardType: TextInputType.multiline,
                        onChanged: (value) {
                          setState(() {
                            insertLink = value;
                          });
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: "Paste the link...",
                            hintStyle: TextStyle(
                                fontFamily: FontRefer.Poppins,
                                color: ColorRefer.kHintColor,
                                fontSize: 15)),
                      ),
                      SizedBox(height: 20),
                      RoundedButton(
                        onPressed: () async {
                          setState(() {
                            post = insertLink;
                            writeController.text = post!;
                          });
                          writeController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: writeController.text.length));
                          if (Uri.parse(
                                      convertStringToLink(writeController.text))
                                  .isAbsolute ==
                              true) {
                            BitlyModel bitlyModel = await FShort.instance
                                .generateShortenURL(
                                    longUrl: convertStringToLink(
                                        writeController.text));
                            setState(() {
                              writeController.text = bitlyModel.link!;
                            });
                            Navigator.of(context).pop();
                          } else {
                            ToastContext().init(context);
                            Toast.show('Paste the link',
                                duration: Toast.lengthLong,
                                gravity: Toast.bottom);
                          }
                        },
                        title: 'OK',
                        colour: ColorRefer.kMainThemeColor,
                        buttonRadius: 8,
                        height: 40,
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  //****************** Functions to post through group ******************

  postWithinGroup() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if(widget.groupName == GroupCategories.School.displayTitle){
      selectedSchool();
    }else if(widget.groupName == GroupCategories.Life.displayTitle){
      selectedGroup(GroupCategories.Life);
    }else if(widget.groupName == GroupCategories.Athletics.displayTitle){
      selectedGroup(GroupCategories.Athletics);
    }else if(widget.groupName == GroupCategories.Activism.displayTitle){
      selectedGroup(GroupCategories.Activism);
    }else if(widget.groupName == GroupCategories.Relationships.displayTitle){
      selectedGroup(GroupCategories.Relationships);
    }else if(widget.groupName == GroupCategories.Friends_And_Roommates.displayTitle){
      selectedGroup(GroupCategories.Friends_And_Roommates);
    }else if(widget.groupName == GroupCategories.Post_Graduate.displayTitle){
      selectedGroup(GroupCategories.Post_Graduate);
    }else if(widget.groupName == GroupCategories.Habit.displayTitle){
      selectedGroup(GroupCategories.Habit);
    }
  }

  selectedGroup(GroupCategories groups) async{
    PostController().assignGroup(GroupModel(title: groups.displayTitle, image: groups.imagesPath, id: groups.id));
    await savePost(groups);
  }

  selectedSchool() async{
    PostController.postData.group = null;
    await savePost(GroupCategories.School);
  }

  savePost(GroupCategories groups) async{
    setState(() {
      Constants.postLoading = true;
    });
    if (poll == true) {
      bool result = PostController().checkPollData(pollOptions, context);
      if (result == true) {
        await PostController().savePostData(post);
        ToastContext().init(context);
        Toast.show('Posted', duration: Toast.lengthLong, gravity: Toast.bottom);
      }
    } else if (camera == true) {
      await PostController().setImages(image).then((value) async{
        await PostController().savePostData(post);
        ToastContext().init(context);
        Toast.show('Posted', duration: Toast.lengthLong, gravity: Toast.bottom);
      });
    } else {
      await PostController().savePostData(post);
      ToastContext().init(context);
      Toast.show('Posted', duration: Toast.lengthLong, gravity: Toast.bottom);
    }
    if(widget.groupName == GroupCategories.School.displayTitle){
      await GroupController.getUniPosts(20).then((value) {
        Get.back();
        Get.to(() => GroupPosts(
            groupDetail: GroupModel(
                title: groups.displayTitle,
                image: groups.imagesPath,
                id: groups.id),
            groups: false));
      });
    }else{
      await GroupController.getGroupPosts(groups.id, 20).then((value) {
        Get.back();
        Get.to(() => GroupPosts(
            groupDetail: GroupModel(
                title: groups.displayTitle,
                image: groups.imagesPath,
                id: groups.id),
            groups: false));
      });
    }

    setState(() {
      Constants.postLoading = false;
    });
  }

}
