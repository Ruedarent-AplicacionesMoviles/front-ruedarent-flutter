class AddressModel {
  int? id; // Hacer que 'id' sea nullable (puede ser null antes de ser asignado)
  final String direccion;
  final String distrito;
  final int userId;

  AddressModel({
    this.id, // 'id' es opcional
    required this.direccion,
    required this.distrito,
    required this.userId,
  });

  // Convertir el objeto a un Map para insertar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id, // 'id' puede ser null al insertar
      'direccion': direccion,
      'distrito': distrito,
      'userId': userId,
    };
  }

  // Crear un objeto a partir de un Map (de la base de datos)
  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'], // El 'id' es asignado desde la base de datos
      direccion: map['direccion'],
      distrito: map['distrito'],
      userId: map['userId'],
    );
  }
}


// // Método útil para debuggear, que devuelve una representación en String del objeto
//   @override
//   String toString() {
//     return 'AddressModel{id: $id, direccion: $direccion, distrito: $distrito, userId: $userId}';
//   }
// }