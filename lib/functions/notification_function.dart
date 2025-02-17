import 'package:buddi/utils/keys.dart';
import 'package:buddi/utils/network_utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert' as json;

class NotificationFunction {
  static AndroidNotificationChannel? channel;
  static FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  static sendResponse(String notification, String? topic) async {
    print('/topics/$topic');
    print('key=' + Keys.SERVER_KEY);
    var body = {
      'to': '/topics/$topic',
      'notification': {'title': 'Buddi', 'body': notification},
      'data': {
        'title': 'Buddi',
        'body': notification,
      }
    };
    await NetworkUtil.internal()
        .post(
      baseURL: "https://fcm.googleapis.com/fcm/send",
      body: json.jsonEncode(body),
    )
        .then((value) {
      print("notification send" + value.toString());
      return;
    }).onError((dynamic error, stackTrace) {
      print(error);
    });
  }
}
