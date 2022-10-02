// ignore_for_file: file_names, unnecessary_new
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'loginScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = TextEditingController();

  // firebase
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  _passwordReset() async {
    if (_formKey.currentState!.validate()) {
      try {
        _formKey.currentState!.save();

        await _auth.sendPasswordResetEmail(email: emailController.text);

        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          // ignore: prefer_const_constructors
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Por favor introduzca su correo electrónico");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Por favor introduzca una dirección de correo electrónico válida");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 16, 20, 16),
        labelText: 'Correo electrónico',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.all(0.0),
          child: Icon(
            Icons.email,
            color: Colors.grey,
          ),
        ),
      ),
    );

    final restoreButton = SizedBox(
      height: 60,
      width: 160,
      child: TextButton(
        style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(16.0),
            backgroundColor: const Color.fromRGBO(48, 35, 167, 1),
            textStyle: const TextStyle(fontSize: 22),
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0))),
        onPressed: () {
          _passwordReset();
        },
        child: const Text('Restablecer'),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Recuperar Contraseña",
                      style: TextStyle(
                        color: Color.fromRGBO(48, 35, 167, 1),
                        fontSize: 50,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 45),
                    emailField,
                    const SizedBox(height: 45),
                    restoreButton,
                    const Text(
                      "________________________________",
                      style: TextStyle(
                        color: Color.fromRGBO(112, 112, 112, 1),
                        fontSize: 20,
                      ),
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
