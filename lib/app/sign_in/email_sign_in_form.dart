import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/widgets/form_sign_in_button.dart';

enum emailFormType { signIn, register }

class EmailSignInForm extends StatefulWidget {
  EmailSignInForm({@required this.auth});
  final AuthBase auth;
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  emailFormType _emailType = emailFormType.signIn;

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  void _toggleForm() {
    setState(() {
      _emailType = _emailType == emailFormType.signIn
          ? emailFormType.register
          : emailFormType.signIn;
      _emailController.clear();
    });
    _passwordController.clear();
  }

  void _submit() async {
    try {
      if (_emailType == emailFormType.signIn) {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await widget.auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.pop(context);
    } catch (e) {
      print(e.toString());
    }
  }

  List<Widget> _buildChildren() {
    String primaryText =
        _emailType == emailFormType.signIn ? 'Sign in' : 'Register';
    String secondaryText = _emailType == emailFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';

    bool submitEnabled = _email.isNotEmpty && _password.isNotEmpty;
    return [
      _buildEmailTextField(),
      SizedBox(
        height: 8,
      ),
      _buildPasswordTextField(),
      SizedBox(
        height: 8,
      ),
      FormSignInButton(
        text: primaryText,
        onPressed: submitEnabled ? _submit : null,
      ),
      SizedBox(
        height: 8,
      ),
      FlatButton(onPressed: _toggleForm, child: Text(secondaryText)),
    ];
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      decoration:
          InputDecoration(labelText: 'Email', hintText: 'test@test.com'),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      onChanged: (email) => _updateState(),
      textInputAction: TextInputAction.next,
    );
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
      ),
      obscureText: true,
      onChanged: (password) => _updateState(),
      textInputAction: TextInputAction.done,
    );
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

  void _updateState() {
    setState(() {});
  }
}
