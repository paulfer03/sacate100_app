import 'package:sacate100_app/models/news_course/news_course_create_dto.dart';

class NewsPostDto {
  final int id;
  final String title;
  final double price;
  final String location;
  final String description;
  final String phoneNumber;
  final String email;
  final String whatsAppLink;
  final String imageUrl;
  final CategoryType category;

  NewsPostDto({
    required this.id,
    required this.title,
    required this.price,
    required this.location,
    required this.description,
    required this.phoneNumber,
    required this.email,
    required this.whatsAppLink,
    required this.imageUrl,
    required this.category,
  });

  factory NewsPostDto.fromJson(Map<String, dynamic> json) {
    return NewsPostDto(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      location: json['location'],
      description: json['description'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      whatsAppLink: json['whatsAppLink'],
      imageUrl: json['imageUrl'],
      category: CategoryType.values.firstWhere(
        (e) => e.toString().split('.').last == json['category'],
        orElse: () => CategoryType.other,
      ),
    );
  }
}