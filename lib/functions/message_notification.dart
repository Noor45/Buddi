import 'package:buddi/controller/auth_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PostNotificationSubscription {

  static void fcmSubscribe() {
    if (AuthController.currentUser!.uid?.isNotEmpty ?? false) {
      print("subscribe" + AuthController.currentUser!.uid!);
      FirebaseMessaging.instance.subscribeToTopic(AuthController.currentUser!.uid!);
    }
  }

  static void fcmUnSubscribe() {
    if (AuthController.currentUser!.uid?.isNotEmpty ?? false) {
      print("un-subscribe" + AuthController.currentUser!.uid!);
      FirebaseMessaging.instance.unsubscribeFromTopic(AuthController.currentUser!.uid!);
    }
  }
}