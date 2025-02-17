// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../utils/colors.dart';
// import '../utils/constants.dart';
// import '../widgets/round_button.dart';
//
//
// class TermConditionCard extends StatefulWidget {
//   @override
//   _TermConditionCardState createState() => _TermConditionCardState();
// }
//
// class _TermConditionCardState extends State<TermConditionCard> {
//   int sec = 15;
//   bool show = false;
//   startTimer(){
//     Future.delayed(Duration(seconds: 1), (){
//       if(mounted){
//         setState(() {
//           if(sec <= 1){
//             show = true;
//             stopTimer();
//           }else{
//             sec--;
//           }
//         });
//       }
//     });
//   }
//   stopTimer() {
//     Future.delayed(Duration(seconds: 1), () {
//       if(mounted){
//         setState(() {
//           sec = 0;
//         });
//       }
//     });
//   }
//   @override
//   void initState() {
//     super.initState();
//   }
//   @override
//   void dispose() {
//     stopTimer();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: EdgeInsets.only(left: 20, right: 20),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(40),
//       ),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       child: contentBox(context),
//     );
//   }
//   contentBox(context) {
//     startTimer();
//
//     return Container(
//       width: double.infinity,
//
//       decoration: BoxDecoration(
//           shape: BoxShape.rectangle,
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
//           ]),
//       child: Wrap(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(17),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   AutoSizeText('Terms and Conditions agreements act as a legal contract between you the company who has the website or mobile app and the user who access your mobile app.', style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,fontSize: 13), textAlign: TextAlign.justify,),
//                   SizedBox(height: 12),
//                   AutoSizeText('Terms and Conditions agreements act as a legal contract between you the company who has the website or mobile app and the user who access your mobile app.',style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,fontSize: 13), textAlign: TextAlign.justify,),
//                   SizedBox(height: 12),
//                   AutoSizeText('Terms and Conditions agreements act as a legal contract between you the company who has the website or mobile app and the user who access your mobile app.', style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,fontSize: 13), textAlign: TextAlign.justify,),
//                   SizedBox(height: 12),
//                   AutoSizeText('Terms and Conditions agreements act as a legal contract between you the company who has the website or mobile app and the user who access your mobile app.', style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,fontSize: 13), textAlign: TextAlign.justify,),
//                   SizedBox(height: 12),
//                   AutoSizeText('Terms and Conditions agreements act as a legal contract between you the company who has the website or mobile app and the user who access your mobile app.', style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,fontSize: 13), textAlign: TextAlign.justify,),
//                   SizedBox(height: 12),
//                   AutoSizeText('Terms and Conditions agreements act as a legal contract between you the company who has the website or mobile app and the user who access your mobile app.', style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,fontSize: 13), textAlign: TextAlign.justify,),
//                   SizedBox(height: 12),
//                   AutoSizeText('Terms and Conditions agreements act as a legal contract between you the company who has the website or mobile app and the user who access your mobile app.', style: TextStyle(color: theme.lightTheme == true ? Colors.black54 : Colors.white,fontSize: 13), textAlign: TextAlign.justify,),
//                   SizedBox(height: 12),
//                   Container(
//                     padding: EdgeInsets.only(left: 30, right: 30),
//                     child: RoundedButton(
//                         title: show == false ? sec.toString() : 'Agree',
//                         colour: show == false ? ColorRefer.kPurpleColor.withOpacity(0.4) : ColorRefer.kPurpleColor,
//                         buttonRadius: 20,
//                         height: 40,
//                         onPressed: (){
//                           if(show == true){
//                             setState(() {
//                               Constants.checkedValue = true;
//                             });
//                             Navigator.pop(context);
//                           }
//                         }
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
