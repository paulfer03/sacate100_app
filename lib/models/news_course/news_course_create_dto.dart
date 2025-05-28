// lib/models/category_type.dart

enum CategoryType {
  electronics,
  books,
  clothing,
  home,
  other,
}

extension CategoryTypeApi on CategoryType {
  /// Devuelve el string exacto que espera el backend
  String toApiString() {
    switch (this) {
      case CategoryType.electronics:
        return 'electronics';
      case CategoryType.books:
        return 'books';
      case CategoryType.clothing:
        return 'clothing';
      case CategoryType.home:
        return 'home';
      case CategoryType.other:
        return 'other';
    }
  }
}
