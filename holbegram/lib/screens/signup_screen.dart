import 'package:flutter/material.dart';

import '../widgets/text_field.dart';

import 'login_screen.dart';
import 'upload_image_screen.dart';

class SignUp extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmController;

  const SignUp({
    super.key,
    required this.emailController,
    required this.usernameController,
    required this.passwordController,
    required this.passwordConfirmController,
  });

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _passwordVisible = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.emailController.dispose();
    widget.usernameController.dispose();
    widget.passwordController.dispose();
    widget.passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 28),

            Text(
              'Holbegram',
              style: TextStyle(fontFamily: 'Billabong', fontSize: 50),
            ),

            Image.asset('assets/images/logo.png', width: 80, height: 60),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextFieldInput(
                    controller: widget.emailController,
                    ispassword: false,
                    hintText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),

                  SizedBox(height: 24),

                  TextFieldInput(
                    controller: widget.usernameController,
                    ispassword: false,
                    hintText: 'Full Name',
                    keyboardType: TextInputType.emailAddress,
                  ),

                  SizedBox(height: 24),

                  TextFieldInput(
                    controller: widget.passwordController,
                    ispassword: !_passwordVisible,
                    hintText: 'Password',
                    keyboardType: TextInputType.visiblePassword,

                    suffixIcon: IconButton(
                      alignment: Alignment.bottomLeft,
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 24),

                  TextFieldInput(
                    controller: widget.passwordConfirmController,
                    ispassword: !_passwordVisible,
                    hintText: 'Confirm Password',
                    keyboardType: TextInputType.visiblePassword,

                    suffixIcon: IconButton(
                      alignment: Alignment.bottomLeft,
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 28),

                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Color.fromARGB(218, 226, 37, 24),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddPicture(
                              email: widget.emailController.text,
                              username: widget.usernameController.text,
                              password: widget.passwordController.text,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Have an account?'),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(
                                emailController: TextEditingController(),
                                passwordController: TextEditingController(),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Log in',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(218, 226, 37, 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
