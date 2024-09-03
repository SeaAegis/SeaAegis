
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seaaegis/backend/authentication/auth_signup.dart';
import 'package:seaaegis/routes/routes.dart';
import 'package:seaaegis/utils/colors.dart';
import 'package:seaaegis/utils/snakbar.dart';
import 'package:seaaegis/widgets/text_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernamecontroller = TextEditingController();
  bool _islaoding = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernamecontroller.dispose();
  }


  void signupUser() async {
    setState(() {
      _islaoding = true;
    });
    String response = await AuthSignUp().signup(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        username: usernamecontroller.text.trim(),
      );
    // print(res);
    if (response != "success") {
      // ignore: use_build_context_synchronously
      showSnackBar(context, response);
    }
    if (response == 'success') {
      Navigator.of(context).pushNamed(AppRoutes.loginRoute);
    }
    setState(() {
      _islaoding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                const SizedBox(
                  height: 30,
                ),
                Stack(
                  children: [
                     const CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                "https://as2.ftcdn.net/v2/jpg/02/15/84/43/1000_F_215844325_ttX9YiIIyeaR7Ne6EaLLjMAmy4GvPC69.jpg"),
                          ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFieldInput(
                  hintText: 'Username',
                  textEditingController: usernamecontroller,
                  textInputType: TextInputType.text,
                  isPassword: false,
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFieldInput(
                  hintText: 'Email or Phone Number',
                  textEditingController: emailController,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFieldInput(
                  hintText: 'Password',
                  textEditingController: passwordController,
                  isPassword: true,
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 18,
                ),
                InkWell(
                  onTap: signupUser,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      color: blueColor,
                    ),
                    child: _islaoding
                        ? const Center(
                            child: CupertinoActivityIndicator(
                              animating: true,
                              color: primaryColor,
                            ),
                          )
                        : const Text(
                            "SignUp",
                            style: TextStyle(color: primaryColor),
                          ),
                  ),
                ),

                // const SizedBox(
                //   height: 24,
                // ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Alraedy have an account?  ",
                        style: TextStyle(color: primaryColor),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutes.loginRoute);
                        },
                        child: const Text(
                          "login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                // SizedBox(
                //   height: 10,
                // )
              ],
            ),
          ],
        ),
      )),
    );
  }
}