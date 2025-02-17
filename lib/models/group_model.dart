import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  // String? category;
  // List? members;
  // List? reportedBy;
  // String? des;
  String? id;
  // String? icon;
  String? title;
  String? image;
  // Timestamp? createdAt;

  GroupModel({
    // this.category,
    // this.createdAt,
    this.title,
    this.image,
    // this.members,
    // this.reportedBy,
    // this.des,
    // this.icon,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      // GroupModelFields.CATEGORIES: this.category,
      // GroupModelFields.DES: this.des,
      // GroupModelFields.CREATED_AT: this.createdAt,
      GroupModelFields.TITLE: this.title,
      GroupModelFields.IMAGE: this.image,
      // GroupModelFields.MEMBERS: this.members,
      GroupModelFields.ID: this.id,
      // GroupModelFields.ICON: this.icon,
      // GroupModelFields.REPORTED_BY: this.reportedBy,
    };
  }

  GroupModel.fromMap(Map<String, dynamic> map) {
    // this.category = map[GroupModelFields.CATEGORIES];
    // this.des = map[GroupModelFields.DES];
    // this.members = map[GroupModelFields.MEMBERS];
    this.id = map[GroupModelFields.ID];
    // this.icon = map[GroupModelFields.ICON];
    // this.createdAt = map[GroupModelFields.CREATED_AT];
    this.title = map[GroupModelFields.TITLE];
    this.image = map[GroupModelFields.IMAGE];
    // this.reportedBy = map[GroupModelFields.REPORTED_BY];
  }

  @override
  String toString() {
    return 'GroupModel{id: $id,  title: $title, image: $image}';
  }
}

class GroupModelFields {
  static const String ID = "id";
  // static const String ICON = "icon";
  // static const String CATEGORIES = "category";
  // static const String DES = "des";
  // static const String CREATED_AT = "created_at";
  static const String TITLE = "title";
  static const String IMAGE = "image";
  // static const String MEMBERS = "members";
  // static const String REPORTED_BY = "reported_by";
}
