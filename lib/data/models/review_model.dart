class ReviewModel {
  final String? id;
  final String eventId;
  final int rating;
  final String comment;
  final String createdAt;

  ReviewModel({
    this.id,
    required this.eventId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'eventId': eventId,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt,
      };

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'eventId': eventId,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt,
      };

  factory ReviewModel.fromMap(Map<String, dynamic> map) => ReviewModel(
        id: map['id'] ?? map['_id'],
        eventId: map['eventId'],
        rating: map['rating'],
        comment: map['comment'],
        createdAt: map['createdAt'],
      );
}
