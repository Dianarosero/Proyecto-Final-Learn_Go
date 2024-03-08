import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learn_go/pages/alumno/home.dart';
import 'package:learn_go/pages/tutor/homeT.dart';
import 'package:learn_go/data/UserData.dart';
import 'package:learn_go/pages/Register.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

String username = '';

final TextEditingController userNameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return MaterialApp(
      title: "LEARN GO",
      home: Start(),
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/HomePageE': (BuildContext context) => new Home(username: username),
        '/HomePageT': (BuildContext context) => new HomeT(username: username),
      },
    );
  }
}

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  String msg = '';

  Future<List> _login() async {
    print("Before HTTP request");
    final response = await http
        .post(Uri.parse("http://127.0.0.1/learn_go/login.php"), body: {
      "email": userNameController.text,
      "password": passwordController.text,
    });
    print("After HTTP request");

    var datauser = json.decode(response.body);

    if (datauser.length == 0) {
      setState(() {
        msg = "Login Fail";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Usuario no encontrado. Introduce los datos nuevamente."),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      if (datauser[0]['id_rol'] == '1') {
        Navigator.pushReplacementNamed(context, '/HomePageE');
      } else if (datauser[0]['id_rol'] == '2') {
        Navigator.pushReplacementNamed(context, '/HomePageT');
      }

      setState(() {
        username = datauser[0]['email'];
      });
    }

    return datauser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: fullBody(context),
    );
  }

  Widget fullBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 160,
            ),
            inputUser(),
            inputPassword(),
            options(context),
          ],
        ),
      ),
    );
  }

  Widget options(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            goButton(),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Don't have an account? "),
            GestureDetector(
              onTap: () {
                _registerPage(context);
              },
              child: Text(
                "Sign up",
                style: TextStyle(
                  color: const Color.fromARGB(255, 242, 171, 39),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget inputUser() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: TextField(
        controller: userNameController,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "Email or Username:",
          labelStyle: TextStyle(color: Colors.black),
          fillColor: Color.fromARGB(50, 217, 214, 214),
          filled: true,
        ),
      ),
    );
  }

  Widget inputPassword() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: TextField(
        controller: passwordController,
        style: TextStyle(color: Colors.black),
        obscureText: true,
        decoration: InputDecoration(
          labelText: "Password:",
          labelStyle: TextStyle(color: Colors.black),
          fillColor: Color.fromARGB(50, 217, 214, 214),
          filled: true,
        ),
      ),
    );
  }

  Widget goButton() {
    return Center(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 242, 171, 39)),
          minimumSize: MaterialStateProperty.all(Size(180, 40)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "LOG IN",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
        onPressed: () {
          _login().then((datauser) {
            // Realizar acciones después del login si es necesario
          });
        },
      ),
    );
  }

  _registerPage(BuildContext context) async {
    final dataFromRegistryPage = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Register()),
    ) as UserData;

    print("Show Data in Login");
    print(dataFromRegistryPage.toString());
  }
}
