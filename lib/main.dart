import 'package:flutter/material.dart';
import 'registration_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future addUser() async {
  final dbCollection = FirebaseFirestore.instance.collection('Users');
  await dbCollection.add({'Full Name': 'LOL'});
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: RegistrationPage(),
    );
  }
}
