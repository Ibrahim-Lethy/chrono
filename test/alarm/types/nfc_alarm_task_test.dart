import 'package:clock_app/alarm/data/alarm_task_schemas.dart';
import 'package:clock_app/alarm/types/alarm_task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('nfc alarm task schema is registered', () {
    expect(alarmTaskSchemasMap, contains(AlarmTaskType.nfc));

    final task = AlarmTask(AlarmTaskType.nfc);

    expect(task.settings.getSetting("Expected NFC Tag").value, "");
  });
}
