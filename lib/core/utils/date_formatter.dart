import 'package:intl/intl.dart';

final _dateFormat = DateFormat('dd/MM/yyyy');
final _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');

String formatDate(DateTime dt) => _dateFormat.format(dt);
String formatDateTime(DateTime dt) => _dateTimeFormat.format(dt);
String formatTime(DateTime dt) => DateFormat('HH:mm').format(dt);

String formatDuration(int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  if (h == 0) return '${m}min';
  if (m == 0) return '${h}h';
  return '${h}h${m.toString().padLeft(2, '0')}';
}
