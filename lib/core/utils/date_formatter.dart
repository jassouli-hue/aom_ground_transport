import 'package:intl/intl.dart';

final _dateFormat = DateFormat('dd/MM/yyyy', 'fr');
final _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm', 'fr');
final _timeFormat = DateFormat('HH:mm', 'fr');

String formatDate(DateTime dt) => _dateFormat.format(dt);
String formatDateTime(DateTime dt) => _dateTimeFormat.format(dt);
String formatTime(DateTime dt) => _timeFormat.format(dt);

String formatDuration(int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  if (h == 0) return '${m}min';
  if (m == 0) return '${h}h';
  return '${h}h${m.toString().padLeft(2, '0')}';
}
