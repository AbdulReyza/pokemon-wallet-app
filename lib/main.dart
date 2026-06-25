import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'screens/login/login_screen.dart';
import 'screens/home/home_wallet_screen.dart';
// import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await NotificationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pokemon Wallet',
        theme: ThemeData(
          primaryColor: const Color(0xFFE3350D),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE3350D)),
          useMaterial3: true,
        ),

        home: const LoginScreen(),

        routes: {
          '/login': (_) => const LoginScreen(),
          '/home': (_) => const HomeWalletScreen(),
        },
      ),
    );
  }
}
