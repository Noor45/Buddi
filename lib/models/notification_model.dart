import 'package:buddi/models/postUserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  var notifyBy;
  String? notification;
  String? post;
  String? id;
  String? userId;
  String? notifyFor;
  Timestamp? createdAt;

  NotificationModel({
    this.notifyBy,
    this.notification,
    this.createdAt,
    this.notifyFor,
    this.post,
    this.userId,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      NotificationModelFields.NOTIFY_BY: this.notifyBy,
      NotificationModelFields.NOTIFICATION: this.notification,
      NotificationModelFields.POST: this.post,
      NotificationModelFields.CREATED_AT: this.createdAt,
      NotificationModelFields.NOTIFY_FOR: this.notifyFor,
      NotificationModelFields.ID: this.id,
      NotificationModelFields.USER_ID: this.userId,
    };
  }

  NotificationModel.fromMap(Map<String, dynamic> map) {
    this.notifyBy = PostUserModel.fromMap(map[NotificationModelFields.NOTIFY_BY]).toMap();
    this.notification = map[NotificationModelFields.NOTIFICATION];
    this.post = map[NotificationModelFields.POST];
    this.id = map[NotificationModelFields.ID];
    this.userId = map[NotificationModelFields.USER_ID];
    this.createdAt = map[NotificationModelFields.CREATED_AT];
    this.notifyFor = map[NotificationModelFields.NOTIFY_FOR];
  }

  @override
  String toString() {
    return 'NotificationModel{notify_by: $notifyBy, id: $id, user_id: $userId, notification: $notification, post: $post, created_at: $createdAt, notify_for: $notifyFor}';
  }
}

class NotificationModelFields {
  static const String ID = "id";
  static const String USER_ID = "user_id";
  static const String NOTIFY_BY = "notify_by";
  static const String NOTIFICATION = "notification";
  static const String POST = "post";
  static const String CREATED_AT = "created_at";
  static const String NOTIFY_FOR = "notify_for";
}
