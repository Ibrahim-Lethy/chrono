import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const String protectionEscapeAttemptsKey = 'protection_escape_attempts';

class ProtectionEscapeAttempt {
  const ProtectionEscapeAttempt({
    required this.timestamp,
    required this.reason,
    required this.packageName,
    required this.className,
    this.alarmId,
  });

  final DateTime timestamp;
  final String reason;
  final String packageName;
  final String className;
  final int? alarmId;

  factory ProtectionEscapeAttempt.fromJson(Map<String, dynamic> json) {
    return ProtectionEscapeAttempt(
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        (json['timestamp'] as num?)?.toInt() ?? 0,
      ),
      reason: json['reason']?.toString() ?? "unknown",
      packageName: json['packageName']?.toString() ?? "",
      className: json['className']?.toString() ?? "",
      alarmId: (json['alarmId'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.millisecondsSinceEpoch,
        'reason': reason,
        'packageName': packageName,
        'className': className,
        if (alarmId != null) 'alarmId': alarmId,
      };
}

class ProtectionEscapeLog {
  static Future<List<ProtectionEscapeAttempt>> loadAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(protectionEscapeAttemptsKey);
    if (encoded == null || encoded.isEmpty) return [];

    try {
      final decoded = json.decode(encoded);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map>()
          .map((json) =>
              ProtectionEscapeAttempt.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(protectionEscapeAttemptsKey);
  }
}
