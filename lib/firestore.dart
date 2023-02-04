import 'package:cloud_firestore/cloud_firestore.dart';

Future addUser(name, phoneNumber) async {
  final dbCollection = FirebaseFirestore.instance.collection('Users');
  await dbCollection
      .doc(phoneNumber)
      .set({'FullName': name, 'PhoneNumber': phoneNumber, 'Voted': false});
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

Future getParties() async {
  final collRef = FirebaseFirestore.instance.collection('Parties');
  List<Map<String, dynamic>?> parties = [];
  Map<String, dynamic>? data;
  int size = await collRef.get().then((value) => value.size);
  for (var i = 1; i <= size; i++) {
    final docRef = collRef.doc(i.toString());
    await docRef.get().then(
      (DocumentSnapshot doc) {
        if (!doc.exists) return null;
        data = doc.data() as Map<String, dynamic>;
        parties.add(data);
      },
      onError: (e) => print('Error: $e'),
    );
  }
  return parties;
}

Future incrementVotes(
    String partyName, String phoneNumber, Function callback) async {
  final db = FirebaseFirestore.instance;
  final partyDocRef = await db
      .collection('Parties')
      .where('Name', isEqualTo: partyName)
      .limit(1)
      .get()
      .then((QuerySnapshot snapshot) {
    return snapshot.docs[0].reference;
  });
  final userDocRef = await db
      .collection('Users')
      .where('PhoneNumber', isEqualTo: phoneNumber)
      .limit(1)
      .get()
      .then((QuerySnapshot snapshot) {
    return snapshot.docs[0].reference;
  });

  await db.runTransaction((transaction) async {
    transaction.update(partyDocRef, {
      // Pass the DocumentReference here ^^
      "Votes": FieldValue.increment(1),
    });
    transaction.update(userDocRef, {
      // Pass the DocumentReference here ^^
      "Voted": true,
    });
  }).then((value) => callback());
}
