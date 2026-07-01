import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/wallet_service.dart';
import '../../services/authenticator_service.dart';

class PaymentScreen extends StatefulWidget {
  final int amount;

  const PaymentScreen({super.key, required this.amount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Menampilkan dialog untuk memasukkan kode Google Authenticator
  Future<String?> _showAuthenticatorDialog() async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text("Verifikasi Authenticator"),
          // Input kode autentikasi 6 digit
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(
              hintText: "Masukkan 6 digit kode",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, controller.text.trim());
              },
              child: const Text("Verifikasi"),
            ),
          ],
        );
      },
    );
  }

  // Status loading selama proses pembayaran berlangsung
  bool loading = false;
  // Proses pembayaran menggunakan saldo wallet
  Future<void> pay() async {
    setState(() {
      loading = true;
    });
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // Minta kode Authenticator
    final code = await _showAuthenticatorDialog();

    if (code == null) {
      setState(() {
        loading = false;
      });
      return;
    }

    // Mengambil secret Authenticator milik pengguna dari Firestore
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    final secret = userDoc.data()?['totpSecret'];
    // Memverifikasi kode Authenticator yang dimasukkan pengguna
    if (secret == null ||
        !AuthenticatorService.verifyCode(secret: secret, code: code)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kode Authenticator salah")),
        );
      }

      setState(() {
        loading = false;
      });

      return;
    }

    try {
      // Mengambil data saldo wallet pengguna
      final wallet = await FirebaseFirestore.instance
          .collection('wallets')
          .doc(uid)
          .get();

      final balance = wallet.data()?['balance'] ?? 0;
      // Memastikan saldo mencukupi untuk melakukan pembayaran
      if (balance < widget.amount) {
        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Saldo tidak cukup")));

        setState(() {
          loading = false;
        });

        return;
      }

      await WalletService().payOrder(
        orderId: DateTime.now().millisecondsSinceEpoch.toString(),
        amount: widget.amount,
      );

      await FirebaseFirestore.instance.collection("wallet_transactions").add({
        "uid": uid,
        "amount": widget.amount,
        "type": "payment",
        "createdAt": Timestamp.now(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pembayaran berhasil")));

      final uri = Uri.parse("pokemonmarket://payment-success");

      await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokemon Payment"),
        backgroundColor: const Color(0xFFE3350D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            const Icon(
              Icons.account_balance_wallet,
              size: 80,
              color: Color(0xFFE3350D),
            ),

            const SizedBox(height: 20),

            const Text(
              "Pokemon Marketplace",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text("Total Pembayaran"),

            const SizedBox(height: 20),

            Text(
              "Rp ${widget.amount}",
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE3350D),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: loading ? null : pay,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("BAYAR", style: TextStyle(fontSize: 18)),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
