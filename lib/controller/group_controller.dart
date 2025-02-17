import 'package:buddi/controller/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/group_model.dart';
import '../models/interests_model.dart';
import '../models/post_model.dart';
import '../utils/constants.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class GroupController {
  static final controller = Get.put(RXConstants());

  static Future<void> joinGroup({String? id}) async {
    await _firestore.collection('groups').doc(id).update({
      'members': FieldValue.arrayUnion([AuthController.currentUser!.uid])
    });
    return;
  }

  static Future<void> getGroupPosts(String? id, int limit) async {
    QuerySnapshot snapShot = await _firestore
        .collection('post')
        .where("group.id", isEqualTo: id)
        .orderBy('created_at', descending: true)
        .limit(limit)
        .get();
    controller.groupPosts.clear();
    final posts = snapShot.docs;
    for (var post in posts) {
      PostModel postData = PostModel.fromMap(post.data() as Map<String, dynamic>);
      var blockedUser = AuthController.currentUser!.blockedUser ?? [];
      if (!blockedUser.contains(postData.userData["uid"])) {
        controller.groupPosts.add(postData);
      }
    }
    return;
  }

  static Future<void> getUniPosts(int limit) async {
    controller.groupPosts.clear();
    QuerySnapshot snapShot = await _firestore
        .collection('post')
        .where("group", isNull: true)
        .where("user_data.uni_name", isEqualTo: AuthController.currentUser?.uniName)
        .orderBy('created_at', descending: true)
        .limit(limit)
        .get();
    final posts = snapShot.docs;
    for (var post in posts) {
      PostModel postData = PostModel.fromMap(post.data() as Map<String, dynamic>);
      var blockedUser = AuthController.currentUser!.blockedUser ?? [];
      if (!blockedUser.contains(postData.userData["uid"])) {
        controller.groupPosts.add(postData);
      }
    }
    return;
  }

  static Future<void> leaveGroup({String? memberId, String? groupId}) async {
    try {
      await _firestore.collection('groups').doc(groupId).update({
        'members': FieldValue.arrayRemove([memberId])
      });
    } on FirebaseException catch (e) {
      print("User update Error: $e");
    }
  }

  static Future<void> reportGroup({String? groupId, String? uid}) async {
    try {
      await _firestore.collection('groups').doc(groupId).update({
        'reported_by': FieldValue.arrayUnion([uid]),
      });
    } catch (e) {}
  }

  static Future<GroupModel?> getGroupDetail({String? groupId}) async {
    try {
      GroupModel? groupDetail;
      DocumentSnapshot snapShot =
          await _firestore.collection('groups').doc(groupId).get();
      if (snapShot.exists) {
        groupDetail = GroupModel.fromMap(snapShot.data() as Map<String, dynamic>);
      }
      return groupDetail;
    } catch (e) {}
    return null;
  }

  static Future<GroupModel?> getGroups() async {
    try {
      GroupModel? groupDetail;
      QuerySnapshot snapShot = await _firestore.collection('groups').get();
      controller.groupsLists?.clear();
      snapShot.docs.forEach((element) {
        GroupModel groups = GroupModel.fromMap(element.data() as Map<String, dynamic>);
        controller.groupsLists!.add(groups);
      });
      return groupDetail;
    } catch (e) {}
    return null;
  }

  static Future<void> getInterests() async {
    QuerySnapshot snapShot = await _firestore.collection('interests').get();
    Constants.interestLists = [];
    snapShot.docs.forEach((element) {
      InterestsModel interest = InterestsModel.fromMap(element.data() as Map<String, dynamic>);
      Constants.interestLists!.add(interest);
    });
    return;
  }
}
