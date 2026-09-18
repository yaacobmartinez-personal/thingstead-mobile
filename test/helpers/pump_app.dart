import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:thingstead/core/theme/app_theme.dart';

import 'fakes.dart';

/// Pumps [child] inside a [ProviderScope] with the [world]'s overrides and a
/// minimal router, so screens that call `context.push` don't blow up.
/// Returns the container so tests can inspect provider state.
Future<ProviderContainer> pumpApp(
  WidgetTester tester,
  Widget child, {
  required TestWorld world,
  List<Override> extraOverrides = const [],
}) async {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, _) => child),
      GoRoute(
        path: '/:any(.*)',
        builder: (_, state) => Scaffold(body: Text('route:${state.uri}')),
      ),
    ],
  );
  final container = ProviderContainer(
    overrides: [...world.overrides, ...extraOverrides],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
    ),
  );
  await tester.pump();
  return container;
}
