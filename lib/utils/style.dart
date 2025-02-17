import 'package:flutter/material.dart';
import 'colors.dart';

class StyleRefer {
  static var kTextFieldDecoration = InputDecoration(
    hintStyle: TextStyle(
      color: ColorRefer.kGreyColor,
      fontSize: 12,
    ),
    focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: ColorRefer.kGreyColor)),
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: ColorRefer.kGreyColor)),
    focusColor: Colors.black,
    contentPadding: EdgeInsets.only(left: 0, top: 3),
  );

  static var kTabDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(30)),
  );

  static var kFieldContainerDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
    color: Colors.white,
    border: Border(
      top: BorderSide(width: 1.0, color: Colors.black38),
      left: BorderSide(width: 1.0, color: Colors.black38),
      right: BorderSide(width: 1.0, color: Colors.black38),
      bottom: BorderSide(width: 1.0, color: Colors.black38),
    ),
  );
}
