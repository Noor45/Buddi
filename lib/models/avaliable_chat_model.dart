import 'package:cloud_firestore/cloud_firestore.dart';

class AvailableForChatModel {
  String? uid;
  int? chatType;
  int? userType;
  Timestamp? createdAt;

  AvailableForChatModel({
    this.uid,
    this.chatType,
    this.userType,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      AvailableForChatModelFields.UID: this.uid,
      AvailableForChatModelFields.CHAT_TYPE: this.chatType,
      AvailableForChatModelFields.USER_TYPE: this.userType,
      AvailableForChatModelFields.CREATED_AT: this.createdAt,
    };
  }

  AvailableForChatModel.fromMap(Map<String, dynamic> map) {
    this.uid = map[AvailableForChatModelFields.UID];
    this.chatType = map[AvailableForChatModelFields.CHAT_TYPE];
    this.userType = map[AvailableForChatModelFields.USER_TYPE];
    this.createdAt = map[AvailableForChatModelFields.CREATED_AT];
  }

  @override
  String toString() {
    return 'AvailableForChatModel{uid: $uid, chat_type: $chatType, user_type: $userType, created_at: $createdAt}';
  }
}

class AvailableForChatModelFields {
  static const String UID = "uid";
  static const String CHAT_TYPE = "chat_type";
  static const String USER_TYPE = "user_type";
  static const String CREATED_AT = "created_at";
}
