import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:family_market/app/widgets/auth_wrapper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FamilyMarket());
}

class FamilyMarket extends StatelessWidget {
  const FamilyMarket({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Family Market',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const AuthWrapper(),
    );
  }
}
