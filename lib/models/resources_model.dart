import 'package:cloud_firestore/cloud_firestore.dart';

class ResourcesModel {
  String? description;
  String? title;
  String? id;
  String? icon;
  Timestamp? createdAt;

  ResourcesModel({
    this.description,
    this.title,
    this.icon,
    this.createdAt,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      ResourcesModelFields.DESCRIPTION: this.description,
      ResourcesModelFields.TITLE: this.title,
      ResourcesModelFields.ID: this.id,
      ResourcesModelFields.ICON: this.icon,
      ResourcesModelFields.CREATED_AT: this.createdAt,
    };
  }

  ResourcesModel.fromMap(Map<String, dynamic> map) {

    this.description = map[ResourcesModelFields.DESCRIPTION];
    this.title = map[ResourcesModelFields.TITLE];
    this.id = map[ResourcesModelFields.ID];
    this.icon = map[ResourcesModelFields.ICON];
    this.createdAt = map[ResourcesModelFields.CREATED_AT];

  }

  @override
  String toString() {
    return 'ResourceModel{des: $description, title: $title, id: $id, icon: $icon, created_at: $createdAt}';
  }
}

class ResourcesModelFields {
  static const String DESCRIPTION = "des";
  static const String TITLE = "title";
  static const String ID = "id";
  static const String ICON = "icon";
  static const String CREATED_AT = "created_at";
}
