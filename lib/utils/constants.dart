import 'package:buddi/controller/post_controller.dart';
import 'package:buddi/models/avaliable_chat_model.dart';
import 'package:buddi/models/group_model.dart';
import 'package:buddi/models/post_model.dart';
import 'package:buddi/models/user_model.dart';
import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import '../models/interests_model.dart';
import '../models/resource_company_model.dart';
import '../models/resources_model.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

int transitionDelay = 300;


var kMessageTextFieldDecoration = InputDecoration(
  hintText: 'Type a comment...',
  filled: true,
  hintStyle: TextStyle(
      fontSize: 14,
      fontFamily: FontRefer.Poppins,
      color: ColorRefer.kHintColor),
  border: InputBorder.none,
  focusedBorder: InputBorder.none,
  enabledBorder: InputBorder.none,
  errorBorder: InputBorder.none,
  disabledBorder: InputBorder.none,
  contentPadding: EdgeInsets.only(left: 15),
);

class Constants {
  static const gifyAPIKey = 'S9mC9vkC4MDXk5ZeKURAYF0WinumCkj4';
  static bool postLoading = false;
  static bool? testingMode = false;
  static List universitySecondList = [];
  static List universityList = [];
  static bool checkedValue = false;
  static List<String?> blockUsers = [];
  static List<ResourceCompaniesModel>? resourceCompaniesList;
  static List<ResourcesModel>? resourcesList;
  static int? selectedIndex = 0;
  static PostModel? commentPostData;
  static bool chatAsListener = false;
  static int chatType = 0;
  static int selectedChatType = 0;
  static int userType = 0;
  static String? threadId;
  static bool assignAvailableBuddi = false;
  static String? selectedChatId;
  static var documentDirectory;
  static late UserModel selectedChatUser;
  static double progressValue = 1.0;
  static bool groups = true;
  static bool reloadHomePosts = false;
  static late List<AvailableForChatModel> availableBuddiList;
  static List<InterestsModel>? interestLists;
}

class RXConstants extends GetxController {
  RxList<PostModel> postDummyList = RxList<PostModel>();
  RxList<PostModel> groupPosts = RxList<PostModel>();
  RxList<GroupModel>? groupsLists = RxList<GroupModel>();

}

// paginationQuery(int limit) async {
//   if (Constants.groups == true) {
//     await PostController().getPostFromUniAndGroups(limit);
//   }else{
//     await PostController().getPostFromGroupsByInterests(limit);
//   }
// }

String convertStringToLink(String textData) {
  if (textData.isEmpty) return "";
  final urlRegExp = new RegExp(r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
  final urlMatches = urlRegExp.allMatches(textData);
  List<String> urls = urlMatches
      .map((urlMatch) => textData.substring(urlMatch.start, urlMatch.end))
      .toList();
  if (urls.isEmpty) return "";
  return urls[0].toString();
}

var mainSearchDecoration = InputDecoration(
  hintText: "Search by universities",
  fillColor: ColorRefer.kGreyColor,
  filled: true,
  hintStyle: TextStyle(
      fontSize: 14,
      fontFamily: FontRefer.Poppins,
      color: ColorRefer.kHintColor),
  contentPadding: EdgeInsets.only(left: 15),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: ColorRefer.kGreyColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(12)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: ColorRefer.kGreyColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(12)),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: ColorRefer.kGreyColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(12)),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: ColorRefer.kGreyColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(12)),
  ),
  prefixIcon: Icon(Icons.search, color: Colors.grey),
);

var kFilterSearchDecoration = InputDecoration(
  hintText: "Search",
  fillColor: ColorRefer.kGreyColor,
  filled: true,
  hintStyle: TextStyle(
      fontSize: 14,
      fontFamily: FontRefer.Poppins,
      color: ColorRefer.kHintColor),
  contentPadding: EdgeInsets.only(left: 15),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: ColorRefer.kGreyColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(30)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: ColorRefer.kGreyColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(30)),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: ColorRefer.kGreyColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(30)),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: ColorRefer.kGreyColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(30)),
  ),
  prefixIcon: Icon(Icons.search, color: Colors.grey),
);

var themeData = ThemeData(
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: ColorRefer.kMainThemeColor,
  ),
);

const kVerificationFieldDecoration = InputDecoration(
  counterText: '',
  hintStyle: TextStyle(
      color: Color(0xff868E9D)),
  contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, width: 0.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, width: 0.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
);
