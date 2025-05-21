import 'package:flutter_test/flutter_test.dart';
import 'package:inspector_tps/core/utils/time_utils.dart';

void main() {
  group('test dateTime utils', () {
    test('test dateFromIso', () {
      const iso1 = '2023-06-29T00:00:00+03:00';
      const iso2 = '2023-06-01T00:00:00+03:00';

      expect(dateFromIso(iso1), '28.06.23');
      expect(dateFromIso(iso2), '31.05.23');
      expect(dateFromIso(''), 'n/a');
    });

    test('test dateTimeFromIso', () {
      const iso1 = '2023-06-29T00:00:00+03:00';
      const iso2 = '2023-06-01T00:00:00+03:00';

      expect(dateTimeFromIso(iso1), '28.06.23 21:00');
      expect(dateTimeFromIso(iso2), '31.05.23 21:00');
      expect(dateTimeFromIso(''), 'n/a');
    });

    test('test month ago', () {
      final monthAgo = monthAgoIso();

      print(monthAgo);
    });

    test('test week ago', () {
      final weekAgo = weekAgoIso();

      print(weekAgo);
    });

    test('test day ago', () {
      final dayAgo = dayAgoIso();

      print(dayAgo);
    });

    test('test today', () {
      final tod = todayIso();

      print('today: $tod');
    });

    test('test tomorrow', () {
      final tom = tomorrowIso();

      print('tomorrow: $tom');
    });

    test('test the day after tomorrow', () {
      final dayAfterTom = theDayAfterTomorrowIso();

      print('the day after tomorrow: $dayAfterTom');
    });

    test('test the two days after tomorrow', () {
      final two = theTwoDayAfterTomorrowIso();

      print('the two days after tomorrow: $two');
    });
  });
}
