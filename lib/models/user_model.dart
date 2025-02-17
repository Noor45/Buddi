import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  List? rating;
  String? name;
  String? username;
  String? email;
  String? address;
  bool? liveOnCampus;
  String? uniName;
  String? profileImageUrl;
  String? selectGrade;
  Timestamp? createdAt;
  Timestamp? joinDate;
  List? blockedUser;
  List? groups;
  List? interests;
  int? listenerCode;
  UserModel({
    this.uid,
    this.name,
    this.username,
    this.email,
    this.address,
    this.liveOnCampus,
    this.profileImageUrl,
    this.selectGrade,
    this.rating,
    this.uniName,
    this.createdAt,
    this.joinDate,
    this.interests,
    this.blockedUser,
    this.groups,
    this.listenerCode,
  });

  Map<String, dynamic> toMap() {
    return {
      UserModelFields.UID: this.uid,
      UserModelFields.NAME: this.name,
      UserModelFields.EMAIL: this.email,
      UserModelFields.ADDRESS: this.address,
      UserModelFields.LIVE_ON_CAMPUS: this.liveOnCampus,
      UserModelFields.RATING: this.rating,
      UserModelFields.UNI_NAME: this.uniName,
      UserModelFields.USERNAME: this.username,
      UserModelFields.CREATED_AT: this.createdAt,
      UserModelFields.JOIN_DATE: this.joinDate,
      UserModelFields.GROUPS: this.groups,
      UserModelFields.PROFILE_IMAGE_URL: this.profileImageUrl,
      UserModelFields.BlockUser: this.blockedUser,
      UserModelFields.SELECT_GRADE: this.selectGrade,
      UserModelFields.INTERESTS: this.interests,
      UserModelFields.LISTENER_CODE: this.listenerCode,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    this.uid = map[UserModelFields.UID];
    this.name = map[UserModelFields.NAME];
    this.email = map[UserModelFields.EMAIL];
    this.address = map[UserModelFields.ADDRESS];
    this.liveOnCampus = map[UserModelFields.LIVE_ON_CAMPUS];
    this.rating = map[UserModelFields.RATING];
    this.uniName = map[UserModelFields.UNI_NAME];
    this.createdAt = map[UserModelFields.CREATED_AT];
    this.interests = map[UserModelFields.INTERESTS];
    this.blockedUser = map[UserModelFields.BlockUser];
    this.selectGrade = map[UserModelFields.SELECT_GRADE];
    this.groups = map[UserModelFields.GROUPS];
    this.profileImageUrl = map[UserModelFields.PROFILE_IMAGE_URL];
    this.listenerCode = map[UserModelFields.LISTENER_CODE];
    this.username = map[UserModelFields.USERNAME];
    this.joinDate = map[UserModelFields.JOIN_DATE];
  }

  @override
  String toString() {
    return 'UserModel{uid: $uid, join_date: $joinDate, username: $username, profile_image_url : $profileImageUrl, listener_code: $listenerCode, name: $name, email: $email, address: $address, live_on_campus: $liveOnCampus, groups: $groups, interests: $interests, uni_name: $uniName, rating: $rating, select_grade: $selectGrade, created_at: $createdAt}';
  }
}

class UserModelFields {
  static const String UID = "uid";
  static const String NAME = "name";
  static const String EMAIL = "email";
  static const String ADDRESS = "address";
  static const String LIVE_ON_CAMPUS = "live_on_campus";
  static const String RATING = "rating";
  static const String UNI_NAME = "uni_name";
  static const String CREATED_AT = "created_at";
  static const String GROUPS = "groups";
  static const String BlockUser = "blocked_user";
  static const String SELECT_GRADE = "select_grade";
  static const String INTERESTS = "interests";
  static const String PROFILE_IMAGE_URL = "profile_image_url";
  static const String LISTENER_CODE = "listener_code";
  static const String USERNAME = "username";
  static const String JOIN_DATE = "join_date";
}
