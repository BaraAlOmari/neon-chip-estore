package com.udst.neon_chip_estore.flag;

import com.flagsmith.FlagsmithClient;
import com.flagsmith.config.FlagsmithConfig;
import com.flagsmith.exceptions.FlagsmithClientError;
import com.flagsmith.models.Flags;

public final class FeatureFlags {

  // --- SIMPLE CONSTANTS (edit these) ----------------------------------------
  private static final String API_KEY = "GA7Dvqj7Zhxe9ovGU3pNuJ"; // <— your Flagsmith Environment Key
  // If you are self-hosted, set your base URL (e.g., "https://flags.mycorp.com/api/v1/").
  // Leave it null or empty for hosted Flagsmith.
  private static final String API_URL = null;
  // --------------------------------------------------------------------------

  private static volatile FlagsmithClient client;

  private FeatureFlags() {}

  /** Minimal: returns true if the feature is enabled (false if disabled or unknown). */
  public static boolean isEnabledFeature(String featureName) {
    if (featureName == null || featureName.isBlank())
      throw new IllegalArgumentException("featureName is blank");
    ensureClient();
    try {
      Flags env = client.getEnvironmentFlags();
      Boolean v = env.isFeatureEnabled(featureName);   // may be null for unknown feature
      return Boolean.TRUE.equals(v);
    } catch (FlagsmithClientError e) {
      throw new RuntimeException("Flagsmith error for '" + featureName + "'", e);
    }
  }

  /** Minimal: returns the raw feature value (String/Number/Boolean/JSON) or null. */
  public static Object getFeatureValue(String featureName) {
    if (featureName == null || featureName.isBlank())
      throw new IllegalArgumentException("featureName is blank");
    ensureClient();
    try {
      Flags env = client.getEnvironmentFlags();
      return env.getFeatureValue(featureName);         // may return null
    } catch (FlagsmithClientError e) {
      throw new RuntimeException("Flagsmith error for '" + featureName + "'", e);
    }
  }

  // --- internals ------------------------------------------------------------

  private static void ensureClient() {
    if (client != null) return;
    synchronized (FeatureFlags.class) {
      if (client != null) return;

      if (API_KEY == null || API_KEY.isBlank()) {
        throw new IllegalStateException("API_KEY is not set in FeatureFlags");
      }

      FlagsmithClient.Builder b = FlagsmithClient.newBuilder().setApiKey(API_KEY);
      if (API_URL != null && !API_URL.isBlank()) {
        b = b.withConfiguration(
              FlagsmithConfig.newBuilder()
                .baseUri(API_URL) // e.g., "https://flags.mycorp.com/api/v1/"
                .build()
            );
      }
      client = b.build();
    }
  }
}
