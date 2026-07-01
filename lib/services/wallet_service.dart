import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WalletService {
  // Instance Firestore dan Firebase Authentication
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Proses menambahkan saldo ke wallet
  Future<void> topUp(int amount) async {
    final doc = await walletDoc.get();

    // Membuat wallet baru jika belum tersedia
    if (!doc.exists) {
      await walletDoc.set({'balance': amount});
    } else {
      // Menambahkan saldo ke balance yang sudah ada
      final currentBalance = (doc.data()?['balance'] ?? 0) as int;

      await walletDoc.update({'balance': currentBalance + amount});
    }

    // Menyimpan riwayat transaksi top up
    await _firestore.collection('wallet_transactions').add({
      'uid': uid,
      'amount': amount,
      'type': 'topup',
      'createdAt': Timestamp.now(),
    });
  }

  // Proses pembayaran menggunakan saldo wallet
  Future<void> payOrder({required String orderId, required int amount}) async {
    final wallet = await walletDoc.get();

    final balance = (wallet.data()?['balance'] ?? 0) as int;

    // Memastikan saldo mencukupi sebelum pembayaran dilakukan
    if (balance < amount) {
      throw Exception("Insufficient balance");
    }

    // Mengurangi saldo wallet sesuai nominal pembayaran
    await walletDoc.update({'balance': balance - amount});

    // Menyimpan riwayat transaksi pembayaran
    await _firestore.collection('wallet_transactions').add({
      'uid': uid,
      'orderId': orderId,
      'amount': amount,
      'type': 'payment',
      'createdAt': Timestamp.now(),
    });
  }

  // Mengambil UID pengguna yang sedang login
  String get uid => _auth.currentUser!.uid;

  // Referensi dokumen wallet milik pengguna
  DocumentReference<Map<String, dynamic>> get walletDoc =>
      _firestore.collection('wallets').doc(uid);

  // Mengambil data wallet secara realtime
  Stream<DocumentSnapshot<Map<String, dynamic>>> getWallet() {
    return walletDoc.snapshots();
  }
}
