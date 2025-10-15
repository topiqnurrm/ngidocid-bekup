class Validator {
  static bool isValidImageFile(String filePath) {
    final validExtensions = ['.jpg', '.jpeg', '.png', '.webp', '.heic', '.heif'];
    return validExtensions.any((ext) => filePath.toLowerCase().endsWith(ext));
  }

  static bool isValidQuery(String query) {
    return query.trim().isNotEmpty && query.trim().length >= 2;
  }

  static String? validateSearchQuery(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a food name';
    }
    if (value.trim().length < 2) {
      return 'Search query must be at least 2 characters';
    }
    return null;
  }
}
