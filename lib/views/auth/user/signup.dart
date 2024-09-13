import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:seaaegis/backend/authentication/auth_signup.dart';
import 'package:seaaegis/views/auth/user/login.dart';
import 'package:seaaegis/views/home/home.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  String username = '';
  String email = '';
  String password = '';
  String mobileNumber = '';

  final AuthSignUp authSignUp =
      AuthSignUp(); // Create an instance of AuthSignUp

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
        backgroundColor: Colors.lightBlue, // Sky blue color
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Lottie.asset(
                'assets/auth/signup.json', // Path to your Lottie animation file
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
                          labelText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter a username';
                          }
                          return null;
                        },
                        onSaved: (value) => username = value ?? '',
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter an email';
                          } else if (!value!.contains('@')) {
                            return 'Please enter a valid email';
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
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(Icons.phone),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter a mobile number';
                          } else if (value!.length < 10) {
                            return 'Please enter a valid mobile number';
                          }
                          return null;
                        },
                        onSaved: (value) => mobileNumber = value ?? '',
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
                            // Call signup method from AuthSignUp class
                            String result = await authSignUp.signup(
                                email: email,
                                password: password,
                                username: username,
                                isuser: true);
                            // Show result in a Snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result)),
                            );
                            if (result == "success") {
                              // Navigate to the login screen or home screen
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()),
                              );
                            }
                          }
                        },
                        child: const Text('Signup'),
                      ),
                      const SizedBox(height: 10),
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: const Text('Login'),
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(
                              Colors.lightBlue), // Sky blue color
                        ),
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
