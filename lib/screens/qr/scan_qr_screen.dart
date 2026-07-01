import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE3350D),
        title: const Text("Scan QR", style: TextStyle(color: Colors.white)),
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (scanned) return;

          final barcode = capture.barcodes.first;

          final uid = barcode.rawValue;

          if (uid == null) return;

          scanned = true;

          Navigator.pop(context, uid);
        },
      ),
    );
  }
}
