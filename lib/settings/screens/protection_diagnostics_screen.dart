import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/settings/data/protection_settings_schema.dart';
import 'package:clock_app/system/native_features_service.dart';
import 'package:clock_app/system/protection_escape_log.dart';
import 'package:clock_app/system/protection_runtime.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProtectionDiagnosticsScreen extends StatefulWidget {
  const ProtectionDiagnosticsScreen({super.key});

  @override
  State<ProtectionDiagnosticsScreen> createState() =>
      _ProtectionDiagnosticsScreenState();
}

class _ProtectionDiagnosticsScreenState
    extends State<ProtectionDiagnosticsScreen> with WidgetsBindingObserver {
  bool _deviceAdminActive = false;
  bool _accessibilityEnabled = false;
  bool _alarmActive = false;
  bool _activePowerOff = false;
  bool _activeAdmin = false;
  int? _activeAlarmId;
  List<ProtectionEscapeAttempt> _attempts = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _load();
    }
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final deviceAdminActive = await NativeFeaturesService.isDeviceAdminActive();
    final accessibilityEnabled =
        await NativeFeaturesService.isAccessibilityServiceEnabled();
    final attempts = await ProtectionEscapeLog.loadAttempts();

    if (!mounted) return;
    setState(() {
      _deviceAdminActive = deviceAdminActive;
      _accessibilityEnabled = accessibilityEnabled;
      _alarmActive = prefs.getBool(ProtectionRuntime.alarmActiveKey) ?? false;
      _activePowerOff =
          prefs.getBool(ProtectionRuntime.activePowerOffKey) ?? false;
      _activeAdmin = prefs.getBool(ProtectionRuntime.activeAdminKey) ?? false;
      _activeAlarmId = prefs.getInt(ProtectionRuntime.activeAlarmIdKey);
      _attempts = attempts;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const AppTopBar(title: "Protection diagnostics"),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text("System state", style: textTheme.titleLarge),
            const SizedBox(height: 12),
            _StatusTile(
              title: "Device Admin",
              subtitle: "Required for uninstall/deactivation friction.",
              enabled: _deviceAdminActive,
            ),
            _StatusTile(
              title: "Accessibility Service",
              subtitle: "Required for blocking common escape screens.",
              enabled: _accessibilityEnabled,
            ),
            _StatusTile(
              title: "Power-off protection preference",
              subtitle: "Global user preference.",
              enabled: powerOffProtectionSetting.value,
            ),
            _StatusTile(
              title: "Force-stop/uninstall preference",
              subtitle: "Global user preference.",
              enabled: forceStopUninstallProtectionSetting.value,
            ),
            const SizedBox(height: 20),
            Text("Active alarm state", style: textTheme.titleLarge),
            const SizedBox(height: 12),
            _StatusTile(
              title: "Alarm protection active",
              subtitle: _activeAlarmId == null
                  ? "No active alarm id recorded."
                  : "Active alarm id: $_activeAlarmId",
              enabled: _alarmActive,
            ),
            _StatusTile(
              title: "Active power-off enforcement",
              subtitle: "Set by the ringing alarm's protection requirement.",
              enabled: _activePowerOff,
            ),
            _StatusTile(
              title: "Active force-stop enforcement",
              subtitle: "Set by the ringing alarm's protection requirement.",
              enabled: _activeAdmin,
            ),
            const SizedBox(height: 20),
            Text("Safe test actions", style: textTheme.titleLarge),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: NativeFeaturesService.openAppSettings,
              child: const Text("Open app info settings"),
            ),
            OutlinedButton(
              onPressed: NativeFeaturesService.openAccessibilitySettings,
              child: const Text("Open accessibility settings"),
            ),
            OutlinedButton(
              onPressed: NativeFeaturesService.openDeviceAdminSettings,
              child: const Text("Open device admin/security settings"),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Recent blocked attempts",
                    style: textTheme.titleLarge,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await ProtectionEscapeLog.clear();
                    await _load();
                  },
                  child: const Text("Clear"),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_attempts.isEmpty)
              const Text("No blocked escape attempts recorded.")
            else
              ..._attempts.map((attempt) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.block),
                    title: Text(_formatReason(attempt.reason)),
                    subtitle: Text(
                      "${attempt.timestamp}\n${attempt.packageName} / ${attempt.className}",
                    ),
                    isThreeLine: true,
                  )),
          ],
        ),
      ),
    );
  }

  String _formatReason(String reason) {
    switch (reason) {
      case "power_menu":
        return "Power menu blocked";
      case "settings_escape":
        return "Settings escape blocked";
      default:
        return "Escape attempt blocked";
    }
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({
    required this.title,
    required this.subtitle,
    required this.enabled,
  });

  final String title;
  final String subtitle;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? Colors.green : Theme.of(context).disabledColor;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(enabled ? Icons.check_circle : Icons.cancel, color: color),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
