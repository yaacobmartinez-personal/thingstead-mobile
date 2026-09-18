/// CSV serialisation for attendee exports — port of regista/lib/csv.ts.
///
/// Attendee names and emails are supplied by the public, so a cell like
/// `=cmd|'/c calc'!A1` would execute as a formula when the file is opened in
/// a spreadsheet. Any cell beginning with a formula trigger is prefixed with
/// an apostrophe, which spreadsheets treat as "this is text".
library;

final RegExp _formulaTrigger = RegExp(r'^[=+\-@\t\r]');
final RegExp _needsQuoting = RegExp(r'[",\n\r]');

String escapeCsvCell(String? value) {
  var cell = value ?? '';
  if (_formulaTrigger.hasMatch(cell)) cell = "'$cell";
  if (_needsQuoting.hasMatch(cell)) cell = '"${cell.replaceAll('"', '""')}"';
  return cell;
}

String toCsv(List<String> headers, List<List<String?>> rows) {
  final lines = [headers.map(escapeCsvCell).join(',')];
  for (final row in rows) {
    lines.add(row.map(escapeCsvCell).join(','));
  }
  // CRLF keeps Excel happy; a trailing newline is conventional.
  return '${lines.join('\r\n')}\r\n';
}

/// Safe filename segment.
String filenameSlug(String value) {
  final s = value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  final cut = s.length > 60 ? s.substring(0, 60) : s;
  return cut.isEmpty ? 'export' : cut;
}
