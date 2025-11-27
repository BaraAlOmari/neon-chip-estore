import 'package:flagsmith/flagsmith.dart';

/// Simple Flagsmith wrapper for the Flutter app.
/// Use a client-side key passed via --dart-define=FLAGSMITH_CLIENT_KEY=... .
class FeatureFlags {
  static final FeatureFlags instance = FeatureFlags._();
  FeatureFlags._();

  FlagsmithClient? _client;
  bool _ready = false;
  Map<String, Flag> _flags = {};

  Future<void> init() async {
    // Read from dart-define: --dart-define=FLAGSMITH_CLIENT_KEY=...
    final key = const String.fromEnvironment('FLAGSMITH_CLIENT_KEY');
    if (key.isEmpty) {
      // No key provided: fall back to local defaults so the UI keeps working.
      _flags = {
        'card': Flag.seed('card', enabled: true),
        'paypal': Flag.seed('paypal', enabled: true),
        'cash': Flag.seed('cash', enabled: true),
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
