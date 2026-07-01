import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'screens/login/login_screen.dart';
import 'app_launcher.dart';
import './services/deeplink_service.dart';

void main() async {
  // Memastikan Flutter telah diinisialisasi sebelum menjalankan aplikasi
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Mengaktifkan layanan Deep Link
  await DeepLinkService.instance.init();

  // Menjalankan aplikasi
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Konfigurasi Provider dan aplikasi utama
    return MultiProvider(
      providers: [
        // Menyediakan AuthProvider agar dapat diakses di seluruh aplikasi
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pokemon Wallet',

        // Konfigurasi tema aplikasi
        theme: ThemeData(
          primaryColor: const Color(0xFFE3350D),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE3350D)),
          useMaterial3: true,
        ),

        // Halaman awal aplikasi
        home: const LoginScreen(),

        // Daftar rute navigasi aplikasi
        routes: {
          '/login': (_) => const LoginScreen(),
          '/home': (_) => const AppLauncher(),
        },
      ),
    );
  }
}
