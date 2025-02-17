import 'package:buddi/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';

class DeletePostBottomSheet extends StatefulWidget {
  DeletePostBottomSheet({this.onDelete});
  final Function? onDelete;
  @override
  _DeletePostBottomSheetState createState() => _DeletePostBottomSheetState();
}

class _DeletePostBottomSheetState extends State<DeletePostBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final  theme = Provider.of<DarkThemeProvider>(context);
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0)
        ),
      ),
      padding: EdgeInsets.only(top: 15),
      height: 200,
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width/4,
            height: 9,
            decoration: BoxDecoration(
                color: Color(0xffDEE2E7),
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
          ),
          SizedBox(height: 40),
          Container(
            child: Column(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async{
                     await widget.onDelete!.call();
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.delete_outlined,
                        color: Colors.red,
                        size: 30,
                      ),
                      title: Text(
                        "Delete",
                        style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.cancel_outlined,
                        color: Colors.green,
                        size: 30,
                      ),
                      title: Text(
                        "Cancel",
                        style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}