import 'package:clock_app/alarm/logic/nfc_tag_id.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcSetupWidget extends StatefulWidget {
  const NfcSetupWidget({super.key, required this.setting});

  final StringSetting setting;

  @override
  State<NfcSetupWidget> createState() => _NfcSetupWidgetState();
}

class _NfcSetupWidgetState extends State<NfcSetupWidget> {
  bool _isScanning = false;

  @override
  void dispose() {
    if (_isScanning) {
      NfcManager.instance.stopSession();
    }
    super.dispose();
  }

  Future<void> _scan() async {
    final messenger = ScaffoldMessenger.of(context);
    final available = await NfcManager.instance.isAvailable();
    if (!available) {
      messenger.showSnackBar(
        const SnackBar(content: Text("NFC is not available or is disabled.")),
      );
      return;
    }

    setState(() => _isScanning = true);
    await NfcManager.instance.startSession(
      onDiscovered: (tag) async {
        final tagId = getNfcTagId(tag);
        await NfcManager.instance.stopSession(
          alertMessage: tagId == null ? null : "NFC tag saved",
          errorMessage: tagId == null ? "Could not read this NFC tag" : null,
        );
        if (!mounted) return;
        setState(() => _isScanning = false);
        if (tagId == null) {
          messenger.showSnackBar(
            const SnackBar(content: Text("Could not read this NFC tag.")),
          );
          return;
        }
        widget.setting.setValue(context, tagId);
        messenger.showSnackBar(
          const SnackBar(content: Text("NFC tag saved.")),
        );
      },
      onError: (error) async {
        if (!mounted) return;
        setState(() => _isScanning = false);
        messenger.showSnackBar(SnackBar(content: Text(error.message)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final saved = widget.setting.value.toString().isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: FilledButton.icon(
        onPressed: _isScanning ? null : _scan,
        icon: const Icon(Icons.nfc),
        label: Text(_isScanning
            ? "Waiting for NFC tag..."
            : saved
                ? "Scan a different NFC tag"
                : "Scan NFC tag to save"),
      ),
    );
  }
}
