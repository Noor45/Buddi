import 'package:cloud_firestore/cloud_firestore.dart';

class ReportUserData {
  String? userId;
  String? type;
  Timestamp? createdAt;

  ReportUserData({
    this.userId,
    this.type,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      ReportUserDataFields.USER_ID: this.userId,
      ReportUserDataFields.TYPE: this.type,
      ReportUserDataFields.CREATED_AT: this.createdAt,
    };
  }

  ReportUserData.fromMap(Map<String, dynamic> map) {
    this.type = map[ReportUserDataFields.TYPE];
    this.createdAt = map[ReportUserDataFields.CREATED_AT];
    this.userId = map[ReportUserDataFields.USER_ID];
  }

  @override
  String toString() {
    return 'ReportUserData{type: $type, created_at: $createdAt, uid: $userId}';
  }
}

class ReportUserDataFields {
  static const String TYPE = "type";
  static const String CREATED_AT = "created_at";
  static const String USER_ID = "uid";
}
