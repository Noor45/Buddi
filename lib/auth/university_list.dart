import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/constants.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UniversityList extends StatefulWidget {
  static String uniListScreenID = "/uni_list_screen";
  @override
  _UniversityListState createState() => _UniversityListState();
}

class _UniversityListState extends State<UniversityList>{
  var notification;
  bool showSpinner = false;
  TextEditingController editingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  void getData()async{
      Constants.universityList.clear();
      Constants.universityList.addAll(Constants.universitySecondList);
      Constants.universityList.sort((a, b) => a.toString().compareTo(b.toString()));
  }

  void filterSearchResults(String query) async{
    List dummySearchList = [];
    dummySearchList.addAll(Constants.universityList);
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummySearchList.forEach((item) {
        String name = item['name'];
        if(name.toLowerCase().startsWith(query) == true) {
          dummyListData.add(item);
        }
      });
      setState(() {
        Constants.universityList.clear();
        Constants.universityList.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        getData();
      });
    }
  }

  @override
  void initState() {
    setState(() {
      Constants.universityList.sort((a, b) => a.toString().compareTo(b.toString()));
      Constants.universityList.removeWhere((element) => element['name']=='All');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final  theme = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor: theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: theme.lightTheme == true ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
        elevation: 0,
        title: AutoSizeText('Universities', style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,fontFamily: FontRefer.Poppins)),
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.close, color: theme.lightTheme == true ? Colors.black54 : Colors.white,)
        )
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    filterSearchResults(value);
                  });
                },
                controller: editingController,
                style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white),
                decoration: InputDecoration(
                  hintText: "Search",

                  fillColor:  theme.lightTheme == true ? ColorRefer.kGreyColor : ColorRefer.kBoxColor,
                  filled: true,
                  hintStyle: TextStyle(
                      fontSize: 14,
                      fontFamily: FontRefer.Poppins,
                      color: ColorRefer.kHintColor),
                  contentPadding: EdgeInsets.only(left: 15),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorRefer.kGreyColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorRefer.kGreyColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorRefer.kGreyColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorRefer.kGreyColor, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  prefixIcon: Icon(Icons.search, color: ColorRefer.kHintColor),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                semanticChildCount: Constants.universityList.length,
                children: Constants.universityList.length == 0
                    ? [Container()]
                    : Constants.universityList.map((e) {
                        showSpinner = false;
                        return Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 25),
                              InkWell(
                                onTap: (){
                                  Navigator.pop(context, [e['name'], e['email']]);
                                },
                                child: AutoSizeText(
                                  e['name'],
                                  style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,fontFamily: FontRefer.Poppins,  fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
