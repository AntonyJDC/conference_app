class EventModel {
  final String id;
  final String title; // Nombre del evento
  final String description; // Descripción
  final String imageUrl; // Imagen
  final String date; // Fecha del evento "YYYY-MM-DD"
  final String startTime; // Hora de inicio "HH:MM"
  final String endTime; // Hora de fin "HH:MM"
  final String location; // Ubicación (dirección)
  final int capacity; // Capacidad máxima de asistentes
  int spotsLeft; // Cupos disponibles
  final List<String> categories; // Categorías (Ej: Música, Tecnología)

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.capacity,
    required this.spotsLeft,
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
