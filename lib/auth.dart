import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'otp_validation.dart';
import 'login_page.dart';

FirebaseAuth auth = FirebaseAuth.instance;

void verify(BuildContext context, String phoneNumber) async {
  await auth.verifyPhoneNumber(
    phoneNumber: '+91 $phoneNumber',
    verificationCompleted: (PhoneAuthCredential credential) async {
      // ANDROID ONLY!

      // Sign the user in (or link) with the auto-generated credential
      await auth.signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
      }

      // Handle other errors
    },
    codeSent: (String verificationId, int? resendToken) async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OtpValidation(phoneNumber, verificationId, resendToken),
        ),
      );
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      // Auto-resolution timed out...
    },
  );
}

void signOut(context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => const LoginPage()));
}
