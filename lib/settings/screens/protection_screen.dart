import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/data/protection_settings_schema.dart';
import 'package:clock_app/settings/screens/protection_diagnostics_screen.dart';
import 'package:clock_app/settings/widgets/protection_illustration.dart';
import 'package:clock_app/system/native_features_service.dart';
import 'package:clock_app/system/protection_preferences.dart';
import 'package:flutter/material.dart';

class ProtectionScreen extends StatefulWidget {
  const ProtectionScreen({super.key});

  @override
  State<ProtectionScreen> createState() => _ProtectionScreenState();
}

class _ProtectionScreenState extends State<ProtectionScreen> with WidgetsBindingObserver {
  bool _isDeviceAdminActive = false;
  bool _isAccessibilityEnabled = false;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkStatuses();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkStatuses();
    }
  }

  Future<void> _checkStatuses() async {
    final adminActive = await NativeFeaturesService.isDeviceAdminActive();
    final accessibilityEnabled = await NativeFeaturesService.isAccessibilityServiceEnabled();
    if (!mounted) return;
    setState(() {
      _isDeviceAdminActive = adminActive;
      _isAccessibilityEnabled = accessibilityEnabled;
    });
  }

  Future<void> _saveProtectionSettings() async {
    await ProtectionPreferences.syncSettingsToNative();
    await powerOffProtectionSetting.parent?.save();
  }

  Future<void> _setPowerOffProtection(bool value) async {
    setState(() {
      _isUpdating = true;
      powerOffProtectionSetting.setValueWithoutNotify(value);
    });
    await _saveProtectionSettings();
    if (value && !_isAccessibilityEnabled) {
      await NativeFeaturesService.openAccessibilitySettings();
    }
    await Future.delayed(const Duration(milliseconds: 500));
    await _checkStatuses();
    if (mounted) {
      setState(() => _isUpdating = false);
    }
  }

  Future<void> _setForceStopUninstallProtection(bool value) async {
    setState(() {
      _isUpdating = true;
      forceStopUninstallProtectionSetting.setValueWithoutNotify(value);
    });
    await _saveProtectionSettings();

    if (value) {
      if (!_isDeviceAdminActive) {
        await NativeFeaturesService.requestDeviceAdmin();
      } else if (!_isAccessibilityEnabled) {
        await NativeFeaturesService.openAccessibilitySettings();
      }
    } else if (_isDeviceAdminActive) {
      await NativeFeaturesService.removeDeviceAdmin();
    }

    await Future.delayed(const Duration(milliseconds: 500));
    await _checkStatuses();
    if (mounted) {
      setState(() => _isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: const AppTopBar(
        title: "CAPTCHA No cheating",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ProtectionIllustration(
                  size: MediaQuery.of(context).size.shortestSide * 0.52,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "CAPTCHA No cheating",
                style: textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                "Use all for maximum protection.",
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.72),
                ),
              ),
              const SizedBox(height: 24),
              _WarningRow(
                text:
                    "These protections add friction during active alarm tasks. Android does not allow regular apps to fully block every force stop or uninstall path.",
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 20),
              _ProtectionToggleRow(
                icon: Icons.power_settings_new,
                title: "Power off protection",
                subtitle: _isAccessibilityEnabled
                    ? "Blocks the power off dialog during an alarm."
                    : "Requires enabling the Accessibility Service.",
                value: powerOffProtectionSetting.value,
                onChanged: _isUpdating ? null : _setPowerOffProtection,
              ),
              const SizedBox(height: 20),
              _ProtectionToggleRow(
                icon: Icons.delete_outline,
                title: "Force stop and uninstall protection",
                subtitle: _protectionStatusText,
                value: forceStopUninstallProtectionSetting.value,
                onChanged:
                    _isUpdating ? null : _setForceStopUninstallProtection,
              ),
              const SizedBox(height: 20),
              _MotivationSection(colorScheme: colorScheme),
              const SizedBox(height: 24),
              CardContainer(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("System status", style: textTheme.titleMedium),
                      const SizedBox(height: 12),
                      _StatusLine(
                        label: "Device Admin",
                        enabled: _isDeviceAdminActive,
                      ),
                      const SizedBox(height: 8),
                      _StatusLine(
                        label: "Accessibility Service",
                        enabled: _isAccessibilityEnabled,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          const ProtectionDiagnosticsScreen(),
                    ),
                  );
                  _checkStatuses();
                },
                icon: const Icon(Icons.health_and_safety_outlined),
                label: const Text("Run protection diagnostics"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _protectionStatusText {
    if (_isDeviceAdminActive && _isAccessibilityEnabled) {
      return "Adds friction to force stop, uninstall, and permission deactivation attempts during an alarm.";
    }
    if (!_isDeviceAdminActive && !_isAccessibilityEnabled) {
      return "Requires Device Admin and Accessibility permissions.";
    }
    if (!_isDeviceAdminActive) {
      return "Requires Device Admin permission for uninstall friction.";
    }
    return "Requires Accessibility permission to detect force stop and uninstall attempts.";
  }
}

class _ProtectionToggleRow extends StatelessWidget {
  const _ProtectionToggleRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 32, color: colorScheme.onSurface),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textTheme.titleMedium),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.72),
                ),
              ),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

class _WarningRow extends StatelessWidget {
  const _WarningRow({required this.text, required this.colorScheme});

  final String text;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline, color: colorScheme.onSurface),
        const SizedBox(width: 24),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class _MotivationSection extends StatelessWidget {
  const _MotivationSection({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.attach_money, size: 32, color: colorScheme.onSurface),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Wakeup motivation", style: textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                "Refundable deposits are not implemented in this fork yet.",
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.72),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.label, required this.enabled});

  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? Colors.green : Theme.of(context).disabledColor;
    return Row(
      children: [
        Icon(enabled ? Icons.check_circle : Icons.cancel, color: color),
        const SizedBox(width: 8),
        Text("$label: ${enabled ? "Enabled" : "Disabled"}"),
      ],
    );
  }
}
