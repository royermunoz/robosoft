// ignore_for_file: file_names, unnecessary_const, unnecessary_new
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:robosoft/auth/loginScreen.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
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
                        logout(context);
                      },
                      child: const Text('Cerrar sesión'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  // ignore: use_build_context_synchronously
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()));
}
