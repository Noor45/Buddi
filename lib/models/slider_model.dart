import '../utils//strings.dart';

class SliderModel {
  String? imageAssetPath;
  String? t1;
  String? t2;
  String? desc;
  String? subDesc;

  SliderModel({this.imageAssetPath, this.t1, this.t2, this.desc, this.subDesc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setT1(String getTitle) {
    t1 = getTitle;
  }

  void setT2(String getTitle) {
    t2 = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }
  void setSubDesc(String getSubDesc) {
    subDesc = getSubDesc;
  }

  String? getImageAssetPath() {
    return imageAssetPath;
  }

  String? getT1() {
    return t1;
  }
  String? getT2() {
    return t2;
  }

  String? getDesc() {
    return desc;
  }
  String? getSubDesc() {
    return subDesc;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = [];
  SliderModel sliderModel = new SliderModel();

  //1
  sliderModel.setDesc(StringRefer.kIntroDes1);
  sliderModel.setT1(StringRefer.kIntroFT1);
  sliderModel.setT2(StringRefer.kIntroST1);
  sliderModel.setImageAssetPath(StringRefer.artwork1);
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel.setDesc(StringRefer.kIntroDes2);
  sliderModel.setT1(StringRefer.kIntroFT2);
  sliderModel.setT2(StringRefer.kIntroST2);
  sliderModel.setImageAssetPath(StringRefer.artwork2);
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //3
  sliderModel.setDesc(StringRefer.kIntroDes3);
  sliderModel.setSubDesc(StringRefer.kIntroSubDes3);
  sliderModel.setT1(StringRefer.kIntroFT3);
  sliderModel.setT2(StringRefer.kIntroST3);
  sliderModel.setImageAssetPath(StringRefer.artwork3);
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //4
  sliderModel.setDesc(StringRefer.kIntroDes4);
  sliderModel.setT1(StringRefer.kIntroFT4);
  sliderModel.setT2(StringRefer.kIntroST4);
  sliderModel.setImageAssetPath(StringRefer.artwork4);
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //5
  sliderModel.setDesc(StringRefer.kIntroDes5);
  sliderModel.setSubDesc(StringRefer.kIntroSubDes5);
  sliderModel.setT1(StringRefer.kIntroFT5);
  sliderModel.setT2(StringRefer.kIntroST5);
  sliderModel.setImageAssetPath(StringRefer.artwork5);
  slides.add(sliderModel);

  // sliderModel = new SliderModel();
  //
  // //6
  // sliderModel.setDesc(StringRefer.kIntroSubtitle6);
  // sliderModel.setT1(StringRefer.kIntroTitle6);
  // sliderModel.setImageAssetPath(StringRefer.artwork6);
  // slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}
