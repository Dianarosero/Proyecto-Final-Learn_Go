import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learn_go/pages/alumno/citas.dart';
import 'package:learn_go/pages/alumno/perfil.dart';
import 'package:learn_go/pages/alumno/listtutor.dart';
import 'package:http/http.dart' as http;

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(
        username: '',
      ),
    );
  }
}

class Home extends StatefulWidget {
  final String username;

  const Home({Key? key, required this.username}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  int _id_usuario = 0;
  String _username = '';
  final TextEditingController descripcionController = TextEditingController();

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

      int? parseInteger(String? value) {
        return value != null ? int.tryParse(value) : null;
      }

      _id_usuario = parseInteger(userData['id']) ?? 0;
      setState(() {});
    } catch (error) {
      print("Error obteniendo información del usuario: $error");
    }
  }

  Future<List<dynamic>> getData() async {
    final response = await http
        .get(Uri.parse("http://127.0.0.1/learn_go/getdatapublicaciones.php"));
    return json.decode(response.body) as List<dynamic>? ?? [];
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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 200.0),
                    child: TextField(
                      controller: descripcionController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Write your post',
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    savePublicacion();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(
                        255, 242, 171, 39), // Color del botón "Publicar"
                  ),
                  child: Text(
                    "Publish",
                    style: TextStyle(
                      color: Colors
                          .black, // Color del texto en el botón "Publicar"
                    ),
                  ),
                ),
              ],
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              username: _username,
            ),
          ),
        );
      } else if (_selectedIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Perfil(
                    username: _username,
                  )),
        );
      } else if (_selectedIndex == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Citas(
                    username: _username,
                  )),
        );
      } else if (_selectedIndex == 3) {
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

  void savePublicacion() async {
    String descripcion = descripcionController.text;

    await http.post(
      Uri.parse('http://127.0.0.1/learn_go/addpublicacion.php'),
      body: {
        'id_usuario': _id_usuario.toString(),
        'descripcion': descripcion,
      },
    );

    _showPublicConfirmationDialog();
  }

  void _showPublicConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Publicacion creada con éxito'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(
                      username: _username,
                    ),
                  ),
                );
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}

class ItemList extends StatelessWidget {
  final List<dynamic> list;

  ItemList({required this.list});

  Future<String> getUserInfo(String userId) async {
    final response = await http
        .get(Uri.parse("http://127.0.0.1/learn_go/getuserinfo.php?id=$userId"));
    final userData = json.decode(response.body);
    return userData['nombre'];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, i) {
        return GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => Detail(
                list: list,
                index: i,
              ),
            ),
          ),
          child: Card(
            elevation: 3,
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<String>(
                    future: getUserInfo(list[i]['id_usuario']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error obteniendo el nombre del usuario");
                      } else {
                        return Text(
                          snapshot.data ?? "",
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.bold),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${list[i]['descripcion']}",
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey, size: 16),
                      SizedBox(width: 4),
                      Text(
                        "Fecha: ${list[i]['fecha']}",
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentsScreen(
                            postId: list[i]['id'] ?? 0,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 242, 171,
                          39), // Color del botón "Ver Comentarios"
                    ),
                    child: Text(
                      "View Comments",
                      style: TextStyle(
                        color: Colors
                            .black, // Color del texto en el botón "Ver Comentarios"
                      ),
                    ),
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

class CommentsScreen extends StatefulWidget {
  final String postId;

  CommentsScreen({required this.postId});

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  TextEditingController commentController = TextEditingController();
  List<dynamic> comments = [];

  @override
  void initState() {
    super.initState();
    getComments();
  }

  Future<void> getComments() async {
    try {
      final response = await http.get(Uri.parse(
          "http://127.0.0.1/learn_go/getcomments.php?postId=${widget.postId}"));

      if (response.statusCode == 200) {
        setState(() {
          comments = json.decode(response.body) as List<dynamic>? ?? [];
        });
      } else {
        print("Error en la solicitud HTTP: ${response.statusCode}");
      }
    } catch (e) {
      print("Error al realizar la solicitud HTTP: $e");
    }
  }

  Future<void> saveComment() async {
    String comment = commentController.text;

    await http.post(
      Uri.parse('http://127.0.0.1/learn_go/addcomment.php'),
      body: {
        'postId': widget.postId,
        'id_usuario': '1', // Ajusta según tu lógica de usuario
        'descripcion': comment,
      },
    ).then((response) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }).catchError((error) {
      print('Error en la solicitud HTTP: $error');
    });

    // Después de guardar el comentario, actualiza la lista de comentarios
    getComments();

    // Limpiar el campo de comentarios
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Comments",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black, // Cambia el color de la flecha a negro
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/logo.png', // Ajusta la ruta según tu proyecto
              height: 40,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, i) {
                return Card(
                  child: ListTile(
                    title: FutureBuilder<String>(
                      future: getUserInfo(comments[i]['id_usuario']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("Cargando...");
                        } else if (snapshot.hasError) {
                          return Text("Error obteniendo el nombre del usuario");
                        } else {
                          return Text(
                            snapshot.data ?? "",
                            style: TextStyle(
                                fontSize: 18.0, color: Colors.orangeAccent),
                          );
                        }
                      },
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
                            Icon(Icons.calendar_today,
                                color: Colors.grey, size: 14),
                            SizedBox(width: 4),
                            Text(
                              "Fecha: ${comments[i]['fecha']}",
                              style:
                                  TextStyle(fontSize: 14.0, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Write your comment...',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    saveComment();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 242, 171, 39),
                  ),
                  child: Text(
                    "Send Comment",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getUserInfo(String userId) async {
    try {
      final response = await http.get(
          Uri.parse("http://127.0.0.1/learn_go/getuserinfo.php?id=$userId"));

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        return userData['nombre'] ?? "Nombre no encontrado";
      } else {
        print("Error en la solicitud HTTP: ${response.statusCode}");
        return "Error obteniendo el nombre del usuario";
      }
    } catch (e) {
      print("Error al realizar la solicitud HTTP: $e");
      return "Error obteniendo el nombre del usuario";
    }
  }
}
