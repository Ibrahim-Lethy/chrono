import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/alarm_task.dart';
import 'package:clock_app/alarm/types/protection_requirement.dart';
import 'package:clock_app/settings/data/protection_settings_schema.dart';
import 'package:clock_app/system/protection_health.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    powerOffProtectionSetting.setValueWithoutNotify(false);
    forceStopUninstallProtectionSetting.setValueWithoutNotify(false);
  });

  test('reports disabled global power protection for protected alarm', () {
    final alarm = Alarm.fromJson(null);
    alarm.setSettingWithoutNotify(
      "Protection Requirement",
      ProtectionRequirement.powerOff.index,
    );

    final issues = ProtectionHealth.getStaticIssues(alarm);

    expect(issues.map((issue) => issue.title),
        contains("Power-off protection is off"));
  });

  test('reports empty QR task content', () {
    final alarm = Alarm.fromJson(null);
    alarm.setSettingWithoutNotify("Tasks", [AlarmTask(AlarmTaskType.qrCode)]);

    final issues = ProtectionHealth.getStaticIssues(alarm);

    expect(issues.map((issue) => issue.title),
        contains("QR task has no saved code"));
  });
}
