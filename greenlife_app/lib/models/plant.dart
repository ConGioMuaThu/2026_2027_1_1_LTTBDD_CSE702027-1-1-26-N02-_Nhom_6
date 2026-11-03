class Plant {
  final String id;
  final String name;
  final String scientificName;
  final String category;
  final String description;
  final String careLevel;
  final String waterNeed;
  final String sunlight;
  final String imageAsset;
  final String imageUrl;
  final bool isFavorite;
  final List<String> tags;

  const Plant({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.category,
    required this.description,
    required this.careLevel,
    required this.waterNeed,
    required this.sunlight,
    required this.imageAsset,
    this.imageUrl = '',
    this.isFavorite = false,
    required this.tags,
  });
}
