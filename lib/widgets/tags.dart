import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:flutter/material.dart';

class Tags extends StatefulWidget {
  Tags({this.color, this.tag});
  final String? tag;
  final Color? color;
  @override
  _TagsState createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(right: 5),
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      decoration: BoxDecoration(
        color: Color(0xffD7E2E9).withOpacity(0.5),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        '#'+widget.tag!,
        style: TextStyle(
            fontFamily: FontRefer.Poppins, fontSize: 13,
            color: ColorRefer.kMainThemeColor),
      ),
    );
  }
}