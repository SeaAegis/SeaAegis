import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:seaaegis/backend/authentication/auth_login.dart';
import 'package:seaaegis/views/auth/user/signup.dart';
import 'package:seaaegis/views/home/home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.lightBlue, // Sky blue color
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Lottie.asset(
                'assets/auth/login.json', // Path to your Lottie animation file
                height: 250,
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter a email';
                          }
                          return null;
                        },
                        onSaved: (value) => email = value ?? '',
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(Icons.lock),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter a password';
                          } else if (value!.length < 8) {
                            return 'Please enter a password with at least 8 characters';
                          }
                          return null;
                        },
                        onSaved: (value) => password = value ?? '',
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.lightBlue), // Sky blue color
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        onPressed: () async {
                          if (formKey.currentState?.validate() ?? false) {
                            formKey.currentState?.save();
                            // Call your API or database to login
                            // For now, just print the values
                            print('Username: $email, Password: $password');
                            String result = await AuthLogin().login(
                              email: email,
                              password: password,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result)),
                            );
                            if (result == "success") {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('Login'),
                      ),
                      const SizedBox(height: 10),
                      const Text('Don\'t have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupScreen()),
                          );
                        },
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(
                              Colors.lightBlue), // Sky blue color
                        ),
                        child: const Text('Signup'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
