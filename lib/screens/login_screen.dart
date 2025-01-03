import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to handle sign-in with email and password
  void _loginWithEmailAndPassword() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if(userCredential.user != null){
        // Navigate to the home page after successful login
        Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
        // Navigator.pushReplacementNamed(context, '/');
      }else{

      }


    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  // Function to display an error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Enter email',
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Enter password',
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: _loginWithEmailAndPassword,
                    child: const Text("Login"),
                  ),
                ),
                Container(width: 50,),
                Center(
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: const Text("Register"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
