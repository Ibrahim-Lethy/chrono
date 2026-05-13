import 'dart:convert';

import 'package:clock_app/system/protection_escape_log.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads escaped attempt records from shared preferences', () async {
    SharedPreferences.setMockInitialValues({
      protectionEscapeAttemptsKey: json.encode([
        {
          'timestamp': 123,
          'reason': 'power_menu',
          'packageName': 'android',
          'className': 'GlobalActions',
          'alarmId': 7,
        }
      ]),
    });

    final attempts = await ProtectionEscapeLog.loadAttempts();

    expect(attempts, hasLength(1));
    expect(attempts.single.reason, 'power_menu');
    expect(attempts.single.alarmId, 7);
  });
}
