import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'registration_page.dart';
import 'mobile_verification.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('E-Voting | Login')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'Login',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24),
            child: LoginForm(),
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextStyle defaultStyle = const TextStyle(color: Colors.grey, fontSize: 20.0);
  TextStyle linkStyle = const TextStyle(color: Colors.blue);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter your mobile number',
            ),
            validator: (value) {
              if (value == null || value.length != 10) {
                return 'Please enter valid mobile number';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
              }
            },
            child: const Text(
              'Generate OTP',
              style: TextStyle(fontSize: 20),
            ),
          ),
          RichText(
            text: TextSpan(
              style: defaultStyle,
              text: 'New voter? Register ',
              children: <TextSpan>[
                TextSpan(
                  style: linkStyle,
                  text: 'here',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistrationPage(),
                        ),
                      );
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
