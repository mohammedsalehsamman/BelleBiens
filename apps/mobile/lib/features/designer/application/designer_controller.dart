import 'dart:async';
import 'dart:convert';

import 'package:belle_biens/core/api/api_providers.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/catalog/data/catalog_repository.dart';
import 'package:belle_biens/features/designer/data/designer_repository.dart';
import 'package:belle_biens/features/designer/domain/bouquet_spec.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

final designerRepositoryProvider = Provider<DesignerRepository>(
  (ref) => DesignerRepository(
    ref.watch(belleApiProvider),
    ref.watch(jsonCacheProvider),
  ),
);

final designerCatalogProvider = FutureProvider<Cached<DesignerCatalogDto>>(
  (ref) => ref.watch(designerRepositoryProvider).catalog(),
);

/// The four steps (screens 15-18).
enum DesignerStep { occasionAndSize, flowers, wrapAndExtras, cardAndPreview }

/// Everything on the designer screens. The spec is what gets ordered; the
/// recipient's name and the card switch belong to the order, not the spec.
class DesignerState {
  const new({
    required this.spec,
    this.step = DesignerStep.occasionAndSize,
    this.undo = const [],
    this.redo = const [],
    this.recipientName = '',
    this.withCard = true,
  });

  final BouquetSpec spec;
  final DesignerStep step;
  final List<BouquetSpec> undo;
  final List<BouquetSpec> redo;
  final String recipientName;
  final bool withCard;

  bool get canUndo => undo.isNotEmpty;
  bool get canRedo => redo.isNotEmpty;

  DesignerState copyWith({
    BouquetSpec? spec,
    DesignerStep? step,
    List<BouquetSpec>? undo,
    List<BouquetSpec>? redo,
    String? recipientName,
    bool? withCard,
  }) => DesignerState(
    spec: spec ?? this.spec,
    step: step ?? this.step,
    undo: undo ?? this.undo,
    redo: redo ?? this.redo,
    recipientName: recipientName ?? this.recipientName,
    withCard: withCard ?? this.withCard,
  );

  /// What is kept on the phone between visits (FR-DSG-11). History is not.
  Map<String, Object?> toDraft() => {
    'spec': spec.toJson(),
    'step': step.name,
    'recipientName': recipientName,
    'withCard': withCard,
  };
}

/// FR-DSG-10: up to 50 steps back.
const maxHistory = 50;

/// A starting spec: medium size, no occasion, the first wrap and ribbon the
/// shop has today, no flowers yet.
BouquetSpec startingSpec(DesignerCatalogDto catalog, {String? occasion}) {
  String first(DesignerPart part) =>
      catalog.items
          .where(
            (i) => i.type2 == part && (i.available == null || i.available! > 0),
          )
          .firstOrNull
          ?.id ??
      catalog.items.firstWhere((i) => i.type2 == part).id;
  return BouquetSpec(
    occasion: occasion ?? 'none',
    size: 'medium',
    flowers: const [],
    wrap: first(DesignerPart.wrap),
    ribbon: first(DesignerPart.ribbon),
  );
}

class DesignerController extends AsyncNotifier<DesignerState> {
  DesignerRepository get _repo => ref.read(designerRepositoryProvider);

  @override
  Future<DesignerState> build() async {
    // Read, not watch: a catalog refresh must not throw the design away.
    final catalog = (await ref.read(designerCatalogProvider.future)).data;
    final draft = await _repo.readDraft();
    if (draft != null) {
      try {
        return DesignerState(
          spec: BouquetSpec.fromJson(
            Map<String, Object?>.from(draft['spec']! as Map),
          ),
          step:
              DesignerStep.values.asNameMap()[draft['step']] ??
              DesignerStep.occasionAndSize,
          recipientName: (draft['recipientName'] as String?) ?? '',
          withCard: (draft['withCard'] as bool?) ?? true,
        );
      } on Object {
        // A draft from an older app version: start fresh.
      }
    }
    return DesignerState(spec: startingSpec(catalog));
  }

