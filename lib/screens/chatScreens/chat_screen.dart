import 'dart:io';
import 'dart:async';
import 'package:buddi/cards/message_bubble.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:buddi/utils/constants.dart';
import 'package:buddi/widgets/dialogs.dart';
import 'package:buddi/widgets/profile.dart';
import 'package:buddi/models/chat_model.dart';
import 'package:buddi/widgets/round_button.dart';
import 'package:buddi/screens/chatScreens/rating_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:buddi/widgets/blinking_button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddi/controller/auth_controller.dart';
import 'package:buddi/functions/global_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

class ChatScreen extends StatefulWidget {
  static const String Chat_Screen = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final messageTextController = TextEditingController();
  String? messageText;
  String? threadId;
  bool emojiKeyBoard = false;
  bool _isLoading = false;
  var theSource = AudioSource.microphone;
  Codec _codec = Codec.aacADTS;
  String _mPath = '';
  String _mFileName = '';
  int isRecording = 0;
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool deletedBy = false;
  bool _isDialogShowing = false;

  GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
  String createChatKey(String? uid1, String? uid2) {
    String key;
    if (uid1!.compareTo(uid2!) > 0)
      key = uid1 + "_" + uid2;
    else
      key = uid2 + "_" + uid1;
    return key;
  }

