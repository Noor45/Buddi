import 'dart:io';
import 'package:buddi/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContactUsScreen extends StatefulWidget {
  static String contactUSID = "/contact_us_screen";

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  num position = 1;
  final key = UniqueKey();
  doneLoading(String A) {
    setState(() {
      position = 0;
    });
  }

  startLoading(String A) {
    setState(() {
      position = 1;
    });
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final  theme = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Platform.isIOS ? Icons.arrow_back_ios_sharp : Icons.arrow_back_rounded,
            color: theme.lightTheme == true ? Colors.black54 : Colors.white,)
        ),
      ),
      body: IndexedStack(
        index: position as int?,
        children: <Widget>[
          WebView(
            initialUrl: 'www.talkbuddi.com',
            javascriptMode: JavascriptMode.unrestricted,
            key: key,
            onPageFinished: doneLoading,
            onPageStarted: startLoading,
          ),
          Container(
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: ColorRefer.kMainThemeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
