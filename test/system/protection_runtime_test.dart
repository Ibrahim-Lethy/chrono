import 'package:clock_app/system/protection_runtime.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('activateForAlarm stores active alarm context', () async {
    await ProtectionRuntime.activateForAlarm(
      scheduleId: 42,
      tasksActive: true,
    );

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(ProtectionRuntime.alarmActiveKey), isTrue);
    expect(prefs.getInt(ProtectionRuntime.activeAlarmIdKey), 42);
    expect(prefs.getBool(ProtectionRuntime.activeAlarmTasksKey), isTrue);
    expect(prefs.getInt(ProtectionRuntime.activeSinceKey), isNotNull);
  });

  test('clear disables active state and removes context', () async {
    await ProtectionRuntime.activateForAlarm(
      scheduleId: 42,
      tasksActive: true,
    );

    await ProtectionRuntime.clear();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(ProtectionRuntime.alarmActiveKey), isFalse);
    expect(prefs.getInt(ProtectionRuntime.activeAlarmIdKey), isNull);
    expect(prefs.getBool(ProtectionRuntime.activeAlarmTasksKey), isNull);
    expect(prefs.getInt(ProtectionRuntime.activeSinceKey), isNull);
  });
}
