import 'dart:math';

class HelperClass {
  static String generateRandomString() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final codeUnits = List<int>.generate(16, (index) {
      final randomIndex = random.nextInt(chars.length);
      return chars.codeUnitAt(randomIndex);
    });

    return String.fromCharCodes(codeUnits);
  }

  static String getSameDayDate() {
    String _twoDigits(int n) {
      if (n >= 10) {
        return '$n';
      }
      return '0$n';
    }

    DateTime now = DateTime.now();
    String formattedDate =
        '${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)}';

    return formattedDate;
  }

  static List<String> generateDateList() {
    String _twoDigits(int n) {
      if (n >= 10) {
        return '$n';
      }
      return '0$n';
    }

    List<String> dateList = [];
    DateTime now = DateTime.now();

    for (int i = 0; i < 20; i++) {
      DateTime currentDate = now.add(Duration(days: i));
      String formattedDate =
          '${currentDate.year}-${_twoDigits(currentDate.month)}-${_twoDigits(currentDate.day)}';
      dateList.add(formattedDate);
    }

    return dateList;
  }

  static String getMonthAbbreviation(String month) {
    final Map<String, String> monthMap = {
      '01': 'Jan',
      '02': 'Feb',
      '03': 'Mar',
      '04': 'Apr',
      '05': 'May',
      '06': 'Jun',
      '07': 'Jul',
      '08': 'Aug',
      '09': 'Sep',
      '10': 'Oct',
      '11': 'Nov',
      '12': 'Dec',
    };

    return monthMap[month] ?? 'Invalid';
  }

 
  static String formatTimestampToAmPm(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String period = dateTime.hour >= 12 ? 'pm' : 'am';
    int hourIn12HourFormat =
        dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    String formattedTime =
        '${hourIn12HourFormat.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $period';
    return formattedTime;
  }

  static String getInitials(String firstName, String lastName) {
    String initials = '';

    // Check if first name is not empty and add its initial
    if (firstName.isNotEmpty) {
      initials += firstName[0].toUpperCase();
    }

    // Check if last name is not empty and add its initial
    if (lastName.isNotEmpty) {
      initials += lastName[0].toUpperCase();
    }

    return initials;
  }

  static String getTwoDaysBeforeDate() {
    String twoDigits(int n) {
      if (n >= 10) {
        return '$n';
      }
      return '0$n';
    }

    DateTime now = DateTime.now();
    DateTime twoDaysBefore = now.subtract(Duration(days: 2));
    String formattedDate =
        '${twoDaysBefore.year}-${twoDigits(twoDaysBefore.month)}-${twoDigits(twoDaysBefore.day)}';

    return formattedDate;
  }
}
