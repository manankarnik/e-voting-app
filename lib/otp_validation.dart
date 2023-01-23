import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class OtpValidation extends StatefulWidget {
  const OtpValidation(this.phoneNumber, this.verificationId, this.resendToken,
      {super.key});

  final String verificationId;
  final String phoneNumber;
  final int? resendToken;

  @override
  State<OtpValidation> createState() => _OtpValidationState();
}

class _OtpValidationState extends State<OtpValidation> {
  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('OTP Validation')),
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
            Form(
              key: _formKey,
              child: PinInputTextFormField(
                  onChanged: (text) async {
                    if (text.length == 6) {
                      String otp = otpController.text;
                      // Create a PhoneAuthCredential with the code
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: widget.verificationId,
                              smsCode: otp);

                      // Sign the user in (or link) with the credential
                      await auth
                          .signInWithCredential(credential)
                          .then((value) => setState(() => isValid = true))
                          .catchError(
                        (e) {
                          isValid = false;
                          print(e);
                        },
                      );
                      if (_formKey.currentState!.validate()) {
                        if (!mounted) return;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(widget.phoneNumber),
                          ),
                          ModalRoute.withName('/'),
                        );
                      }
                    }
                  },
                  validator: (value) {
                    if (isValid) return null;
                    return "Invalid OTP";
                  },
                  controller: otpController),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
