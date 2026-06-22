import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  Future<void> sendOtp({required String email, required String otp}) async {
    await http.post(
      Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'service_id': 'service_55vqect',
        'template_id': 'template_x8fc706',
        'user_id': 'wC-lCh6sb90jUwDCT',
        'template_params': {'to_email': email, 'otp': otp},
      }),
    );
  }
}
