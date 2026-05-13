import 'package:clock_app/alarm/types/alarm.dart';
import 'package:clock_app/alarm/types/protection_requirement.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('alarm protection requirement defaults to none', () {
    final alarm = Alarm.fromJson(null);

    expect(alarm.protectionRequirement, ProtectionRequirement.none);
  });

  test('alarm protection requirement survives json round trip', () {
    final alarm = Alarm.fromJson(null);
    alarm.setSettingWithoutNotify(
      "Protection Requirement",
      ProtectionRequirement.all.index,
    );

    final decoded = Alarm.fromJson(alarm.toJson());

    expect(decoded.protectionRequirement, ProtectionRequirement.all);
  });
}
