import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'login_page.dart';
import 'auth.dart';
import 'firestore.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Center(child: Text('Register')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'Register',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24),
            child: RegistrationForm(),
          )
        ],
      ),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  TextStyle defaultStyle = const TextStyle(color: Colors.grey, fontSize: 20.0);
  TextStyle linkStyle = const TextStyle(color: Colors.blue);

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool userExists = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Full Name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: phoneController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Mobile number',
            ),
            onChanged: (text) async {
              await getUser(phoneController.text).then((data) {
                if (data != null) {
                  setState(() => userExists = true);
                } else {
                  setState(() => userExists = false);
                }
              });
            },
            validator: (value) {
              if (value == null || value.length != 10) {
                return 'Please enter valid mobile number';
              } else if (userExists) {
                return 'User with this phone number already exists';
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
                addUser(nameController.text, phoneController.text);
                verify(context, phoneController.text);
              }
            },
            child: const Text(
              'Register',
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          RichText(
            text: TextSpan(
              style: defaultStyle,
              text: 'Returning voter? Login ',
              children: <TextSpan>[
                TextSpan(
                  style: linkStyle,
                  text: 'here',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
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
