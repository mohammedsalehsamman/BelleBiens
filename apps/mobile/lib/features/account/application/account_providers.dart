import 'package:belle_biens/app/locale/app_locale.dart';
import 'package:belle_biens/app/preferences.dart';
import 'package:belle_biens/core/api/api_providers.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/text/digits.dart';
import 'package:belle_biens/features/account/data/account_repository.dart';
import 'package:belle_biens/features/auth/application/session_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => AccountRepository(ref.watch(belleApiProvider)),
);

/// A list only a signed-in customer has; empty for a guest.
FutureProvider<List<T>> _signedInList<T>(
  Future<List<T>> Function(AccountRepository repo) load,
) => FutureProvider.autoDispose<List<T>>((ref) async {
  final session = await ref.watch(sessionControllerProvider.future);
  if (session == null) return <T>[];
  return await load(ref.watch(accountRepositoryProvider));
});

/// Screen 29.
final FutureProvider<List<AddressDto>> myAddressesProvider = _signedInList(
  (repo) => repo.addresses(),
);

/// Screen 30, priced again by the server each time.
final FutureProvider<List<SavedDesignDto>> myDesignsProvider = _signedInList(
  (repo) => repo.designs(),
);

/// Screen 31, soonest first.
final FutureProvider<List<OccasionReminderDto>> myOccasionsProvider =
    _signedInList((repo) => repo.occasions());

/// FR-LOC-02: Western digits by default, Arabic-Indic as a setting. Kept on
/// the phone and, when signed in, on the profile too.
class NumeralsController extends Notifier<Numerals> {
  @override
  Numerals build() => ref.read(appPreferencesProvider).numerals;

  Future<void> select(Numerals value) async {
    state = value;
    await ref.read(appPreferencesProvider).setNumerals(value);
    if (ref.read(sessionControllerProvider).value != null) {
      try {
        final me = await ref.read(accountRepositoryProvider).updateMe({
          'numerals': value.name,
        });
        await ref.read(sessionControllerProvider.notifier).updateUser(me);
      } on Object {
        // Kept on the phone; the profile follows next time.
      }
    }
  }
}

final numeralsProvider = NotifierProvider<NumeralsController, Numerals>(
  NumeralsController.new,
);

/// The digits on screen. The setting is for Arabic: in English the app keeps
/// Western digits, since Arabic-Indic digits inside left-to-right text are
/// reordered ("November 12 · 20:00" would read "٢٠:٠٠ ١٢").
final displayNumeralsProvider = Provider<Numerals>(
  (ref) => ref.watch(appLocaleProvider).languageCode == 'ar'
      ? ref.watch(numeralsProvider)
      : Numerals.western,
);
