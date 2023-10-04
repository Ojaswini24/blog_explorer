class Blog {
  final String title;
  final String imageUrl;
  final bool isFavorite;

  Blog({
    required this.title,
    required this.imageUrl,
    this.isFavorite = false,
  });
}
