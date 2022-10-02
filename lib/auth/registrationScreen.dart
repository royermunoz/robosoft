// ignore_for_file: file_names, unnecessary_new
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../mainPage.dart';
import '../models/userModel.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;

  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final nameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    //first name field
    final nameField = TextFormField(
      autofocus: false,
      controller: nameEditingController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return ("El nombre no puede estar vacío");
        }
        return null;
      },
      onSaved: (value) {
        nameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
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
            Icons.person,
            color: Colors.grey,
          ),
        ),
        labelText: 'Nombre',
        contentPadding: EdgeInsets.fromLTRB(20, 16, 20, 16),
      ),
    );

    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
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
        emailEditingController.text = value!;
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

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Se requiere contraseña para iniciar sesión");
        }
        if (!regex.hasMatch(value)) {
          return ("Introduzca una contraseña válida (mínimo 6 caracteres).)");
        }
      },
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 16, 20, 16),
        labelText: 'Contraseña',
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
      ),
    );

    //confirm password field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Se requiere contraseña para iniciar sesión");
        }
        if (confirmPasswordEditingController.text !=
            passwordEditingController.text) {
          return "La contraseña no coincide";
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        labelText: 'Confirmar contraseña',
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
      ),
    );

    //signup button
    final signUpButton = SizedBox(
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
          signUp(emailEditingController.text, passwordEditingController.text);
        },
        child: const Text("Registrar"),
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
                      "Crear Usuario",
                      style: TextStyle(
                        color: Color.fromRGBO(48, 35, 167, 1),
                        fontSize: 50,
                      ),
                    ),
                    const SizedBox(height: 45),
                    nameField,
                    const SizedBox(height: 20),
                    emailField,
                    const SizedBox(height: 20),
                    passwordField,
                    const SizedBox(height: 20),
                    confirmPasswordField,
                    const SizedBox(height: 45),
                    signUpButton,
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

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
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

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = nameEditingController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Cuenta creada con éxito :)");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const MainPage()),
        (route) => false);
  }
}
