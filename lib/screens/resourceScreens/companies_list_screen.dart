import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../cards/resource_card.dart';
import '../../models/resources_model.dart';
import '../../utils/constants.dart';

class CompaniesList extends StatefulWidget {
  final ResourcesModel? data;
  CompaniesList({required this.data});
  @override
  _CompaniesListState createState() => _CompaniesListState();
}

class _CompaniesListState extends State<CompaniesList> {

  @override
  Widget build(BuildContext context) {
    final  theme = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor: theme.lightTheme == true ? Colors.white : ColorRefer.kBackColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ColorRefer.kMainThemeColor,
        title: Text(
          widget.data!.title!,
          style: TextStyle(
            fontFamily: FontRefer.PoppinsMedium,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 15),
                child: Text(
                  'Introduction',
                  style: TextStyle(
                    fontFamily: FontRefer.PoppinsMedium,
                    fontSize: 20,
                    color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Html(
                  data: widget.data!.description,
                  style: {
                    "p": Style(
                        fontSize: FontSize.medium, fontFamily: FontRefer.PoppinsMedium,
                        lineHeight: LineHeight.number(1.2), color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                    ),
                    "ul": Style(
                        fontSize: FontSize.medium, fontFamily: FontRefer.PoppinsMedium,
                        lineHeight: LineHeight.number(1.2), color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                    ),
                    "span": Style(
                        fontSize: FontSize.medium, fontFamily: FontRefer.PoppinsMedium, textDecorationColor: theme.lightTheme == true ? Colors.black54 : Colors.white,
                        lineHeight: LineHeight.number(1.2), color: theme.lightTheme == true ? Colors.black54 : Colors.white
                    ),
                    "div": Style(
                        fontSize: FontSize.medium, fontFamily: FontRefer.PoppinsMedium,
                        lineHeight: LineHeight.number(0.8), color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                    ),
                  },
                  onLinkTap: (url, context, map, element) async{
                    assert(url != null);
                  },
                ),
              ),
              Container(
                child: Constants.resourceCompaniesList == null || Constants.resourceCompaniesList!.length == 0
                ? Container() : Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'Products We LOVE',
                    style: TextStyle(
                      fontFamily: FontRefer.PoppinsMedium,
                      fontSize: 20,
                      color: theme.lightTheme == true ? Colors.black54 : Colors.white,
                    ),
                  ),
                ),
              ),
              Column(
                children: Constants.resourceCompaniesList == null || Constants.resourceCompaniesList!.length == 0
                    ? [Container()]
                    : Constants.resourceCompaniesList!.map((e){
                    return ResourceExpandedCard(
                      title: e.title,
                      subtitle: e.description,
                      link: e.link,
                      image: e.image,
                    );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

