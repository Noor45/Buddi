import 'dart:io';
import 'package:buddi/screens/chatScreens/rating_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ConversationActionStyle {
  normal,
  destructive,
  important,
  important_destructive
}

class ConversationAppDialog {
  static Color _normal = Colors.black;
  static Color _destructive = Colors.red;

  /// show the OS Native dialog
  showOSDialog(BuildContext context, String title, String message,
      String firstButtonText, Function firstCallBack,
      {ConversationActionStyle firstActionStyle =
          ConversationActionStyle.normal,
      String? secondButtonText,
      Function? secondCallback,
      ConversationActionStyle secondActionStyle =
          ConversationActionStyle.normal}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          return WillPopScope(
            onWillPop: () async => false,
            child: _iosDialog(
                context, title, message, firstButtonText, firstCallBack,
                firstActionStyle: firstActionStyle,
                secondButtonText: secondButtonText,
                secondCallback: secondCallback,
                secondActionStyle: secondActionStyle),
          );
        } else {
          return WillPopScope(
            onWillPop: () async => false,
            child: _androidDialog(
                context, title, message, firstButtonText, firstCallBack,
                firstActionStyle: firstActionStyle,
                secondButtonText: secondButtonText,
                secondCallback: secondCallback,
                secondActionStyle: secondActionStyle),
          );
        }
      },
    );
  }

  /// show the android Native dialog
  Widget _androidDialog(BuildContext context, String title, String message,
      String firstButtonText, Function firstCallBack,
      {ConversationActionStyle firstActionStyle =
          ConversationActionStyle.normal,
      String? secondButtonText,
      Function? secondCallback,
      ConversationActionStyle secondActionStyle =
          ConversationActionStyle.normal}) {
    List<MaterialButton> actions = [];
    actions.add(MaterialButton(
      child: Text(
        firstButtonText,
        style: TextStyle(
            color: (firstActionStyle ==
                        ConversationActionStyle.important_destructive ||
                    firstActionStyle == ConversationActionStyle.destructive)
                ? _destructive
                : _normal,
            fontWeight: (firstActionStyle ==
                        ConversationActionStyle.important_destructive ||
                    firstActionStyle == ConversationActionStyle.important)
                ? FontWeight.bold
                : FontWeight.normal),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ));

    if (secondButtonText != null) {
      actions.add(MaterialButton(
        child: Text(secondButtonText,
            style: TextStyle(
                color: (secondActionStyle ==
                            ConversationActionStyle.important_destructive ||
                        firstActionStyle == ConversationActionStyle.destructive)
                    ? _destructive
                    :  _normal)),
        onPressed: () {
          Navigator.of(context).pop();
          secondCallback!();
        },
      ));
    }

    return AlertDialog(
        title: Text(title), content: Text(message), actions: actions);
  }

  /// show the iOS Native dialog
  Widget _iosDialog(BuildContext context, String title, String message,
      String firstButtonText, Function firstCallback,
      {ConversationActionStyle firstActionStyle =
          ConversationActionStyle.normal,
      String? secondButtonText,
      Function? secondCallback,
      ConversationActionStyle secondActionStyle =
          ConversationActionStyle.normal}) {
    List<CupertinoDialogAction> actions = [];
    actions.add(
      CupertinoDialogAction(
        isDefaultAction: true,
        onPressed: () {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            useSafeArea: false,
            barrierColor: Colors.white10.withOpacity(0.96),
            builder: (BuildContext context) {
              return RatingScreen();
            },
          );
        },
        child: Text(
          firstButtonText,
          style: TextStyle(
              color: (firstActionStyle ==
                          ConversationActionStyle.important_destructive ||
                      firstActionStyle == ConversationActionStyle.destructive)
                  ? _destructive
                  : _normal,
              fontWeight: (firstActionStyle ==
                          ConversationActionStyle.important_destructive ||
                      firstActionStyle == ConversationActionStyle.important)
                  ? FontWeight.bold
                  : FontWeight.normal),
        ),
      ),
    );

    if (secondButtonText != null) {
      actions.add(
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop();
            secondCallback!();
          },
          child: Text(
            secondButtonText,
            style: TextStyle(
                color: (secondActionStyle ==
                            ConversationActionStyle.important_destructive ||
                        secondActionStyle ==
                            ConversationActionStyle.destructive)
                    ? _destructive
                    : _normal,
                fontWeight: (secondActionStyle ==
                            ConversationActionStyle.important_destructive ||
                        secondActionStyle == ConversationActionStyle.important)
                    ? FontWeight.bold
                    : FontWeight.normal),
          ),
        ),
      );
    }

    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: actions,
    );
  }
}
