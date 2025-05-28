import '../enums/category_type.dart';

class NewsPostCreateDto {
  final String title;
  final double price;
  final String location;
  final String description;
  final String phoneNumber;
  final String email;
  final String whatsAppLink;
  final String imageUrl;
  final CategoryType category;

  NewsPostCreateDto({
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

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'location': location,
      'description': description,
      'phoneNumber': phoneNumber,
      'email': email,
      'whatsAppLink': whatsAppLink,
      'imageUrl': imageUrl,
      'category': category.toString().split('.').last,
    };
  }
}