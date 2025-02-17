import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  List? reportId;
  String? postId;
  Timestamp? createdAt;

  ReportModel({
    this.reportId,
    this.postId,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      ReportModelFields.REPORT_ID: this.reportId,
      ReportModelFields.POST_ID: this.postId,
      ReportModelFields.CREATED_AT: this.createdAt,
    };
  }

  ReportModel.fromMap(Map<String, dynamic> map) {
    this.reportId = map[ReportModelFields.REPORT_ID] ?? [];
    this.postId = map[ReportModelFields.POST_ID];
    this.createdAt = map[ReportModelFields.CREATED_AT];
  }

  @override
  String toString() {
    return 'ReportModel{post_id: $postId, report_id: $reportId, created_at: $createdAt}';
  }
}

class ReportModelFields {
  static const String POST_ID = "post_id";
  static const String REPORT_ID = "report_id";
  static const String CREATED_AT = "created_at";
}
