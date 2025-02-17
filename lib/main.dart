import 'dart:async';
import 'package:buddi/auth/policy_screen.dart';
import 'package:buddi/auth/select_university.dart';
import 'package:buddi/auth/university_list.dart';
import 'package:buddi/controller/auth_controller.dart';
import 'package:buddi/controller/find_buddi_controller.dart';
import 'package:buddi/onboarding_screens/first_screen.dart';
import 'package:buddi/screens/settingScreens/community_guidelines_screens.dart';
import 'package:buddi/screens/settingScreens/contact_us_screen.dart';
import 'package:buddi/screens/chatScreens/chat_option.dart';
import 'package:buddi/screens/chatScreens/chat_screen.dart';
import 'package:buddi/screens/postScreens/comment_screen.dart';
import 'package:buddi/screens/settingScreens/external_link_screen.dart';
import 'package:buddi/screens/mainScreens/main_screen.dart';
import 'package:buddi/screens/mainScreens/notification_screen.dart';
import 'package:buddi/screens/postScreens/create_post.dart';
import 'package:buddi/screens/settingScreens/support.dart';
import 'package:buddi/screens/settingScreens/term_condition.dart';
import 'package:buddi/screens/chatScreens/wait_screen.dart';
import 'package:buddi/utils/constants.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/access_denied_screen.dart';
import 'auth/select_grade_screen.dart';
import 'auth/signin_screen.dart';
import 'auth/signup_screen.dart';
import 'auth/start_screen.dart';
import 'auth/forget_password_screen.dart';
import 'auth/splash_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  if (AuthController.currentUser!.uid != null) {
    Constants.selectedIndex = 1;
  }
}

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  } else {}
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  channel = const AndroidNotificationChannel(
    'max_importance_channel',
    'Max Importance Notifications',
    importance: Importance.max,
  );
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runZonedGuarded(() {
    runApp(MyApp());
  }, FirebaseCrashlytics.instance.recordError);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.lightTheme =
        await themeChangeProvider.lightThemePreference.getTheme();
  }

  @override
  void initState() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print('message init start');
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (AuthController.currentUser!.uid != null) {
        Constants.selectedIndex = 1;
      }
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      if (AuthController.currentUser!.uid != null) {
        Constants.selectedIndex = 1;
      }
    });
    getCurrentAppTheme();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  AppLifecycleState? _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    _notification = state;
    if (_notification == AppLifecycleState.detached) {
      if (AuthController.currentUser != null) {
        if (Constants.assignAvailableBuddi == true) {
          await FindBuddiController.deleteAvailability(
              AuthController.currentUser!.uid);
        }
        if (Constants.threadId != null) {
          await FindBuddiController.removeChat(Constants.threadId);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) {
      return themeChangeProvider;
    }, child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget? child) {
      return Sizer(
        builder: (context, orientation, deviceType) {
          return Builder(builder: (context) {
            return GetMaterialApp(
              themeMode: ThemeMode.system,
              theme: ThemeData(
                brightness: Brightness.light,
                primaryColor: Colors.white,
                appBarTheme: AppBarTheme(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
                  titleTextStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      fontFamily: FontRefer.PoppinsMedium,
                      fontSize: 18),
                  iconTheme: IconThemeData(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
              ),
              debugShowCheckedModeBanner: false,
              initialRoute: SplashScreen.splashScreenId,
              routes: {
                SplashScreen.splashScreenId: (context) => SplashScreen(),
                MainScreen.MainScreenId: (context) => MainScreen(),
                ChatScreen.Chat_Screen: (context) => ChatScreen(),
                AccessDeniedScreen.ID: (context) => AccessDeniedScreen(),
                SelectGradeScreen.selectGradeID: (context) =>
                    SelectGradeScreen(),
                SelectUniversity.selectUniScreenID: (context) =>
                    SelectUniversity(),
                UniversityList.uniListScreenID: (context) => UniversityList(),
                CreatePost.createPostScreenID: (context) => CreatePost(),
                SignUpScreen.signUpScreenID: (context) => SignUpScreen(),
                SignInScreen.signInScreenID: (context) => SignInScreen(),
                WelcomeScreen.ID: (context) => WelcomeScreen(),
                WaitingScreen.waitingScreenID: (context) => WaitingScreen(),
                ExternalLinkScreen.externalLinkScreenID: (context) =>
                    ExternalLinkScreen(),
                ChatOption.chatOptionScreenID: (context) => ChatOption(),
                CommentScreen.commentScreenID: (context) => CommentScreen(),
                ForgetPasswordScreen.ID: (_) => ForgetPasswordScreen(),
                TermConditionScreen.termConditionID: (context) =>
                    TermConditionScreen(),
                SupportScreen.supportID: (context) => SupportScreen(),
                ContactUsScreen.contactUSID: (context) => ContactUsScreen(),
                IntroScreens.ID: (context) => IntroScreens(),
                NotificationScreen.notificationScreenID: (context) =>
                    NotificationScreen(),
                PrivacyPolicyScreens.ID: (context) => PrivacyPolicyScreens(),
                CommunityGuidelinesScreen.ID: (context) =>
                    CommunityGuidelinesScreen(),
              },
            );
          });
        },
      );
    }));
  }
}
