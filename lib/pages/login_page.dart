import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vqa_graduation_project/go_router/app_router.dart';
import 'package:vqa_graduation_project/pages/home_page.dart';
import 'package:vqa_graduation_project/services/auth_services.dart';
import 'package:vqa_graduation_project/widgets/default_button.dart';
import 'package:vqa_graduation_project/widgets/default_textformfield.dart';

class LoginPage extends StatefulWidget {
   LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey< FormState>();
  void _onTap(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      User? user = await _authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed')),
        );
      }
    }
  
       
      }

  @override
  Widget build(BuildContext context) {
   


    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.message,
                      color: Theme.of(context).colorScheme.primary,
                      size: 50,
                    ),
                    SizedBox(height: 25),
                    Text(
                      "Welcome Back, You Have been missed!",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    DefaultTextformfield(
                      hintText: "Email",
                      ispassword: false,
                      prefix: Icon(Icons.email),
                      controller: emailController,
                    ),
                    SizedBox(height: 10),
                    DefaultTextformfield(
                      hintText: "Password",
                      ispassword: true,
                      prefix: Icon(Icons.password),
                      controller: passwordController,
                    ),
                    SizedBox(height: 25),
                    DefaultButton(
                      text: "Login",
                      radius: 30,
                      onTap: ()=>_onTap(context),
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?  ",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(
                                  context, AppRouter.register),
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
