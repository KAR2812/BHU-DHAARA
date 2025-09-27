import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;
  String? error;

  void _login() async {
    setState(() { _loading = true; error = null; });
    try {
      final user = await _auth.signIn(_email.text.trim(), _pass.text.trim());
      if (user != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen(userId: user.uid)));
      } else {
        setState(() { error = "Login failed"; });
      }
    } catch (e) {
      setState(() { error = e.toString(); });
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _email, decoration: InputDecoration(labelText: 'Email')),
          TextField(controller: _pass, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
          if (_loading) CircularProgressIndicator(),
          if (error != null) Text(error!, style: TextStyle(color: Colors.red)),
          ElevatedButton(onPressed: _login, child: const Text('Login')),
        ]),
      ),
    );
  }
}
