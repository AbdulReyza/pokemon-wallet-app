import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> login() async {
    try {
      final authProvider = context.read<AuthProvider>();

      // 1. LOGIN FIREBASE AUTH
      await authProvider.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = authProvider.user!.uid;

      // 2. CEK / CREATE WALLET
      final walletDoc = _firestore.collection('wallets').doc(uid);

      final doc = await walletDoc.get();

      if (!doc.exists) {
        await walletDoc.set({
          'email': emailController.text.trim(),
          'balance': 5000000,
          'pin': '123456', // sementara untuk UAS (2FA simulasi)
          'createdAt': Timestamp.now(),
        });
      }

      // 3. LANJUT KE HOME (kalau pakai routing)
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
