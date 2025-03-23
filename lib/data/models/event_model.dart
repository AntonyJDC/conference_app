class EventModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String date; // "YYYY-MM-DD"
  final String startTime; // "HH:MM"
  final String endTime; // "HH:MM"
  final String location;
  final int capacity;
  int spotsLeft;
  final List<String> categories; // Ej: ["Música", "Tecnología"]

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

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
        'location': location,
        'capacity': capacity,
        'spotsLeft': spotsLeft,
        'categories': categories.join(','),
      };

  factory EventModel.fromMap(Map<String, dynamic> map) => EventModel(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        imageUrl: map['imageUrl'],
        date: map['date'],
        startTime: map['startTime'],
        endTime: map['endTime'],
        location: map['location'],
        capacity: map['capacity'],
        spotsLeft: map['spotsLeft'],
        categories: map['categories'].toString().split(','),
      );

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
