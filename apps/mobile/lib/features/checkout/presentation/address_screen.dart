import 'dart:async';

import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/map/map_tiles.dart';
import 'package:belle_biens/core/network/api_error.dart';
import 'package:belle_biens/core/network/error_text.dart';
import 'package:belle_biens/core/text/arabic_normalize.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/account/application/account_providers.dart';
import 'package:belle_biens/features/auth/application/session_controller.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:belle_biens/features/checkout/application/checkout_controller.dart';
import 'package:belle_biens/features/checkout/domain/checkout_draft.dart';
import 'package:belle_biens/features/checkout/presentation/checkout_screen.dart';
import 'package:belle_biens/features/checkout/presentation/checkout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

/// The branch in Abu Rummaneh: where the map opens the first time.
const _branch = LatLng(33.5155, 36.284);

/// Screen 22: a pin on the map, a landmark and the building (FR-DLV-01/06).
/// The pin stays in the middle; moving the map moves the address, and the
/// server says which zone it falls in.
///
/// With [forAccount], it adds or changes a saved address instead (screen
/// 29): an address outside the zones is kept, only flagged.
class AddressScreen extends ConsumerStatefulWidget {
  const new({super.key, this.forAccount = false, this.editing});

  final bool forAccount;

  /// The saved address being changed (screen 29 "تعديل").
  final AddressDto? editing;

  @override
  ConsumerState<AddressScreen> createState() => _AddressScreenState();
}

enum _Label { home, work, other }

class _AddressScreenState extends ConsumerState<AddressScreen> {
  final _map = MapController();
  late final _search = TextEditingController();
  late final _landmark = TextEditingController();
  late final _building = TextEditingController();
  late final _floor = TextEditingController();
  late final _details = TextEditingController();

  late LatLng _center;
  _Label _label = _Label.home;
  bool _save = false;
  bool _isDefault = false;
  bool _callBefore = false;
  bool _saving = false;

  /// The zone at the pin; null outside every zone.
  ZoneDto? _zone;
  bool _checking = false;
  Object? _checkError;
  Timer? _debounce;
  int _check = 0;
  String? _searchError;

