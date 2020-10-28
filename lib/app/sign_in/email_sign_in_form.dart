import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/validators.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/widgets/form_sign_in_button.dart';
import 'package:time_tracker/widgets/paltform_exception_alert_dialog.dart';

enum emailFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  emailFormType _emailType = emailFormType.signIn;
  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  void _toggleForm() {
    setState(() {
      _submitted = false;
      _emailType = _emailType == emailFormType.signIn
          ? emailFormType.register
          : emailFormType.signIn;
      _emailController.clear();
    });
    _passwordController.clear();
  }

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context);
      if (_emailType == emailFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.pop(context);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Widget> _buildChildren() {
    String primaryText =
        _emailType == emailFormType.signIn ? 'Sign in' : 'Register';
    String secondaryText = _emailType == emailFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;
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
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: showErrorText ? widget.emailValidatorErrorText : null),
      enabled: _isLoading == false,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      onChanged: (email) => _updateState(),
      textInputAction: TextInputAction.next,
    );
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.passwordValidatorErrorText : null,
        enabled: _isLoading == false,
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
