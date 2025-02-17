import 'package:flutter/material.dart';

class RecorderStopButton extends StatefulWidget {
  RecorderStopButton({this.onPressed});
  final Function? onPressed;
  @override
  _RecorderStopButtonState createState() => _RecorderStopButtonState();
}

class _RecorderStopButtonState extends State<RecorderStopButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed as void Function()?,
      child: FadeTransition(
        opacity: _animationController,
        child: Container(
          width: 30,
          height: 30,
          margin: EdgeInsets.only(right: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
          child: Center(child: Icon(Icons.mic_outlined, color: Colors.white)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
