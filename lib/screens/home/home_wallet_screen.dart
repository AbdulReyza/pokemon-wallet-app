import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../topup/topup_screen.dart';

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

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('wallets')
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data?.data() as Map<String, dynamic>?;

          final balance = data?['balance'] ?? 0;

          final currency = NumberFormat.currency(
            locale: 'id_ID',
            symbol: 'Rp ',
            decimalDigits: 0,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER TRAINER
                Row(
                  children: [
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFFE3350D),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.black.withOpacity(.08),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.catching_pokemon,
                        color: Color(0xFFE3350D),
                        size: 42,
                      ),
                    ),

                    const SizedBox(width: 16),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Back",
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Pokemon Trainer",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// WALLET CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE3350D), Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                        color: Colors.black.withOpacity(.15),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -20,
                        top: -20,
                        child: Opacity(
                          opacity: .15,
                          child: Icon(
                            Icons.catching_pokemon,
                            size: 130,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "PokéCoin Balance",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            currency.format(balance),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 30),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Trainer Wallet",
                                style: TextStyle(color: Colors.white70),
                              ),
                              Icon(Icons.wallet, color: Colors.white),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                /// QUICK ACTIONS
                const Text(
                  "Quick Actions",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: _ActionCard(
                        icon: Icons.add_circle,
                        title: "Top Up",
                        color: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TopUpScreen(),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _ActionCard(
                        icon: Icons.send,
                        title: "Transfer",
                        color: Colors.blue,
                        onTap: () {},
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _ActionCard(
                        icon: Icons.history,
                        title: "History",
                        color: Colors.orange,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// STAT CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(.05),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _StatItem(title: "Pokémon", value: "12"),
                      _StatItem(title: "Orders", value: "8"),
                      _StatItem(title: "Level", value: "24"),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// RECENT TRANSACTIONS
                const Text(
                  "Recent Transactions",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(.05),
                      ),
                    ],
                  ),
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('wallet_transactions')
                        .where('uid', isEqualTo: uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Firestore Error:\n${snapshot.error}");
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final docs = snapshot.data?.docs ?? [];

                      if (docs.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: Text(
                              "Belum ada transaksi",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: docs.map((doc) {
                          final data = doc.data();

                          final amount = data['amount'] ?? 0;
                          final type = data['type'] ?? 'unknown';

                          String dateText = '-';

                          try {
                            final createdAt = data['createdAt'];

                            if (createdAt is Timestamp) {
                              dateText =
                                  "${createdAt.toDate().day}/${createdAt.toDate().month}/${createdAt.toDate().year}";
                            }
                          } catch (_) {}

                          final isTopup = type == 'topup';

                          return Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,

                                leading: CircleAvatar(
                                  child: Icon(
                                    isTopup ? Icons.add : Icons.shopping_cart,
                                  ),
                                ),

                                title: Text(
                                  isTopup
                                      ? "Top Up Wallet"
                                      : "Pokemon Purchase",
                                ),

                                subtitle: Text(dateText),

                                trailing: Text(
                                  "${isTopup ? '+' : '-'} Rp $amount",
                                  style: TextStyle(
                                    color: isTopup ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              const Divider(),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(.05)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE3350D),
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
