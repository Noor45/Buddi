import 'package:cloud_firestore/cloud_firestore.dart';

class ResourceModel {
  String? title;
  String? id;
  Timestamp? createdAt;

  ResourceModel({
    this.title,
    this.createdAt,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      ResourceModelFields.TITLE: this.title,
      ResourceModelFields.ID: this.id,
      ResourceModelFields.CREATED_AT: this.createdAt,
    };
  }

  ResourceModel.fromMap(Map<String, dynamic> map) {
    this.title = map[ResourceModelFields.TITLE];
    this.id = map[ResourceModelFields.ID];
    this.createdAt = map[ResourceModelFields.CREATED_AT];
  }

  @override
  String toString() {
    return 'ResourceModel{title: $title, post_id: $id, created_at: $createdAt}';
  }
}

class ResourceModelFields {
  static const String TITLE = "title";
  static const String ID = "post_id";
  static const String CREATED_AT = "created_at";
}
