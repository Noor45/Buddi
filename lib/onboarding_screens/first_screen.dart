import 'package:buddi/auth/policy_screen.dart';
import 'package:buddi/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../models/slider_model.dart';

class IntroScreens extends StatefulWidget {
  static const String ID = "/intro_screen";
  @override
  _IntroScreensState createState() => _IntroScreensState();
}

class _IntroScreensState extends State<IntroScreens> {
  late List<SliderModel> mySlides;
  int slideIndex = 0;
  PageController? controller;

  Future<void> _initIntroScreens() async {
    mySlides = getSlides();
    controller = new PageController();
  }

  @override
  void initState() {
    _initIntroScreens();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor:
          theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 60,
        elevation: 0,
        systemOverlayStyle: theme.lightTheme == true
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
        title: Slider(
          value: Constants.progressValue,
          min: 0,
          max: 9,
          inactiveColor: ColorRefer.kFeroziColor,
          activeColor: ColorRefer.kMainThemeColor,
          onChanged: (double newValue) {},
        ),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        onPageChanged: (index) {
          setState(() {
            slideIndex = index;
          });
        },
        children: <Widget>[
          SlideTile(
            showSubDec: false,
            t1: mySlides[0].getT1(),
            t2: mySlides[0].getT2(),
            desc: mySlides[0].getDesc(),
            slideIndex: slideIndex,
            controller: controller,
            imagePath: mySlides[0].getImageAssetPath(),
          ),
          SlideTile(
            showSubDec: false,
            t1: mySlides[1].getT1(),
            t2: mySlides[1].getT2(),
            desc: mySlides[1].getDesc(),
            slideIndex: slideIndex,
            controller: controller,
            imagePath: mySlides[1].getImageAssetPath(),
          ),
          SlideTile(
            showSubDec: true,
            t1: mySlides[2].getT1(),
            t2: mySlides[2].getT2(),
            desc: mySlides[2].getDesc(),
            subDesc: mySlides[2].getSubDesc(),
            slideIndex: slideIndex,
            controller: controller,
            imagePath: mySlides[2].getImageAssetPath(),
          ),
          SlideTile(
            showSubDec: false,
            t1: mySlides[3].getT1(),
            t2: mySlides[3].getT2(),
            desc: mySlides[3].getDesc(),
            slideIndex: slideIndex,
            controller: controller,
            imagePath: mySlides[3].getImageAssetPath(),
          ),
          SlideTile(
            showSubDec: true,
            t1: mySlides[4].getT1(),
            t2: mySlides[4].getT2(),
            desc: mySlides[4].getDesc(),
            subDesc: mySlides[4].getSubDesc(),
            slideIndex: slideIndex,
            controller: controller,
            imagePath: mySlides[4].getImageAssetPath(),
          ),
          PrivacyPolicyScreens(),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class SlideTile extends StatefulWidget {
  SlideTile({
    this.imagePath,
    this.t1,
    this.t2,
    this.desc,
    this.subDesc,
    this.showSubDec,
    this.slideIndex,
    // this.link,
    this.controller,
    // this.linkTitle,
  });

  String? imagePath, t1, t2, desc;
  bool? showSubDec;
  int? slideIndex;
  Color? backColor;
  String? subDesc;
  String? link;
  PageController? controller;
  String? linkTitle;

  @override
  _SlideTileState createState() => _SlideTileState();
}

class _SlideTileState extends State<SlideTile> {
  bool checkedValue = false;
  double sliderValue = 0.0;
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          //Image
          Center(
              child: Image.asset(
            widget.imagePath!,
            fit: BoxFit.fill,
          )),

          //Text Content
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    widget.t1!,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: ColorRefer.kMainThemeColor,
                      fontFamily: FontRefer.Poppins,
                    ),
                  ),
                  SizedBox(width: 8),
                  AutoSizeText(
                    widget.t2!,
                    style: TextStyle(
                        fontSize: 18.sp,
                        color: ColorRefer.kMainThemeColor,
                        fontFamily: FontRefer.PoppinsMedium,
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, right: 25, top: 20),
                child: AutoSizeText(
                  widget.desc!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 8.sp,
                    fontFamily: FontRefer.Poppins,
                    color:
                        theme.lightTheme == true ? Colors.black : Colors.white,
                  ),
                ),
              ),
              Visibility(
                visible: widget.showSubDec!,
                child: Padding(
                  padding: EdgeInsets.only(left: 25, right: 25, top: 20),
                  child: AutoSizeText(
                    widget.showSubDec == true ? widget.subDesc! : '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 8.sp,
                        fontFamily: FontRefer.Poppins,
                        color: Color(0xffFA7A35)),
                  ),
                ),
              ),
            ],
          ),

          //Button
          Container(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: RoundedButton(
                title:
                    '${widget.slideIndex == 0 || widget.slideIndex == 1 ? 'Continue' : 'I\'ve read, understood and agree!'}',
                buttonRadius: 10,
                colour: ColorRefer.kMainThemeColor,
                height: 45,
                onPressed: () async {
                  setState(() {
                    switch (widget.slideIndex) {
                      case 0:
                        Constants.progressValue = Constants.progressValue + 1;
                        widget.controller!.animateToPage(1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linear);
                        break;
                      case 1:
                        Constants.progressValue = Constants.progressValue + 1;
                        widget.controller!.animateToPage(2,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linear);
                        break;
                      case 2:
                        Constants.progressValue = Constants.progressValue + 1;
                        widget.controller!.animateToPage(3,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linear);
                        break;
                      case 3:
                        Constants.progressValue = Constants.progressValue + 1;
                        widget.controller!.animateToPage(4,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linear);
                        break;
                      case 4:
                        Constants.progressValue = Constants.progressValue + 2;
                        widget.controller!.animateToPage(5,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linear);
                        break;
                      case 5:
                        Constants.progressValue = Constants.progressValue + 2;
                        widget.controller!.animateToPage(6,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linear);
                        break;
                    }
                  });
                }),
          ),
        ],
      ),
    );
  }
}
