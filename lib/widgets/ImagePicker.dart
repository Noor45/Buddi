import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/colors.dart';

// ignore: must_be_immutable
class CameraGalleryBottomSheet extends StatelessWidget {
  Function? cameraClick;
  Function? galleryClick;
  CameraGalleryBottomSheet({this.cameraClick, this.galleryClick});
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return Container(
      padding: EdgeInsets.only(left: 20, top: 30),
      height: 250,
      decoration: BoxDecoration(
          color: theme.lightTheme == false ? ColorRefer.kBoxColor : Colors.white,
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: (){
                cameraClick!.call();
                Navigator.pop(context);
              },
              child: ListTile(
                leading: Icon(
                  FontAwesomeIcons.camera,
                  size: 30,
                  color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                ),
                title: Text(
                  "Camera",
                  style: TextStyle(
                      color: theme.lightTheme == true ? Colors.black54 : Colors.white, fontSize: 20),
                ),
                subtitle: Text("Click to Capture image from camera", style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white)),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: (){
                galleryClick!.call();
                Navigator.pop(context);
              },
              child: ListTile(
                leading: Icon(
                  FontAwesomeIcons.image,
                  size: 30,
                  color: theme.lightTheme == true ? Colors.black54 : Colors.white,

                ),
                title: Text(
                  "Gallery",
                  style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,fontSize: 20),
                ),
                subtitle: Text("Click to add picture from camera", style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white)),
              ),
            ),
          ),

        ],
      ),
    );
  }
}