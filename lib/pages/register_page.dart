import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vqa_graduation_project/go_router/app_router.dart';
import 'package:vqa_graduation_project/pages/home_page.dart';
import 'package:vqa_graduation_project/services/auth_services.dart';
import 'package:vqa_graduation_project/widgets/default_button.dart';
import 'package:vqa_graduation_project/widgets/default_textformfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();
    final AuthService _authService = AuthService();
    final _formKey = GlobalKey<FormState>();

    void _onTap(BuildContext context) async {
      if (_formKey.currentState!.validate()) {
        if (passwordController.text == confirmPasswordController.text) {
          User? user = await _authService.registerWithEmailAndPassword(
            emailController.text,
            passwordController.text,
          );
          if (user != null) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (Context) => HomePage()));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registration failed')),
            );
          }
        }
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('the confirm password is not correct')),
        );
      }
    }

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
                      "Let's create an account for you",
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
                    const SizedBox(height: 10),
                    DefaultTextformfield(
                      hintText: "Password",
                      ispassword: true,
                      prefix: Icon(Icons.password),
                      controller: passwordController,
                    ),
                    const SizedBox(height: 10),
                    DefaultTextformfield(
                      hintText: "Confirm Password",
                      ispassword: true,
                      prefix: Icon(Icons.password),
                      controller: confirmPasswordController,
                    ),
                    const SizedBox(height: 25),
                    DefaultButton(
                      text: "Register",
                      radius: 30,
                      onTap: () => _onTap(context),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?  ",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(
                              context, AppRouter.login),
                          child: Text(
                            "Login",
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
