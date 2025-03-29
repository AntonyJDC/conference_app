class EventModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String date;
  final String startTime;
  final String endTime;
  final String location;
  final int capacity;
  final int spotsLeft;
  final List<String> categories;
  final double? averageRating;

  EventModel(
      {required this.id,
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
      this.averageRating});

  Map<String, dynamic> toMap() {
    return {
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
      'averageRating': averageRating,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
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
        categories: (map['categories'] as String?)?.split(',') ?? [],
        averageRating: map['averageRating'] != null
            ? double.parse(map['averageRating'].toString())
            : null);
  }

  EventModel copyWith(
      {String? id,
      String? title,
      String? imageUrl,
      String? date,
      String? description,
      String? startTime,
      String? endTime,
      String? location,
      int? capacity,
      int? spotsLeft,
      List<String>? categories,
      double? averageRating}) {
    return EventModel(
        id: id ?? this.id,
        title: title ?? this.title,
        imageUrl: imageUrl ?? this.imageUrl,
        date: date ?? this.date,
        description: description ?? this.description,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        location: location ?? this.location,
        capacity: capacity ?? this.capacity,
        spotsLeft: spotsLeft ?? this.spotsLeft,
        categories: categories ?? this.categories,
        averageRating: averageRating ?? this.averageRating);
  }
}
