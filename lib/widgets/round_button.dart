import 'package:flutter_svg/svg.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils/strings.dart';

class RoundedButton extends StatefulWidget {
  RoundedButton(
      {this.title,
      this.colour,
      this.height,
      required this.onPressed,
      this.buttonRadius});

  final Color? colour;
  final String? title;
  final double? height;
  final Function onPressed;
  final double? buttonRadius;
  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: widget.onPressed as void Function()?,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.buttonRadius!),
      ),
      highlightElevation: 0,
      height: widget.height,
      elevation: 0,
      color: widget.colour,
      minWidth: MediaQuery.of(context).size.width,
      child: Text(
        widget.title!,
        style: TextStyle(color: Colors.white, fontFamily: FontRefer.Poppins),
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  SubmitButton({this.title, this.colour, required this.onPressed});

  final Color? colour;
  final String? title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      height: 40,
      decoration: BoxDecoration(
        color: colour,
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        height: 20.0,
        onPressed: onPressed as void Function()?,
        child: Text(
          title!,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ButtonWithOutline extends StatelessWidget {
  ButtonWithOutline(
      {this.title,
      this.colour,
      this.radius,
      this.height,
      this.width,
      this.textColor,
      this.borderColor,
      required this.onPressed});
  final Color? colour;
  final String? title;
  final Function? onPressed;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double? radius;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return InkWell(
      onTap: onPressed as void Function()?,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: theme.lightTheme == true ? Colors.white : Colors.transparent,
          border: Border(
            top: BorderSide(color: borderColor!, width: 2.0),
            left: BorderSide(color: borderColor!, width: 2.0),
            right: BorderSide(color: borderColor!, width: 2.0),
            bottom: BorderSide(color: borderColor!, width: 2.0),
          ),
          borderRadius: BorderRadius.all(Radius.circular(radius!)),
        ),
        child: Text(
          title!,
          style: TextStyle(color: textColor, fontFamily: FontRefer.Poppins),
        ),
      ),
    );
  }
}

class CustomizedButton extends StatelessWidget {
  CustomizedButton(
      {this.title,
      this.colour,
      this.width,
      this.height,
      required this.onPressed,
      this.buttonRadius});

  final Color? colour;
  final String? title;
  final double? height;
  final double? width;
  final Function onPressed;
  final double? buttonRadius;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed as void Function()?,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colour,
          borderRadius: BorderRadius.all(Radius.circular(buttonRadius!)),
        ),
        child: Text(
          title!,
          style: TextStyle(color: Colors.white, fontFamily: FontRefer.Poppins),
        ),
      ),
    );
  }
}

class SendButton extends StatefulWidget {
  @override
  _SendButtonState createState() => _SendButtonState();
}

class _SendButtonState extends State<SendButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      margin: EdgeInsets.only(right: 15),
      padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: ColorRefer.kMainThemeColor),
      child: SvgPicture.asset(StringRefer.commentSend),
    );
  }
}

class RecorderStartButton extends StatefulWidget {
  RecorderStartButton({this.onPressed});
  final Function? onPressed;
  @override
  _RecorderStartButtonState createState() => _RecorderStartButtonState();
}

class _RecorderStartButtonState extends State<RecorderStartButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed as void Function()?,
      child: Container(
        width: 30,
        height: 30,
        margin: EdgeInsets.only(right: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: ColorRefer.kMainThemeColor),
        child: Center(child: Icon(Icons.mic_outlined, color: Colors.white)),
      ),
    );
  }
}

class WaitButton extends StatefulWidget {
  @override
  _WaitButtonState createState() => _WaitButtonState();
}

class _WaitButtonState extends State<WaitButton> with TickerProviderStateMixin {
  // AnimationController animationController;
  @override
  void initState() {
    // animationController = new AnimationController(
    //     vsync: this,
    //     duration: new Duration(milliseconds: 1200));
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    // animationController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      margin: EdgeInsets.only(right: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorRefer.kMainThemeColor.withOpacity(0.3)),
      child: Center(
          child: Container(
              padding: EdgeInsets.all(2),
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.fromSwatch()
                      .copyWith(secondary: ColorRefer.kMainThemeColor),
                ),
                child: SpinKitThreeBounce(
                  color: Colors.white,
                  size: 10,
                  // controller: animationController,
                ),
              ))),
    );
  }
}
