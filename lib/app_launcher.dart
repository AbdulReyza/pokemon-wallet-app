import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'screens/home/home_wallet_screen.dart';
import 'screens/login/login_screen.dart';

class AppLauncher extends StatelessWidget {
  const AppLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengecek apakah pengguna sudah login
    final user = FirebaseAuth.instance.currentUser;
    // Jika sudah login, arahkan ke halaman utama wallet
    if (user != null) {
      return const HomeWalletScreen();
    }
    // Jika belum login, tampilkan halaman login
    return const LoginScreen();
  }
}
