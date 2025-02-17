import 'dart:io';
import 'package:buddi/auth/select_university.dart';
import 'package:buddi/functions/global_functions.dart';
import 'package:buddi/functions/shared_preference.dart';
import 'package:buddi/models/notification_model.dart';
import 'package:buddi/models/post_model.dart';
import 'package:buddi/models/user_model.dart';
import 'package:buddi/auth/select_interest.dart';
import 'package:buddi/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth/access_denied_screen.dart';
import '../screens/mainScreens/main_screen.dart';
import '../utils/strings.dart';
import '../widgets/dialogs.dart';
import '../onboarding_screens/first_screen.dart';

final _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AuthController {
  static UserModel? currentUser;

  //****************** Create User ******************

  Future<bool> signupWithCredentials(BuildContext context, String uniName,
      String password, String grade) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: currentUser!.email!, password: password);
      _auth.currentUser!.sendEmailVerification();
      currentUser!.uid = userCredential.user!.uid;
      currentUser!.uniName = uniName;
      currentUser!.selectGrade = grade;
      currentUser!.rating = [];
      currentUser!.createdAt = Timestamp.now();
      currentUser!.joinDate = Timestamp.fromDate(DateTime(
          DateTime.now().year + 1, DateTime.now().month, DateTime.now().day));
      return true;
    } on FirebaseException catch (e) {
      switch (e.code) {
        case FirebaseRef.EMAIL_ALREADY_EXISTS:
          AppDialog()
              .showOSDialog(context, "Error", "Email already exists", "Ok", () {
            Navigator.pop(context);
          });
          break;
      }
      print("Sign up Error: ${e.code}");
      return false;
    }
  }

  //****************** Login User ******************

  Future<void> loginWithCredentials(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (Constants.testingMode == true) {
        await checkUserExistsTestMode(context, uid: userCredential.user!.uid);
      } else {
        if (userCredential.user!.emailVerified == false) {
          AppDialog().showOSDialog(
              context,
              "Invalid",
              "Your email not verified yet, please verify your email and try again.",
              "Ok", () {
            _auth.currentUser!.sendEmailVerification();
            return;
          });
        } else {
          await checkUserExists(context, uid: userCredential.user!.uid);
        }
      }
    } on FirebaseException catch (e) {
      switch (e.code) {
        case FirebaseRef.WRONG_PASSWORD:
          AppDialog()
              .showOSDialog(context, "Error", "Invalid password", "Ok", () {});
          break;
        case FirebaseRef.USER_NOT_EXISTS:
          AppDialog()
              .showOSDialog(context, "Error", "User not found", "Ok", () {});
          break;
      }
      return;
    }
  }

  //****************** Check User Exists ******************

  Future<void> checkUserExists(BuildContext context, {String? uid}) async {
    User? currentAuthUser = _auth.currentUser;
    Constants.testingMode = LocalPreferences.preferences.getBool(LocalPreferences.testingMode);
    if (Constants.testingMode == false || Constants.testingMode == null) {                                 
      if (currentAuthUser == null || currentAuthUser.emailVerified == false) {
        bool? areOnBoardingScreensVisited = LocalPreferences.preferences.getBool(LocalPreferences.OnBoardingScreensVisited);
        Future.delayed(Duration(seconds: 2), () {    
          Navigator.pushReplacementNamed(context, areOnBoardingScreensVisited != null && areOnBoardingScreensVisited ? SelectUniversity.selectUniScreenID : IntroScreens.ID);
        });
        return;
      }
    } else {
      if (currentAuthUser == null) {
        bool? areOnBoardingScreensVisited = LocalPreferences.preferences.getBool(LocalPreferences.OnBoardingScreensVisited);
        Future.delayed(Duration(seconds: 2), () {    
          Navigator.pushReplacementNamed(context, areOnBoardingScreensVisited != null && areOnBoardingScreensVisited ? SelectUniversity.selectUniScreenID : IntroScreens.ID);
        });
        return;
      }
    }  
    DocumentSnapshot snapshot = await _firestore
        .doc("${FirebaseRef.USERS}/${uid ?? currentAuthUser.uid}")
        .get();
    if (!snapshot.exists) {
      Navigator.pushReplacementNamed(
          context, SelectUniversity.selectUniScreenID);
    } else {
      currentUser = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);

      await getIntoApp(context);
    }
  }

  Future<void> getIntoApp(BuildContext context) async {
    if (currentUser!.username == null) {
      clearData();
      await getAppData();
      Get.to(() => SelectInterests());
    } else {
      List result = userValidity(AuthController.currentUser!.joinDate!.toDate(),
          AuthController.currentUser!.selectGrade);
      AuthController.currentUser!.selectGrade = result[0];
      AuthController.currentUser!.joinDate = Timestamp.fromDate(result[1]);
      updateUserFields();
      if (AuthController.currentUser!.selectGrade == StringRefer.Alumni) {
        clearData();
        _auth.signOut();
        Navigator.pushNamedAndRemoveUntil(
            context, AccessDeniedScreen.ID, (route) => false);
        // Navigator.pushNamed(context,
        //     AccessDeniedScreen.ID);
      } else {
        clearData();
        await getAppData();
        Navigator.pushNamedAndRemoveUntil(
            context, MainScreen.MainScreenId, (route) => false);
      }
    }
  }

  Future<void> checkUserExistsTestMode(BuildContext context,
      {String? uid}) async {
    User? currentAuthUser = _auth.currentUser;
    if (currentAuthUser == null) {
      Navigator.pushReplacementNamed(
          context, SelectUniversity.selectUniScreenID);
    } else {
      DocumentSnapshot snapshot = await _firestore
          .doc("${FirebaseRef.USERS}/${uid ?? currentAuthUser.uid}")
          .get();
      if (!snapshot.exists) {
        Navigator.pushReplacementNamed(
            context, SelectUniversity.selectUniScreenID);
      } else {
        currentUser =
            UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
        await getIntoApp(context);
      }
    }
  }

  //****************** Update User ******************

  Future<void> updateUserFields() async {
    try {
      await _firestore
          .doc(FirebaseRef.USERS + '/' + currentUser!.uid!)
          .set(currentUser!.toMap());
    } on FirebaseException catch (e) {
      print("User update Error: $e");
    }
  }

  Future<void> rateUser(String uid, int rateValue) async {
    await _firestore.doc(FirebaseRef.USERS + '/' + uid).update({
      'rating': FieldValue.arrayUnion([rateValue])
    });
    return;
  }

  Future<bool> blockUser(String? blockedUser, BuildContext context) async {
    await _firestore.doc(FirebaseRef.USERS + '/' + currentUser!.uid!).update({
      'blocked_user': FieldValue.arrayUnion([blockedUser])
    }).whenComplete(() async {
      if (currentUser!.blockedUser == null) currentUser!.blockedUser = [];
      currentUser!.blockedUser!.add(blockedUser);
    });
    return true;
  }

  Future<void> updateUserProfileColor(String color, int index) async {
    try {
      await _firestore
          .doc("${FirebaseRef.USERS}/${currentUser!.uid}")
          .update({'profileColor': color, 'emojiIndex': index});
    } on FirebaseException catch (e) {
      print("User update Error: $e");
    }
  }

  static Future<void> saveNotificationData(
      String notification, PostModel postData, String notifyFor) async {
    NotificationModel notifications = NotificationModel();
    notifications.notifyBy = {
      'uid': currentUser!.uid,
      'profileImageUrl': currentUser!.profileImageUrl,
      'uni_name': currentUser!.uniName,
      'name': currentUser!.name,
    };
    notifications.post = postData.post;
    notifications.notifyFor = notifyFor;
    notifications.notification = notification;
    notifications.createdAt = Timestamp.now();
    notifications.userId = postData.userData['uid'];

    var ref =
        await _firestore.collection('notifications').add(notifications.toMap());
    notifications.id = ref.id;
    await _firestore
        .collection('notifications')
        .doc(notifications.id)
        .set(notifications.toMap());
    return;
  }

  usernameCheck(String? username) async {
    final result = await _firestore
        .collection('users')
        .where('uid', isNotEqualTo: AuthController.currentUser?.uid)
        .where('username', isEqualTo: username)
        .get();
    // result.docs.forEach((element){
    //   UserModel user = UserModel.fromMap(element.data());
    //   print(user.uid);
    //   print(AuthController.currentUser!.uid);
    //   if(user.uid != AuthController.currentUser!.uid)
    //     userList.add(user);
    // });
    // print(userList);
    return result.docs.isEmpty;
  }

