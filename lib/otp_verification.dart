import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class OtpValidation extends StatelessWidget {
  OtpValidation(this.verificationId, resendToken, {super.key});

  String verificationId;
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('E-Voting | OTP Validation')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Enter OTP',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              PinInputTextField(controller: otpController),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () async {
                    String otp = otpController.text;
                    // Create a PhoneAuthCredential with the code
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: otp);

                    // Sign the user in (or link) with the credential
                    await auth.signInWithCredential(credential).then(
                          (value) => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          ),
                        );
                  },
                  child: const Text('Submit'))
            ]),
      ),
    );
  }
}
