import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

part 'csv_sharer.g.dart';

/// Hands a CSV to the platform share sheet. Abstracted so the export flow
/// can be tested without a platform channel.
abstract class CsvSharer {
  Future<void> share(List<int> bytes, String filename);
}

/// Writes the file to the temp directory (the share sheet needs a path) and
/// opens the sheet. The temp copy is left for the OS to clean up — the share
/// target may still be reading it after this returns.
class SharePlusCsvSharer implements CsvSharer {
  const SharePlusCsvSharer();

  @override
  Future<void> share(List<int> bytes, String filename) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}${Platform.pathSeparator}$filename');
    await file.writeAsBytes(bytes, flush: true);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'text/csv', name: filename)],
        subject: filename,
      ),
    );
  }
}

@Riverpod(keepAlive: true)
CsvSharer csvSharer(Ref ref) => const SharePlusCsvSharer();
