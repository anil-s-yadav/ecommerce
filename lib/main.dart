import 'package:flutter/material.dart';
import 'screens/user-panel/main-screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // This is necessary for async code in main()
  await Firebase.initializeApp(); // Initializes Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),    delete it
        useMaterial3: true,
      ),
      home: (const MainScreen()),
    );
  }
}
