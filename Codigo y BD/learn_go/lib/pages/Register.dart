import 'dart:convert';

import 'package:flutter/material.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  int? _mySelection;
  String? _selectedSubject;
  List<String> selectedSubjects = [];

  List<Map<String, dynamic>> _myJson = [
    {"id": 1, "name": "Alumno"},
    {"id": 2, "name": "Tutor"}
  ];

  @override
  void initState() {
    super.initState();
    fetchMaterias();
  }

  List<Map<String, dynamic>> _materias = [];

  final _formKey = GlobalKey<FormState>(); // Clave global del formulario

  Future<void> fetchMaterias() async {
    try {
      var response = await http
          .get(Uri.parse("http://127.0.0.1/learn_go/listmaterias.php"));

      if (response.statusCode == 200) {
        setState(() {
          _materias =
              List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        print(
            "Error al obtener las materias. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during HTTP request: $e");
    }
  }

  void register() {
    String? idMateria = _materias.firstWhere(
      (materia) => materia['nombre'] == _selectedSubject,
      orElse: () => {'id': null},
    )['id'];

    if (_formKey.currentState?.validate() ?? false) {
      var url = "http://127.0.0.1/learn_go/adddata.php";
      int idRol; // Variable para almacenar el valor de id_rol

      // Asignar el valor de id_rol según la selección del usuario
      if (_mySelection == 1) {
        idRol = 1;
      } else if (_mySelection == 2) {
        idRol = 2;
      } else {
        // Manejar un caso por defecto o error
        idRol = 0; // O cualquier otro valor que consideres apropiado
      }

      http.post(Uri.parse(url), body: {
        "nombre": nameController.text,
        "apellido": lastnController.text,
        "edad": int.parse(ageController.text).toString(),
        "email": emailController.text,
        "password": passController.text,
        "id_rol": idRol.toString(), // Convertir a cadena
        "id_materia": idMateria.toString(), // Convertir a cadena
      });

      // Mensajes de impresión para verificar datos
      print("Nombre: ${nameController.text}");
      print("Apellido: ${lastnController.text}");
      print("Edad: ${ageController.text}");
      print("Email: ${emailController.text}");
      print("Contraseña: ${passController.text}");
      print("Rol: $_mySelection");
      print("id_materia: $idMateria");

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyApp()), // Reemplazar la pantalla actual
      );
    } else {
      // Mostrar un mensaje de advertencia utilizando ScaffoldMessenger
      // Mostrar un AlertDialog con el mensaje de advertencia
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Advertencia'),
            content:
                Text('Por favor, complete todos los campos del formulario.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            fullBody(context),
          ],
        ),
      ),
    );
  }

  Widget fullBody(BuildContext context) {
    return Form(
      key: _formKey, // Asociar la clave global del formulario
      child: Container(
        decoration: BoxDecoration(),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 80,
              ),
              nameUser(),
              lastnUser(),
              ageUser(),
              tuser(),
              subjects(),
              // selectedSubjectsList(),
              emailUser(),
              passUser(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  backButton(context), // Botón de retroceso independiente
                  SizedBox(width: 20), // Espaciador horizontal
                  saveButton(context), // Botón de registro
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget nameUser() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: TextFormField(
        keyboardType: TextInputType.name,
        controller: nameController,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "Name:",
          labelStyle: TextStyle(color: Colors.black),
          fillColor: Color.fromARGB(50, 217, 214, 214),
          filled: true,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your name';
          }
          return null;
        },
      ),
    );
  }

  Widget lastnUser() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: TextFormField(
        keyboardType: TextInputType.name,
        controller: lastnController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your last name';
          }
          return null;
        },
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "Last Name:",
          labelStyle: TextStyle(color: Colors.black),
          fillColor: Color.fromARGB(50, 217, 214, 214),
          filled: true,
        ),
      ),
    );
  }

  Widget ageUser() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: ageController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your age';
          }
          return null;
        },
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "Age:",
          labelStyle: TextStyle(color: Colors.black),
          fillColor: Color.fromARGB(50, 217, 214, 214),
          filled: true,
        ),
      ),
    );
  }

  Widget tuser() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: DropdownButton<int>(
        value: _mySelection,
        onChanged: (int? value) {
          if (value != null) {
            setState(() {
              _mySelection = value;
            });
          }
        },
        items: _myJson.map((Map<String, dynamic> map) {
          return DropdownMenuItem<int>(
            value: map["id"],
            child: Text(
              map["name"],
              style: TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        style: TextStyle(color: Colors.black),
        hint: Text(
          "Select User Type",
          style: TextStyle(color: Colors.black),
        ),
        isExpanded: true,
        underline: Container(
          height: 1,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget subjects() {
    return Container(
      padding: EdgeInsets.all(16),
      width: 500,
      child: DropdownButton<String>(
        value: _selectedSubject,
        onChanged: (String? newValue) {
          setState(() {
            _selectedSubject = newValue;
          });
        },
        items: _materias.map((Map<String, dynamic> materia) {
          return DropdownMenuItem<String>(
            value: materia['nombre'],
            child: Text(
              materia['nombre'],
              style: TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        hint: Text(
          "Select Subject",
          style: TextStyle(color: Colors.black),
        ),
        isExpanded: true,
        underline: Container(
          height: 1,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget emailUser() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your email';
          }
          return null;
        },
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

  Widget passUser() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: TextFormField(
        obscureText: true,
        controller: passController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: "Password:",
          labelStyle: TextStyle(color: Colors.black),
          fillColor: Color.fromARGB(50, 217, 214, 214),
          filled: true,
        ),
      ),
    );
  }

  Widget saveButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: customButtonStyle, // Estilo común para ambos botones
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 7),
            Text(
              "Sign Up",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        onPressed: () {
          register();
        },
      ),
    );
  }

  Widget backButton(BuildContext context) {
    return ElevatedButton(
      style: customButtonStyle, // Estilo común para ambos botones
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyApp()), // Reemplazar la pantalla actual
        );
      },
      child: Text(
        "Back",
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  final ButtonStyle customButtonStyle = ButtonStyle(
    backgroundColor:
        MaterialStateProperty.all(Color.fromARGB(255, 242, 171, 39)),
  );
}
