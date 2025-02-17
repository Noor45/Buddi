import 'dart:io';
import 'package:buddi/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommunityGuidelinesScreen extends StatefulWidget {
  static const String ID = "/community_guidelines_screen";

  @override
  _CommunityGuidelinesScreenState createState() => _CommunityGuidelinesScreenState();
}

class _CommunityGuidelinesScreenState extends State<CommunityGuidelinesScreen> {
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
    List args = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
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
            child: Icon(Platform.isIOS ? Icons.arrow_back_ios_sharp : Icons.arrow_back_rounded,
              color: theme.lightTheme == true ? Colors.black54 : Colors.white,)
        ),
        title: Text(args[0], style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,)),
      ),
      body: IndexedStack(
        index: position as int?,
        children: <Widget>[
          WebView(
            initialUrl: args[1],
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
