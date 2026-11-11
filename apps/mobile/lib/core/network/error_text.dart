import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/core/network/api_error.dart';

/// The message to show for an error, in the customer's language (NFR-INT-05).
/// The server already localizes its titles from Accept-Language; the app adds
/// the cases where no server answered.
String errorText(AppLocalizations l10n, Object error) {
  if (error is ApiError) {
    if (error.code == ApiError.network) return l10n.errorNetwork;
    if (error.code == ApiError.timeout) return l10n.errorTimeout;
    final title = error.title;
    if (title != null && title.isNotEmpty) return title;
  }
  return l10n.errorGeneric;
}
