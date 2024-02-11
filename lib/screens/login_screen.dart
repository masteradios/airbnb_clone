import 'package:airbnb_clone/screens/signup_screen.dart';
import 'package:airbnb_clone/widgets/showSnackBar.dart';
import 'package:flutter/material.dart';

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

      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
              buildLoginPage(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account? '),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SignUpScreen.routeName);
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildLoginPage(BuildContext context) {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _signUpKey = GlobalKey<FormState>();
  void signUpUser() async {
    print('succcess');
    // AuthService().signUpUser(context);
  }

  return Form(
    key: _signUpKey,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
      child: Column(
        children: [
          CustomTextFormField(
            hintText: 'Enter your Email',
            controller: _emailController,
          ),
          CustomTextFormField(
            hintText: 'Enter your Password',
            controller: _passwordController,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CustomTextButton(
              callback: () {
                if (_signUpKey.currentState!.validate()) {
                  if (_passwordController.text.length < 6) {
                    displaySnackBar(
                        context: context,
                        content: 'Paswword can\'t be less than 6 characters!!');
                  } else {
                    signUpUser();
                  }
                }
              },
              buttonTitle: 'Login',
            ),
          )
        ],
      ),
    ),
  );
}


