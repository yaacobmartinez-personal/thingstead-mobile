import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_config.dart';

part 'api_mode.g.dart';

/// The build-time [ApiMode], exposed as a provider so tests can override it.
@Riverpod(keepAlive: true)
ApiMode apiMode(Ref ref) => AppConfig.apiMode;
