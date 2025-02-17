import 'dart:io';
import 'dart:convert' as json;
import 'package:buddi/controller/auth_controller.dart';
import 'package:buddi/functions/global_functions.dart';
import 'package:buddi/models/group_model.dart';
import 'package:buddi/models/like_post_model.dart';
import 'package:buddi/models/post_model.dart';
import 'package:buddi/models/report_post_model.dart';
import 'package:buddi/models/report_post_user.dart';
import 'package:buddi/screens/postScreens/comment_screen.dart';
import 'package:buddi/utils/constants.dart';
import 'package:buddi/widgets/dialogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toast/toast.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class PostController {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseFunctions firebaseFunction = FirebaseFunctions.instance;
  static PostModel postData = PostModel();
  static ReportModel reportPostData = ReportModel();
  static ReportUserData report = ReportUserData();
  final controller = Get.put(RXConstants());

  //****************** Post Data ******************

  // Future<void> getInterestPost(int limit) async {
  //   try {
  //     List posts = [];
  //     int limits = limit ~/ 2;
  //     var data = {
  //       "limits": limits,
  //       "uniName": AuthController.currentUser!.uniName,
  //       // "groups": AuthController.currentUser!.groups,
  //       "groups": null,
  //     };
  //     HttpsCallable callable = firebaseFunction.httpsCallable('getGroupPost');
  //     final results = await callable(data);
  //     List postList = results.data;
  //     if(postList.length == 2){
  //       List uniPosts = json.jsonDecode(json.jsonEncode(postList[0]));
  //       List groupPosts = json.jsonDecode(json.jsonEncode(postList[1]));
  //       uniPosts.forEach((e) => posts.add(e));
  //       groupPosts.forEach((e) => posts.add(e));
  //     }else{
  //       List uniPosts = json.jsonDecode(json.jsonEncode(postList));
  //       uniPosts.forEach((e) => posts.add(e));
  //     }
  //   } on FirebaseFunctionsException catch (error) {
  //     print(error.message);
  //   }
  //   return;
  // }
  // Future<void> getData(int limit) async {
  //   try {
  //     var data = {
  //       "limit": limit,
  //       "interests": AuthController.currentUser!.interests,
  //     };
  //     HttpsCallable callable = firebaseFunction.httpsCallable('getInterestPosts');
  //     final results = await callable(data);
  //     print('${results.data}');
  //   } on FirebaseFunctionsException catch (error) {
  //     print(error.message);
  //   }
  //   return;
  // }


  // Future<void> getPostFromGroupsByInterests(int limit) async {
  //   var data = {
  //     "limit": limit,
  //     "interests": AuthController.currentUser!.interests,
  //   };
  //   HttpsCallable callable = firebaseFunction.httpsCallable('getInterestPosts');
  //   final results = await callable(data);
  //   controller.postDummyList.clear();
  //   final posts = results.data;
  //   for (var post in posts) {
  //     var jsonData = json.jsonEncode(post);
  //     Map<String, dynamic> data = new Map<String, dynamic>.from(json.jsonDecode(jsonData));
  //     Timestamp createdAt = Timestamp(data['created_at']['_seconds'], data['created_at']['_nanoseconds']);
  //     data['created_at'] = createdAt;
  //     PostModel postData = PostModel.fromMap(data);
  //     var blockedUser = AuthController.currentUser!.blockedUser ?? [];
  //     print('.....$blockedUser.......................');
  //     print('.....${postData.userData["uid"]}....^^^^........');
  //     if (!blockedUser.contains(postData.userData["uid"])) {
  //       controller.postDummyList.add(postData);
  //     }
  //   }
  //   controller.postDummyList.sort(
  //       (a, b) => b.createdAt.toString().compareTo(a.createdAt.toString()));
  //   return;
  // }

  // Future<void> getPostFromUniAndGroups(int limit) async {
  //   int limits = limit ~/ 2;
  //   List posts = [];
  //   var data = {
  //     "limits": limits,
  //     "uniName": AuthController.currentUser!.uniName,
  //     "groups": AuthController.currentUser!.groups,
  //   };
  //   HttpsCallable callable = firebaseFunction.httpsCallable('getGroupPost');
  //   final results = await callable(data);
  //   List postList = results.data;
  //   if(postList.length == 2){
  //     List uniPosts = json.jsonDecode(json.jsonEncode(postList[0]));
  //     List groupPosts = json.jsonDecode(json.jsonEncode(postList[1]));
  //     uniPosts.forEach((e) => posts.add(e));
  //     groupPosts.forEach((e) => posts.add(e));
  //   }else{
  //     List uniPosts = json.jsonDecode(json.jsonEncode(postList));
  //     uniPosts.forEach((e) => posts.add(e));
  //   }
  //   controller.postDummyList.clear();
  //   for (var post in posts) {
  //     var jsonData = json.jsonEncode(post);
  //     Map<String, dynamic> data = new Map<String, dynamic>.from(json.jsonDecode(jsonData));
  //     Timestamp createdAt = Timestamp(data['created_at']['_seconds'], data['created_at']['_nanoseconds']);
  //     data['created_at'] = createdAt;
  //     PostModel postData = PostModel.fromMap(data);
  //     var blockedUser = AuthController.currentUser!.blockedUser ?? [];
  //     print('.....$blockedUser.......................');
  //     print('.....${postData.userData["uid"]}....^^^^........');
  //     if (!blockedUser.contains(postData.userData["uid"])) {
  //       print(postData.postId);
  //       controller.postDummyList.add(postData);
  //     }
  //   }
  //   controller.postDummyList.sort(
  //       (a, b) => b.createdAt.toString().compareTo(a.createdAt.toString()));
  //   controller.postDummyList.unique((x) => x.postId);
  //   return;
  // }

  Future<String?> _uploadImage(File file) async {
    try {
      String name = getRandomString(15);
      await FirebaseStorage.instance.ref('post_images/$name').putFile(file);
      final downloadURL = await FirebaseStorage.instance
          .ref('post_images/$name')
          .getDownloadURL();
      return downloadURL;
    } on FirebaseException catch (e) {
      print("File upload Error: $e");
      return null;
    }
  }

  Future<void> setImages(File? file) async {
    try {
      if (file != null) {
        postData.image = await _uploadImage(file);
        postData.poll = null;
        postData.gif = null;
      }
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  setGif({String? gifUrl}) {
    postData.gif = gifUrl;
    postData.image = null;
    postData.poll = null;
  }

  removeGif() {
    postData.gif = null;
  }

  assignGroup(GroupModel groupDetail) {
    postData.group = {
      'id': groupDetail.id,
      'title': groupDetail.title
    };
  }

  //****************** Polling on Post ******************

  static Future<void> polling(List poll, String option, String? postId) async {
    try {
      String name = 'polls.$option';
      await _firestore
          .collection('post')
          .doc(postId)
          .update({name: FieldValue.arrayUnion(poll)});
    } on FirebaseException catch (e) {
      print("User update Error: $e");
    }
  }

  bool checkPollData(List polls, BuildContext context) {
    bool result = true;
    if (polls[0] == '') {
      ToastContext().init(context);
      Toast.show('Please write Answer #1 for poll',
          duration: Toast.lengthLong, gravity: Toast.bottom);
      result = false;
    } else if (polls[1] == '') {
      ToastContext().init(context);
      Toast.show('Please write Answer #2 for poll',
          duration: Toast.lengthLong, gravity: Toast.bottom);
      result = false;
    } else if (polls.length == 3) {
      if (polls[2] == '') {
        ToastContext().init(context);
        Toast.show('Please write Answer #3 for poll',
            duration: Toast.lengthLong, gravity: Toast.bottom);
        result = false;
      } else {
        result = setPollData(polls);
      }
    } else if (polls.length == 4) {
      if (polls[3] == '') {
        ToastContext().init(context);
        Toast.show('Please write Answer #4 for poll',
            duration: Toast.lengthLong, gravity: Toast.bottom);
        result = false;
      } else {
        result = setPollData(polls);
      }
    } else {
      result = setPollData(polls);
    }
    return result;
  }

  bool setPollData(List polls) {
    Map<String, Object> poll = {};
    polls.forEach((element) {
      poll[element] = [];
    });
    postData.poll = poll;
    postData.image = null;
    postData.gif = null;
    return true;
  }

  //****************** Save Post ******************

  Future<void> savePostData(String? post) async {
    postData.post = post;
    postData.createdAt = Timestamp.now();
    postData.userData = {
      'uid': AuthController.currentUser!.uid,
      'profileImage': AuthController.currentUser!.profileImageUrl,
      'uni_name': AuthController.currentUser!.uniName,
      'name': AuthController.currentUser!.username,
    };
    var ref = await _firestore.collection('post').add(postData.toMap());
    postData.postId = ref.id;
    await _firestore.collection('post').doc(ref.id).update(postData.toMap());
    reportPostData.reportId = [];
    reportPostData.postId = ref.id;
    reportPostData.createdAt = Timestamp.now();
    postData = PostModel();
    return;
  }

  //****************** Like on Post ******************

  static Future<void> likePost(LikePostModel data, String? postId) async {
    try {
      await _firestore
          .collection('post')
          .doc(postId)
          .collection('post_likes')
          .doc(data.uid)
          .set(data.toMap());
    } on FirebaseException catch (e) {
      print("User update Error: $e");
    }
  }

  static Future<void> unLikePost(LikePostModel data, String? postId) async {
    try {
      await _firestore
          .collection('post')
          .doc(postId)
          .collection('post_likes')
          .doc(data.uid)
          .delete();
    } on FirebaseException catch (e) {
      print("User update Error: $e");
    }
  }

  static Future<void> updateLikePost(LikePostModel data, String? postId, int? perIndex) async {
    try {
      LikePostModel preData = LikePostModel();
      preData.uid = data.uid;
      preData.reaction = perIndex;
      await unLikePost(preData, postId);
      await _firestore.collection('post').doc(postId).update({
        'post_likes': FieldValue.arrayUnion([data.toMap()])
      });
    } on FirebaseException catch (e) {
      print("User update Error: $e");
    }
  }

  //****************** Comment on Post ******************

  static Future<void> commentPost(Comment data, String? postId) async {
    try {
      await _firestore
          .collection('post')
          .doc(postId)
          .collection('post_comments')
          .doc(data.commentId)
          .set(data.toMap());
    } on FirebaseException catch (e) {
      print("User update Error: $e");
    }
  }

  static Future<void> postSubComment(
      Comment data, String? postId, String? pCommentId) async {
    try {
      await _firestore
          .collection('post')
          .doc(postId)
          .collection('post_comments')
          .doc(pCommentId)
          .collection('sub_comments')
          .doc(data.commentId)
          .set(data.toMap());
    } on FirebaseException catch (e) {
      print("User update Error: $e");
    }
  }

  static Future<void> deleteCommentPost(
      String? postId, String? commentId) async {
    try {
      await _firestore
          .collection('post')
          .doc(postId)
          .collection('post_comments')
          .doc(commentId)
          .delete();
    } on FirebaseException catch (e) {
      print("User update Error: $e");
    }
  }

  static Future<void> deleteSubCommentPost(
      var data, String? postId, String? commentId, String? subDocId) async {
    try {
      await _firestore
          .collection('post')
          .doc(postId)
          .collection('post_comments')
          .doc(commentId)
          .collection('sub_comments')
          .doc(subDocId)
          .delete();
    } on FirebaseException catch (e) {
      print("User update Error: $e");
    }
  }

  static Future<void> deletePost(String? postId) async {
    await _firestore.collection('post').doc(postId).delete();
    return;
  }

  //****************** Post Report ******************

  static Future<void> reportPost(
      PostModel postData, String type, String msg, BuildContext context) async {
    try {
      bool apply = true;
      DocumentSnapshot snapShot =
          await _firestore.collection('report').doc(postData.postId).get();
      if (!snapShot.exists) {
        report.type = type;
        report.userId = AuthController.currentUser!.uid;
        report.createdAt = Timestamp.now();
        await _firestore.collection('report').doc(postData.postId).set({
          'report_id': FieldValue.arrayUnion([report.toMap()]),
          'post_id': postData.postId,
          'created_at': postData.createdAt
        });
        AppDialog().showOSDialog(context, "Success", msg, "OK", () {
          Navigator.pop(context);
          return;
        });
        return;
      } else {
        ReportModel reportPost =
            ReportModel.fromMap(snapShot.data() as Map<String, dynamic>);
        Future.wait(reportPost.reportId!.map((element) async {
          if (element['uid'] == AuthController.currentUser!.uid &&
              element['type'] == type) {
            apply = false;
            AppDialog().showOSDialog(
                context, "Invalid", "You have already submit the request", "OK",
                () {
              Navigator.pop(context);
              return;
            });
            return;
          }
        }));
        if (apply == true) {
          Future.wait(reportPost.reportId!.map((element) async {
            // try {
            if (element['uid'] == AuthController.currentUser!.uid &&
                element['type'] != type) {
              report.type = type;
              report.userId = AuthController.currentUser!.uid;
              report.createdAt = Timestamp.now();
              reportPost.reportId!.add(report.toMap());
              await _firestore
                  .collection('report')
                  .doc(postData.postId)
                  .update({
                'report_id': FieldValue.arrayUnion([report.toMap()]),
                'post_id': postData.postId,
                'created_at': postData.createdAt
              });
              AppDialog().showOSDialog(context, "Success", msg, "Ok", () {
                Navigator.pop(context);
                return;
              });
              return;
            }
          })).onError((dynamic error, stackTrace) => (error));
        }
      }
      return;
    } catch (e) {}
  }
}
