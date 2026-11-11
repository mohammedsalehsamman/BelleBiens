import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Runs before every test file.
///
/// Loads the real bundled fonts so layout tests (360 dp, large text) measure
/// the text customers will see, not the square test glyphs.
///
/// Golden tests use Alchemist "CI goldens": text is drawn as blocks, so the
/// images are identical on Windows (where they are made) and Linux (CI).
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

  await AlchemistConfig.runWithConfig(
    config: const AlchemistConfig(
      platformGoldensConfig: PlatformGoldensConfig(enabled: false),
    ),
    run: testMain,
  );
}

Future<void> _loadFont(String family, List<String> files) async {
  final loader = FontLoader(family);
  for (final path in files) {
    final bytes = File(path).readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}
