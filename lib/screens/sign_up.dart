
import 'package:flutter/material.dart';

import '../services/firebase_helper.dart';
import 'home.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController nameController;

  bool isLoading = false;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text('Sign Up using Email & Password'),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  controller: emailController,
                  onChanged: (value) {
                    emailController.text = value;
                  },
                  decoration:  const InputDecoration(
                    hintText: 'example@email.com',
                    labelText: 'Enter your email'
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  controller: passwordController,
                  onChanged: (value) {
                    passwordController.text = value;
                  },
                  obscureText: true,
                  decoration:  const InputDecoration(
                    hintText: '*******',
                    labelText: 'Enter your password'
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  controller: nameController,
                  onChanged: (value) {
                    nameController.text = value;
                  },
                  decoration:  const InputDecoration(
                    hintText: 'name',
                    labelText: 'Enter your name'
                  ),
                ),
              ),

              isLoading ? const CircularProgressIndicator() : ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (!isValidForm(context)) {
                      setState(() {
                        isLoading = false;
                      });
                      return;
                    }

                    try{
                      final isSave = await FirebaseHelper.saveUser(
                        email: emailController.text,
                        password: passwordController.text,
                        name: nameController.text,
                      );
                      if (isSave && mounted) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                      }

                    }catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString()))
                      );
                    }

                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: const Text('Sign Up')
              )
            ],
          ),
        ),
      ),
    );
  }
  
  bool isValidForm(BuildContext context) {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('fill all the fields'))
      );
      return false;
    }
    return true;
  }
}
