import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WalletService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> topUp(int amount) async {
    final doc = await walletDoc.get();

    if (!doc.exists) {
      await walletDoc.set({'balance': amount});
    } else {
      final currentBalance = (doc.data()?['balance'] ?? 0) as int;

      await walletDoc.update({'balance': currentBalance + amount});
    }

    await _firestore.collection('wallet_transactions').add({
      'uid': uid,
      'amount': amount,
      'type': 'topup',
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> payOrder({required String orderId, required int amount}) async {
    final wallet = await walletDoc.get();

    final balance = (wallet.data()?['balance'] ?? 0) as int;

    if (balance < amount) {
      throw Exception("Insufficient balance");
    }

    await walletDoc.update({'balance': balance - amount});

    await _firestore.collection('wallet_transactions').add({
      'uid': uid,
      'orderId': orderId,
      'amount': amount,
      'type': 'payment',
      'createdAt': Timestamp.now(),
    });
  }

  String get uid => _auth.currentUser!.uid;

  DocumentReference<Map<String, dynamic>> get walletDoc =>
      _firestore.collection('wallets').doc(uid);

  Stream<DocumentSnapshot<Map<String, dynamic>>> getWallet() {
    return walletDoc.snapshots();
  }
}
