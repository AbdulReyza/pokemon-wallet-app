import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeWalletScreen extends StatelessWidget {
  const HomeWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFE3350D),
        title: const Text(
          "Pokémon Wallet",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),


           
          );
        },
      ),
    );
  }
}