//****************** Password Reset ******************

  Future<void> sendPasswordResetEmail(
      BuildContext context, String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email)
       .then((value) {
        AppDialog().showOSDialog(
          context, "Success", "Password reset email sent successfully", "OK",
              () {
            Navigator.pop(context);
          });
       }).catchError((onError){
        AppDialog().showOSDialog(
          context, "Failed", onError.toString(), "OK",
                () {
              Navigator.pop(context);
          });
      });
    } on FirebaseException catch (e) {
      print("Password Reset Error: $e");
    }
    catch(e){
      print('error');
    }
  }

  Future<String?> _uploadProfileImage(File file) async {
    try {
      await FirebaseStorage.instance
          .ref(FirebaseRef.PROFILE_IMAGE + "/" + currentUser!.uid!)
          .putFile(file);
      final downloadURL = await FirebaseStorage.instance
          .ref(FirebaseRef.PROFILE_IMAGE + "/" + currentUser!.uid!)
          .getDownloadURL();
      return downloadURL;
    } on FirebaseException catch (e) {
      print("File upload Error: $e");
      return null;
    }
  }

  Future<void> updateUserImages(File? file) async {
    try {
      if (file != null) {
        currentUser!.profileImageUrl = await _uploadProfileImage(file);
        await _firestore
            .doc(FirebaseRef.USERS + '/' + currentUser!.uid!)
            .update(currentUser!.toMap());
      }
    } on FirebaseException catch (e) {
      print("User update Error: $e");
    }
  }
}

class FirebaseRef {
  static const String USERS = "users";
  static const String PROFILE_IMAGE = "profile_image";
  static const String WRONG_PASSWORD = "wrong-password";
  static const String USER_NOT_EXISTS = "user-not-found";
  static const String EMAIL_ALREADY_EXISTS = "email-already-in-use";
}
