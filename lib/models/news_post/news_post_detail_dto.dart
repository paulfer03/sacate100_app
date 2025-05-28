
class NewsPostDetailDto {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final DateTime publishedAt;
  final String phoneNumber;
  final String whatsAppLink;
  final String category;
  final String description;
  final DateTime publishDate;
  final double price;
  final String location;
  final String? email;

  NewsPostDetailDto({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.publishedAt,
    required this.phoneNumber,
    required this.whatsAppLink,
    required this.category,
    required this.description,
    required this.publishDate,
    required this.price,
    required this.location,
    this.email,
  });

  factory NewsPostDetailDto.fromJson(Map<String, dynamic> json) {
    return NewsPostDetailDto(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      phoneNumber: json['phoneNumber'] as String,
      whatsAppLink: json['whatsAppLink'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      publishDate: DateTime.parse(json['publishDate'] as String),
      price: (json['price'] as num).toDouble(),
      location: json['location'] as String,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'publishedAt': publishedAt.toIso8601String(),
      'phoneNumber': phoneNumber,
      'whatsAppLink': whatsAppLink,
      'category': category,
      'description': description,
      'publishDate': publishDate.toIso8601String(),
      'price': price,
      'location': location,
      'email': email,
    };
  }
}