import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learn_go/data/UserData.dart';
import 'package:learn_go/pages/alumno/citas.dart';
import 'package:learn_go/pages/alumno/home.dart';
import 'package:learn_go/pages/alumno/listtutor.dart';
import 'package:learn_go/pages/alumno/perfil.dart';
import 'package:http/http.dart' as http;

class Listreserv extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Aquí deberías devolver el widget que deseas construir, no una ListView.builder
    // Se asume que deseas construir un MaterialApp por analogía con el resto del código
    return MaterialApp(
      home: listreserv(
        username: '',
      ),
    );
  }
}

class listreserv extends StatefulWidget {
  final UserData? ud;
  final String username;

  const listreserv({Key? key, this.ud, required this.username})
      : super(key: key);

  @override
  _listreservState createState() => _listreservState();
}

class _listreservState extends State<listreserv> {
  int _selectedIndex = 1;
  int _id_usuario = 0;
  String _username = '';
  UserData? _userData;

  @override
  void initState() {
    super.initState();
    _username = widget.username;
    _id_usuario = 0;
    _getUserData(); // Inicializa el nombre de usuario en el estado
  }

  Future<void> _getUserData() async {
    try {
      final response = await http.get(Uri.parse(
          "http://127.0.0.1/learn_go/getuserinfo1.php?email=$_username"));
      final userData = json.decode(response.body);

      // Función para convertir una cadena a entero o devolver null si no se puede convertir
      int? parseInteger(String? value) {
        return value != null ? int.tryParse(value) : null;
      }

      // Verificar si los datos del usuario son nulos antes de asignarlos
      _userData = UserData(
        id: parseInteger(userData['id']),
        nombre: userData['nombre'],
        apellido: userData['apellido'],
        edad: parseInteger(userData['edad']),
        idRol: parseInteger(userData['id_rol']),
        email: userData['email'],
        password: userData['password'],
      );

      _id_usuario = _userData?.id ?? 0;
      // Actualizar el estado para que se vuelva a construir con la nueva información
      setState(() {});
    } catch (error) {
      print("Error obteniendo información del usuario: $error");
    }
  }

  @override
  void didUpdateWidget(covariant listreserv oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_username != widget.username) {
      setState(() {
        _username = widget.username;
      });
    }
  }

  Future<List<dynamic>> getData() async {
    try {
      final response = await http.get(Uri.parse(
          "http://127.0.0.1/learn_go/getdatareservas.php?id_estudiante=$_id_usuario"));
      print("Response body: ${response.body}");
      print("ID Usuario: $_id_usuario");

      final jsonData = json.decode(response.body);

      // Verifica si jsonData es una lista
      if (jsonData is List) {
        // Si es una lista y no está vacía, devuelve la lista
        if (jsonData.isNotEmpty) {
          return jsonData;
        } else {
          // Si está vacía, devuelve una lista con un elemento indicando que no hay publicaciones
          return [
            {"mensaje": "No hay reservas para este usuario"}
          ];
        }
      } else {
        // Si no es una lista, devuelve una lista vacía
        return [];
      }
    } catch (error) {
      print("Error obteniendo datos: $error");
      // Si hay un error, devuelve una lista vacía
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Text(
                //   _username,
                //   style: TextStyle(fontSize: 18, color: Colors.black),
                // ),
                SizedBox(width: 8),
                Image.asset(
                  'assets/images/logo.png',
                  height: 40,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'List Reservations',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? ItemList(
                        list: snapshot.data!,
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color.fromARGB(255, 242, 171, 39),
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_to_photos_rounded),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'List',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        // Navegar a otra página cuando se selecciona "listreserv"
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              username: _username,
            ),
          ),
        );
      } else if (_selectedIndex == 1) {
        // Navegar a la página de perfil cuando se selecciona "Perfil"
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Perfil(
                    username: _username,
                  )),
        );
      } else if (_selectedIndex == 2) {
        // Navegar a la página de chats cuando se selecciona "Chats"
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Citas(
                    username: _username,
                  )),
        );
      } else if (_selectedIndex == 3) {
        // Navegar a la página de chats cuando se selecciona "Chats"
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => listtutor(
                    username: _username,
                  )),
        );
      }
    });
  }
}

class ItemList extends StatelessWidget {
  final List<dynamic> list;

  ItemList({required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, i) {
        return GestureDetector(
          onTap: () {
            // Puedes agregar lógica aquí para manejar el evento onTap según tus necesidades
          },
          child: Card(
            elevation: 3,
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ID Tutor: ${list[i]['id_tutor']}",
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                  Text(
                    "ID Materia: ${list[i]['id_materia']}",
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                  Text(
                    "Fecha: ${list[i]['fecha']}",
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                  Text(
                    "Hora: ${list[i]['hora']}",
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                  Text(
                    "Tipo Reunión: ${list[i]['tipo_reunion']}",
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                  Text(
                    "Precio: ${list[i]['precio']}",
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                  Text(
                    "Estado Reserva: ${list[i]['estado_reserva']}",
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
