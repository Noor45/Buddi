import 'package:cloud_firestore/cloud_firestore.dart';

class AppMessages {

  String? id;
  String? senderId;
  String? receiverId;
  String? text;
  String? threadId;
  int? type;
  Timestamp? date;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'thread_id': threadId,
      'type': type,
      'text': text,
      'date': date,
    };
  }

  AppMessages();

  static AppMessages mapToMessage(Map<String, dynamic> map) {
    AppMessages appMessage = new AppMessages();
    appMessage.id = map['id'];
    appMessage.senderId = map['sender_id'];
    appMessage.receiverId = map['receiver_id'];
    appMessage.type = map['type'];
    appMessage.text = map['text'] ?? "";
    appMessage.threadId = map["thread_id"];
    appMessage.date = map["date"];
    return appMessage;
  }
}
