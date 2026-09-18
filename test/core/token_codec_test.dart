import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/network/token_codec.dart';

void main() {
  final exp = DateTime.utc(2026, 10, 18, 12);

  String realShaped(Map<String, dynamic> payload) {
    final body = base64Url.encode(utf8.encode(jsonEncode(payload))).replaceAll('=', '');
    return '$body.c2ln'; // any signature; the app never verifies it
  }

  test('reads exp and sub from a real-shaped token', () {
    final token = realShaped({'sub': 'u_1', 'exp': exp.millisecondsSinceEpoch});
    expect(TokenCodec.expiry(token), exp);
    expect(TokenCodec.subject(token), 'u_1');
    expect(TokenCodec.isFake(token), isFalse);
  });

  test('fake tokens carry the same payload behind a prefix', () {
    final token = TokenCodec.mintFake('u_9', exp);
    expect(TokenCodec.isFake(token), isTrue);
    expect(TokenCodec.expiry(token), exp);
    expect(TokenCodec.subject(token), 'u_9');
  });

  test('garbage is null, never a throw', () {
    for (final t in ['', 'nodot', '.', 'not-base64!.sig', '${base64Url.encode(utf8.encode('[]'))}.x']) {
      expect(TokenCodec.expiry(t), isNull, reason: t);
      expect(TokenCodec.subject(t), isNull, reason: t);
    }
  });

  test('tolerates missing padding', () {
    final token = realShaped({'sub': 'ab', 'exp': 1}); // short body, odd length
    expect(TokenCodec.subject(token), 'ab');
  });
}
