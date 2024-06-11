import 'package:dahlah/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBoIYDznf-OuAFQy8F1ZJkaToS2kVoLg0w",
        appId: "catcation-auth",
        messagingSenderId: "562408995849",
        projectId: "catcation-auth",
        storageBucket: "gs://catcation-auth.appspot.com",
      ),
    );
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CatCation',
      theme: ThemeData(
        primaryColor: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.orange),
        ),
      ),
      home: WelcomePage(),
    );
  }
}
