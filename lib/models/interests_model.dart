class InterestsModel {
  String? id;
  String? icon;
  String? title;

  InterestsModel({
    this.id,
    this.icon,
    this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      InterestsModelFields.ID: this.id,
      InterestsModelFields.ICON: this.icon,
      InterestsModelFields.TITLE: this.title,
    };
  }

  InterestsModel.fromMap(Map<String, dynamic> map) {
    this.id = map[InterestsModelFields.ID];
    this.icon = map[InterestsModelFields.ICON];
    this.title = map[InterestsModelFields.TITLE];
  }

  @override
  String toString() {
    return 'InterestsModel{id: $id, icon: $icon, title: $title}';
  }
}

class InterestsModelFields {
  static const String ID = "id";
  static const String ICON = "icon";
  static const String TITLE = "title";
}