  Future<DesignerState> get _current async => state.value ?? await future;

  void _set(DesignerState next) {
    state = AsyncData(next);
    unawaited(_repo.saveDraft(next.toDraft()));
  }

  /// Applies a change to the spec, keeping the old one for undo.
  Future<void> edit(BouquetSpec Function(BouquetSpec spec) change) async {
    final current = await _current;
    final next = change(current.spec);
    if (next == current.spec) return;
    final undo = [...current.undo, current.spec];
    _set(
      current.copyWith(
        spec: next,
        undo: undo.length > maxHistory
            ? undo.sublist(undo.length - maxHistory)
            : undo,
        redo: const [],
      ),
    );
  }

  Future<void> undo() async {
    final current = await _current;
    if (!current.canUndo) return;
    _set(
      current.copyWith(
        spec: current.undo.last,
        undo: current.undo.sublist(0, current.undo.length - 1),
        redo: [...current.redo, current.spec],
      ),
    );
  }

  Future<void> redo() async {
    final current = await _current;
    if (!current.canRedo) return;
    _set(
      current.copyWith(
        spec: current.redo.last,
        redo: current.redo.sublist(0, current.redo.length - 1),
        undo: [...current.undo, current.spec],
      ),
    );
  }

  /// Starts over; the old design stays one undo away.
  Future<void> restart() async {
    final catalog = (await ref.read(designerCatalogProvider.future)).data;
    await edit((_) => startingSpec(catalog));
    await goTo(DesignerStep.occasionAndSize);
  }

  Future<void> goTo(DesignerStep step) async {
    final current = await _current;
    _set(current.copyWith(step: step));
  }

  /// "خصّصها" on a ready bouquet (FR-CAT-07): its spec becomes the design.
  Future<void> startFrom(Map<String, Object?> template) async {
    final spec = BouquetSpec.fromJson(template);
    await edit((_) => spec);
    await goTo(DesignerStep.flowers);
  }

  /// "صمّم باقة عيد ميلاد" on an occasion page (screen 11).
  Future<void> startForOccasion(String slug) async {
    await edit((spec) => spec.copyWith(occasion: slug));
    await goTo(DesignerStep.occasionAndSize);
  }

  /// The card text is not part of the design (it is left out of the hash),
  /// so typing it does not fill the undo history.
  Future<void> setCardMessage(String? message) async {
    final current = await _current;
    _set(
      current.copyWith(
        spec: current.spec.copyWith(
          cardMessage: () =>
              message == null || message.isEmpty ? null : message,
        ),
      ),
    );
  }

  Future<void> setRecipient(String name) async =>
      _set((await _current).copyWith(recipientName: name));

  Future<void> setWithCard({required bool value}) async =>
      _set((await _current).copyWith(withCard: value));
}

final designerControllerProvider =
    AsyncNotifierProvider<DesignerController, DesignerState>(
      DesignerController.new,
    );

/// The server's price and checks for a spec, 400 ms after the last change
/// (plan 4.4). Keyed by the spec's JSON, so a newer spec simply replaces an
/// older request; null while the design has no flowers yet.
final FutureProviderFamily<DesignerQuoteDto?, String> designerQuoteProvider =
    FutureProvider.autoDispose.family<DesignerQuoteDto?, String>((
      ref,
      specJson,
    ) async {
      // A newer spec disposes this request: the timer stops, nothing is sent.
      final wait = Completer<bool>();
      final timer = Timer(
        const Duration(milliseconds: 400),
        () => wait.complete(true),
      );
      ref.onDispose(() {
        timer.cancel();
        if (!wait.isCompleted) wait.complete(false);
      });
      if (!await wait.future) return null;
      final spec = BouquetSpec.fromJson(
        jsonDecode(specJson) as Map<String, Object?>,
      );
      if (spec.flowers.isEmpty) return null;
      return await ref.read(designerRepositoryProvider).quote(spec);
    });

/// The key [designerQuoteProvider] uses for a spec.
String quoteKey(BouquetSpec spec) => jsonEncode(spec.toJson());
