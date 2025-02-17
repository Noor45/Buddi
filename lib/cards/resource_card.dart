import 'package:buddi/utils/colors.dart';
import 'package:buddi/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buddi/utils/theme_model.dart';
import '../screens/settingScreens/external_link_screen.dart';
import '../utils/strings.dart';

// class ExpandedCard extends StatefulWidget {
//   ExpandedCard({this.title, this.subtitle, this.color});
//   final String title;
//   final List subtitle;
//   final Color color;
//
//   @override
//   _ExpandedCardState createState() => _ExpandedCardState();
// }
//
// class _ExpandedCardState extends State<ExpandedCard> {
//   @override
//   Widget build(BuildContext context) {
//     final  theme = Provider.of<DarkThemeProvider>(context);
//     return Card(
//       elevation: 5,
//       color: widget.color,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: ExpandableNotifier(
//         child: Container(
//           decoration: BoxDecoration(
//             color: widget.color,
//             borderRadius: BorderRadius.all(Radius.circular(15)),
//           ),
//           margin: EdgeInsets.only(top: 5, bottom: 5),
//           child: ScrollOnExpand(
//             scrollOnExpand: true,
//             scrollOnCollapse: true,
//             child: ExpandablePanel(
//               theme: const ExpandableThemeData(
//                 headerAlignment: ExpandablePanelHeaderAlignment.center,
//                 tapHeaderToExpand: true,
//                 hasIcon: false,
//               ),
//               header: Container(
//                 padding: EdgeInsets.only(left: 12, right: 12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         widget.title,
//                         style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
//                             color: Colors.black,
//                             fontFamily: FontRefer.PoppinsMedium,
//                             fontSize: 18),
//                       ),
//                     ),
//                     ExpandableIcon(
//                       theme: ExpandableThemeData(
//                         expandIcon: Icons.expand_more_outlined,
//                         collapseIcon: Icons.expand_less_outlined,
//                         iconColor: Colors.black,
//                         iconSize: 30,
//                         iconRotationAngle: math.pi / 2,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               expanded: Column(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
//                     decoration: BoxDecoration(
//                       color: widget.color.withOpacity(0.2),
//                       borderRadius: BorderRadius.all(Radius.circular(15)),
//                     ),
//                     child: Container(
//                       padding: EdgeInsets.only(
//                           bottom: 5, right: 10, left: 10, top: 5),
//                       decoration: BoxDecoration(
//                         color: theme.lightTheme == true
//                             ? Colors.white
//                             : Colors.black87,
//                         borderRadius: BorderRadius.all(Radius.circular(15)),
//                       ),
//                       child: ListView.builder(
//                           physics: NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemCount: widget.subtitle.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   widget.subtitle[index]['title'],
//                                   style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
//                                       color:
//                                           theme.lightTheme == true
//                                               ? Colors.black
//                                               : Colors.white,
//                                       fontFamily: FontRefer.Poppins,
//                                       fontWeight: FontWeight.w600,
//                                       wordSpacing: 1.5,
//                                       height: 1.5,
//                                       fontSize: 16),
//                                 ),
//                                 Linkify(
//                                   onOpen: (LinkableElement link) async {
//                                     Navigator.pushNamed(
//                                         context, CommunityGuidelinesScreen.ID,
//                                         arguments: ['', link.url]);
//                                   },
//                                   text: widget.subtitle[index]['description'],
//                                   style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
//                                       color:
//                                           theme.lightTheme == true
//                                               ? Colors.black
//                                               : Colors.white,
//                                       fontFamily: FontRefer.Poppins,
//                                       height: 1.5,
//                                       fontSize: 12),
//                                   linkStyle: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,
//                                       color: ColorRefer.kMainThemeColor,
//                                       fontFamily: FontRefer.Poppins,
//                                       height: 1.5,
//                                       fontSize: 12),
//                                 ),
//                               ],
//                             );
//                           }),
//                     ),
//                   )
//                 ],
//               ),
//               builder: (_, collapsed, expanded) {
//                 return Expandable(
//                   collapsed: collapsed,
//                   expanded: expanded,
//                   theme: const ExpandableThemeData(crossFadePoint: 0),
//                 );
//               },
//               collapsed: Offstage(),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class ResourceExpandedCard extends StatefulWidget {
  ResourceExpandedCard({this.title, this.subtitle, this.image, this.link});
  final String? title;
  final String? subtitle;
  final String? image;
  final String? link;

  @override
  _ResourceExpandedCardState createState() => _ResourceExpandedCardState();
}

class _ResourceExpandedCardState extends State<ResourceExpandedCard> {
  String? url;
  @override
  void initState() {
    url = widget.link;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    return Column(
      children: [
        InkWell(
          onTap: () async{
            Navigator.pushNamed(context,
                ExternalLinkScreen.externalLinkScreenID, arguments: url);
          },
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage.assetNetwork(
                        image: widget.image!,
                        placeholder: StringRefer.placeholder,
                        height: MediaQuery.of(context).size.width/8,
                        width: MediaQuery.of(context).size.width/8,
                        fit: BoxFit.fill,
                      ),
                    ),
                     SizedBox(width: 15),
                     Text(
                      widget.title!,
                      style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,fontFamily: FontRefer.PoppinsMedium, fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.subtitle!,
                        style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,fontSize: 14.0, fontFamily: FontRefer.PoppinsMedium, height: 1.5),
                       ),
                    ),
                     SizedBox(width: 25),
                     Padding(
                       padding: EdgeInsets.only(top: 8.0),
                       child: Icon(Icons.arrow_forward_ios_sharp, color: ColorRefer.kHintColor),
                     ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider(
          color: Color(0xffFADC35),
          thickness: 1,
        ),
      ],
    );
  }
}
