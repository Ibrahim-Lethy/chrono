import 'package:clock_app/settings/types/setting.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrSetupWidget extends StatelessWidget {
  final StringSetting setting;

  const QrSetupWidget({super.key, required this.setting});

  void _openScanner(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Scan QR Code",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: MobileScanner(
                  onDetect: (BarcodeCapture capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                      String value = barcodes.first.rawValue!;
                      setting.setValue(context, value);
                      
                      String displayValue = value.length > 20 
                        ? "${value.substring(0, 20)}..." 
                        : value;
                        
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("QR code saved: $displayValue")),
                      );
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ElevatedButton.icon(
        onPressed: () => _openScanner(context),
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text("Tap to scan QR code to save"),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }
}
