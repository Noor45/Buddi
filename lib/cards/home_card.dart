import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddi/utils/colors.dart';
import 'package:toast/toast.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';

class ThemeCard extends StatefulWidget {
  const ThemeCard({Key? key}) : super(key: key);
  @override
  State<ThemeCard> createState() => _ThemeCardState();
}

class _ThemeCardState extends State<ThemeCard> {
  int val = -1;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(left: 25, right: 25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      elevation: 0,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: width / 2,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: theme.lightTheme == true ? Colors.white : ColorRefer.kBoxColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0, theme.lightTheme == true ? 4 : 0),
                blurRadius: theme.lightTheme == true ? 10 : 0),
          ]),
      child: Container(
        padding: EdgeInsets.only(top: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: AutoSizeText(
                'Chose Theme',
                style: TextStyle(
                  fontSize: 18,
                  color:
                      theme.lightTheme == true ? Colors.black54 : Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontRefer.PoppinsMedium,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Dark',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: FontRefer.PoppinsMedium,
                          color: theme.lightTheme == true
                              ? Colors.black54
                              : Colors.white)),
                  Radio(
                    value: 1,
                    groupValue: theme.lightTheme == false ? 1 : -1,
                    onChanged: (dynamic value) {
                      setState(() {
                        theme.lightTheme = false;
                        ThemeData.dark();
                        ToastContext().init(context);
                        Toast.show("Switching to Dark mode...",
                            duration: Toast.lengthLong,
                            gravity: Toast.bottom,
                            backgroundColor: Colors.black,
                            textStyle: TextStyle(color: Colors.white));
                      });
                    },
                    fillColor: MaterialStateColor.resolveWith(
                        (states) => ColorRefer.kMainThemeColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Light',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: theme.lightTheme == true
                            ? Colors.black54
                            : Colors.white,
                        fontFamily: FontRefer.PoppinsMedium,
                      )),
                  Radio(
                    value: 2,
                    groupValue: theme.lightTheme == true ? 2 : -1,
                    onChanged: (dynamic value) {
                      setState(() {
                        theme.lightTheme = true;
                        ThemeData.light();
                        ToastContext().init(context);
                        Toast.show("Switching to Light mode...",
                            duration: Toast.lengthLong,
                            gravity: Toast.bottom,
                            textStyle: TextStyle(color: Colors.white));
                      });
                    },
                    activeColor: ColorRefer.kMainThemeColor,
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(left: 30, right: 30),
            //   child: SubmitButton(
            //     title: 'Done',
            //     colour:  ColorRefer.kMainThemeColor ,
            //     onPressed: () async{
            //       if(val == -1){
            //         ToastContext().init(context);
            //         Toast.show('Please select one option', duration: Toast.lengthLong, gravity: Toast.bottom);
            //       }
            //       else await savePost();
            //     },
            //
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class GroupCard extends StatefulWidget {
  const GroupCard({required this.onTap, this.image, this.title, Key? key})
      : super(key: key);
  final Function onTap;
  final String? image;
  final String? title;

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2.25,
        child: Stack(
          alignment: Alignment.center,
          children: [
            new ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: MediaQuery.of(context).size.width / 2.25,
                height: MediaQuery.of(context).size.width / 2.8,
                decoration: BoxDecoration(
                  color: theme.lightTheme == true
                      ? Colors.grey.shade400
                      : ColorRefer.kBoxColor,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  image: DecorationImage(
                      image: AssetImage(widget.image!),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(
                              theme.lightTheme == true ? 0.3 : 0.5),
                          BlendMode.darken)),
                ),
              ),
            ),
            AutoSizeText(
              widget.title!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                height: 1.2,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: FontRefer.Poppins,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// CachedNetworkImage(
//   placeholder: (context, url) => Image.asset('assets/images/placeholder.jpg', fit: BoxFit.cover),
//   imageUrl: widget.image == null ? '': widget.image!,
//   errorWidget: (context, url, error) => new Icon(Icons.error),
//   fit: BoxFit.cover,
//   width: MediaQuery.of(context).size.width/2.25,
//   height: MediaQuery.of(context).size.width/2.8,
// )