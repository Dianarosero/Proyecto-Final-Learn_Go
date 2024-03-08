import 'dart:async';
import 'dart:convert';

import 'package:learn_go/data/UserData.dart';
import 'package:flutter/material.dart';
import 'package:learn_go/pages/tutor/listreservT.dart';
import 'package:learn_go/pages/tutor/homeT.dart';
import 'package:learn_go/pages/tutor/perfilT.dart';
import 'package:http/http.dart' as http;

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Acept(
        username: '',
      ),
    );
  }
}

class Acept extends StatefulWidget {
  final UserData? ud;
  final String username;

  const Acept({Key? key, this.ud, required this.username}) : super(key: key);

  @override
  _AceptState createState() => _AceptState();
}

class _AceptState extends State<Acept> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 2;
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
  void didUpdateWidget(covariant Acept oldWidget) {
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
          "http://127.0.0.1/learn_go/getdatareservasT.php?id_tutor=$_id_usuario"));
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
      key: _scaffoldKey,
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
              'Update Reservation Status',
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

class ItemList extends StatefulWidget {
  final List<dynamic> list;

  ItemList({required this.list});

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.list.length,
      itemBuilder: (context, i) {
        return Card(
          elevation: 3,
          margin: EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ID Estudiante: ${widget.list[i]['id_estudiante']}",
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                ),
                Text(
                  "ID Materia: ${widget.list[i]['id_materia']}",
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                Text(
                  "Fecha: ${widget.list[i]['fecha']}",
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                Text(
                  "Hora: ${widget.list[i]['hora']}",
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                Text(
                  "Tipo Reunión: ${widget.list[i]['tipo_reunion']}",
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                Text(
                  "Precio: ${widget.list[i]['precio']}",
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Estado Reserva: ",
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          // Agregar un DropdownButton para seleccionar el estado de reserva
                          DropdownButton<String>(
                            value: widget.list[i]['estado_reserva'],
                            items: ["En Espera", "Confirmada", "Anulada"]
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                widget.list[i]['estado_reserva'] = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 16),

                    // Agregar un botón de actualización
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para actualizar el estado de reserva en la base de datos
                        _updateReservationStatus(
                          widget.list[i]['id'],
                          widget.list[i]['estado_reserva'],
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(
                            255, 242, 171, 39), // Color del botón
                      ),
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.black, // Color del texto
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Función para actualizar el estado de reserva en la base de datos
  Future<void> _updateReservationStatus(
      int idReserva, String? newStatus) async {
    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1/learn_go/aceptareserva.php"),
        body: {
          "id": idReserva.toString(),
          "estado_reserva": newStatus ?? "",
        },
      );

      if (response.statusCode == 200) {
        // Éxito en la actualización
        print("Estado de reserva actualizado correctamente");

        // Muestra el SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Estado de reserva actualizado correctamente'),
          ),
        );
      } else {
        print(
            "Error al actualizar el estado de reserva: ${response.statusCode}");

        // Muestra el SnackBar con un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar el estado de reserva'),
          ),
        );
      }
    } catch (error) {
      print("Error al realizar la solicitud HTTP: $error");

      // Muestra el SnackBar con un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al realizar la solicitud HTTP'),
        ),
      );
    }
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
