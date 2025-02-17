import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:buddi/models/chat_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddi/controller/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'audio_player_card.dart';

class MessagesStream extends StatefulWidget {
  final String? threadId;
  final String? buddiName;
  final String? buddiID;
  MessagesStream(this.threadId, this.buddiName, this.buddiID);
  @override
  _MessagesStreamState createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream> {
  final _firestore = FirebaseFirestore.instance;
  final List<Map<String, dynamic>> messageList = [];

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('MMM dd, yyyy');
    var timeFormatter = new DateFormat('hh:mm a');
    return new StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .where("thread_id", isEqualTo: widget.threadId)
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        List<MessageBubble> messageBubbles = [];
        if (snapshot.hasData) {
          final messages = snapshot.data!.docs;
          try {
            for (var message in messages) {
              AppMessages appMessages = AppMessages.mapToMessage(
                  message.data() as Map<String, dynamic>);
              final messageText = appMessages.text;
              final messageSender = appMessages.senderId ?? "";
              final currentUser = AuthController.currentUser!.uid;
              final type = appMessages.type;
              final date = appMessages.date!;
              timeFormatter.format(date.toDate());
              final messageBubble = MessageBubble(
                key: UniqueKey(),
                id: message.id,
                sender: messageSender,
                text: messageText ?? "",
                type: type,
                time: timeFormatter.format(date.toDate()),
                isMe: currentUser == messageSender,
              );
              messageBubbles.add(messageBubble);
            }
          } catch (e) {
            print(e);
          }
        }
        return Expanded(
          child: Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25), topLeft: Radius.circular(25)),
            ),
            child: Column(
              children: [
                AutoSizeText(
                  formatter.format(DateTime.now()),
                  style: TextStyle(color: ColorRefer.kHintColor, fontSize: 14),
                ),
                Flexible(
                  child: ListView(
                    reverse: true,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    semanticChildCount: messageBubbles.length,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                    children: messageBubbles,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // endConversation(BuildContext context, String? threadId, DarkThemeProvider theme) {
  //   Navigator.of(context).pop();
  //   AppDialog().showOSDialog(
  //     context,
  //     "Conversation End",
  //     "Conversation has been ended by " + widget.buddiName!,
  //     "OK",
  //     () async{
  //       await FindBuddiController.removeChat(threadId);
  //       await showDialog(
  //         context: context,
  //         useSafeArea: false,
  //         barrierColor: theme.lightTheme == true
  //             ? ColorRefer.kBackColor.withOpacity(0.30)
  //             : ColorRefer.kBackColor.withOpacity(0.30),
  //         builder: (BuildContext context) {
  //           return RatingScreen();
  //         },
  //       );
  //     },
  //   );
  // }
}

class MessageBubble extends StatefulWidget {
  MessageBubble(
      {this.sender,
      this.text,
      this.id,
      this.isMe,
      this.time,
      this.type,
      Key? key})
      : super(key: key);
  final String? time;
  final String? sender;
  final String? text;
  final String? id;
  final int? type;
  final bool? isMe;
  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            widget.isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: widget.type == 0
                ? Material(
                    borderRadius: widget.isMe!
                        ? BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            bottomLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0))
                        : BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0),
                            topRight: Radius.circular(12.0),
                          ),
                    elevation: 3.0,
                    color: widget.isMe!
                        ? ColorRefer.kMainThemeColor
                        : ColorRefer.kChatColor,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      child: Text(
                        widget.text!,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: FontRefer.PoppinsSemiBold,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  )
                : widget.type == 1
                    ? Container(
                        child: AudioPlayerCard(
                          file: widget.text,
                          id: widget.id,
                          color: widget.isMe!
                              ? ColorRefer.kMainThemeColor
                              : ColorRefer.kChatColor,
                          isMe: widget.isMe,
                        ),
                      )
                    : Container(),
          ),
          SizedBox(height: 5),
          Text(
            widget.time!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontFamily: FontRefer.PoppinsSemiBold,
              fontSize: 10.0,
            ),
          )
        ],
      ),
    );
  }
}
