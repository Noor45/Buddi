import 'package:admob_flutter/admob_flutter.dart';
import 'package:buddi/functions/ad_function.dart';
import 'package:buddi/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';

class AdCard extends StatefulWidget {
  @override
  _AdCardState createState() => _AdCardState();
}

class _AdCardState extends State<AdCard> {
  @override
  Widget build(BuildContext context) {
    final  theme = Provider.of<DarkThemeProvider>(context);
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.5, color: ColorRefer.kGreyColor),
        ),
        color: theme.lightTheme == true ? Colors.white : ColorRefer.kBoxColor,
      ),
      child: AdmobBanner(
        adUnitId: AdsFunctions.getBannerAdUnitId()!,
        adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
        onBannerCreated:
            (AdmobBannerController controller) {
        },
      ),
    );
  }
}
