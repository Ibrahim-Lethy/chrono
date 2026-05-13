import 'package:clock_app/alarm/logic/nfc_tag_id.dart';
import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcTask extends StatefulWidget {
  const NfcTask({
    super.key,
    required this.onSolve,
    required this.settings,
  });

  final VoidCallback onSolve;
  final SettingGroup settings;

  @override
  State<NfcTask> createState() => _NfcTaskState();
}

class _NfcTaskState extends State<NfcTask> {
  late final String _expectedTagId;
  bool _isAvailable = false;
  bool _isSolved = false;
  bool _isScanning = false;
  String? _status;

  @override
  void initState() {
    super.initState();
    _expectedTagId = widget.settings.getSetting("Expected NFC Tag").value;
    _start();
  }

  @override
  void dispose() {
    if (_isScanning) {
      NfcManager.instance.stopSession();
    }
    super.dispose();
  }

  Future<void> _start() async {
    final available = await NfcManager.instance.isAvailable();
    if (!mounted) return;
    setState(() {
      _isAvailable = available;
      _status = available
          ? "Hold the saved NFC tag near your phone."
          : "NFC is not available or is disabled on this device.";
    });
    if (available && _expectedTagId.isNotEmpty) {
      await _startSession();
    }
  }

  Future<void> _startSession() async {
    setState(() => _isScanning = true);
    await NfcManager.instance.startSession(
      onDiscovered: (tag) async {
        if (_isSolved) return;
        final tagId = getNfcTagId(tag);
        if (tagId == _expectedTagId) {
          _isSolved = true;
          await NfcManager.instance.stopSession(alertMessage: "NFC tag matched");
          if (!mounted) return;
          widget.onSolve();
        } else if (mounted) {
          setState(() {
            _status = "Wrong NFC tag. Try the saved tag.";
          });
        }
      },
      onError: (error) async {
        if (!mounted) return;
        setState(() {
          _isScanning = false;
          _status = error.message;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text("Scan the NFC tag", style: textTheme.headlineMedium),
          const SizedBox(height: 16),
          CardContainer(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.nfc,
                    size: 96,
                    color: _isAvailable ? null : Theme.of(context).disabledColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _expectedTagId.isEmpty
                        ? "No NFC tag has been saved for this task."
                        : (_status ?? "Waiting for NFC tag."),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
