import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens other apps: WhatsApp, the phone dialer, maps, Instagram (EI-SW-01,
/// EI-SW-07). Behind an interface so widget tests can record what was opened.
abstract class ExternalLinks {
  Future<bool> open(Uri uri);

  /// wa.me link with an optional ready-made message (FR-CRT-12).
  static Uri whatsapp(String phone, {String? text}) => Uri.https(
    'wa.me',
    '/${phone.replaceAll(RegExp('[^0-9]'), '')}',
    {'text': ?text},
  );

  static Uri call(String phone) => Uri(scheme: 'tel', path: phone);

  /// Directions in the phone's maps app (no Google SDK, ADR 0010).
  static Uri maps(num latitude, num longitude, String label) {
    final at = '$latitude,$longitude';
    return Uri.parse('geo:$at?q=$at(${Uri.encodeComponent(label)})');
  }

  static Uri instagram(String handle) =>
      Uri.https('instagram.com', '/${handle.replaceFirst('@', '')}');
}

class UrlLauncherLinks implements ExternalLinks {
  @override
  Future<bool> open(Uri uri) =>
      launchUrl(uri, mode: LaunchMode.externalApplication);
}

final externalLinksProvider = Provider<ExternalLinks>(
  (ref) => UrlLauncherLinks(),
);
