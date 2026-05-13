import 'package:clock_app/alarm/types/protection_requirement.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProtectionRuntime {
  static const String alarmActiveKey = 'alarm_active';
  static const String activeAlarmIdKey = 'protection_active_alarm_id';
  static const String activeAlarmTasksKey = 'protection_active_alarm_tasks';
  static const String activeSinceKey = 'protection_active_since';
  static const String activePowerOffKey = 'protection_active_power_off';
  static const String activeAdminKey = 'protection_active_admin';

  static Future<void> activateForAlarm({
    required int scheduleId,
    required bool tasksActive,
    ProtectionRequirement requirement = ProtectionRequirement.none,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setBool(alarmActiveKey, true),
      prefs.setInt(activeAlarmIdKey, scheduleId),
      prefs.setBool(activeAlarmTasksKey, tasksActive),
      prefs.setBool(activePowerOffKey, requirement.requiresPowerOffProtection),
      prefs.setBool(
        activeAdminKey,
        requirement.requiresForceStopUninstallProtection,
      ),
      prefs.setInt(activeSinceKey, DateTime.now().millisecondsSinceEpoch),
    ]);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setBool(alarmActiveKey, false),
      prefs.remove(activeAlarmIdKey),
      prefs.remove(activeAlarmTasksKey),
      prefs.remove(activePowerOffKey),
      prefs.remove(activeAdminKey),
      prefs.remove(activeSinceKey),
    ]);
  }
}
