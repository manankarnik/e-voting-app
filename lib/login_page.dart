import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'registration_page.dart';
import 'auth.dart';
import 'firestore.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Login')),
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

  TextEditingController phoneController = TextEditingController();
  bool userExists = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: phoneController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter your mobile number',
            ),
            onChanged: (text) async {
              await getUser(phoneController.text).then(
                (data) {
                  if (data != null) {
                    setState(() => userExists = true);
                  } else {
                    setState(() => userExists = false);
                  }
                },
              );
            },
            validator: (value) {
              if (value == null || value.length != 10) {
                return 'Please enter valid mobile number';
              } else if (!userExists) {
                return 'User does not exist. Please register';
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
                verify(context, phoneController.text);
              }
            },
            child: const Text(
              'Generate OTP',
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 20,
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
