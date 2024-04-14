import 'package:airbnb_clone/screens/login_screen.dart';
import 'package:airbnb_clone/services/auth_service.dart';
import 'package:airbnb_clone/widgets/showSnackBar.dart';
import 'package:flutter/material.dart';

import '../widgets/customtextbutton.dart';
import '../widgets/customtextfield.dart';

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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/signupimage.jpg'),
                  fit: BoxFit.fill,
                  opacity: 0.7)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/logow.png',
                  height: 200,
                ),
              ),
              BuildSignUpPage(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, LoginScreen.routeName);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20),
                      ),
                    )
                  ],
                ),
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
    });
    // AuthService().signUpUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signUpKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30, bottom: 10),
            child: Material(
              borderRadius: BorderRadius.circular(12),
              shadowColor: Colors.black,
              elevation: 30,
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                child: Column(
                  children: [
                    CustomTextFormField(
                      hintText: 'Enter your Name',
                      controller: _nameController,
                      callback: () {},
                    ),
                    CustomTextFormField(
                      textInputType: TextInputType.emailAddress,
                      hintText: 'Enter your Email',
                      controller: _emailController,
                      callback: () {},
                    ),
                    CustomTextFormField(
                      hintText: 'Enter your Password',
                      textInputAction: TextInputAction.done,
                      controller: _passwordController,
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
                if (_signUpKey.currentState!.validate()) {
                  if (_passwordController.text.length < 6) {
                    displaySnackBar(
                        context: context,
                        content: 'Password can\'t be less than 6 characters!!');
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
    );
  }
}
