import 'package:buddi/controller/auth_controller.dart';
import 'package:buddi/models/group_model.dart';
import 'package:buddi/models/post_model.dart';
import 'package:buddi/models/report_post_model.dart';
import 'package:buddi/models/report_post_user.dart';
import 'package:buddi/utils/constants.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AccountController {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseFunctions functions = FirebaseFunctions.instance;
  static PostModel postData = PostModel();
  static ReportModel reportPostData = ReportModel();
  static ReportUserData report = ReportUserData();
  final controller = Get.put(RXConstants());

  Future<void> deleteUserData() async {
    await deletePost();
    await deleteMessages();
    await leaveGroups();
    await deleteNotifications();
    await deleteAccount();
    return;
  }

  Future<void> deleteAccount() async {
    try {
      await FirebaseFunctions.instance.httpsCallable("deleteUser").call(AuthController.currentUser!.uid);
    } on FirebaseFunctionsException catch (error) {
      print(error.message);
    }
    return;
  }

  Future<void> deletePost() async {
    final WriteBatch batch = FirebaseFirestore.instance.batch();
    _firestore.collection('post').where("user_data.uid", isEqualTo: AuthController.currentUser!.uid).get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) async{
        batch.delete(document.reference);
        PostModel postData = PostModel.fromMap(document.data());
        await deletePostReports(postData.postId);
      });
      return batch.commit();
    });
    return;
  }

  Future<void> deleteMessages() async {
    final WriteBatch batch = FirebaseFirestore.instance.batch();
    _firestore.collection('messages').where("receiver_id", isEqualTo: AuthController.currentUser!.uid)
        .where("sender_id", isEqualTo: AuthController.currentUser!.uid).get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        batch.delete(document.reference);
      });
      return batch.commit();
    });
    return;
  }

  Future<void> leaveGroups() async {
     _firestore.collection("groups")
         .where("members", arrayContains: AuthController.currentUser!.uid)
         .get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) async{
        GroupModel groupData = GroupModel.fromMap(document.data());
        await removeGroupMember(groupId: groupData.id, memberId: AuthController.currentUser!.uid);
      });
    });
    return;
  }

  Future<void> removeGroupMember({String? memberId, String? groupId}) async {
    try {
      await _firestore.collection('groups').doc(groupId).update({
        'members': FieldValue.arrayRemove([memberId])
      });
    } on FirebaseException catch (e) {
      print("User update Error: $e");
    }
  }

  Future<void> deleteNotifications() async {
    final WriteBatch batch = FirebaseFirestore.instance.batch();
    _firestore.collection('notifications').where("notify_by.uid", isEqualTo: AuthController.currentUser!.uid).get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        batch.delete(document.reference);
      });
      return batch.commit();
    });
    return;
  }

  Future<void> deletePostReports(String? postId) async {
    final WriteBatch batch = FirebaseFirestore.instance.batch();
    _firestore.collection('report').where("post_id", isEqualTo: postId).get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        batch.delete(document.reference);
      });
      return batch.commit();
    });
    return;
  }

}
