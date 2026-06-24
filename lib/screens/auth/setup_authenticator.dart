import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SetupAuthenticatorScreen extends StatelessWidget {
  final String email;
  final String secret;

  const SetupAuthenticatorScreen({
    super.key,
    required this.email,
    required this.secret,
  });

  @override
  Widget build(BuildContext context) {
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
            const Text(
              "Scan QR ini menggunakan Google Authenticator",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            QrImageView(data: otpUrl, size: 250),

            const SizedBox(height: 24),

            SelectableText(secret, textAlign: TextAlign.center),

            const Spacer(),

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
