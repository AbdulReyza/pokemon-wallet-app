import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  Future<void> sendOtp({required String email, required String otp}) async {
    final response = await http.post(
      Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'service_id': 'service_55vqect',
        'template_id': 'template_x8fc706',
        'user_id': 'wC-lCh6sb90jUwDCT',
        'accessToken': 'IIXa7xxJ66Ggw3IzR8OW5',
        'template_params': {'to_email': email, 'otp': otp},
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal mengirim OTP. Status: ${response.statusCode}");
    }
  }
}
