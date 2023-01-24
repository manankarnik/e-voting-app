import 'package:flutter/material.dart';
import 'auth.dart';
import 'firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage(this.phoneNumber, {super.key});
  final String phoneNumber;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  String title = 'Home';
  static const TextStyle headingStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  Widget getWidget(homeText) {
    switch (selectedIndex) {
      case 0:
        return Text(
          'Welcome, $homeText',
          style: headingStyle,
        );
      case 1:
        return const Text(
          'Vote',
          style: headingStyle,
        );
      default:
        return const Text(
          'Settings',
          style: headingStyle,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () => signOut(context),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: FutureBuilder(
        future: getUser(widget.phoneNumber),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: double.infinity,
                  ),
                  getWidget(snapshot.data["FullName"])
                ],
              ),
            );
          }
          return const CircularProgressIndicator();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_vote_rounded),
            label: 'Vote',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              setState(() => title = 'Home');
              break;
            case 1:
              setState(() => title = 'Vote');
              break;
            default:
              setState(() => title = 'Settings');
          }
          setState(() => selectedIndex = index);
        },
      ),
    );
  }
}
