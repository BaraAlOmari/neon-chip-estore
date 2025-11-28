import 'package:flagsmith/flagsmith.dart';

/// Simple Flagsmith wrapper for the Flutter app.
class FeatureFlags {
  static final FeatureFlags instance = FeatureFlags._();
  FeatureFlags._();

  FlagsmithClient? _client;
  bool _ready = false;
  Map<String, Flag> _flags = {};

  Future<void> init() async {
    //FLAGSMITH_CLIENT_KEY
    final key = "GA7Dvqj7Zhxe9ovGU3pNuJ";
    if (key.isEmpty) {
      // No key provided: fall back to local defaults so the UI keeps working.
      _flags = {
        'card': Flag.seed('card', enabled: true),
        'paypal': Flag.seed('paypal', enabled: true),
        'cash': Flag.seed('cash', enabled: true),
        'discount': Flag.seed('discount', enabled: true),
        'cart/order': Flag.seed('cart/order', enabled: true),
      };
      _ready = true;
      return;
    }
    try {
      _client = FlagsmithClient(
        apiKey: key,
        config: const FlagsmithConfig(
          enableAnalytics: true,
        ),
      );
      final flags = await _client!.getFeatureFlags(reload: true);
      _flags = {for (final f in flags) f.feature.name: f};
      _ready = true;
    } catch (_) {
      // On failure, also fall back to local defaults.
      _flags = {
        'card': Flag.seed('card', enabled: true),
        'paypal': Flag.seed('paypal', enabled: true),
        'cash': Flag.seed('cash', enabled: true),
        'discount': Flag.seed('discount', enabled: true),
        'cart/order': Flag.seed('cart/order', enabled: true),
      };
      _ready = true;
    }
  }

  bool isEnabled(String name) {
    if (!_ready) return false;
    return _flags[name]?.enabled ?? false;
  }

  String? getValue(String name) {
    if (!_ready) return null;
    final value = _flags[name]?.stateValue;
    return value;
  }
}
