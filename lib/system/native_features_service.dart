import 'package:flutter/services.dart';

class NativeFeaturesService {
  static const _channel = MethodChannel('com.vicolo.chrono/alarm');

  static Future<bool> isDeviceAdminActive() async {
    final bool? isActive = await _channel.invokeMethod('isDeviceAdminActive');
    return isActive ?? false;
  }

  static Future<void> requestDeviceAdmin() async {
    await _channel.invokeMethod('requestDeviceAdmin');
  }

  static Future<void> removeDeviceAdmin() async {
    await _channel.invokeMethod('removeDeviceAdmin');
  }

  static Future<bool> isAccessibilityServiceEnabled() async {
    final bool? isEnabled = await _channel.invokeMethod('isAccessibilityServiceEnabled');
    return isEnabled ?? false;
  }

  static Future<void> openAccessibilitySettings() async {
    await _channel.invokeMethod('openAccessibilitySettings');
  }
}
