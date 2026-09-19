import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thingstead/core/fake/seed.dart';
import 'package:thingstead/core/model/enums.dart';
import 'package:thingstead/core/network/api_client.dart';
import 'package:thingstead/core/network/api_error.dart';
import 'package:thingstead/core/network/unauthorized_events.dart';
import 'package:thingstead/features/auth/application/auth_controller.dart';
import 'package:thingstead/features/organizer/checkin/data/fake_checkin_repository.dart';
import 'package:thingstead/features/organizer/checkin/data/real_checkin_repository.dart';
import 'package:thingstead/features/organizer/checkin/domain/scan_result.dart';
import 'package:thingstead/features/organizer/organizer_providers.dart';

import '../../helpers/fakes.dart';

/// Records every request and answers each with a canned JSON body.
class _CapturingAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  Map<String, Object?> reply = const {};

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? body, Future<void>? cancel) async {
    requests.add(options);
    return ResponseBody.fromString(jsonEncode(reply), 200, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('RealCheckinRepository.setCheckedIn (#24)', () {
    late _CapturingAdapter adapter;
    late RealCheckinRepository repo;

    setUp(() {
      adapter = _CapturingAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api'))..httpClientAdapter = adapter;
      repo = RealCheckinRepository(ApiClient(dio: dio, token: () => 't', unauthorized: UnauthorizedEvents()));
    });

    Map<String, Object?> body() => adapter.requests.single.data as Map<String, Object?>;

    test('sends `at` as UTC ISO-8601 when given', () async {
      adapter.reply = {'checkedInAt': '2026-09-18T12:00:00.000Z'};
      final at = DateTime(2026, 9, 18, 20, 0).toUtc();
      await repo.setCheckedIn('acme', 'summer-meetup', 'r_1', checkedIn: true, at: at);
      expect(adapter.requests.single.path, '/mobile/orgs/acme/events/summer-meetup/attendees/r_1/checkin');
      expect(body(), {'checkedIn': true, 'at': at.toIso8601String()});
      expect(body()['at'], endsWith('Z'));
    });

    test('omits `at` entirely when not given (server stamps now)', () async {
      adapter.reply = {'checkedInAt': '2026-09-18T12:00:00.000Z'};
      await repo.setCheckedIn('acme', 'summer-meetup', 'r_1', checkedIn: true);
      expect(body(), {'checkedIn': true});
    });
  });

  group('RealCheckinRepository.scan (E6 `at`)', () {
    late _CapturingAdapter adapter;
    late RealCheckinRepository repo;

    setUp(() {
      adapter = _CapturingAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api'))..httpClientAdapter = adapter;
      repo = RealCheckinRepository(ApiClient(dio: dio, token: () => 't', unauthorized: UnauthorizedEvents()));
      adapter.reply = {'outcome': 'checked_in', 'name': 'Ava'};
    });

    Map<String, Object?> body() => adapter.requests.single.data as Map<String, Object?>;

    test('sends `at` as UTC ISO-8601 when given', () async {
      final at = DateTime.utc(2026, 9, 18, 12);
      await repo.scan('acme', 'chk_r_1', eventSlug: 'summer-meetup', at: at);
      expect(adapter.requests.single.path, '/mobile/checkin');
      expect(body(), {'slug': 'acme', 'code': 'chk_r_1', 'eventSlug': 'summer-meetup', 'at': at.toIso8601String()});
    });

    test('omits `at` for a live scan', () async {
      await repo.scan('acme', 'chk_r_1');
      expect(body(), {'slug': 'acme', 'code': 'chk_r_1'});
    });
  });

  group('FakeCheckinRepository.setCheckedIn mirrors the server clamp', () {
    late TestWorld world;
    late FakeCheckinRepository repo;

    setUp(() async {
      world = TestWorld();
      final c = world.container();
      await c
          .read(authControllerProvider.notifier)
          .signInWithPassword(FakeAccounts.organizerEmail, FakeAccounts.password);
      repo = c.read(checkinRepositoryProvider) as FakeCheckinRepository;
    });

    String fresh() {
      final acme = world.store.tenantBySlug('acme')!;
      final summer = world.store.eventBySlug(acme.id, 'summer-meetup')!;
      return world.store
          .registrationsOf(summer.id)
          .firstWhere((r) => r.status == RegistrationStatus.confirmed && r.checkedInAt == null)
          .id;
    }

    test('a past `at` is stored as given', () async {
      final door = testNow.subtract(const Duration(hours: 1));
      expect(await repo.setCheckedIn('acme', 'summer-meetup', fresh(), checkedIn: true, at: door), door);
    });

    test('earlier than the registration clamps to createdAt', () async {
      final id = fresh();
      final createdAt = world.store.registrationById(id)!.createdAt;
      final at = await repo.setCheckedIn('acme', 'summer-meetup', id, checkedIn: true, at: DateTime.utc(2000));
      expect(at, createdAt);
    });

    test('a few seconds fast clamps to now', () async {
      final at = await repo.setCheckedIn(
        'acme',
        'summer-meetup',
        fresh(),
        checkedIn: true,
        at: testNow.add(const Duration(seconds: 30)),
      );
      expect(at, testNow);
    });

    test('more than five minutes fast is a 400', () async {
      await expectLater(
        repo.setCheckedIn(
          'acme',
          'summer-meetup',
          fresh(),
          checkedIn: true,
          at: testNow.add(FakeCheckinRepository.futureTolerance + const Duration(seconds: 1)),
        ),
        throwsA(isA<ApiError>().having((e) => e.status, 'status', 400)),
      );
    });

    test('no `at` means now', () async {
      expect(await repo.setCheckedIn('acme', 'summer-meetup', fresh(), checkedIn: true), testNow);
    });

    group('and so does scan', () {
      String token() => world.store.registrationById(fresh())!.checkInToken!;

      test('a past `at` is stored as given', () async {
        final door = testNow.subtract(const Duration(hours: 1));
        final r = await repo.scan('acme', token(), at: door);
        expect(r.outcome, CheckInOutcome.checkedIn);
        expect(r.at, door);
      });

      test('a few seconds fast clamps to now', () async {
        final r = await repo.scan('acme', token(), at: testNow.add(const Duration(seconds: 30)));
        expect(r.at, testNow);
      });

      test('more than five minutes fast is a 400, before any lookup', () async {
        await expectLater(
          repo.scan('acme', 'garbage', at: testNow.add(FakeCheckinRepository.futureTolerance + const Duration(seconds: 1))),
          throwsA(isA<ApiError>().having((e) => e.status, 'status', 400)),
        );
      });

      test('a second scan reads already with the original door time', () async {
        final t = token();
        final door = testNow.subtract(const Duration(minutes: 20));
        await repo.scan('acme', t, at: door);
        final again = await repo.scan('acme', t);
        expect(again.outcome, CheckInOutcome.already);
        expect(again.at, door);
      });
    });
  });
}
