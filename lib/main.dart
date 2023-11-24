import 'package:flutter/material.dart';
import 'package:teste/telas/home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Erro ao inicializar o Firebase: $e");
  }

  runApp(
    MaterialApp(
      home: const home(), // Certifique-se de que "home()" é uma classe/widget, não uma função.
      debugShowCheckedModeBanner: false,
    ),
  );
}
