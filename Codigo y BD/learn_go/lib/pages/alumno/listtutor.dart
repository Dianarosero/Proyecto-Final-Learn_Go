import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learn_go/data/UserData.dart';
import 'package:learn_go/pages/alumno/citas.dart';
import 'package:learn_go/pages/alumno/home.dart';
import 'package:learn_go/pages/alumno/perfil.dart';
import 'package:http/http.dart' as http;

class Listtutor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Aquí deberías devolver el widget que deseas construir, no una ListView.builder
    // Se asume que deseas construir un MaterialApp por analogía con el resto del código
    return MaterialApp(
      home: listtutor(
        username: '',
      ),
    );
  }
}

class listtutor extends StatefulWidget {
  final UserData? ud;
  final String username;

  const listtutor({Key? key, this.ud, required this.username})
      : super(key: key);

  @override
  _listtutorState createState() => _listtutorState();
}

class _listtutorState extends State<listtutor> {
  int _selectedIndex = 3;
  String _username = '';
  List<dynamic> _tutors = [];
  List<dynamic> _materias = [];

  @override
  void initState() {
    super.initState();
    _username = widget.username;
    _getData();
  }

  Future<void> _getData() async {
    try {
      final tutorsResponse = await http
          .get(Uri.parse("http://127.0.0.1/learn_go/listtutores.php"));
      final materiasResponse = await http
          .get(Uri.parse("http://127.0.0.1/learn_go/listmaterias.php"));

      setState(() {
        _tutors = json.decode(tutorsResponse.body) as List<dynamic>? ?? [];
        _materias = json.decode(materiasResponse.body) as List<dynamic>? ?? [];
      });
    } catch (error) {
      print("Error obteniendo datos: $error");
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
            scale: 1.8,
            child: Image.asset(
              'assets/images/logo.png',
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'List Tutors',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: _tutors.isNotEmpty
                ? ItemList(
                    tutors: _tutors,
                    materias: _materias,
                  )
                : Center(
                    child: CircularProgressIndicator(),
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
        // Navegar a otra página cuando se selecciona "listtutor"
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
  final List<dynamic> tutors;
  final List<dynamic> materias;

  ItemList({required this.tutors, required this.materias});

  String getMateriaName(String idMateria) {
    var materia = materias.firstWhere(
      (materia) => materia['id'] == idMateria,
      orElse: () => {'nombre': 'Materia no encontrada'},
    );
    return materia['nombre'];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tutors.length,
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
                    "${tutors[i]['nombre']} ${tutors[i]['apellido']}",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color.fromARGB(255, 242, 171, 39), // Color deseado
                    ),
                  ),
                  Text(
                    "Subject: ${getMateriaName(tutors[i]['id_materia'])}",
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

class Detail extends StatelessWidget {
  final List<dynamic> list;
  final int index;

  Detail({required this.list, required this.index});

  @override
  Widget build(BuildContext context) {
    // Implementa la construcción de tu widget Detail según tus necesidades
    // Se proporciona un contenedor como ejemplo
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle'),
      ),
      body: Container(
        child: Text('Detalles de ${list[index]['id_usuario']}'),
      ),
    );
  }
}

class CommentsScreen extends StatelessWidget {
  final String postId;

  CommentsScreen({required this.postId});

  Future<List<dynamic>> getComments(String postId) async {
    try {
      final response = await http.get(Uri.parse(
          "http://127.0.0.1/learn_go/getcomments.php?postId=$postId"));

      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>? ?? [];
      } else {
        print("Error en la solicitud HTTP: ${response.statusCode}");
        return []; // O maneja el error de alguna manera adecuada para tu aplicación
      }
    } catch (e) {
      print("Error al realizar la solicitud HTTP: $e");
      return []; // O maneja el error de alguna manera adecuada para tu aplicación
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comentarios"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getComments(postId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text("Error al cargar comentarios"),
            );
          }

          return snapshot.hasData
              ? CommentList(
                  comments: snapshot.data!,
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

class CommentList extends StatelessWidget {
  final List<dynamic> comments;

  CommentList({required this.comments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, i) {
        return Card(
          child: ListTile(
            title: Text(
              comments[i]['id_usuario'],
              style: TextStyle(fontSize: 18.0, color: Colors.orangeAccent),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${comments[i]['descripcion']}",
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.grey, size: 14),
                    SizedBox(width: 4),
                    Text(
                      "Fecha: ${comments[i]['fecha']}",
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.access_time, color: Colors.grey, size: 14),
                    SizedBox(width: 4),
                    Text(
                      "Hora: ${comments[i]['hora']}",
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