  @override
  void initState() {
    super.initState();
    final a = _start;
    _center = a == null ? _branch : LatLng(a.latitude, a.longitude);
    _isDefault = widget.editing?.isDefault ?? false;
    _callBefore = widget.editing?.callBeforeArrival ?? false;
    _checking = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkZone());
  }

  bool _filled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The label names need the app's language, so the fields fill here.
    if (_filled) return;
    _filled = true;
    final a = _start;
    if (a != null) _fill(a);
  }

  /// Where the screen starts: the saved address being changed, or the one
  /// already chosen at checkout.
  DraftAddress? get _start {
    final editing = widget.editing;
    if (editing != null) return DraftAddress.fromSaved(editing);
    if (widget.forAccount) return null;
    return ref.read(checkoutControllerProvider).address;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _map.dispose();
    for (final c in [_search, _landmark, _building, _floor, _details]) {
      c.dispose();
    }
    super.dispose();
  }

  void _fill(DraftAddress a) {
    _landmark.text = a.landmark;
    _building.text = a.building;
    _floor.text = a.floor;
    _details.text = a.details;
    _zone = a.zone;
    _label = _labelOf(a.label);
  }

  _Label _labelOf(String label) {
    final l10n = AppLocalizations.of(context);
    if (label.isEmpty || label == l10n.addressHome) return _Label.home;
    if (label == l10n.addressWork) return _Label.work;
    return _Label.other;
  }

  String _labelText(AppLocalizations l10n) => switch (_label) {
    _Label.home => l10n.addressHome,
    _Label.work => l10n.addressWork,
    _Label.other => l10n.addressOther,
  };

  void _moved(MapCamera camera, bool hasGesture) {
    _center = camera.center;
    if (!hasGesture) return;
    _debounce?.cancel();
    setState(() => _checking = true);
    _debounce = Timer(const Duration(milliseconds: 400), _checkZone);
  }

  Future<void> _checkZone() async {
    final at = _center;
    final n = ++_check;
    setState(() {
      _checking = true;
      _checkError = null;
    });
    try {
      final result = await ref
          .read(checkoutRepositoryProvider)
          .zoneCheck(at.latitude, at.longitude);
      if (!mounted || n != _check) return;
      setState(() {
        _zone = result.inZone ? result.zone : null;
        _checking = false;
      });
    } on ApiError catch (error) {
      if (!mounted || n != _check) return;
      setState(() {
        _checkError = error;
        _checking = false;
      });
    }
  }

  void _goTo(LatLng point) {
    _center = point;
    _map.move(point, 16);
    unawaited(_checkZone());
  }

  /// Area search: the shop's zone names, matched the Arabic way (FR-CAT-04).
  void _findArea(String query, List<ZoneWithAreaDto> zones) {
    final q = normalizeArabic(query);
    if (q.isEmpty) return;
    final zone = zones
        .where(
          (z) =>
              normalizeArabic(z.name.ar).contains(q) ||
              z.name.en.toLowerCase().contains(query.trim().toLowerCase()),
        )
        .firstOrNull;
    setState(
      () => _searchError = zone == null
          ? AppLocalizations.of(context).addressNoArea
          : null,
    );
    if (zone == null) return;
    final points = zone.polygon;
    final lat = points.map((p) => p[1]).reduce((a, b) => a + b) / points.length;
    final lng = points.map((p) => p[0]).reduce((a, b) => a + b) / points.length;
    _goTo(LatLng(lat, lng));
  }

  /// Screen 29: saves the address to the account, inside the zones or not.
  Future<void> _saveToAccount() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _saving = true);
    try {
      await ref.read(accountRepositoryProvider).saveAddress({
        'latitude': _center.latitude,
        'longitude': _center.longitude,
        'label': _labelText(l10n),
        'landmark': _landmark.text.trim(),
        'building': _building.text.trim(),
        'floor': _floor.text.trim(),
        'details': _details.text.trim(),
        'isDefault': _isDefault,
        'callBeforeArrival': _callBefore,
      }, id: widget.editing?.id);
      ref
        ..invalidate(myAddressesProvider)
        ..invalidate(savedAddressesProvider);
      messenger.showSnackBar(SnackBar(content: Text(l10n.addressesSaved)));
      if (mounted) context.pop();
    } on Object catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l10n, error))));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _confirm() async {
    if (widget.forAccount) return await _saveToAccount();
    final l10n = AppLocalizations.of(context);
    final address = DraftAddress(
      latitude: _center.latitude,
      longitude: _center.longitude,
      zone: _zone,
      label: _labelText(l10n),
      landmark: _landmark.text.trim(),
      building: _building.text.trim(),
      floor: _floor.text.trim(),
      details: _details.text.trim(),
      save: _save,
    );
    final checkout = ref.read(checkoutControllerProvider.notifier)
      ..address(address);
    if (_zone != null) {
      context.pop();
      return;
    }
    // Screen 36: outside the zones.
    final choice = await context.push<String>(Routes.checkoutOutOfZone);
    if (!mounted) return;
    if (choice == outOfZonePickup) {
      checkout.fulfillment(Fulfillment.pickup);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final money = ref.watch(moneyFormatProvider);
    final zones = ref.watch(zonesProvider).value ?? const [];
    final tiles = ref.watch(mapTilesProvider);
    final signedIn = ref.watch(sessionControllerProvider).value != null;
    final saved = ref.watch(savedAddressesProvider).value ?? const [];
    final zone = _zone;

    return Scaffold(
      appBar: BBTopBar(
        title: l10n.addressTitle,
        onBack: () => Navigator.of(context).maybePop(),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 300,
            child: Stack(
              children: [
                Semantics(
                  label: l10n.addressMapLabel,
                  child: FlutterMap(
                    mapController: _map,
                    options: MapOptions(
                      initialCenter: _center,
                      initialZoom: 15,
                      minZoom: 11,
                      maxZoom: 19,
                      backgroundColor: BBColors.surfaceMuted,
                      onPositionChanged: _moved,
                      onMapEvent: (event) {
                        if (event is MapEventMoveEnd ||
                            event is MapEventFlingAnimationEnd) {
                          _debounce?.cancel();
                          _debounce = Timer(
                            const Duration(milliseconds: 150),
                            _checkZone,
                          );
                        }
                      },
                    ),
                    children: [
                      if (tiles != null)
                        TileLayer(
                          urlTemplate: tiles.urlTemplate,
                          userAgentPackageName: mapUserAgentPackage,
                        ),
                      PolygonLayer(
                        polygons: [
                          for (final z in zones)
                            Polygon(
                              points: [
                                for (final p in z.polygon)
                                  LatLng(p[1].toDouble(), p[0].toDouble()),
                              ],
                              color: BBColors.primary.withValues(alpha: 0.08),
                              borderColor: BBColors.primary.withValues(
                                alpha: 0.5,
                              ),
                              borderStrokeWidth: 1.5,
                            ),
                        ],
                      ),
                      if (tiles != null)
                        RichAttributionWidget(
                          // The "i" button keeps the credit small at any
                          // text size, as the tiles' terms ask.
                          attributions: [
                            TextSourceAttribution(tiles.attribution),
                          ],
                        ),
                    ],
                  ),
                ),
                // The pin marks the middle of the map.
                const IgnorePointer(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 32),
                      child: BBIcon(
                        BBIcons.pin,
                        size: 40,
                        color: BBColors.primary,
                      ),
                    ),
                  ),
                ),
                if (zone != null)
                  PositionedDirectional(
                    top: BBSpacing.gutter,
                    start: BBSpacing.gutter,
                    child: BBBadge(
                      label: l10n.addressZoneBadge(zone.name.of(context)),
                      tone: BBBadgeTone.green,
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(BBSpacing.page),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BBTextField(
                  label: l10n.addressSearch,
                  controller: _search,
                  prefix: const BBIcon(
                    BBIcons.search,
                    color: BBColors.textMuted,
                  ),
                  error: _searchError,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (q) => _findArea(q, zones),
                ),
                if (saved.isNotEmpty) ...[
                  const SizedBox(height: BBSpacing.gutter),
                  Text(l10n.addressSavedTitle, style: BBText.label),
                  const SizedBox(height: BBSpacing.xs),
                  Wrap(
                    spacing: BBSpacing.sm,
                    runSpacing: BBSpacing.sm,
                    children: [
                      for (final a in saved)
                        BBChip(
                          label: addressTitle(context, a.label, a.zone),
                          icon: BBIcons.pin,
                          selected: false,
                          onTap: () {
                            setState(() => _fill(DraftAddress.fromSaved(a)));
                            _goTo(
                              LatLng(
                                a.latitude.toDouble(),
                                a.longitude.toDouble(),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: BBSpacing.gutter),
                _ZoneNotice(
                  zone: zone,
                  checking: _checking,
                  error: _checkError,
                  fee: zone == null ? null : money.syp(zone.feeMinor),
                ),
                const SizedBox(height: BBSpacing.md),
                BBTextField(
                  label: l10n.addressLandmark,
                  controller: _landmark,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: BBSpacing.gutter),
                Row(
                  children: [
                    Expanded(
                      child: BBTextField(
                        label: l10n.addressBuilding,
                        controller: _building,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(width: BBSpacing.gutter),
                    Expanded(
                      child: BBTextField(
                        label: l10n.addressFloor,
                        controller: _floor,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: BBSpacing.gutter),
                BBTextField(
                  label: l10n.addressDetails,
                  controller: _details,
                  maxLines: 3,
                ),
                const SizedBox(height: BBSpacing.md),
                Text(l10n.addressLabel, style: BBText.label),
                const SizedBox(height: BBSpacing.xs),
                Wrap(
                  spacing: BBSpacing.sm,
                  children: [
                    for (final (value, text) in [
                      (_Label.home, l10n.addressHome),
                      (_Label.work, l10n.addressWork),
                      (_Label.other, l10n.addressOther),
                    ])
                      BBChip(
                        label: text,
                        selected: _label == value,
                        onTap: () => setState(() => _label = value),
                      ),
                  ],
                ),
                if (widget.forAccount) ...[
                  const SizedBox(height: BBSpacing.sm),
                  ToggleRow(
                    label: l10n.checkoutCallBefore,
                    value: _callBefore,
                    onChanged: (v) => setState(() => _callBefore = v),
                  ),
                  if (widget.editing?.isDefault != true)
                    ToggleRow(
                      label: l10n.addressDefaultToggle,
                      value: _isDefault,
                      onChanged: (v) => setState(() => _isDefault = v),
                    ),
                ] else if (signedIn) ...[
                  const SizedBox(height: BBSpacing.sm),
                  ToggleRow(
                    label: l10n.addressSave,
                    value: _save,
                    onChanged: (v) => setState(() => _save = v),
                  ),
                ],
                const SizedBox(height: BBSpacing.lg),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BBBottomCta(
        children: [
          Expanded(
            child: BBButton(
              label: widget.forAccount ? l10n.profileSave : l10n.addressConfirm,
              expand: true,
              loading: _checking || _saving,
              onPressed: _confirm,
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoneNotice extends StatelessWidget {
  const new({
    required this.zone,
    required this.checking,
    required this.error,
    required this.fee,
  });

  final ZoneDto? zone;
  final bool checking;
  final Object? error;
  final String? fee;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (checking) return BBNotice(text: l10n.addressChecking);
    if (error != null) {
      return BBNotice(text: errorText(l10n, error!), tone: BBNoticeTone.error);
    }
    final z = zone;
    if (z == null) {
      return BBNotice(
        text: l10n.addressOutOfZone,
        tone: BBNoticeTone.warn,
        icon: BBIcons.warning,
      );
    }
    return BBNotice(
      text: l10n.addressInZone(z.name.of(context), fee!, z.eta.of(context)),
      tone: BBNoticeTone.ok,
      icon: BBIcons.check,
    );
  }
}
