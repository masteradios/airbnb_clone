import 'package:airbnb_clone/screens/login_screen.dart';
import 'package:airbnb_clone/services/auth_service.dart';
import 'package:airbnb_clone/widgets/showSnackBar.dart';
import 'package:flutter/material.dart';

import '../widgets/customtextbutton.dart';
import '../widgets/customtextfield.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SignUp',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
              BuildSignUpPage(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? '),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, LoginScreen.routeName);
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildSignUpPage extends StatefulWidget {
  const BuildSignUpPage({super.key});

  @override
  State<BuildSignUpPage> createState() => _BuildSignUpPageState();
}

class _BuildSignUpPageState extends State<BuildSignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _signUpKey = GlobalKey<FormState>();
  bool isLoading = false;
  void signUpUser() async {
    setState(() {
      isLoading = true;
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
    await AuthService().signUpUser(
        context: context,
        username: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());
    setState(() {
      isLoading = false;
      Navigator.of(context).pop();
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    });
    // AuthService().signUpUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signUpKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
        child: Column(
          children: [
            CustomTextFormField(
              hintText: 'Enter your Name',
              controller: _nameController,
            ),
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
                          content:
                              'Password can\'t be less than 6 characters!!');
                    } else {
                      signUpUser();
                    }
                  }
                },
                buttonTitle: 'SignUp',
              ),
            )
          ],
        ),
      ),
    );
  }
}
