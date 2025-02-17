import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import '../utils/colors.dart';

enum ActionStyle { normal, destructive, important, important_destructive }

class AppDialog {
  static Color _destructive = Colors.red;

  /// show the OS Native dialog
  showOSDialog(BuildContext context, String title, String message,
      String firstButtonText, Function firstCallBack,
      {ActionStyle firstActionStyle = ActionStyle.normal,
        String? secondButtonText,
        Function? secondCallback,
        ActionStyle secondActionStyle = ActionStyle.normal}) {
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
      {ActionStyle firstActionStyle = ActionStyle.normal,
        String? secondButtonText,
        Function? secondCallback,
        ActionStyle secondActionStyle = ActionStyle.normal}) {
    final theme = Provider.of<DarkThemeProvider>(context);
    List<MaterialButton> actions = [];
    actions.add(MaterialButton(
      child: Text(
        firstButtonText,
        style: TextStyle(
            color: (firstActionStyle == ActionStyle.important_destructive ||
                firstActionStyle == ActionStyle.destructive)
                ? _destructive
                : theme.lightTheme == true
                ? Colors.black54
                : Colors.white,
            fontWeight:
            (firstActionStyle == ActionStyle.important_destructive ||
                firstActionStyle == ActionStyle.important)
                ? FontWeight.bold
                : FontWeight.normal),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        firstCallBack();
      },
    ));

    if (secondButtonText != null) {
      actions.add(MaterialButton(
        child: Text(secondButtonText,
            style: TextStyle(
                color:
                (secondActionStyle == ActionStyle.important_destructive ||
                    firstActionStyle == ActionStyle.destructive)
                    ? _destructive
                    : theme.lightTheme == true
                    ? Colors.black54
                    : Colors.white)),
        onPressed: () {
          Navigator.of(context).pop();
          secondCallback!();
        },
      ));
    }

    return AlertDialog(
        backgroundColor:
        theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
        title: Text(title,
            style: TextStyle(
                color:
                theme.lightTheme == true ? Colors.black54 : Colors.white)),
        content: Text(message,
            style: TextStyle(
                color:
                theme.lightTheme == true ? Colors.black54 : Colors.white)),
        actions: actions);
  }

  /// show the iOS Native dialog
  Widget _iosDialog(BuildContext context, String title, String message,
      String firstButtonText, Function firstCallback,
      {ActionStyle firstActionStyle = ActionStyle.normal,
        String? secondButtonText,
        Function? secondCallback,
        ActionStyle secondActionStyle = ActionStyle.normal}) {
    final theme = Provider.of<DarkThemeProvider>(context);
    List<CupertinoDialogAction> actions = [];
    actions.add(
      CupertinoDialogAction(
        isDefaultAction: true,
        onPressed: () {
          Navigator.of(context).pop();
          firstCallback();
        },
        child: Text(
          firstButtonText,
          style: TextStyle(
              color: (firstActionStyle == ActionStyle.important_destructive ||
                  firstActionStyle == ActionStyle.destructive)
                  ? _destructive
                  : theme.lightTheme == true
                  ? Colors.black54
                  : Colors.white,
              fontWeight:
              (firstActionStyle == ActionStyle.important_destructive ||
                  firstActionStyle == ActionStyle.important)
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
                color:
                (secondActionStyle == ActionStyle.important_destructive ||
                    secondActionStyle == ActionStyle.destructive)
                    ? _destructive
                    : theme.lightTheme == true
                    ? Colors.black54
                    : Colors.white,
                fontWeight:
                (secondActionStyle == ActionStyle.important_destructive ||
                    secondActionStyle == ActionStyle.important)
                    ? FontWeight.bold
                    : FontWeight.normal),
          ),
        ),
      );
    }

    return Theme(
      data: theme.lightTheme == true ? ThemeData.light() : ThemeData.dark(),
      child: CupertinoAlertDialog(
        title: Text(title,
            style: TextStyle(
                color:
                theme.lightTheme == true ? Colors.black54 : Colors.white)),
        content: Text(message,
            style: TextStyle(
                color:
                theme.lightTheme == true ? Colors.black54 : Colors.white)),
        actions: actions,
      ),
    );
  }
}