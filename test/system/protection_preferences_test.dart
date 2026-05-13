import 'package:clock_app/settings/data/protection_settings_schema.dart';
import 'package:clock_app/system/protection_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    powerOffProtectionSetting.setValueWithoutNotify(false);
    forceStopUninstallProtectionSetting.setValueWithoutNotify(false);
  });

  test('syncSettingsToNative mirrors disabled settings', () async {
    await ProtectionPreferences.syncSettingsToNative();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(protectionPowerOffPreferenceKey), isFalse);
    expect(prefs.getBool(protectionAdminPreferenceKey), isFalse);
    expect(prefs.getBool(protectionAccessibilityPreferenceKey), isFalse);
  });

  test('syncSettingsToNative enables accessibility for either protection', () async {
    forceStopUninstallProtectionSetting.setValueWithoutNotify(true);

    await ProtectionPreferences.syncSettingsToNative();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(protectionPowerOffPreferenceKey), isFalse);
    expect(prefs.getBool(protectionAdminPreferenceKey), isTrue);
    expect(prefs.getBool(protectionAccessibilityPreferenceKey), isTrue);
  });
}
