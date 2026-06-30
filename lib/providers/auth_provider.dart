import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  // Service yang menangani proses autentikasi (login, register, logout)
  final AuthService _authService = AuthService();

  // Instance Firebase Authentication
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Status loading untuk menampilkan indikator proses
  bool isLoading = false;

  // Menyimpan data user yang sedang login
  User? _user;

  User? get user => _user;

  AuthProvider() {
    // Mengambil user yang masih tersimpan saat aplikasi dibuka
    _user = _firebaseAuth.currentUser;
  }

  // Proses login menggunakan email dan password
  Future<void> login({required String email, required String password}) async {
    isLoading = true;
    notifyListeners();

    try {
      await _authService.login(email: email, password: password);

      // Memperbarui data user setelah login berhasil
      _user = _firebaseAuth.currentUser;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Proses registrasi akun baru
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String pin,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      await _authService.register(
        name: name,
        email: email,
        password: password,
        pin: pin,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Proses logout dan menghapus data user dari provider
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
}
