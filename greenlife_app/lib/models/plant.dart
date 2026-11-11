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
  final bool inGarden;
  final String plantedDate;
  final String careNotes;
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
    this.inGarden = false,
    this.plantedDate = '',
    this.careNotes = '',
    required this.tags,
  });

  static const Set<String> catalogIds = {
    'plant-1',
    'plant-2',
    'plant-3',
    'plant-4',
    'plant-5',
    'plant-6',
    'plant-7',
    'plant-8',
    'plant-9',
  };

  bool get isCatalog => catalogIds.contains(id);
}