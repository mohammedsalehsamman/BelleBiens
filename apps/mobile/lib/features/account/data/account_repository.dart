import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/network/api_error.dart';

/// The signed-in customer's own data (screens 28-31, 33; FR-ACC-03..08).
class AccountRepository {
  new(this._api);

  final BelleApi _api;

  Future<MeDto> updateMe(Map<String, Object?> fields) => guardApi(
    () => _api.me.meControllerUpdate(body: UpdateMeDto.fromJson(fields)),
  );

  // ---------- addresses (screen 29) ----------

  Future<List<AddressDto>> addresses() =>
      guardApi(_api.me.addressesControllerList);

  Future<AddressDto> saveAddress(Map<String, Object?> fields, {String? id}) {
    final body = AddressInputDto.fromJson(fields);
    return guardApi(
      () => id == null
          ? _api.me.addressesControllerCreate(body: body)
          : _api.me.addressesControllerUpdate(id: id, body: body),
    );
  }

  Future<void> deleteAddress(String id) =>
      guardApi(() => _api.me.addressesControllerRemove(id: id));

  // ---------- designs (screen 30) ----------

  Future<List<SavedDesignDto>> designs() =>
      guardApi(_api.me.savedDesignsControllerList);

  Future<SavedDesignDto> saveDesign({
    required String name,
    required Map<String, Object?> spec,
    String? previewUrl,
  }) => guardApi(
    () => _api.me.savedDesignsControllerCreate(
      body: SavedDesignInputDto.fromJson({
        'name': name,
        'spec': spec,
        'previewUrl': ?previewUrl,
      }),
    ),
  );

  Future<void> deleteDesign(String id) =>
      guardApi(() => _api.me.savedDesignsControllerRemove(id: id));

  // ---------- occasions (screen 31) ----------

  Future<List<OccasionReminderDto>> occasions() =>
      guardApi(_api.me.occasionsControllerList);

  Future<OccasionReminderDto> saveOccasion(
    Map<String, Object?> fields, {
    String? id,
  }) {
    final body = OccasionReminderInputDto.fromJson(fields);
    return guardApi(
      () => id == null
          ? _api.me.occasionsControllerCreate(body: body)
          : _api.me.occasionsControllerUpdate(id: id, body: body),
    );
  }

  Future<void> deleteOccasion(String id) =>
      guardApi(() => _api.me.occasionsControllerRemove(id: id));

  // ---------- FR-ACC-08 ----------

  Future<Map<String, Object?>> exportData() async =>
      (await guardApi(_api.me.meControllerExportData)).toJson();

  Future<void> deleteAccount() => guardApi(_api.me.meControllerRemove);
}

/// The spec a saved design keeps, as the designer reads it.
Map<String, Object?> designSpec(SavedDesignDto design) =>
    Map<String, Object?>.from(design.toJson()['spec']! as Map);
