import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/network/api_error.dart';

void main() {
  group('ApiError.fromResponse', () {
    test('uses the server message when present', () {
      final e = ApiError.fromResponse(400, {'error': 'Title is required.'});
      expect(e.status, 400);
      expect(e.message, 'Title is required.');
    });

    test('falls back per status like the Expo client', () {
      expect(ApiError.fromResponse(401, null).message,
          'Your session has expired. Sign in again.');
      expect(ApiError.fromResponse(403, {}).message,
          "You don't have access to that.");
      expect(ApiError.fromResponse(500, 'oops').message,
          'Something went wrong. Try again.');
    });

    test('keeps fieldErrors and reason', () {
      final e = ApiError.fromResponse(409, {
        'error': 'You are the only admin.',
        'reason': 'sole_admin',
        'fieldErrors': {'email': 'Taken', 'ignored': 5},
      });
      expect(e.reason, 'sole_admin');
      expect(e.fieldErrors, {'email': 'Taken'});
    });

    test('ignores an empty error string', () {
      expect(ApiError.fromResponse(404, {'error': ''}).message,
          'Something went wrong. Try again.');
    });
  });

  group('ApiError.fromDio', () {
    final options = RequestOptions(path: '/x');

    test('transport failure is status 0', () {
      final e = ApiError.fromDio(
        DioException(requestOptions: options, type: DioExceptionType.connectionError),
      );
      expect(e.status, 0);
      expect(e.isNetwork, isTrue);
      expect(e.message, ApiError.networkMessage);
    });

    test('response failure maps status and body', () {
      final e = ApiError.fromDio(DioException(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: 403,
          data: {'error': 'Forbidden'},
        ),
      ));
      expect(e.status, 403);
      expect(e.isForbidden, isTrue);
      expect(e.message, 'Forbidden');
    });
  });

  test('flags', () {
    expect(ApiError(401, 'x').isUnauthorized, isTrue);
    expect(ApiError(404, 'x').isNotFound, isTrue);
    expect(ApiError.notAvailable().status, 501);
    expect(ApiError(0, 'x').toString(), 'ApiError(0, x)');
  });
}
