import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:get/get.dart';
import '../../controller/resource_article_controller.dart';
import '../../models/resources_model.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';
import '../../utils/strings.dart';
import '../../widgets/input_field.dart';
import 'companies_list_screen.dart';

class ResourceScreen extends StatefulWidget {
  const ResourceScreen({Key? key}) : super(key: key);
  @override
  _ResourceScreenState createState() => _ResourceScreenState();
}
class _ResourceScreenState extends State<ResourceScreen> {
  List<ResourcesModel>  resourcesTempList = [];

  void getData()async{
    Constants.resourcesList!.clear();
    Constants.resourcesList!.addAll(resourcesTempList);
    Constants.resourcesList!.sort((a, b) => a.toString().compareTo(b.toString()));
  }
  void filterSearchResults(String query) async{
    List<ResourcesModel> dummySearchList = [];
    dummySearchList.addAll(Constants.resourcesList!);
    if(query.isNotEmpty) {
      List<ResourcesModel> dummyListData = [];
      dummySearchList.forEach((item) {
        String name = item.title!;
        if(name.toLowerCase().startsWith(query) == true) {
          dummyListData.add(item);
        }
      });
      setState(() {
        Constants.resourcesList!.clear();
        Constants.resourcesList!.addAll(dummyListData);
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
      Constants.resourcesList!.sort((a, b) => a.toString().compareTo(b.toString()));
      resourcesTempList.addAll(Constants.resourcesList!);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final  theme = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor: theme.lightTheme == true
          ? Colors.white
          : ColorRefer.kBackColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorRefer.kMainThemeColor,
        title: InputSearchField(
          textInputType: TextInputType.text,
          hint: 'I am looking for...',
          icon: CupertinoIcons.search,
          onChanged: (value) {
            setState(() {
              filterSearchResults(value);
            });
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 20),
          child: Column(
            children: Constants.resourcesList == null || Constants.resourcesList!.length == 0
                ? [Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height / 1.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.bell,
                    color: ColorRefer.kGreyColor,
                    size: 50,
                  ),
                  SizedBox(height: 6),
                  AutoSizeText(
                    'Empty',
                    style: TextStyle(
                        color: ColorRefer.kGreyColor,
                        fontFamily: FontRefer.PoppinsMedium,
                        fontSize: 20),
                  )
                ],
              ),
            )]
                : Constants.resourcesList!.map((e){
              return ResourceListWidget(
                data: e,
                icon: e.icon,
                title: e.title,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}


class ResourceListWidget extends StatefulWidget {
  const ResourceListWidget({
    Key? key,
    this.icon, this.title, this.data,
  }) : super(key: key);
  final String? icon;
  final String? title;
  final ResourcesModel? data;

  @override
  State<ResourceListWidget> createState() => _ResourceListWidgetState();
}

class _ResourceListWidgetState extends State<ResourceListWidget> {
  String? iconValue = '';
  @override
  void initState() {
    iconValue = widget.icon;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return Column(
      children: [
        InkWell(
          splashColor: ColorRefer.kGreyColor,
          onTap: () async{
            await ArticleController.getCompanies(widget.data!.id);
            Get.to(() => CompaniesList(data: widget.data));
          },
          child: Container(
            height: MediaQuery.of(context).size.width / 7,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 35, right: 15),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                          placeholder: (context, url) => Image.asset(StringRefer.placeholder),
                          imageUrl:  iconValue == null ? '': iconValue!,
                          errorWidget: (context, url, error) => new Icon(Icons.error),
                          height: MediaQuery.of(context).size.width/9,
                          width: MediaQuery.of(context).size.width/9,
                          fit: BoxFit.fill,
                        ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      widget.title!,
                      style: TextStyle(
                        color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Divider(
          color: ColorRefer.kGreyColor,
          thickness: 1.5,
        ),
      ],
    );
  }
}

