import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class EventModel {
  EventModel({
    required this.id,
    required this.eventName,
    required this.eventDate,
    this.venue,
    this.description,
    this.imageUrl,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as int,
      eventName: json['event_name'] as String,
      eventDate: json['event_date'] as String,
      venue: json['venue'] as String?,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }

  final int id;

  final String eventName;

  final String eventDate;

  final String? venue;

  final String? description;

  final String? imageUrl;
}
