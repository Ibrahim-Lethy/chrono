import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/navigation/widgets/app_top_bar.dart';
import 'package:clock_app/system/native_features_service.dart';
import 'package:flutter/material.dart';

class ProtectionScreen extends StatefulWidget {
  const ProtectionScreen({super.key});

  @override
  State<ProtectionScreen> createState() => _ProtectionScreenState();
}

class _ProtectionScreenState extends State<ProtectionScreen> with WidgetsBindingObserver {
  bool _isDeviceAdminActive = false;
  bool _isAccessibilityEnabled = false;

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
    setState(() {
      _isDeviceAdminActive = adminActive;
      _isAccessibilityEnabled = accessibilityEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(
        title: "Protection",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              CardContainer(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Device Admin",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text("Prevents uninstallation and force-stopping the app."),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Status: ${_isDeviceAdminActive ? "Active" : "Disabled"}"),
                          ElevatedButton(
                            onPressed: () async {
                              if (_isDeviceAdminActive) {
                                await NativeFeaturesService.removeDeviceAdmin();
                              } else {
                                await NativeFeaturesService.requestDeviceAdmin();
                              }
                              await Future.delayed(const Duration(milliseconds: 500));
                              _checkStatuses();
                            },
                            child: Text(_isDeviceAdminActive ? "Deactivate" : "Activate Device Admin"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CardContainer(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Accessibility Service",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text("Prevents the device from being powered off while the alarm is ringing."),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Status: ${_isAccessibilityEnabled ? "Enabled" : "Disabled"}"),
                          ElevatedButton(
                            onPressed: () async {
                              await NativeFeaturesService.openAccessibilitySettings();
                            },
                            child: const Text("Open Settings"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
