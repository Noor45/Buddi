import 'package:cloud_firestore/cloud_firestore.dart';

class ReportPostData {
  String? postId;
  List? tags;
  String? post;
  var userData;
  List? postLike;
  List? postComment;
  Timestamp? createdAt;

  ReportPostData({
    this.postId,
    this.post,
    this.userData,
    this.postLike,
    this.postComment,
    this.tags,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      ReportPostDataFields.POST_ID: this.postId,
      ReportPostDataFields.POST: this.post,
      ReportPostDataFields.POST_LIKE: this.postLike,
      ReportPostDataFields.POST_COMMENT: this.postComment,
      ReportPostDataFields.USER_DATA: this.userData,
      ReportPostDataFields.TAGS: this.tags,
      ReportPostDataFields.CREATED_AT: this.createdAt,
    };
  }

  ReportPostData.fromMap(Map<String, dynamic> map) {
    this.postId = map[ReportPostDataFields.POST_ID];
    this.post = map[ReportPostDataFields.POST];
    this.postLike = map[ReportPostDataFields.POST_LIKE];
    this.postComment = map[ReportPostDataFields.POST_COMMENT];
    this.userData = map[ReportPostDataFields.USER_DATA];
    this.tags = map[ReportPostDataFields.TAGS];
    this.createdAt = map[ReportPostDataFields.CREATED_AT];
  }

  @override
  String toString() {
    return 'ReportPostData{post_id: $postId, post: $post, post_comment: $postComment, post_like: $postLike, user_data: $userData, tags: $tags, post_created_at: $createdAt}';
  }
}

class ReportPostDataFields {
  static const String TAGS = "tags";
  static const String POST_ID = "post_id";
  static const String POST = "post";
  static const String USER_DATA = "user_data";
  static const String POST_LIKE = "post_like";
  static const String POST_COMMENT = "post_comment";
  static const String CREATED_AT = "created_at";
}
