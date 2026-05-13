import 'package:clock_app/settings/data/protection_settings_schema.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProtectionPreferences {
  static Future<void> syncSettingsToNative() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setBool(
        protectionPowerOffPreferenceKey,
        powerOffProtectionSetting.value,
      ),
      prefs.setBool(
        protectionAdminPreferenceKey,
        forceStopUninstallProtectionSetting.value,
      ),
      prefs.setBool(
        protectionAccessibilityPreferenceKey,
        powerOffProtectionSetting.value ||
            forceStopUninstallProtectionSetting.value,
      ),
    ]);
  }

  static Future<void> setPowerOffProtectionEnabled(bool enabled) async {
    powerOffProtectionSetting.setValueWithoutNotify(enabled);
    await syncSettingsToNative();
  }

  static Future<void> setForceStopUninstallProtectionEnabled(
      bool enabled) async {
    forceStopUninstallProtectionSetting.setValueWithoutNotify(enabled);
    await syncSettingsToNative();
  }

  static bool get isPowerOffProtectionEnabled =>
      powerOffProtectionSetting.value;

  static bool get isForceStopUninstallProtectionEnabled =>
      forceStopUninstallProtectionSetting.value;
}
