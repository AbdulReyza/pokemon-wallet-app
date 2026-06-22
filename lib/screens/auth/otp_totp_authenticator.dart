import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class AuthVerificationScreen extends StatefulWidget {
  const AuthVerificationScreen({super.key});

  @override
  State<AuthVerificationScreen> createState() => _AuthVerificationScreenState();
}

class _AuthVerificationScreenState extends State<AuthVerificationScreen> {
  final pinController = TextEditingController();

  bool loading = false;
  int seconds = 30;
  Timer? timer;

  String currentCode = "";

  void generateCode() {
    final random = Random();

    currentCode = (100000 + random.nextInt(900000)).toString();
  }

  @override
  void initState() {
    super.initState();

    generateCode();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          seconds = 30;
          generateCode();
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    pinController.dispose();
    super.dispose();
  }

  void verify() async {
    setState(() => loading = true);

    await Future.delayed(const Duration(milliseconds: 500));

    if (pinController.text.trim() == currentCode) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Authenticator code salah")));
    }

    if (mounted) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3350D), Color(0xFF3B82F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// AUTHENTICATOR CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.shield,
                          color: Colors.greenAccent,
                          size: 50,
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Google Authenticator",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        /// OTP YANG DIGENERATE
                        Text(
                          currentCode,
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 8,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Expires in ${seconds}s",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Authenticator Verification",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Masukkan kode dari Google Authenticator",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.verified_user, color: Colors.green),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Two-Factor Authentication Enabled",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// INPUT OTP
                  TextField(
                    controller: pinController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 6,
                    style: const TextStyle(
                      letterSpacing: 8,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: currentCode,
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// VERIFY BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE3350D), Color(0xFF3B82F6)],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: loading ? null : verify,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "VERIFY",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
