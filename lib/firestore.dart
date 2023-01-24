import 'package:cloud_firestore/cloud_firestore.dart';

Future addUser(name, phoneNumber) async {
  final dbCollection = FirebaseFirestore.instance.collection('Users');
  await dbCollection
      .doc(phoneNumber)
      .set({'FullName': name, 'PhoneNumber': phoneNumber});
}

Future getUser(phoneNumber) async {
  final docRef =
      FirebaseFirestore.instance.collection('Users').doc(phoneNumber);

  Map<String, dynamic>? data;
  await docRef.get().then(
    (DocumentSnapshot doc) {
      if (!doc.exists) return null;
      data = doc.data() as Map<String, dynamic>;
    },
    onError: (e) => print('Error: $e'),
  );
  return data;
}

Future getVotePercent() async {
  final collRef = FirebaseFirestore.instance.collection('Parties');
  List<int> votes = [];
  for (var i = 1; i <= 4; i++) {
    final docRef = collRef.doc(i.toString());
    Map<String, dynamic>? data;
    await docRef.get().then(
      (DocumentSnapshot doc) {
        if (!doc.exists) return null;
        data = doc.data() as Map<String, dynamic>;
        votes.add(data?['Votes']);
      },
      onError: (e) => print('Error: $e'),
    );
  }
  return votes.map((e) => (e / votes.reduce((a, b) => a + b) * 100)).toList();
}
