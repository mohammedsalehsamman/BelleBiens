import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Share of pixels that may differ before a golden fails. Goldens are made on
/// Windows and checked on Linux in CI; anti-aliasing of curves, shadows and
/// SVG icons differs slightly between the two. A real layout change (a moved
/// or resized component) changes far more than this.
const goldenTolerance = 0.02;

/// Runs before every test file.
///
/// Loads the real bundled fonts so layout tests (360 dp, large text) measure
/// the text customers will see, not the square test glyphs.
///
/// Golden tests use Alchemist "CI goldens": text is drawn as blocks, so the
/// images do not depend on the platform's text rendering.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await _loadFont('IBMPlexSansArabic', [
    'assets/fonts/ibm_plex_sans_arabic/IBMPlexSansArabic-Regular.ttf',
    'assets/fonts/ibm_plex_sans_arabic/IBMPlexSansArabic-Medium.ttf',
    'assets/fonts/ibm_plex_sans_arabic/IBMPlexSansArabic-SemiBold.ttf',
    'assets/fonts/ibm_plex_sans_arabic/IBMPlexSansArabic-Bold.ttf',
  ]);
  await _loadFont('PlayfairDisplay', [
    'assets/fonts/playfair_display/PlayfairDisplay-Variable.ttf',
  ]);

  final current = goldenFileComparator;
  if (current is LocalFileComparator) {
    goldenFileComparator = _TolerantComparator(
      current.basedir.resolve('flutter_test_config.dart'),
    );
  }

  await AlchemistConfig.runWithConfig(
    config: const AlchemistConfig(
      platformGoldensConfig: PlatformGoldensConfig(enabled: false),
    ),
    run: testMain,
  );
}

class _TolerantComparator extends LocalFileComparator {
  new(super.testFile);

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    if (result.passed || result.diffPercent <= goldenTolerance) {
      result.dispose();
      return true;
    }
    final error = await generateFailureOutput(result, golden, basedir);
    final percent = (result.diffPercent * 100).toStringAsFixed(2);
    result.dispose();
    throw FlutterError(
      '$error\n$percent% of pixels differ '
      '(tolerance ${(goldenTolerance * 100).toStringAsFixed(0)}%).',
    );
  }
}

Future<void> _loadFont(String family, List<String> files) async {
  final loader = FontLoader(family);
  for (final path in files) {
    final bytes = File(path).readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}
