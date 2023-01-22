import 'package:flutter/material.dart';
import 'auth.dart';
import 'firestore.dart';

class HomePage extends StatelessWidget {
  HomePage(this.phoneNumber, {super.key});
  String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => signOut(context),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: getUser(phoneNumber),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('Welcome, ${snapshot.data["FullName"]}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
