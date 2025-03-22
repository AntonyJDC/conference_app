class EventModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String date; // Formato "YYYY-MM-DD"
  final String location;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.location,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        imageUrl: json['image_url'],
        date: json['date'],
        location: json['location']['address'],
      );
}
