import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';

const String protectionPowerOffPreferenceKey =
    'protection_power_off_enabled';
const String protectionAdminPreferenceKey =
    'protection_admin_enabled';
const String protectionAccessibilityPreferenceKey =
    'protection_accessibility_enabled';

final SwitchSetting powerOffProtectionSetting = SwitchSetting(
  "Power Off Protection Enabled",
  (context) => "Power off protection",
  false,
  getDescription: (context) => "Blocks the power off dialog during an alarm.",
  isVisual: false,
);

final SwitchSetting forceStopUninstallProtectionSetting = SwitchSetting(
  "Force Stop And Uninstall Protection Enabled",
  (context) => "Force stop and uninstall protection",
  false,
  getDescription: (context) =>
      "Uses Device Admin and Accessibility permissions to make force stop and uninstall attempts harder during an alarm.",
  isVisual: false,
);

final SwitchSetting showProtectionOnboardingAgainSetting = SwitchSetting(
  "Show Advanced Protection Onboarding Again",
  (context) => "Show protection onboarding again",
  false,
  getDescription: (context) =>
      "Shows the advanced CAPTCHA protection education flow again.",
  isVisual: false,
);

List<SwitchSetting> protectionPreferenceSettings = [
  powerOffProtectionSetting,
  forceStopUninstallProtectionSetting,
  showProtectionOnboardingAgainSetting,
];
