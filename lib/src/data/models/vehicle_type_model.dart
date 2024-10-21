class VehicleTypeModel {
  final int? id;
  final String name; // Nombre de la categoría (e.g., 'Bicycle', 'Scooter', etc.)
  final String? info; // Información adicional o descripción
  final String? image; // URL o ruta de la imagen representativa

  VehicleTypeModel({
    this.id,
    required this.name,
    this.info,
    this.image,
  });

  // Método para convertir el modelo a Map (para insertar/actualizar en la base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'info': info,
      'image': image,
    };
  }

  // Método para crear una instancia de VehicleTypeModel desde un Map (cuando se lee de la base de datos)
  factory VehicleTypeModel.fromMap(Map<String, dynamic> map) {
    return VehicleTypeModel(
      id: map['id'],
      name: map['name'],
      info: map['info'],
      image: map['image'],
    );
  }

  // Método adicional para obtener una representación en formato String (opcional, útil para debug)
  @override
  String toString() {
    return 'VehicleTypeModel{id: $id, name: $name, info: $info, image: $image}';
  }
}