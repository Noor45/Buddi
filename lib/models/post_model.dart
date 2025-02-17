import 'package:buddi/models/postUserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  var userData;
  var group;
  var poll;
  String? gif;
  String? post;
  String? image;
  String? postId;
  List? postLike;
  Timestamp? createdAt;

  PostModel({
    this.post,
    this.postId,
    this.postLike,
    this.userData,
    this.group,
    this.createdAt,
    this.gif,
    this.image,
    this.poll,
  });

  Map<String, dynamic> toMap() {
    return {
      PostModelFields.POST: this.post,
      PostModelFields.USER_DATA: this.userData,
      PostModelFields.POST_ID: this.postId,
      PostModelFields.CREATED_AT: this.createdAt,
      PostModelFields.GIF: this.gif,
      PostModelFields.POLL: this.poll,
      PostModelFields.IMAGE: this.image,
      PostModelFields.GROUP: this.group,
    };
  }

  PostModel.fromMap(Map<String, dynamic> map) {
    this.userData = PostUserModel.fromMap(map[PostModelFields.USER_DATA]).toMap();
    this.gif = map[PostModelFields.GIF];
    this.image = map[PostModelFields.IMAGE];
    this.post = map[PostModelFields.POST];
    this.group = map[PostModelFields.GROUP];
    this.postId = map[PostModelFields.POST_ID];
    this.poll = map[PostModelFields.POLL];
    this.createdAt = map[PostModelFields.CREATED_AT];
    this.postLike = map[PostModelFields.POST_LIKE] ?? [];
  }


  @override
  String toString() {
    return 'PostModel{post_id: $postId, post: $post, polls: $poll, user_data: $userData, group: $group, post_likes: $postLike, created_at: $createdAt, image: $image}';
  }
}

class PostModelFields {
  static const String POST = "post";
  static const String POST_ID = "post_id";
  static const String USER_DATA = "user_data";
  static const String GROUP = "group";
  static const String UNI_NAME = "uni_name";
  static const String POST_LIKE = "post_likes";
  static const String REPORTS = "reports";
  static const String CONCERNED = "concerned";
  static const String CREATED_AT = "created_at";
  static const String POST_COMMENT = "post_comments";
  static const String GIF = "gif";
  static const String POLL = "polls";
  static const String IMAGE = "image";
}
