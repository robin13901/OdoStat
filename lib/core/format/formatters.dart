import 'package:intl/intl.dart';

/// German-locale number, date and unit formatting for OdoStat.
///
/// Dates are stored throughout the app as an `int` in `yyyyMMdd` form (e.g.
/// `20250313`) — the same convention as the CarGo source app. These helpers
/// convert between that packed int, [DateTime], and display strings.
class Fmt {
  const Fmt._();

  static final NumberFormat _int = NumberFormat.decimalPattern('de_DE');
  static final NumberFormat _dec1 = NumberFormat('#,##0.0', 'de_DE');
  static final NumberFormat _dec2 = NumberFormat('#,##0.00', 'de_DE');
  static final DateFormat _date = DateFormat('dd.MM.yyyy', 'de_DE');
  static final DateFormat _monthYear = DateFormat('MMMM yyyy', 'de_DE');
  static final DateFormat _monthShort = DateFormat('MMM', 'de_DE');

  // --- Packed yyyyMMdd <-> DateTime --------------------------------------
  static DateTime intToDate(int yyyymmdd) {
    final y = yyyymmdd ~/ 10000;
    final m = (yyyymmdd % 10000) ~/ 100;
    final d = yyyymmdd % 100;
    return DateTime(y, m, d);
  }

  static int dateToInt(DateTime d) => d.year * 10000 + d.month * 100 + d.day;

  static int todayAsInt() => dateToInt(DateTime.now());

  /// Year component of a packed date.
  static int yearOf(int yyyymmdd) => yyyymmdd ~/ 10000;

  /// Month component (1-12) of a packed date.
  static int monthOf(int yyyymmdd) => (yyyymmdd % 10000) ~/ 100;

  // --- Date display -------------------------------------------------------
  static String date(int yyyymmdd) => _date.format(intToDate(yyyymmdd));

  static String monthYear(int year, int month) =>
      _monthYear.format(DateTime(year, month));

  static String monthShort(int month) => _monthShort.format(DateTime(2000, month));

  // --- Numbers & units ----------------------------------------------------
  static String km(num value) => '${_int.format(value.round())} km';

  static String liters(num value) => '${_dec2.format(value)} l';

  static String kwh(num value) => '${_dec2.format(value)} kWh';

  static String euro(num value) => '${_dec2.format(value)} €';

  static String eurPerLiter(num value) => '${_dec2.format(value)} €/l';

  static String eurPerKwh(num value) => '${_dec2.format(value)} €/kWh';

  /// Consumption per 100 km, unit depends on propulsion (`l` or `kWh`).
  static String per100km(num value, {required bool electric}) =>
      '${_dec1.format(value)} ${electric ? 'kWh' : 'l'}/100 km';

  static String eurPer100km(num value) =>
      '${_dec2.format(value)} €/100 km';

  static String decimal1(num value) => _dec1.format(value);
  static String decimal2(num value) => _dec2.format(value);
}
