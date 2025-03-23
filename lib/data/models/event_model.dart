class EventModel {
  final String id;
  final String title; // Nombre del evento
  final String? description; // Descripción (opcional)
  final String imageUrl; // Imagen
  final String date; // Fecha del evento "YYYY-MM-DD"
  final String? startTime; // Hora de inicio "HH:MM" (opcional)
  final String? endTime; // Hora de fin "HH:MM" (opcional)
  final String location; // Ubicación (dirección)
  final int? capacity; // Capacidad máxima de asistentes (opcional)
  int? spotsLeft; // Cupos disponibles (opcional)
  final List<String> categories; // Categorías (Ej: Música, Tecnología)

  EventModel({
    required this.id,
    required this.title,
    this.description, // Opcional
    required this.imageUrl,
    required this.date,
    this.startTime, // Opcional
    this.endTime, // Opcional
    required this.location,
    this.capacity, // Opcional
    this.spotsLeft, // Opcional
    required this.categories,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        imageUrl: json['image_url'],
        date: json['date'],
        startTime: json['start_time'],
        endTime: json['end_time'],
        location: json['location']['address'],
        capacity: json['capacity'],
        spotsLeft: json['spots_left'],
        categories: List<String>.from(json['categories']),
      );
}
