import 'dart:io';
import 'package:buddi/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermConditionScreen extends StatefulWidget {
  static String termConditionID = "/term_condition_screen";

  @override
  _TermConditionScreenState createState() => _TermConditionScreenState();
}

class _TermConditionScreenState extends State<TermConditionScreen> {
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
      backgroundColor: theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
      appBar: AppBar(
        backgroundColor: theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
        systemOverlayStyle: theme.lightTheme == true ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Platform.isIOS ? Icons.arrow_back_ios_sharp : Icons.arrow_back_rounded, color: theme.lightTheme == true ? Colors.black54 : Colors.white,)
        ),
        title: Text('Terms & Conditions', style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,),),
      ),
      body: IndexedStack(
        index: position as int?,
        children: <Widget>[
          WebView(
            initialUrl: 'https://www.talkbuddi.com/legal',
            javascriptMode: JavascriptMode.unrestricted,
            key: key,
            onPageFinished: doneLoading,
            onPageStarted: startLoading,
          ),
          Center(
            child: CircularProgressIndicator(
              backgroundColor: ColorRefer.kMainThemeColor,
            ),
          ),
        ],
      ),
    );
  }
}
