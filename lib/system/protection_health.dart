import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/alarm_task.dart';
import 'package:clock_app/alarm/types/protection_requirement.dart';
import 'package:clock_app/settings/data/protection_settings_schema.dart';
import 'package:clock_app/system/native_features_service.dart';
import 'package:flutter/material.dart';

enum ProtectionHealthAction {
  openProtectionSettings,
  configureQrTask,
}

class ProtectionHealthIssue {
  const ProtectionHealthIssue({
    required this.title,
    required this.description,
    required this.action,
  });

  final String title;
  final String description;
  final ProtectionHealthAction action;
}

class ProtectionHealth {
  static List<ProtectionHealthIssue> getStaticIssues(Alarm alarm) {
    final requirement = alarm.protectionRequirement;
    final issues = <ProtectionHealthIssue>[];

    if (requirement.requiresPowerOffProtection &&
        !powerOffProtectionSetting.value) {
      issues.add(const ProtectionHealthIssue(
        title: "Power-off protection is off",
        description:
            "This alarm requires power-off protection, but the global protection toggle is disabled.",
        action: ProtectionHealthAction.openProtectionSettings,
      ));
    }

    if (requirement.requiresForceStopUninstallProtection &&
        !forceStopUninstallProtectionSetting.value) {
      issues.add(const ProtectionHealthIssue(
        title: "Force stop protection is off",
        description:
            "This alarm requires force-stop/uninstall protection, but the global protection toggle is disabled.",
        action: ProtectionHealthAction.openProtectionSettings,
      ));
    }

    if (_hasEmptyQrTask(alarm)) {
      issues.add(const ProtectionHealthIssue(
        title: "QR task has no saved code",
        description:
            "Scan and save the QR code you want to require before relying on this alarm.",
        action: ProtectionHealthAction.configureQrTask,
      ));
    }

    return issues;
  }

  static Future<List<ProtectionHealthIssue>> getIssues(Alarm alarm) async {
    final issues = getStaticIssues(alarm);
    final requirement = alarm.protectionRequirement;

    if (requirement.requiresForceStopUninstallProtection &&
        !await NativeFeaturesService.isDeviceAdminActive()) {
      issues.add(const ProtectionHealthIssue(
        title: "Device Admin is inactive",
        description:
            "This alarm requires uninstall/deactivation friction. Enable Device Admin before sleeping.",
        action: ProtectionHealthAction.openProtectionSettings,
      ));
    }

    if (requirement.requiresAccessibility &&
        !await NativeFeaturesService.isAccessibilityServiceEnabled()) {
      issues.add(const ProtectionHealthIssue(
        title: "Accessibility Service is disabled",
        description:
            "This alarm requires Accessibility protection to block common escape screens.",
        action: ProtectionHealthAction.openProtectionSettings,
      ));
    }

    return issues;
  }

  static bool _hasEmptyQrTask(Alarm alarm) {
    for (final task in alarm.tasks) {
      if (task.type == AlarmTaskType.qrCode) {
        final value = task.settings.getSetting("Expected QR Content").value;
        if (value is! String || value.trim().isEmpty) return true;
      }
    }
    return false;
  }

  static Widget buildIssueChip(BuildContext context, ProtectionHealthIssue issue) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 6, right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withOpacity(0.55),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_rounded,
              size: 16, color: colorScheme.onErrorContainer),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              issue.title,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onErrorContainer,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
