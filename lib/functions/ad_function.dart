import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';

class AdsFunctions {

  /*
Test Id's from:
https://developers.google.com/admob/ios/banner
https://developers.google.com/admob/android/banner

App Id - See README where these Id's go
Android: ca-app-pub-3940256099942544~3347511713
iOS: ca-app-pub-3940256099942544~1458002511

Banner
Android: ca-app-pub-3940256099942544/6300978111
iOS: ca-app-pub-3940256099942544/2934735716

Interstitial
Android: ca-app-pub-3940256099942544/1033173712
iOS: ca-app-pub-3940256099942544/4411468910

Reward Video
Android: ca-app-pub-3940256099942544/5224354917
iOS: ca-app-pub-3940256099942544/1712485313
*/

  static adAuthorization() async{
    await Admob.requestTrackingAuthorization();
  }

  static String? getBannerAdUnitId() {
      if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/6300978111';
  }
    return null;
  }

  static String? getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-1663163252588001/7192609714';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }
    return null;
  }

  static String? getRewardBasedVideoAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-1663163252588001/7018168131';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
    }
    return null;
  }
}