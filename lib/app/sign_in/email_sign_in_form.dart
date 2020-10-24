import 'package:flutter/material.dart';
import 'package:time_tracker/widgets/form_sign_in_button.dart';

enum emailFormType { signIn, register }

class EmailSignInForm extends StatefulWidget {
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  emailFormType _emailType = emailFormType.signIn;

  void _toggleForm() {
    setState(() {
      _emailType = _emailType == emailFormType.signIn
          ? emailFormType.register
          : emailFormType.signIn;
      _emailController.clear();
    });
    _passwordController.clear();
  }

  void _submit() {
    print(
        'email: ${_emailController.text} password: ${_passwordController.text}');
  }

  List<Widget> _buildChildren() {
    String primaryText =
        _emailType == emailFormType.signIn ? 'Sign in' : 'Register';
    String secondaryText = _emailType == emailFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
    return [
      TextField(
        controller: _emailController,
        decoration:
            InputDecoration(labelText: 'Email', hintText: 'test@test.com'),
      ),
      SizedBox(
        height: 8,
      ),
      TextField(
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: 'Password',
        ),
        obscureText: true,
      ),
      SizedBox(
        height: 8,
      ),
      FormSignInButton(
        text: primaryText,
        onPressed: _submit,
      ),
      SizedBox(
        height: 8,
      ),
      FlatButton(onPressed: _toggleForm, child: Text(secondaryText)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
