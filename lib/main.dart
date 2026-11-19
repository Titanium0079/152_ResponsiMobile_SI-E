import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../models/data.dart';

void main() {
  runApp(const ResepMasakanApp());
}

class ResepMasakanApp extends StatelessWidget {
  const ResepMasakanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resep Masakan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          primary: Colors.green,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: const Color(0xFF1A1C2C),
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F7FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const _AuthGatePage(),
    );
  }
}

class _AuthGatePage extends StatefulWidget {
  const _AuthGatePage();

  @override
  State<_AuthGatePage> createState() => _AuthGatePageState();
}

class _AuthGatePageState extends State<_AuthGatePage> {
  late Future<bool> _loginCheckFuture;

  @override
  void initState() {
    super.initState();
    _loginCheckFuture = AppStorage.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _loginCheckFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data == true) {
          return const HomePage();
        }
        return const LoginPage();
      },
    );
  }
}
