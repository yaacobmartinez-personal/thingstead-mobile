/// Pull the check-in token out of a scanned value: either the bare token or the
/// full ticket URL (`…/checkin?c=TOKEN`). Port of `extractCheckInToken` in
/// regista/lib/checkin.ts so the app and the server agree on what a QR holds.
String? extractCheckInToken(String scanned) {
  final value = scanned.trim();
  if (value.isEmpty) return null;
  final uri = Uri.tryParse(value);
  if (uri != null && uri.hasScheme) {
    final c = uri.queryParameters['c'];
    if (c != null && c.isNotEmpty) return c;
  }
  return value;
}
