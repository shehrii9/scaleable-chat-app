extension CorrectedTimeWithAmPm on DateTime {
  String get correctedHour {
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    return hour12 > 9 ? "$hour12" : "0$hour12";
  }

  String get correctedMinute {
    return minute > 9 ? "$minute" : "0$minute";
  }

  String get amPm {
    return hour >= 12 ? "PM" : "AM";
  }

  String get formattedTime {
    return "$correctedHour:$correctedMinute $amPm";
  }
}
