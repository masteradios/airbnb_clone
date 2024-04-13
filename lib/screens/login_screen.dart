import 'package:airbnb_clone/screens/signup_screen.dart';
import 'package:airbnb_clone/services/auth_service.dart';
import 'package:airbnb_clone/widgets/showSnackBar.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/customtextbutton.dart';
import '../widgets/customtextfield.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  logo,
                  height: 300,
                  width: 200,
                ),
                BuildLoginPage(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, SignUpScreen.routeName);
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuildLoginPage extends StatefulWidget {
  const BuildLoginPage({super.key});

  @override
  State<BuildLoginPage> createState() => _BuildLoginPageState();
}

class _BuildLoginPageState extends State<BuildLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _loginKey = GlobalKey<FormState>();
  void loginuser() async {
    setState(() {
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          });
    });
    await AuthService().loginUser(
        context: context,
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());

    // AuthService().signUpUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Material(
              elevation: 20,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                child: Column(
                  children: [
                    CustomTextFormField(
                      hintText: 'Enter your Email',
                      controller: _emailController,
                      textInputType: TextInputType.emailAddress,
                      callback: () {},
                    ),
                    CustomTextFormField(
                      hintText: 'Enter your Password',
                      controller: _passwordController,
                      textInputAction: TextInputAction.done,
                      callback: () {
                        if (_loginKey.currentState!.validate()) {
                          if (_passwordController.text.length < 6) {
                            displaySnackBar(
                                context: context,
                                content:
                                    'Password can\'t be less than 6 characters!!');
                          } else {
                            loginuser();
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: CustomTextButton(
              callback: () {
                if (_loginKey.currentState!.validate()) {
                  if (_passwordController.text.length < 6) {
                    displaySnackBar(
                        context: context,
                        content: 'Password can\'t be less than 6 characters!!');
                  } else {
                    loginuser();
                  }
                }
              },
              buttonTitle: 'Login',
            ),
          )
        ],
      ),
    );
  }
}
