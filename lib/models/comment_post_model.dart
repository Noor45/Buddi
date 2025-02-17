import 'package:buddi/models/postUserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentPostModel {
  String? uid;
  String? comment;
  var userData;
  String? commentId;
  Timestamp? createdAt;

  CommentPostModel({
    this.uid,
    this.comment,
    this.userData,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      CommentPostModelFields.UID: this.uid,
      CommentPostModelFields.COMMENT: this.comment,
      CommentPostModelFields.COMMENT_ID: this.commentId,
      CommentPostModelFields.USER_DATA: this.userData,
      CommentPostModelFields.CREATED_AT: this.createdAt,
    };
  }

  CommentPostModel.fromMap(Map<String, dynamic> map) {
    this.uid = map[CommentPostModelFields.UID];
    this.comment = map[CommentPostModelFields.COMMENT];
    this.commentId = map[CommentPostModelFields.COMMENT_ID];
    this.userData = PostUserModel.fromMap(map[CommentPostModelFields.USER_DATA]).toMap();
    this.createdAt = map[CommentPostModelFields.CREATED_AT];
  }

  @override
  String toString() {
    return 'CommentPostModel{uid: $uid, comment: $comment, comment_id: $commentId, user_data: $userData, created_at: $createdAt}';
  }
}

class CommentPostModelFields {
  static const String UID = "uid";
  static const String COMMENT = "comment";
  static const String COMMENT_ID = "comment_id";
  static const String USER_DATA = "user_data";
  static const String CREATED_AT = "created_at";
}
