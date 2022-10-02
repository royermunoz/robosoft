// ignore_for_file: file_names, unnecessary_new, unnecessary_const
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:robosoft/auth/registrationScreen.dart';

import '../mainPage.dart';
import 'forgotPasswordScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // firebase
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

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
        labelText: 'Correo electrónico',
      ),
    );

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Se requiere contraseña para iniciar sesión");
        }
        if (!regex.hasMatch(value)) {
          return ("Ingrese una contraseña válida (mínimo 6 caracteres)");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 16, 20, 16),
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
            Icons.lock,
            color: Colors.grey,
          ),
        ),
        labelText: 'Contraseña',
      ),
    );

    final loginButton = SizedBox(
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
          signIn(emailController.text, passwordController.text);
        },
        child: const Text('Inicio'),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Robosoft",
                      style: TextStyle(
                        color: Color.fromRGBO(48, 35, 167, 1),
                        fontSize: 70,
                      ),
                    ),
                    const SizedBox(height: 45),
                    emailField,
                    const SizedBox(height: 20),
                    passwordField,
                    const SizedBox(height: 45),
                    loginButton,
                    const SizedBox(height: 20),
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: const Color.fromRGBO(32, 38, 114, 1),
                          padding: const EdgeInsets.all(16.0),
                          textStyle: const TextStyle(fontSize: 18),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0))),
                      onPressed: () {
                        Navigator.push(
                          context,
                          // ignore: prefer_const_constructors
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen()),
                        );
                      },
                      child: const Text('¿Olvidó su contraseña?'),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: const Color.fromRGBO(32, 38, 114, 1),
                          padding: const EdgeInsets.all(16.0),
                          textStyle: const TextStyle(fontSize: 18),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0))),
                      onPressed: () {
                        Navigator.push(
                          context,
                          // ignore: prefer_const_constructors
                          MaterialPageRoute(
                              builder: (context) => const RegistrationScreen()),
                        );
                      },
                      child: const Text('¿No tienes cuenta registrada?'),
                    ),
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

  // login function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(msg: "Inicio de sesión exitosa"),
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const MainPage())),
                });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage =
                "Su dirección de correo electrónico parece tener un formato incorrecto.";
            break;
          case "wrong-password":
            errorMessage = "Tu contraseña es incorrecta.";
            break;
          case "user-not-found":
            errorMessage = "El usuario con este correo electrónico no existe.";
            break;
          case "user-disabled":
            errorMessage =
                "El usuario con este correo electrónico ha sido inhabilitado.";
            break;
          case "too-many-requests":
            errorMessage = "Demasiadas solicitudes";
            break;
          case "operation-not-allowed":
            errorMessage =
                "Iniciar sesión con correo electrónico y contraseña no está habilitado.";
            break;
          default:
            errorMessage = "Se produjo un error indefinido.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        // ignore: avoid_print
        print(error.code);
      }
    }
  }
}
