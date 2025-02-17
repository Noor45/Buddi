class LikePostModel {
  String? uid;
  int? reaction;

  LikePostModel({
    this.uid,
    this.reaction,
  });

  Map<String, dynamic> toMap() {
    return {
      LikePostModelFields.UID: this.uid,
      LikePostModelFields.REACTION: this.reaction,
    };
  }

  LikePostModel.fromMap(Map<String, dynamic> map) {
    this.uid = map[LikePostModelFields.UID];
    this.reaction = map[LikePostModelFields.REACTION];
  }

  @override
  String toString() {
    return 'LikePostModel{uid: $uid, reaction: $reaction}';
  }
}

class LikePostModelFields {
  static const String UID = "uid";
  static const String REACTION = "reaction";
}
