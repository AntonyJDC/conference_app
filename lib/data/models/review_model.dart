class ReviewModel {
  final int? id;
  final String eventId;
  final int rating; // de 1 a 5
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

  factory ReviewModel.fromMap(Map<String, dynamic> map) => ReviewModel(
        id: map['id'],
        eventId: map['eventId'],
        rating: map['rating'],
        comment: map['comment'],
        createdAt: map['createdAt'],
      );
}