  void onEmojiSelected(Emoji emoji) {
    setState(() {
      messageTextController
        ..text += emoji.emoji
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: messageTextController.text.length));
    });
  }

  void startRecorder() async {
    setState(() {
      isRecording = 1;
    });
    var tempDir = await getTemporaryDirectory();
    _mPath =
    '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.aac';
    _mFileName = '${DateTime.now().millisecondsSinceEpoch.toString()}.aac';
    await _mRecorder!
        .startRecorder(
      toFile: _mPath,
      codec: _codec,
      numChannels: 1,
      audioSource: theSource,
    )
        .then((value) {
      setState(() {});
    });
  }

  Future<void> stopRecorder() async {
    setState(() {
      isRecording = 2;
    });
    await _mRecorder!.stopRecorder().then((value) async {
      AppMessages message = AppMessages();
      if (_mPath != '') {
        File file = new File(_mPath);
        String fileName =
        await uploadRecordingToFirebase(file, _mFileName, threadId);
        setState(() {
          message.text = fileName;
        });
      }
      setState(() {
        message.threadId = this.threadId;
        message.senderId = AuthController.currentUser!.uid;
        message.receiverId = Constants.selectedChatId;
        message.type = 1;
        messageTextController.clear();
        message.date = Timestamp.now();
      });
      var ref = await _firestore.collection('messages').add(message.toMap());
      message.id = ref.id;
      await _firestore
          .collection('messages')
          .doc(ref.id)
          .update(message.toMap());
      setState(() {});
    });
    setState(() {
      isRecording = 0;
    });
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        // throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    _mRecorder!.openRecorder();
  }

  @override
  void dispose() {
    _mRecorder!.closeRecorder();
    _mRecorder = null;
    Constants.threadId = null;
    super.dispose();
  }

  @override
  void initState() {
    threadId = createChatKey(
        Constants.selectedChatId, AuthController.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: ModalProgressHUD(
        inAsyncCall: _isLoading,
        progressIndicator: Theme(
          data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: ColorRefer.kMainThemeColor)),
          child: CircularProgressIndicator(
            backgroundColor: ColorRefer.kMainThemeColor,
          ),
        ),
        child: Scaffold(
          backgroundColor: theme.lightTheme == true
              ? ColorRefer.kChatBackColor
              : ColorRefer.kBackColor,
          appBar: AppBar(
            toolbarHeight: 0,
            elevation: 0,
          ),
          body: new StreamBuilder<DocumentSnapshot>(
              stream: _firestore
                  .collection('delete_message')
                  .doc(threadId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active &&
                    snapshot.hasData) {
                  if (snapshot.hasData) {
                    if (snapshot.data?.metadata.isFromCache == false) {
                      if (snapshot.data?.exists == true) {
                        String tId = snapshot.data?.get('threadId');
                        if (tId == threadId) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            closeConversation(context, this.threadId, theme);
                          });
                        }
                      }
                    }
                  }
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Profile(
                                    image: Constants
                                        .selectedChatUser.profileImageUrl),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 35),
                                child: AutoSizeText(
                                  Constants.selectedChatUser.name!,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: FontRefer.PoppinsMedium,
                                    color: theme.lightTheme == true
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              )
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: RoundedButton(
                                title: 'End Conversation',
                                height: 40,
                                buttonRadius: 12,
                                colour: Colors.red,
                                onPressed: () {
                                  AppDialog().showOSDialog(
                                      context,
                                      "Conversation End",
                                      "Are you sure you want to end the conversation",
                                      "Yes", () {
                                    endConversation(context, theme);
                                  },
                                      secondButtonText: "Cancel",
                                      secondCallback: () {});
                                }),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                                topLeft: Radius.circular(25)),
                            color: theme.lightTheme == true
                                ? Colors.white
                                : ColorRefer.kBoxColor,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(
                                      theme.lightTheme == true ? 0.3 : 0.0),
                                  spreadRadius: 8,
                                  blurRadius: 7,
                                  offset: Offset(0, 6)),
                            ],
                          ),
                          child: Container(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Column(
                              children: [
                                MessagesStream(
                                    threadId,
                                    Constants.selectedChatUser.name,
                                    Constants.selectedChatUser.uid),
                                Expanded(
                                  flex: 0,
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        color: theme.lightTheme == true
                                            ? ColorRefer.kGreyColor
                                            : ColorRefer.kBackColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              if (emojiKeyBoard == false)
                                                emojiKeyBoard = true;
                                              else
                                                emojiKeyBoard = false;
                                            });
                                          },
                                          child: Icon(
                                            Icons.emoji_emotions_outlined,
                                            color: emojiKeyBoard == false
                                                ? ColorRefer.kHintColor
                                                : ColorRefer.kMainThemeColor,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: TextField(
                                            controller: messageTextController,
                                            onChanged: (value) {
                                              setState(() {
                                                messageText = value;
                                              });
                                            },
                                            style: TextStyle(
                                                color: theme.lightTheme == true
                                                    ? Colors.black
                                                    : Colors.white),
                                            decoration:
                                            kMessageTextFieldDecoration
                                                .copyWith(
                                              hintText: 'Type a message...',
                                              fillColor:
                                              theme.lightTheme == true
                                                  ? ColorRefer.kGreyColor
                                                  : Colors.transparent,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: messageTextController.text ==
                                              ''
                                              ? Container(
                                            child: isRecording == 1
                                                ? RecorderStopButton(
                                              onPressed: () {
                                                stopRecorder();
                                              },
                                            )
                                                : isRecording == 0
                                                ? RecorderStartButton(
                                              onPressed: () {
                                                openTheRecorder()
                                                    .then(
                                                        (value) {
                                                      setState(() {
                                                        startRecorder();
                                                      });
                                                    });
                                              },
                                            )
                                                : WaitButton(),
                                          )
                                              : InkWell(
                                              onTap: () {
                                                sendMessage();
                                              },
                                              child: SendButton()),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: emojiKeyBoard,
                                  child: Expanded(
                                    child: EmojiPicker(
                                      onEmojiSelected: (category, emoji) {
                                        onEmojiSelected(emoji);
                                      },
                                      onBackspacePressed: () {
                                        setState(() {
                                          messageTextController
                                            ..text = messageTextController
                                                .text.characters
                                                .skipLast(1)
                                                .toString()
                                            ..selection = TextSelection
                                                .fromPosition(TextPosition(
                                                offset:
                                                messageTextController
                                                    .text.length));
                                        });
                                      },
                                      config: Config(
                                          columns: 7,
                                          emojiSizeMax: 32.0,
                                          verticalSpacing: 0,
                                          horizontalSpacing: 0,
                                          initCategory: Category.RECENT,
                                          indicatorColor:
                                          ColorRefer.kMainThemeColor,
                                          iconColorSelected:
                                          ColorRefer.kMainThemeColor,
                                          backspaceColor:
                                          ColorRefer.kMainThemeColor,
                                          showRecentsTab: true,
                                          recentsLimit: 28,
                                          categoryIcons: const CategoryIcons(),
                                          buttonMode: ButtonMode.MATERIAL),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  sendMessage() async {
    AppMessages message = AppMessages();
    setState(() {
      message.threadId = this.threadId;
      message.senderId = AuthController.currentUser!.uid;
      message.type = 0;
      if (messageTextController.text == null) {
        message.text = null;
      } else {
        message.text = messageTextController.text;
      }
      message.receiverId = Constants.selectedChatId;
      messageTextController.clear();
      message.date = Timestamp.now();
    });
    var ref = await _firestore.collection('messages').add(message.toMap());
    message.id = ref.id;
    await _firestore.collection('messages').doc(ref.id).update(message.toMap());
  }

  void endConversation(BuildContext context, DarkThemeProvider theme) async {
    FocusScope.of(context).requestFocus(FocusNode());
    deletedBy = true;
    _isLoading = true;
    Map<String, dynamic> doc = {'threadId': this.threadId};
    _firestore.collection('delete_message').doc(this.threadId).set(doc);
    Navigator.of(context).pop();
    showDialog(
      context: context,
      useSafeArea: false,
      barrierColor: theme.lightTheme == true
          ? ColorRefer.kBackColor.withOpacity(0.99)
          : ColorRefer.kBackColor.withOpacity(0.99),
      builder: (BuildContext context) {
        return RatingScreen();
      },
    );
    _isLoading = false;
    return;
  }

  closeConversation(
      BuildContext context, String? threadId, DarkThemeProvider theme) {
    print("=================> closeConversation");
    if (deletedBy == false && _isDialogShowing == false) {
      _isDialogShowing = true;
      print("=================> Showing Diloag");
      AppDialog().showOSDialog(
        context,
        "Conversation End",
        "Conversation has been ended by " + Constants.selectedChatUser.name!,
        "OK",
            () async {
          Navigator.of(context).pop();
          await showDialog(
            context: context,
            useSafeArea: false,
            barrierColor: theme.lightTheme == true
                ? ColorRefer.kBackColor.withOpacity(0.99)
                : ColorRefer.kBackColor.withOpacity(0.99),
            builder: (_) {
              return RatingScreen();
            },
          );
        },
      );
    }
  }
}