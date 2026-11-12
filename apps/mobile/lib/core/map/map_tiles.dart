import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Where map tiles come from (screen 22, EI-SW-07). OpenStreetMap's own
/// servers are for development only; staging and production use a tile
/// provider with a restricted key (plan section 9, R-01). Null draws the map
/// without tiles, as in widget tests.
class MapTiles {
  const new({required this.urlTemplate, required this.attribution});

  final String urlTemplate;
  final String attribution;

  static const openStreetMap = MapTiles(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    attribution: '© OpenStreetMap contributors',
  );
}

final mapTilesProvider = Provider<MapTiles?>((ref) => MapTiles.openStreetMap);

/// The Android application id, sent with tile requests as their usage
/// policies ask.
const mapUserAgentPackage = 'com.bellebiens.app';
