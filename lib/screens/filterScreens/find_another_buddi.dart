import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddi/controller/auth_controller.dart';
import 'package:buddi/controller/find_buddi_controller.dart';
import 'package:buddi/screens/chatScreens/wait_screen.dart';
import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:buddi/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';

import '../../utils/constants.dart';


class FindAnotherBuddi extends StatefulWidget {
  @override
  _FindAnotherBuddiState createState() => _FindAnotherBuddiState();
}

class _FindAnotherBuddiState extends State<FindAnotherBuddi> {
  TextEditingController selectUniversityController = TextEditingController();
  TextEditingController selectTagsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(left: 20, right: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      elevation: 0,
      child: contentBox(context),
    );
  }
  contentBox(context) {
    double width = MediaQuery.of(context).size.width;
    final  theme = Provider.of<DarkThemeProvider>(context);
    return Container(
      width: width,
      height: 280,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black45, offset: Offset(0, 4), blurRadius: 10),
          ]
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.lightTheme == true ? ColorRefer.kDarkGreyColor : ColorRefer.kBoxColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: theme.lightTheme == true ? ColorRefer.kLightGreyColor : ColorRefer.kBackColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              ),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: (){
                        FindBuddiController.deleteAvailability(AuthController.currentUser!.uid);
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close, size: 25, color: ColorRefer.kMainThemeColor,)
                  ),
                  AutoSizeText(
                    'Find another Buddi!',
                    style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontRefer.PoppinsMedium,
                    ),
                  ),
                  SizedBox(width:30),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  AutoSizeText(
                    'We apologize your Buddi could not help. Would you like to search for another Buddi?',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                      fontSize: 14,
                      fontFamily: FontRefer.Poppins,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.only(left: 50, right: 50),
                    child: RoundedButton(
                      title: 'Search',
                      colour: ColorRefer.kMainThemeColor,
                      height: 45,
                      buttonRadius: 30,
                      onPressed: (){
                        Constants.availableBuddiList = [];
                        Constants.selectedChatId = '';
                        Navigator.pushReplacementNamed(context, WaitingScreen.waitingScreenID);
                      },
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: ()async{
                Navigator.pop(context);
              },
              child: Container(
                width: width,
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.lightTheme == true ?  ColorRefer.kLightGreyColor : ColorRefer.kBackColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,fontFamily: FontRefer.Poppins, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
