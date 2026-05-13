import 'package:flutter/material.dart';

enum ProtectionRequirement {
  none,
  powerOff,
  forceStopUninstall,
  all,
}

extension ProtectionRequirementDetails on ProtectionRequirement {
  String displayName(BuildContext context) {
    switch (this) {
      case ProtectionRequirement.none:
        return "None";
      case ProtectionRequirement.powerOff:
        return "Power-off protection";
      case ProtectionRequirement.forceStopUninstall:
        return "Force stop and uninstall protection";
      case ProtectionRequirement.all:
        return "All protections";
    }
  }

  String description(BuildContext context) {
    switch (this) {
      case ProtectionRequirement.none:
        return "This alarm does not require advanced protection.";
      case ProtectionRequirement.powerOff:
        return "Requires power-off protection while this alarm is ringing.";
      case ProtectionRequirement.forceStopUninstall:
        return "Requires Device Admin and Accessibility protection while this alarm is ringing.";
      case ProtectionRequirement.all:
        return "Requires all available no-cheating protections while this alarm is ringing.";
    }
  }

  bool get requiresPowerOffProtection =>
      this == ProtectionRequirement.powerOff || this == ProtectionRequirement.all;

  bool get requiresForceStopUninstallProtection =>
      this == ProtectionRequirement.forceStopUninstall ||
      this == ProtectionRequirement.all;

  bool get requiresAccessibility =>
      requiresPowerOffProtection || requiresForceStopUninstallProtection;

  bool get isProtected => this != ProtectionRequirement.none;
}
