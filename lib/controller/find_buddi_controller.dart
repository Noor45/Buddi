import 'package:buddi/controller/auth_controller.dart';
import 'package:buddi/models/user_model.dart';
import 'package:buddi/utils/constants.dart';
import 'package:buddi/models/avaliable_chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class FindBuddiController {
  static Future<void> getBuddies(int selectedChatType) async {
    QuerySnapshot snapShot = await _firestore
        .collection('available_buddi')
        .where('chat_type', isEqualTo: selectedChatType)
        .orderBy('created_at', descending: true)
        .get();
    Constants.availableBuddiList = [];
    snapShot.docs.forEach((element) {
      AvailableForChatModel availableForChat = AvailableForChatModel.fromMap(element.data() as Map<String, dynamic>);
      Constants.availableBuddiList.add(availableForChat);
    });
    Constants.availableBuddiList.removeWhere((element) => element.uid == AuthController.currentUser!.uid);
    return;
  }

  static Future<void> saveAvailability({int? chatType, int? user}) async {
    DocumentSnapshot snapShot = await _firestore
        .collection('available_buddi')
        .doc(AuthController.currentUser!.uid)
        .get();
    if (!snapShot.exists) {
      AvailableForChatModel availableForChat = AvailableForChatModel();
      availableForChat.uid = AuthController.currentUser!.uid;
      availableForChat.chatType = chatType;
      availableForChat.userType = user;
      Constants.assignAvailableBuddi = true;
      availableForChat.createdAt = Timestamp.now();
      await _firestore
          .collection('available_buddi')
          .doc(AuthController.currentUser!.uid)
          .set(availableForChat.toMap());
    }else{
      await FindBuddiController.deleteAvailability(AuthController.currentUser!.uid);
      await saveAvailability(chatType: chatType, user: user);
      print('already exists');
    }
    return;
  }

  static Future<void> setAvailability() async {
      AvailableForChatModel availableForChat = AvailableForChatModel();
      availableForChat.uid = '0cJSOWTRx2Oq8HJjdDRgrjUT8BG2';
      // 57321
      availableForChat.chatType = 0;
      availableForChat.userType = 0;
      availableForChat.createdAt = Timestamp.now();
      await _firestore
          .collection('available_buddi')
          .doc('0cJSOWTRx2Oq8HJjdDRgrjUT8BG2')
          .set(availableForChat.toMap());
      print('Availability Set');
    return;
  }
  static Future<void> getBuddiData(String? id) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(id).get();
    if (snapshot.exists) {
      Constants.selectedChatUser = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    }
    return;
  }

  static Future<void> deleteAvailability(String? id) async {
    Constants.assignAvailableBuddi = false;
    await _firestore.collection('available_buddi').doc(id).delete();
    return;
  }

  static Future<void> removeChat(String? threadId) async {
        HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('deleteMessages');
        final results = await callable(threadId);
    // var snapShot = _firestore
    //     .collection('messages')
    //     .where('thread_id', isEqualTo: threadId);
    // var batch = _firestore.batch();
    // await snapShot.get().then((value) {
    //   value.docs.forEach((element) {
    //     batch.delete(element.reference);
    //   });
    //   return batch.commit();
    // });
    // return;
  }
}

