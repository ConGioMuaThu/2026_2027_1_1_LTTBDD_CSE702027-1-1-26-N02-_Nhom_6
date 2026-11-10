class GrowthNote {
  final String id;
  final String plantName;
  final String title;
  final String date;
  final String summary;
  final String imagePath;

  const GrowthNote({
    required this.id,
    required this.plantName,
    required this.title,
    required this.date,
    required this.summary,
    this.imagePath = '',
  });
}
