class ResourceCompaniesModel {
  String? description;
  String? title;
  String? image;
  String? link;

  ResourceCompaniesModel({
    this.description,
    this.title,
    this.link,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      ResourceCompaniesModelFields.DESCRIPTION: this.description,
      ResourceCompaniesModelFields.TITLE: this.title,
      ResourceCompaniesModelFields.IMAGE: this.image,
      ResourceCompaniesModelFields.LINK: this.link,
    };
  }

  ResourceCompaniesModel.fromMap(Map<String, dynamic> map) {
    this.description = map[ResourceCompaniesModelFields.DESCRIPTION];
    this.title = map[ResourceCompaniesModelFields.TITLE];
    this.image = map[ResourceCompaniesModelFields.IMAGE];
    this.link = map[ResourceCompaniesModelFields.LINK];
  }

  @override
  String toString() {
    return 'ResourceCompaniesModel{des: $description, title: $title, image: $image, link: $link}';
  }
}

class ResourceCompaniesModelFields {
  static const String DESCRIPTION = "des";
  static const String TITLE = "title";
  static const String IMAGE = "image";
  static const String LINK = "link";
}
