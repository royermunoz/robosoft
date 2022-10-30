// ignore_for_file: file_names, unnecessary_const, unnecessary_new
import 'dart:async';
import 'dart:math';

import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:robosoft/auth/loginScreen.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int num = 1;

  _MainPageState() {
    AlanVoice.addButton(
        "59599ce2b5a93f692bceb1be03d44acc2e956eca572e1d8b807a3e2338fdd0dc/stage");

    AlanVoice.onCommand.add((command) {
      debugPrint("got new command ${command.toString()}");
    });

    Timer.periodic(
        Duration(seconds: Random().nextInt(20)), (_) => incrementCounter());
  }

  void incrementCounter() {
    setState(() {
      num = Random().nextInt(5);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(218, 236, 248, 1),
      body: Center(
        child: InkWell(
          onTap: incrementCounter,
          child: SizedBox(
            height: 500,
            width: 500,
            child: Image.asset(
              "assets/img$num.png",
              fit: BoxFit.contain,
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
