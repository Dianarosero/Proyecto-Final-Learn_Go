import 'package:flutter/material.dart';
import 'package:learn_go/data/UserData.dart';
import 'package:learn_go/pages/alumno/home.dart';
import 'package:learn_go/pages/alumno/listtutor.dart';
import 'package:learn_go/pages/alumno/perfil.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Citas(
        username: '',
      ),
    );
  }
}

class Citas extends StatefulWidget {
  final UserData? ud;
  final String username;

  const Citas({Key? key, this.ud, required this.username}) : super(key: key);

  @override
  _CitasState createState() => _CitasState();
}

class _CitasState extends State<Citas> {
  final TextEditingController priceController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();

  String? _selectedMeetingType;

  String? _selectedSubject;
  List<String> selectedSubjects = [];

  String? _selectedTutor;
  List<String> selectedTutors = [];

  int _selectedIndex = 2;
  int _id_usuario = 0;
  String _username = '';
  UserData? _userData;

  @override
  void initState() {
    super.initState();
    _username = widget.username;
    _id_usuario = 0;
    _getUserData();
    fetchMaterias();
    fetchTutores();
  }

  List<Map<String, dynamic>> _materias = [];
  List<Map<String, dynamic>> _tutores = [];

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

  Future<void> fetchTutores() async {
    try {
      var response = await http
          .get(Uri.parse("http://127.0.0.1/learn_go/listtutores.php"));

      if (response.statusCode == 200) {
        setState(() {
          _tutores =
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
  void didUpdateWidget(covariant Citas oldWidget) {
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
            scale: 1.8,
            child: Image.asset(
              'assets/images/logo.png',
            ),
          ),
        ),
      ),
      body: Form(
        // Create a GlobalKey to uniquely identify the Form widget and retrieve the FormState
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Make a Reservation',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Formulario para registrar reservas
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Combobox para seleccionar materia
                  DropdownButton<String>(
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
                  // Combobox para seleccionar tutor
                  DropdownButton<String>(
                    value: _selectedTutor,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedTutor = newValue;
                      });
                    },
                    items: _tutores.map((Map<String, dynamic> tutor) {
                      return DropdownMenuItem<String>(
                        value: tutor['nombre'],
                        child: Text(
                          tutor['nombre'],
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    hint: Text(
                      "Select Tutor",
                      style: TextStyle(color: Colors.black),
                    ),
                    isExpanded: true,
                    underline: Container(
                      height: 1,
                      color: Colors.black,
                    ),
                  ),
                  // Escoger fecha
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: dateController, // Use the controller
                    decoration: InputDecoration(
                      labelText: 'Date (YYYY/MM/DD)',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the price';
                      }
                      return null;
                    },
                    // Update onSaved to use priceController.text
                    onSaved: (value) {},
                  ),
                  // Seleccionar hora
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: hoursController, // Use the controller
                    decoration: InputDecoration(
                      labelText: 'Hour (HH:MM AM/PM)',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the price';
                      }
                      return null;
                    },
                    // Update onSaved to use priceController.text
                    onSaved: (value) {},
                  ),

                  // Escoger tipo de reunión (Virtual, Presencial)
                  DropdownButtonFormField<String>(
                    value: _selectedMeetingType,
                    onChanged: (value) {
                      setState(() {
                        _selectedMeetingType = value!;
                      });
                    },
                    items: ['Virtual', 'Presencial'].map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Meeting Type',
                    ),
                  ),
                  // Precio
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: priceController, // Use the controller
                    decoration: InputDecoration(
                      labelText: 'Price',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the price';
                      }
                      return null;
                    },
                    // Update onSaved to use priceController.text
                    onSaved: (value) {},
                  ),
                  SizedBox(height: 16),
                  // Botón de guardar reserva
                  ElevatedButton(
                    onPressed: () {
                      // Validate the form before saving
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Add logic to save the reservation data to the database
                        saveReservation();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary:
                          Color.fromARGB(255, 242, 171, 39), // Color de fondo
                      onPrimary: Colors.black, // Color del texto
                    ),
                    child: Text('Save Reservation'),
                  )
                ],
              ),
            ),
          ],
        ),
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
        // Navegar a otra página cuando se selecciona "Home"
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

  void saveReservation() async {
    // Obtén los IDs correspondientes a las materias y tutores seleccionados
    String? idMateria = _materias.firstWhere(
      (materia) => materia['nombre'] == _selectedSubject,
      orElse: () => {'id': null},
    )['id'];

    String? idTutor = _tutores.firstWhere(
      (tutor) => tutor['nombre'] == _selectedTutor,
      orElse: () => {'id': null},
    )['id'];

    if (idMateria == null || idTutor == null) {
      // Maneja el caso donde no se encontraron los IDs
      print(
          'No se encontraron los IDs correspondientes a la materia o al tutor');
      return;
    }

    // Realiza la solicitud HTTP con los IDs
    await http.post(
      Uri.parse('http://127.0.0.1/learn_go/addreserva.php'),
      body: {
        'id_estudiante': _id_usuario.toString(),
        'id_materia': idMateria.toString(),
        'id_tutor': idTutor.toString(),
        'fecha': dateController.text,
        'hora': hoursController.text,
        'tipo_reunion': _selectedMeetingType,
        'precio': priceController.text,
      },
    );
    // Muestra el diálogo de confirmación
    _showReservationConfirmationDialog();
  }

  void _showReservationConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reserva creada con éxito'),
          content: Text(
            'Espere hasta que el tutor confirme la reserva.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Cierra el diálogo
                Navigator.of(context).pop();
                // Redirige al usuario al 'home'
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
