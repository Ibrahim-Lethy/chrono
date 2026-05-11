import 'package:clock_app/settings/types/setting_group.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:clock_app/common/widgets/card_container.dart';

class QrTask extends StatefulWidget {
  final Function() onSolve;
  final SettingGroup settings;

  const QrTask({super.key, required this.onSolve, required this.settings});

  @override
  State<QrTask> createState() => _QrTaskState();
}

class _QrTaskState extends State<QrTask> {
  final MobileScannerController _controller = MobileScannerController();
  late String _expectedQrContent;
  bool _solved = false;

  @override
  void initState() {
    super.initState();
    _expectedQrContent = widget.settings.getSetting("Expected QR Content").value;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_solved) return;
    
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        if (barcode.rawValue == _expectedQrContent) {
          setState(() {
            _solved = true;
          });
          widget.onSolve();
          break;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Wrong QR code"),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextTheme textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Scan the QR Code",
            style: textTheme.headlineMedium,
          ),
          const SizedBox(height: 16.0),
          CardContainer(
            child: SizedBox(
              width: double.infinity,
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
