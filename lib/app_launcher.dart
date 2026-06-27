import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'screens/home/home_wallet_screen.dart';
import 'screens/login/login_screen.dart';

class AppLauncher extends StatelessWidget {
  const AppLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return const HomeWalletScreen();
    }

    return const LoginScreen();
  }
}
