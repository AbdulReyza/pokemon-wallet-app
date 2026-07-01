import 'dart:math';
import 'package:otp/otp.dart';

class AuthenticatorService {
  // Membuat secret key untuk konfigurasi Google Authenticator
  static String generateSecret() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

    final random = Random.secure();

    return List.generate(32, (_) => chars[random.nextInt(chars.length)]).join();
  }

  // Memverifikasi kode TOTP yang dimasukkan pengguna
  static bool verifyCode({required String secret, required String code}) {
    final now = DateTime.now();

    // Memberikan toleransi waktu ±30 detik untuk menghindari perbedaan waktu perangkat
    for (int offset = -1; offset <= 1; offset++) {
      final generatedCode = OTP.generateTOTPCodeString(
        secret,
        now.add(Duration(seconds: offset * 30)).millisecondsSinceEpoch,
        interval: 30,
        algorithm: Algorithm.SHA1,
        isGoogle: true,
      );

      // Membandingkan kode yang dihasilkan dengan kode dari pengguna
      if (generatedCode == code) {
        return true;
      }
    }

    // Mengembalikan false jika tidak ada kode yang cocok
    return false;
  }
}
