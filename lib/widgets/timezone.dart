import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

extension DateTimeExtension on DateTime {
  static int? _estToUtcDifference;

  int _getESTtoUTCDifference() {
    if (_estToUtcDifference == null) {
      tz.initializeTimeZones();
      final locationNY = tz.getLocation('America/New_York');
      tz.TZDateTime nowNY = tz.TZDateTime.now(locationNY);
      _estToUtcDifference = nowNY.timeZoneOffset.inHours;
    }

    return _estToUtcDifference!;
  }

  DateTime toESTzone() {
    DateTime result = toUtc(); // local time to UTC
    result = result.add(Duration(hours: _getESTtoUTCDifference()));
    // convert UTC to EST and remove ZULU as it is not UTC anymore.
    String dateTimeAsIso8601String =
    result.toIso8601String().replaceAll('Z', '');
    result = DateTime.parse(dateTimeAsIso8601String);
    return result;
  }

  DateTime fromESTzone() {
    DateTime result = subtract(
        Duration(hours: _getESTtoUTCDifference())); // convert EST to UTC

    String dateTimeAsIso8601String = result.toIso8601String();
    dateTimeAsIso8601String += dateTimeAsIso8601String.endsWith('Z') ? '' : 'Z';
    result = DateTime.parse(dateTimeAsIso8601String); // make isUtc to be true

    result = result.toLocal(); // convert UTC to local time
    return result;
  }
}