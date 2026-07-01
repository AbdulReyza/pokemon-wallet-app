import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SetupAuthenticatorScreen extends StatelessWidget {
  // Data email dan secret key untuk konfigurasi Authenticator
  final String email;
  final String secret;

  const SetupAuthenticatorScreen({
    super.key,
    required this.email,
    required this.secret,
  });

  @override
  Widget build(BuildContext context) {
    // Membuat URL OTP yang akan dibaca oleh aplikasi Authenticator
    final otpUrl =
        "otpauth://totp/PokemonMarketplace:$email"
        "?secret=$secret"
        "&issuer=PokemonMarketplace";

    return Scaffold(
      appBar: AppBar(title: const Text("Setup Authenticator")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Instruksi kepada pengguna untuk melakukan scan QR Code
            const Text(
              "Scan QR ini menggunakan Google Authenticator",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Menampilkan QR Code yang berisi data konfigurasi OTP
            QrImageView(data: otpUrl, size: 250),

            const SizedBox(height: 24),

            // Menampilkan secret key sebagai alternatif jika QR gagal dipindai
            SelectableText(secret, textAlign: TextAlign.center),

            const Spacer(),

            // Tombol untuk kembali setelah proses scan selesai
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Saya Sudah Scan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
