import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimeAgo{
  static String timeAgoSinceDate(String dateString, bool long, {bool numericDates = true}) {
    DateTime notificationDate = DateFormat("dd-MM-yyyy h:mma").parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);
    final ago = new DateTime.now().subtract(difference);
    return timeago.format(ago, allowFromNow: true, locale: 'en');
  }

}