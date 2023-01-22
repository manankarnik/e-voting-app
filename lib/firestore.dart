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
