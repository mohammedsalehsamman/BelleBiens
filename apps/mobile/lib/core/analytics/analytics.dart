import 'package:belle_biens/app/preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// FR-ANL-02: the six moments the shop wants to count.
enum AnalyticsEvent {
  productView('product_view'),
  designerStarted('designer_started'),
  designerCompleted('designer_completed'),
  addToCart('add_to_cart'),
  checkoutStarted('checkout_started'),
  purchase('purchase');

  new(this.wire);

  final String wire;
}

/// Where events go. Firebase Analytics joins with the shop's Firebase
/// project (plan 4.7); until then events go to the debug log.
abstract class AnalyticsSink {
  void log(String name, Map<String, Object> params);
}

class DebugAnalyticsSink implements AnalyticsSink {
  @override
  void log(String name, Map<String, Object> params) {
    if (kDebugMode) debugPrint('analytics $name $params');
  }
}

final analyticsSinkProvider = Provider<AnalyticsSink>(
  (ref) => DebugAnalyticsSink(),
);

/// FR-ANL-01: nothing is recorded until the customer agrees (screen 33).
class AnalyticsConsent extends Notifier<bool> {
  @override
  bool build() => ref.read(appPreferencesProvider).analyticsConsent;

  Future<void> set({required bool value}) async {
    state = value;
    await ref.read(appPreferencesProvider).setAnalyticsConsent(value: value);
  }
}

final analyticsConsentProvider = NotifierProvider<AnalyticsConsent, bool>(
  AnalyticsConsent.new,
);

/// Records an event when the customer agreed; does nothing otherwise.
class Analytics {
  new(this._ref);

  final Ref _ref;

  void log(AnalyticsEvent event, [Map<String, Object> params = const {}]) {
    if (!_ref.read(analyticsConsentProvider)) return;
    _ref.read(analyticsSinkProvider).log(event.wire, params);
  }
}

final analyticsProvider = Provider<Analytics>(Analytics.new);
