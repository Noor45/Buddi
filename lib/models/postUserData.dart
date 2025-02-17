class PostUserModel {
  String? uid;
  String? name;
  String? profileImage;
  String? uniName;
  // int emojiIndex;

  PostUserModel({
    this.uid,
    this.name,
    this.profileImage,
    this.uniName,
    // this.emojiIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      PostUserModelFields.UID: this.uid,
      PostUserModelFields.NAME: this.name,
      PostUserModelFields.UNI_NAME: this.uniName,
      PostUserModelFields.PROFILE_IMAGE: this.profileImage,
      // PostUserModelFields.EMOJI_INDEX: this.emojiIndex,
    };
  }

  PostUserModel.fromMap(Map<String, dynamic> map) {
    this.uid = map[PostUserModelFields.UID];
    this.name = map[PostUserModelFields.NAME];
    this.uniName = map[PostUserModelFields.UNI_NAME];
    this.profileImage = map[PostUserModelFields.PROFILE_IMAGE];
    // this.emojiIndex = map[PostUserModelFields.EMOJI_INDEX];
  }

  @override
  String toString() {
    return 'PostUserModel{uid: $uid, name: $name, profileImage: $profileImage, uni_name: $uniName}';
  }
}

class PostUserModelFields {
  static const String UID = "uid";
  static const String NAME = "name";
  static const String UNI_NAME = "uni_name";
  static const String PROFILE_IMAGE = "profileImage";
  // static const String EMOJI_INDEX = "emojiIndex";
}
