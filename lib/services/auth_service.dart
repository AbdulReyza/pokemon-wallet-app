import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Instance Firebase Authentication dan Firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mengambil data pengguna yang sedang login
  User? get currentUser => _auth.currentUser;

  // Memantau perubahan status autentikasi pengguna
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Mengambil data profil pengguna dari Firestore
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final user = _auth.currentUser;

    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();

    return doc.data();
  }

  // Proses registrasi akun baru beserta pembuatan data wallet
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String pin,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    // Menyimpan data profil pengguna
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
    });

    // Membuat wallet baru dengan saldo awal
    await _firestore.collection('wallets').doc(uid).set({
      'name': name,
      'email': email,
      'balance': 0,
      'pin': pin,
      'createdAt': Timestamp.now(),
    });
  }

  // Proses login menggunakan email dan password
  Future<void> login({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Proses logout dari aplikasi
  Future<void> logout() async {
    await _auth.signOut();
  }
}
