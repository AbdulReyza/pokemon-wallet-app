import 'package:flutter/material.dart';
import '../../services/wallet_service.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  // Controller untuk input nominal top up
  final amountController = TextEditingController();
  // Status loading selama proses top up
  bool isLoading = false;
  // Proses menambahkan saldo ke wallet
  Future<void> topUp() async {
    final amount = int.tryParse(amountController.text);
    // Memastikan nominal yang dimasukkan valid
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan nominal yang valid')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await WalletService().topUp(amount);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Top up berhasil')));

        Navigator.pop(context);
      }
      // Menampilkan pesan jika proses top up gagal
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tampilan halaman top up wallet
    return Scaffold(
      appBar: AppBar(title: const Text("Top Up Wallet")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Input nominal saldo yang akan ditambahkan
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nominal',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),
            // Tombol untuk memulai proses top up
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : topUp,
                child: const Text("Top Up"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
