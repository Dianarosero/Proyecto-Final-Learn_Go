class UserData {
  final int? id;
  final String? nombre;
  final String? apellido;
  final int? edad;
  final int? idRol;
  final String? email;
  final String? password;
  String? selectedStatus; // Propiedad adicional para el estado de reserva

  UserData({
    this.id,
    this.nombre,
    this.apellido,
    this.edad,
    this.idRol,
    this.email,
    this.password,
    this.selectedStatus,
  });

  @override
  String toString() {
    return 'UserData{id: $id, nombre: $nombre, apellido: $apellido, edad: $edad, idRol: $idRol, email: $email, password: $password, selectedStatus: $selectedStatus}';
  }
}
