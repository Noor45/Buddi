import 'dart:io';
import 'package:buddi/functions/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:buddi/controller/post_controller.dart';
import 'package:buddi/controller/resource_article_controller.dart';
import 'package:buddi/models/post_model.dart';
import 'package:buddi/utils/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:coachmaker/coachmaker.dart';
import 'package:path_provider/path_provider.dart';
import '../controller/group_controller.dart';
import '../models/user_model.dart';
import '../utils/colors.dart';
import '../utils/strings.dart';

clearData() {
  RXConstants().postDummyList.clear();
  Constants.commentPostData = PostModel();
  Constants.selectedChatId = '';
  Constants.postLoading = false;
  Constants.testingMode = false;
  Constants.universitySecondList = [];
  Constants.universityList = [];
  Constants.checkedValue = false;
  Constants.blockUsers = [];
  Constants.resourceCompaniesList?.clear();
  Constants.resourcesList?.clear();
  Constants.selectedIndex = 0;
  // Constants.sort = true;
  Constants.chatAsListener = false;
  Constants.chatType = 0;
  Constants.selectedChatType = 0;
  Constants.userType = 0;
  Constants.threadId = null;
  Constants.assignAvailableBuddi = false;
  Constants.selectedChatUser = UserModel();
  Constants.progressValue = 1.0;
  Constants.groups = true;
  Constants.availableBuddiList = [];
  Constants.interestLists = [];
}

startShowcase(BuildContext context) async {
  await LocalPreferences.preferences
      .setBool(LocalPreferences.showcaseVisited, true);
  CoachMaker(context,
          duration: Duration(seconds: 1),
          initialList: [
            CoachModel(
                initial: '1',
                title: '',
                maxWidth: 400,
                subtitle: [
                  'Welcome to Buddi! Do you want a quick tour of our features?',
                ],
                alignment: Alignment.bottomCenter,
                header: Container()),
            // CoachModel(
            //     initial: '2',
            //     title: '',
            //     maxWidth: 400,
            //     subtitle: [
            //       'The Following page is where you will find all posts from students at your university and posts from groups you are in!',
            //     ],
            //     header: Container()
            // ),
            // CoachModel(
            //     initial: '3',
            //     title: '',
            //     maxWidth: 400,
            //     subtitle: [
            //       'The Country page shows posts from students everywhere- tailored to your selected interests.',
            //     ],
            //     header: Container()
            // ),
            // CoachModel(
            //     initial: '4',
            //     title: '',
            //     maxWidth: 400,
            //     subtitle: [
            //       'Create or join groups and communities with students everywhere. The topics are endless.',
            //     ],
            //     header: Container()
            // ),
            CoachModel(
                initial: '2',
                title: '',
                maxWidth: 400,
                subtitle: [
                  'Random live chat with students or vent to a student listener',
                ],
                header: Container()),
            CoachModel(
                initial: '3',
                title: '',
                maxWidth: 400,
                subtitle: [
                  'You can now post real-time photos, GIFS, polls and text by selecting the plus icon',
                ],
                header: Container()),
            CoachModel(
                initial: '4',
                title: '',
                maxWidth: 400,
                subtitle: [
                  'Explore a list of Buddi approved general life and mental health resources',
                ],
                header: Container()),
            CoachModel(
                initial: '5',
                title: '',
                maxWidth: 400,
                subtitle: [
                  'Change your settings and view your posted content',
                ],
                header: Container()),
          ],
          nextStep: CoachMakerControl.next,
          buttonOptions: CoachButtonOptions(
              buttonTitle: 'Continue',
              buttonStyle: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(ColorRefer.kMainThemeColor),
                  elevation: MaterialStateProperty.all(0))))
      .show();
}

DateTime getYear(DateTime creationDate, int value) {
  return DateTime(
      creationDate.year + value, creationDate.month, creationDate.day);
}

List userValidity(DateTime date, String? grade) {
  String? selectedGrade = '';
  DateTime? selectedDate;
  DateTime now = DateTime.now();
  if (grade == StringRefer.Freshman) {
    if (now.isAfter(date)) {
      selectedGrade = StringRefer.Sophomore;
      selectedDate = getYear(date, 1);
    }
  } else if (grade == StringRefer.Sophomore) {
    if (now.isAfter(date)) {
      selectedGrade = StringRefer.Junior;
      selectedDate = getYear(date, 1);
    }
  } else if (grade == StringRefer.Junior) {
    if (now.isAfter(date)) {
      selectedGrade = StringRefer.Senior;
      selectedDate = getYear(date, 1);
    }
  } else if (grade == StringRefer.Senior) {
    if (now.isAfter(date)) {
      selectedGrade = StringRefer.Graduate;
      selectedDate = getYear(date, 1);
    }
  } else if (grade == StringRefer.Graduate) {
    if (now.isAfter(date)) {
      selectedGrade = StringRefer.Alumni;
      selectedDate = date;
    }
  } else {
    selectedGrade = grade;
    selectedDate = date;
  }

  return [
    selectedGrade == '' ? grade : selectedGrade,
    selectedDate == null ? date : selectedDate
  ];
}

Future getAppData() async {
  // await PostController().getPostFromUniAndGroups(20);
  await ArticleController.getResources();
  await GroupController.getInterests();
  await GroupController.getGroups();
  Constants.documentDirectory = await getApplicationDocumentsDirectory();
}

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inPlace = true]) {
    final ids = Set();
    var list = inPlace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

Future<String> uploadRecordingToFirebase(
    File fileName, String refName, String? threadId) async {
  try {
    await FirebaseStorage.instance
        .ref('recordings/$threadId/$refName')
        .putFile(fileName);
    final downloadURL = await FirebaseStorage.instance
        .ref('recordings/$threadId/$refName')
        .getDownloadURL();
    return downloadURL;
  } catch (error) {
    print(error);
    return '';
  }
}
