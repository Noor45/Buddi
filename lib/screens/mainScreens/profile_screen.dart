import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddi/screens/postScreens/posts_screen.dart';
import 'package:buddi/screens/settingScreens/setting_screen.dart';
import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  bool posts = true;
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor:
          theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 90,
        backgroundColor: ColorRefer.kMainThemeColor,
        title: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    'Profile',
                    style: TextStyle(
                      fontSize: 20,
                      height: 0.8,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: FontRefer.PoppinsMedium,
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            posts = true;
                          });
                        },
                        child: AutoSizeText(
                          'Posts',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: FontRefer.PoppinsMedium,
                            color: posts == true
                                ? ColorRefer.kFeroziColor
                                : Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        height: 15,
                        width: 2,
                        color: Colors.white,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            posts = false;
                          });
                        },
                        child: AutoSizeText(
                          'Settings',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: FontRefer.PoppinsMedium,
                            color: posts == false
                                ? ColorRefer.kFeroziColor
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: posts == true ? PostsScreen() : SettingScreen(),
    );
  }
}
