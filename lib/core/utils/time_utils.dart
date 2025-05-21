import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

bool outdated(String input) {
  try {
    final date = DateTime.parse(input);
    return DateTime.now().compareTo(date) > 0;
  } catch (err) {
    return false;
  }
}

String dateFromIso(String input) {
  try {
    final date = DateTime.parse(input);
    return DateFormat('dd.MM.yy').format(date);
  } catch (err) {
    debugPrint(err.toString());
    return 'n/a';
  }
}

String dateTimeFromIso(String input) {
  try {
    final date = DateTime.parse(input);
    return DateFormat('dd.MM.yy HH:mm').format(date);
  } catch (err) {
    debugPrint(err.toString());
    return 'n/a';
  }
}

const monthMs = 30 * 24 * 60 * 60 * 1000;
const weekMs = 7 * 24 * 60 * 60 * 1000;
const dayMs = 24 * 60 * 60 * 1000;

String monthAgoIso({int monthsCount = 1}) {
  final now = DateTime.now().millisecondsSinceEpoch;
  return DateTime.fromMillisecondsSinceEpoch(now - monthMs * monthsCount)
      .toIso8601String()
      .split('T')[0];
}

String weekAgoIso() {
  final now = DateTime.now().millisecondsSinceEpoch;
  return DateTime.fromMillisecondsSinceEpoch(now - weekMs)
      .toIso8601String()
      .split('T')[0];
}

String dayAgoIso() {
  final now = DateTime.now().millisecondsSinceEpoch;
  return DateTime.fromMillisecondsSinceEpoch(now - dayMs)
      .toIso8601String()
      .split('T')[0];
}

String todayIso() {
  return DateTime.now().toIso8601String().split('T')[0];
}

String todayFullIso() {
  return DateTime.now().toIso8601String();
}

String tomorrowIso() {
  final now = DateTime.now().millisecondsSinceEpoch;
  return DateTime.fromMillisecondsSinceEpoch(now + dayMs)
      .toIso8601String()
      .split('T')[0];
}

String theDayAfterTomorrowIso() {
  final now = DateTime.now().millisecondsSinceEpoch;
  return DateTime.fromMillisecondsSinceEpoch(now + dayMs + dayMs)
      .toIso8601String()
      .split('T')[0];
}

String theTwoDayAfterTomorrowIso() {
  final now = DateTime.now().millisecondsSinceEpoch;
  return DateTime.fromMillisecondsSinceEpoch(now + dayMs + dayMs + dayMs)
      .toIso8601String()
      .split('T')[0];
}
