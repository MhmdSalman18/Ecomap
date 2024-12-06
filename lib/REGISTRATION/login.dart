import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required String title});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
 

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Login'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Handle login logic
            },
            child: Text('Login'),
          ),
          TextButton(
            onPressed: () {
              // Navigate to signup page
            },
            child: Text('Don\'t have an account? Sign up'),
          ),
        ],
      ),
    ),
  );
}
}