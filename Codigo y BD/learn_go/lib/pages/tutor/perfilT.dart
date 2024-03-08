import 'dart:async';
import 'dart:convert';

import 'package:learn_go/data/UserData.dart';
import 'package:flutter/material.dart';
import 'package:learn_go/pages/tutor/acept_reserva.dart';
import 'package:learn_go/pages/tutor/homeT.dart';
import 'package:learn_go/pages/tutor/listreservT.dart';
import 'package:http/http.dart' as http;

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PerfilT(
        username: '',
      ),
    );
  }
}

class PerfilT extends StatefulWidget {
  final UserData? ud;
  final String username;

  const PerfilT({Key? key, this.ud, required this.username}) : super(key: key);

  @override
  _PerfilTState createState() => _PerfilTState();
}

class _PerfilTState extends State<PerfilT> {
  int _selectedIndex = 1;
  int _id_usuario = 0;
  String _username = '';
  UserData? _userData;

  @override
  void initState() {
    super.initState();
    _username = widget.username;
    _id_usuario = 0;
    _getUserData();
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
  void didUpdateWidget(covariant PerfilT oldWidget) {
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
          "http://127.0.0.1/learn_go/getdatapublicacionesU.php?id_usuario=$_id_usuario"));
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
            {"mensaje": "No hay publicaciones para este usuario"}
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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Transform.scale(
            scale: 1.8, // Ajusta el valor de scale según tus necesidades
            child: Image.asset(
              'assets/images/logo.png',
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(width: 8),
                // Agrega el botón de cierre de sesión
                TextButton(
                  onPressed: () {
                    // Navigate to the initial route and remove all previous routes from the stack
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => false,
                    );
                  },
                  child: Text(
                    'Sign Off',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Mostrar información del usuario usando el nuevo widget UserInfoCard
          if (_userData != null) UserInfoCard(userData: _userData!),
          // Agregar un texto entre la información del usuario y la lista de elementos
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'My Posts',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
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
            icon: Icon(Icons.add_task_sharp),
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeT(
              username: _username,
            ),
          ),
        );
      } else if (_selectedIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PerfilT(
                    username: _username,
                  )),
        );
      } else if (_selectedIndex == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Acept(
                    username: _username,
                  )),
        );
      } else if (_selectedIndex == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => listreserv(
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
                    "${list[i]['descripcion']}",
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
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

class UserInfoCard extends StatelessWidget {
  final UserData userData;

  UserInfoCard({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Columna izquierda con el icono de usuario
            Column(
              children: [
                Icon(
                  Icons.account_circle_outlined,
                  size: 100,
                  color: Color.fromARGB(255, 242, 171, 39),
                ),
              ],
            ),
            SizedBox(width: 16), // Espacio entre las columnas
            // Columna derecha con el resto de los datos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${userData.nombre} ${userData.apellido}",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text("Age: ${userData.edad}"),
                  Text(
                      "Type User: ${userData.idRol == 1 ? 'Estudiante' : 'Tutor'}"),
                  Text("Email: ${userData.email}"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
