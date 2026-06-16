import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WalletService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  DocumentReference<Map<String, dynamic>> get walletDoc =>
      _firestore.collection('wallets').doc(uid);

  Stream<DocumentSnapshot<Map<String, dynamic>>> getWallet() {
    return walletDoc.snapshots();
  }
}
