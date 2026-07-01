import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthVerificationScreen extends StatefulWidget {
  const AuthVerificationScreen({super.key});

  @override
  State<AuthVerificationScreen> createState() => _AuthVerificationScreenState();
}

class _AuthVerificationScreenState extends State<AuthVerificationScreen> {
  // Controller untuk input kode OTP
  final pinController = TextEditingController();

  // Status loading dan countdown masa berlaku OTP
  bool loading = false;
  int seconds = 300;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // Memulai timer countdown OTP
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      setState(() {
        if (seconds > 0) {
          seconds--;
        }
      });
    });
  }

  @override
  void dispose() {
    // Membersihkan resource saat halaman ditutup
    timer?.cancel();
    pinController.dispose();
    super.dispose();
  }

  // Memvalidasi kode OTP yang dimasukkan pengguna
  Future<void> verify() async {
    setState(() => loading = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // Mengambil data OTP dari Firestore
      final doc = await FirebaseFirestore.instance
          .collection('otp_codes')
          .doc(uid)
          .get();

      if (!doc.exists) {
        throw Exception("OTP tidak ditemukan");
      }

      final data = doc.data()!;
      final savedOtp = data['otp'];
      final expiresAt = (data['expiresAt'] as Timestamp).toDate();

      // Memastikan OTP belum kedaluwarsa
      if (DateTime.now().isAfter(expiresAt)) {
        throw Exception("OTP sudah expired");
      }

      // Mencocokkan OTP yang diinput dengan data di database
      if (pinController.text.trim() == savedOtp) {
        Navigator.pop(context, true);
      } else {
        throw Exception("Kode OTP salah");
      }
    } catch (e) {
      // Menampilkan pesan error jika verifikasi gagal
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    if (mounted) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Tampilan halaman verifikasi OTP
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
                  // Header halaman verifikasi
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: const [
                        Icon(
                          Icons.security,
                          color: Colors.greenAccent,
                          size: 60,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Email Verification",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "OTP Verification",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Masukkan kode OTP 6 digit yang telah dikirim ke email Anda.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 20),

                  // Input kode OTP
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
                    decoration: const InputDecoration(
                      counterText: "",
                      hintText: "••••••",
                      filled: true,
                      fillColor: Color(0xFFF2F2F2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Tombol untuk memulai proses verifikasi OTP
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: loading ? null : verify,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE3350D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "VERIFY",
                              style: TextStyle(color: Colors.white),
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
